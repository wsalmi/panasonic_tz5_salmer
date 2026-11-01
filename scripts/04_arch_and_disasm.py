#!/usr/bin/env python3
"""
Phase 4: Panasonic MN10300 / MN103S (AM33) Architecture Analysis, Disassembler,
and Cross-Reference Mapper for TZ5_unpacked.bin.
"""

import json
import os
import re
import struct
from collections import Counter, defaultdict

OUTPUT_DIR = "/Users/wesleysalmi/source-me/tz5-rea/output"
UNPACKED_PATH = os.path.join(OUTPUT_DIR, "TZ5_unpacked.bin")

ROM_BASE = 0x55C7C000
DATA_ROM_START = 0x014000
DATA_ROM_END = 0x01F02C
DATA_RAM_START = 0x54012840


def file_to_va(off: int) -> int:
    return off + ROM_BASE


def va_to_file(va: int):
    if ROM_BASE <= va < ROM_BASE + 0x484020:
        return va - ROM_BASE
    if DATA_RAM_START <= va < DATA_RAM_START + (DATA_ROM_END - DATA_ROM_START):
        return DATA_ROM_START + (va - DATA_RAM_START)
    return None


def decode_movm_regs(mask: int) -> str:
    # MN10300 movm register bitmask conventions
    regs = []
    if mask & 0x80:
        regs.append("d2")
    if mask & 0x40:
        regs.append("d3")
    if mask & 0x20:
        regs.append("a2")
    if mask & 0x10:
        regs.append("a3")
    if mask & 0x08:
        regs.append("other")
    if mask & 0x04:
        regs.append("exreg1")
    if mask & 0x02:
        regs.append("exreg0")
    if mask & 0x01:
        regs.append("exother")
    return "[" + ",".join(regs) + "]" if regs else f"0x{mask:02x}"


def disasm_mn103(data: bytes, start_off: int, max_insns: int = 40):
    """
    Lightweight MN10300 / MN103S disassembler for key entry points and routines.
    """
    insns = []
    pc = start_off
    end = len(data)

    bcc_names = {
        0xC0: "blt",
        0xC1: "bgt",
        0xC2: "bge",
        0xC3: "ble",
        0xC4: "bcs",
        0xC5: "bhi",
        0xC6: "bcc",
        0xC7: "bls",
        0xC8: "beq",
        0xC9: "bne",
        0xCA: "bra",
    }

    for _ in range(max_insns):
        if pc >= end:
            break
        va = file_to_va(pc)
        b0 = data[pc]

        # 1-byte instructions
        if b0 == 0xCB:
            insns.append((pc, va, data[pc : pc + 1], "rets"))
            pc += 1
            continue
        if b0 == 0xB0:
            insns.append((pc, va, data[pc : pc + 1], "clr d0"))
            pc += 1
            continue
        if b0 == 0xB1:
            insns.append((pc, va, data[pc : pc + 1], "clr d1"))
            pc += 1
            continue
        if b0 == 0xB2:
            insns.append((pc, va, data[pc : pc + 1], "clr d2"))
            pc += 1
            continue
        if b0 == 0xB3:
            insns.append((pc, va, data[pc : pc + 1], "clr d3"))
            pc += 1
            continue
        if 0x50 <= b0 <= 0x57:
            reg = ["d0", "d1", "d2", "d3", "a0", "a1", "a2", "a3"][b0 - 0x50]
            insns.append((pc, va, data[pc : pc + 1], f"inc {reg}"))
            pc += 1
            continue
        if 0x58 <= b0 <= 0x5B:
            reg = ["a0", "a1", "a2", "a3"][b0 - 0x58]
            insns.append((pc, va, data[pc : pc + 1], f"inc4 {reg}"))
            pc += 1
            continue
        if 0x60 <= b0 <= 0x6F:
            dreg = f"d{(b0 >> 2) & 3}"
            areg = f"a{b0 & 3}"
            insns.append((pc, va, data[pc : pc + 1], f"mov ({areg}), {dreg}"))
            pc += 1
            continue
        if 0x70 <= b0 <= 0x7F:
            dreg = f"d{(b0 >> 2) & 3}"
            areg = f"a{b0 & 3}"
            insns.append((pc, va, data[pc : pc + 1], f"mov {dreg}, ({areg})"))
            pc += 1
            continue

        # 2-byte movm / ret / bcc / mov imm8
        if b0 == 0xCF and pc + 2 <= end:
            mask = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"movm {decode_movm_regs(mask)}, (sp)"))
            pc += 2
            continue
        if b0 == 0xCE and pc + 2 <= end:
            mask = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"movm (sp), {decode_movm_regs(mask)}"))
            pc += 2
            continue
        if b0 in bcc_names and pc + 2 <= end:
            disp = struct.unpack("b", data[pc + 1 : pc + 2])[0]
            target = va + disp
            insns.append((pc, va, data[pc : pc + 2], f"{bcc_names[b0]} 0x{target:08x}"))
            pc += 2
            continue
        if 0x80 <= b0 <= 0x83 and pc + 2 <= end:
            dreg = f"d{b0 - 0x80}"
            imm8 = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"mov 0x{imm8:02x}, {dreg}"))
            pc += 2
            continue
        if 0x90 <= b0 <= 0x93 and pc + 2 <= end:
            areg = f"a{b0 - 0x90}"
            imm8 = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"mov 0x{imm8:02x}, {areg}"))
            pc += 2
            continue
        if 0x20 <= b0 <= 0x23 and pc + 2 <= end:
            dreg = f"d{b0 - 0x20}"
            imm8 = struct.unpack("b", data[pc + 1 : pc + 2])[0]
            insns.append((pc, va, data[pc : pc + 2], f"add {imm8}, {dreg}"))
            pc += 2
            continue
        if 0xA0 <= b0 <= 0xA3 and pc + 2 <= end:
            dreg = f"d{b0 - 0xA0}"
            imm8 = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"cmp 0x{imm8:02x}, {dreg}"))
            pc += 2
            continue
        if 0x3C <= b0 <= 0x3F and pc + 2 <= end:
            dreg = f"d{b0 - 0x3C}"
            disp8 = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"mov ({disp8}, sp), {dreg}"))
            pc += 2
            continue
        if 0x40 <= b0 <= 0x43 and pc + 2 <= end:
            dreg = f"d{b0 - 0x40}"
            disp8 = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"mov {dreg}, ({disp8}, sp)"))
            pc += 2
            continue
        if 0x5C <= b0 <= 0x5F and pc + 2 <= end:
            areg = f"a{b0 - 0x5C}"
            disp8 = data[pc + 1]
            insns.append((pc, va, data[pc : pc + 2], f"mov ({disp8}, sp), {areg}"))
            pc += 2
            continue

        # 3-byte instructions: ret, mov imm16, jmp16, calls16
        if b0 == 0xDF and pc + 3 <= end:
            mask = data[pc + 1]
            imm8 = data[pc + 2]
            insns.append((pc, va, data[pc : pc + 3], f"ret {decode_movm_regs(mask)}, {imm8}"))
            pc += 3
            continue
        if 0x2C <= b0 <= 0x2F and pc + 3 <= end:
            dreg = f"d{b0 - 0x2C}"
            imm16 = struct.unpack("<H", data[pc + 1 : pc + 3])[0]
            insns.append((pc, va, data[pc : pc + 3], f"mov 0x{imm16:04x}, {dreg}"))
            pc += 3
            continue
        if 0x24 <= b0 <= 0x27 and pc + 3 <= end:
            areg = f"a{b0 - 0x24}"
            imm16 = struct.unpack("<H", data[pc + 1 : pc + 3])[0]
            insns.append((pc, va, data[pc : pc + 3], f"mov 0x{imm16:04x}, {areg}"))
            pc += 3
            continue
        if b0 == 0xDC and pc + 3 <= end:
            disp16 = struct.unpack("<h", data[pc + 1 : pc + 3])[0]
            insns.append((pc, va, data[pc : pc + 3], f"jmp 0x{(va + disp16) & 0xFFFFFFFF:08x}"))
            pc += 3
            continue
        if b0 == 0xDA and pc + 3 <= end:
            disp16 = struct.unpack("<h", data[pc + 1 : pc + 3])[0]
            insns.append((pc, va, data[pc : pc + 3], f"calls 0x{(va + disp16) & 0xFFFFFFFF:08x}"))
            pc += 3
            continue

        # 5-byte call disp16 / jmp32 / calls32
        if b0 == 0xCD and pc + 5 <= end:
            disp16 = struct.unpack("<h", data[pc + 1 : pc + 3])[0]
            mask = data[pc + 3]
            imm8 = data[pc + 4]
            insns.append(
                (pc, va, data[pc : pc + 5], f"call 0x{(va + disp16) & 0xFFFFFFFF:08x}, {decode_movm_regs(mask)}, {imm8}")
            )
            pc += 5
            continue
        if b0 == 0xDB and pc + 5 <= end:
            disp32 = struct.unpack("<i", data[pc + 1 : pc + 5])[0]
            insns.append((pc, va, data[pc : pc + 5], f"calls 0x{(va + disp32) & 0xFFFFFFFF:08x}"))
            pc += 5
            continue

        # 7-byte call disp32
        if b0 == 0xDD and pc + 7 <= end:
            disp32 = struct.unpack("<i", data[pc + 1 : pc + 5])[0]
            mask = data[pc + 5]
            imm8 = data[pc + 6]
            insns.append(
                (pc, va, data[pc : pc + 7], f"call 0x{(va + disp32) & 0xFFFFFFFF:08x}, {decode_movm_regs(mask)}, {imm8}")
            )
            pc += 7
            continue

        # 2-byte prefix F0..F7
        if 0xF0 <= b0 <= 0xF7 and pc + 2 <= end:
            b1 = data[pc + 1]
            if b0 == 0xF8:
                pass
            else:
                insns.append((pc, va, data[pc : pc + 2], f"ext_{b0:02x}_{b1:02x}"))
                pc += 2
                continue

        # 3-byte prefix F8
        if b0 == 0xF8 and pc + 3 <= end:
            b1 = data[pc + 1]
            imm8 = struct.unpack("b", data[pc + 2 : pc + 3])[0]
            if b1 == 0xFE:
                insns.append((pc, va, data[pc : pc + 3], f"add {imm8}, sp"))
            else:
                insns.append((pc, va, data[pc : pc + 3], f"ext_f8_{b1:02x} {imm8}"))
            pc += 3
            continue

        # 4-byte prefix FA
        if b0 == 0xFA and pc + 4 <= end:
            b1 = data[pc + 1]
            imm16 = struct.unpack("<h", data[pc + 2 : pc + 4])[0]
            if b1 == 0xFE:
                insns.append((pc, va, data[pc : pc + 4], f"add {imm16}, sp"))
            else:
                insns.append((pc, va, data[pc : pc + 4], f"ext_fa_{b1:02x} 0x{imm16 & 0xFFFF:04x}"))
            pc += 4
            continue

        # 6-byte prefix FC (32-bit imm / abs32)
        if b0 == 0xFC and pc + 6 <= end:
            b1 = data[pc + 1]
            val32 = struct.unpack("<I", data[pc + 2 : pc + 6])[0]
            fc_map = {
                0xCC: f"mov 0x{val32:08x}, d0",
                0xCD: f"mov 0x{val32:08x}, d1",
                0xCE: f"mov 0x{val32:08x}, d2",
                0xCF: f"mov 0x{val32:08x}, d3",
                0xDC: f"mov 0x{val32:08x}, a0",
                0xDD: f"mov 0x{val32:08x}, a1",
                0xDE: f"mov 0x{val32:08x}, a2",
                0xDF: f"mov 0x{val32:08x}, a3",
                0x80: f"mov d0, (0x{val32:08x})",
                0x81: f"mov d1, (0x{val32:08x})",
                0x82: f"movb d0, (0x{val32:08x})",
                0x83: f"movhu d0, (0x{val32:08x})",
                0x84: f"mov a0, (0x{val32:08x})",
                0x85: f"mov a1, (0x{val32:08x})",
                0xAC: f"movhu (0x{val32:08x}), d0",
                0xAD: f"movhu (0x{val32:08x}), d1",
                0xAE: f"movhu (0x{val32:08x}), d2",
                0xAF: f"movhu (0x{val32:08x}), d3",
                0xD8: f"jmp (0x{val32:08x})",
                0xFF: f"calls (0x{val32:08x})",
            }
            mnemonic = fc_map.get(b1, f"ext_fc_{b1:02x} 0x{val32:08x}")
            insns.append((pc, va, data[pc : pc + 6], mnemonic))
            pc += 6
            continue

        # Fallback 1 byte
        insns.append((pc, va, data[pc : pc + 1], f"db 0x{b0:02x}"))
        pc += 1

    return insns


def format_disasm(insns) -> str:
    lines = []
    for off, va, raw, mnem in insns:
        hex_b = " ".join(f"{b:02x}" for b in raw)
        lines.append(f"  0x{va:08x} (file+0x{off:06x}): {hex_b:<20s}  {mnem}")
    return "\n".join(lines)


def main():
    with open(UNPACKED_PATH, "rb") as f:
        data = f.read()

    # 1. Scan for MN10300 function prologues: `cf <mask> f8 fe <sp_delta>` or `cf <mask> fa fe <sp_delta16>`
    # or `cf <mask>` preceded by `cb` (rets) or `df xx yy` (ret)
    code_end = 0x21F428
    prologues = []
    for i in range(0, code_end - 5):
        if data[i] == 0xCF and data[i + 1] in (0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF, 0xA0, 0xB0, 0xD0):
            if (data[i + 2] == 0xF8 and data[i + 3] == 0xFE) or (data[i + 2] == 0xFA and data[i + 3] == 0xFE):
                prologues.append(i)
            elif i >= 1 and data[i - 1] == 0xCB:
                prologues.append(i)
            elif i >= 3 and data[i - 3] == 0xDF:
                prologues.append(i)

    print(f"Discovered {len(prologues)} high-confidence MN103S function prologues (`movm [regs], (sp)`)")

    # 2. Scan all 6-byte `fc <op> <imm32>` instructions in code region (0x000000..0x21F428)
    # to map MMIO peripheral registers (0x9Cxxxxxx) and string/data cross-references (0x55C80000..0x55E9B428)
    mmio_Counter = Counter()
    va_xrefs = defaultdict(list)

    for i in range(0, code_end - 6):
        if data[i] == 0xFC and data[i + 1] in (0xCC, 0xCD, 0xCE, 0xCF, 0xDC, 0xDD, 0xDE, 0xDF, 0x80, 0x81, 0x82, 0x83, 0x84, 0xAC, 0xAD, 0xAE, 0xAF):
            val = struct.unpack("<I", data[i + 2 : i + 6])[0]
            top = val >> 24
            if top == 0x9C:
                mmio_Counter[val & 0xFFFFFF00] += 1
            elif 0x55C80000 <= val < 0x56100000:
                va_xrefs[val].append(file_to_va(i))
            elif DATA_RAM_START <= val < DATA_RAM_START + (DATA_ROM_END - DATA_ROM_START):
                va_xrefs[val].append(file_to_va(i))

    # Also scan 32-bit pointer tables in `.rodata` and `.data`
    ptr_xrefs = defaultdict(list)
    for i in range(0x008000, len(data) - 4, 2):
        val = struct.unpack("<I", data[i : i + 4])[0]
        if 0x55C80000 <= val < 0x56100000:
            if len(ptr_xrefs[val]) < 8:
                ptr_xrefs[val].append(file_to_va(i))

    print("\n=== Top MMIO Peripheral Register Blocks (0x9Cxxxxxx) ===")
    for base, cnt in mmio_Counter.most_common(15):
        print(f"  0x{base:08x}..0x{base+0xff:08x}: {cnt:5d} code references")

    # 3. Disassemble key entry points
    key_routines = {
        "Reset_Bootloader_0x55C7C000": (0x000000, 32),
        "Vector_Table_And_Init_0x55C80000": (0x004000, 32),
        "Kernel_Init_Copy_0x55C800D1": (0x0040D1, 25),
        "CRT0_Init_BSS_And_Data_0x55C9B02C": (0x01F02C, 28),
        "Main_Code_Start_0x55C9C000": (0x020000, 28),
        "EEPROM_Data_Info_Dumper_0x55CE8445": (0x06C445, 28),
        "TZ5_AHX_Updater_Handler_0x55CE93F4": (0x06D3F4, 28),
        "Service_Mode_Camera_Info_0x55D87488": (0x10B488, 30),
        "ROMDATA_And_FIRMWARE_BIN_Handler_0x55D9C0B8": (0x1200B8, 28),
    }

    disasm_dump = {}
    for name, (off, count) in key_routines.items():
        print(f"\n=== Disassembly: {name} (file+0x{off:06x} / VA 0x{file_to_va(off):08x}) ===")
        insns = disasm_mn103(data, off, count)
        text = format_disasm(insns)
        print(text)
        disasm_dump[name] = [
            {"file_offset": f"0x{o:06x}", "va": f"0x{v:08x}", "bytes": r.hex(), "mnemonic": m}
            for o, v, r, m in insns
        ]

    # 4. Resolve XREFs to Notable Strings
    notable_offsets = [
        (0x013F00, "Panasonic"),
        (0x013F10, "DMC-TZ5"),
        (0x013F38, "LUMIX"),
        (0x0384AF, "Copyright (c) 2000-2007 by FotoNation. All rights reserved."),
        (0x1D8DC8, "USBMNT"),
        (0x1D8DE1, "###### EEPROM DATA INFORMATION ######"),
        (0x1E3C34, "\\TZ5.AHX"),
        (0x1E3C3D, "\\TZ5E.AHX"),
        (0x1EEF57, "OIS ADJ"),
        (0x1F37E8, "FOCUS FREE ERROR"),
        (0x1F3892, "OIS ERROR"),
        (0x1F3B63, "SD CARD FORMAT ERROR"),
        (0x1F57A1, "LUMIX Ver.01.00"),
        (0x1F7098, "VER.BIN"),
        (0x1F7174, "EXIF2 -J"),
        (0x20F4FC, "HREQUEST.DPS"),
    ]

    print("\n=== String Virtual Addresses & Cross-References ===")
    string_xref_report = []
    for off, label in notable_offsets:
        va = file_to_va(off)
        # Check exact or nearby (-4..+4) references in code and pointer tables
        code_refs = []
        table_refs = []
        for delta in range(-4, 5):
            code_refs.extend(va_xrefs.get(va + delta, []))
            table_refs.extend(ptr_xrefs.get(va + delta, []))
        print(
            f"  0x{va:08x} (file+0x{off:06x}) {label!r:42s} -> "
            f"code_refs={[hex(x) for x in code_refs[:4]]}, table_refs={[hex(x) for x in table_refs[:4]]}"
        )
        string_xref_report.append(
            {
                "file_offset": f"0x{off:06x}",
                "va": f"0x{va:08x}",
                "string": label,
                "code_xrefs": [f"0x{x:08x}" for x in code_refs[:10]],
                "table_xrefs": [f"0x{x:08x}" for x in table_refs[:10]],
            }
        )

    # 5. Decode Multi-Language OSD String Table in Partition 3 (0x224000 / VA 0x55EA0000)
    # Check pointer table at 0x384e90 pointing into 0x55EAxxxx (Partition 3)
    print("\n=== Multi-Language OSD / UI String Table Samples (Partition 3 @ 0x224000 / VA 0x55EA0000) ===")
    osd_samples = []
    # Scan for UTF-16LE strings with ASCII characters in Partition 3 (0x224000..0x31f118)
    p3 = data[0x224000:0x31F118]
    for m in re.finditer(rb"(?:[\x20-\x7e]\x00){5,}\x00\x00", p3):
        if m.start() % 2 == 0:
            s = m.group(0)[:-2].decode("utf-16le", errors="replace")
            off = 0x224000 + m.start()
            va = file_to_va(off)
            osd_samples.append({"file_offset": f"0x{off:06x}", "va": f"0x{va:08x}", "text": s})
    print(f"Found {len(osd_samples)} UTF-16LE strings in Partition 3 (0x224000..0x31F118)")
    for item in osd_samples[:25]:
        print(f"  {item['va']} ({item['file_offset']}): {item['text'][:70]}")

    out_data = {
        "architecture": "Matsushita/Panasonic MN10300 / MN103S (AM33) 32-bit little-endian RISC",
        "rom_base_va": f"0x{ROM_BASE:08x}",
        "memory_map": [
            {
                "region": "Bootloader & Flash Updater",
                "file_range": "0x000000..0x001305",
                "va_range": "0x55c7c000..0x55c7d305",
                "runtime_dest": "0x400001e4 / 0x4000071c (Fast RAM) & 0x54200000 (SDRAM)",
            },
            {
                "region": "Hardware Reset & Interrupt Vector Table",
                "file_range": "0x004000..0x0049f2",
                "va_range": "0x55c80000..0x55c809f2",
                "runtime_dest": "Executed in place; copies 0x55c80638 to 0x54000400, zeros 0x5400042c..0x540127e4",
            },
            {
                "region": "Panasonic Firmware Header & Model Metadata",
                "file_range": "0x008000..0x013fff",
                "va_range": "0x55c84000..0x55c8ffff",
                "runtime_dest": "Read-only metadata ('Pana' magic, version 1.02, 'DMC-TZ5')",
            },
            {
                "region": "Initialized .data Image",
                "file_range": "0x014000..0x01f02c",
                "va_range": "0x55c90000..0x55c9b02c",
                "runtime_dest": "Copied to SDRAM 0x54012840..0x5401d86c (45,100 bytes)",
            },
            {
                "region": "Zero-Initialized .bss (Main + Uncached SDRAM)",
                "file_range": "N/A (runtime allocated)",
                "va_range": "0x5401d86c..0x54077238 & 0x9809a400..0x980c0000",
                "runtime_dest": "Zeroed by CRT0 at 0x55c9b02c (367,052 B + 154,624 B)",
            },
            {
                "region": "Main Firmware Code (.text) & Read-Only Data (.rodata) [TZ5.AHX]",
                "file_range": "0x01f02c..0x21f428",
                "va_range": "0x55c9b02c..0x55e9b428",
                "runtime_dest": "2,098,172 bytes of MN103S instructions, strings, and tables",
            },
            {
                "region": "OSD / Multi-Language UI / Font Resource Partition",
                "file_range": "0x224000..0x31f118",
                "va_range": "0x55ea0000..0x55f9b118",
                "runtime_dest": "1,028,376 bytes of UTF-16LE strings, glyphs, and UI tables",
            },
            {
                "region": "Upper Resource / Pointer Table Partition (0x12345678 magic)",
                "file_range": "0x384000..0x480f08",
                "va_range": "0x56000000..0x560fcf08",
                "runtime_dest": "1,036,040 bytes of indexed tables and camera/ISP presets",
            },
            {
                "region": "MMIO Peripheral Space",
                "file_range": "N/A (Hardware Registers)",
                "va_range": "0x9c000000..0x9c01ffff",
                "runtime_dest": "Venus Engine IV SoC peripheral, DMA, clock, timer, and flash controller registers",
            },
        ],
        "prologue_count": len(prologues),
        "top_mmio_blocks": [
            {"base": f"0x{base:08x}", "count": cnt} for base, cnt in mmio_Counter.most_common(20)
        ],
        "disassembled_routines": disasm_dump,
        "string_xrefs": string_xref_report,
        "partition3_utf16_samples": osd_samples[:60],
    }

    out_path = os.path.join(OUTPUT_DIR, "04_arch_and_disasm.json")
    with open(out_path, "w") as f:
        json.dump(out_data, f, indent=2)
    print(f"\nSaved architecture & disassembly report to {out_path}")


if __name__ == "__main__":
    main()
