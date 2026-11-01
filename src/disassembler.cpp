#include "tz5/disassembler.hpp"
#include "tz5/symbols.hpp"

#include <algorithm>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5 {

namespace {

constexpr const char* kDRegs[4] = {"d0", "d1", "d2", "d3"};
constexpr const char* kARegs[4] = {"a0", "a1", "a2", "a3"};

std::string hex8(uint8_t v) {
    char buf[16];
    std::snprintf(buf, sizeof(buf), "0x%02X", v);
    return buf;
}

std::string hex16(uint16_t v) {
    char buf[16];
    std::snprintf(buf, sizeof(buf), "0x%04X", v);
    return buf;
}

std::string hex32(uint32_t v) {
    char buf[24];
    std::snprintf(buf, sizeof(buf), "0x%08X", v);
    return buf;
}

std::string escape_json(const std::string& s) {
    std::string out;
    out.reserve(s.size() + 8);
    for (unsigned char c : s) {
        if (c == '"') out += "\\\"";
        else if (c == '\\') out += "\\\\";
        else if (c == '\n') out += "\\n";
        else if (c == '\r') out += "\\r";
        else if (c == '\t') out += "\\t";
        else if (c >= 0x20 && c < 0x7F) out.push_back(static_cast<char>(c));
    }
    return out;
}

} // namespace

Mn103Disassembler::Mn103Disassembler(const FirmwareImage& fw)
    : fw_(fw), symbols_(get_default_code_symbols()) {
    for (const auto& [va, _] : symbols_) {
        function_entries_.insert(va);
    }
}

void Mn103Disassembler::add_symbol(uint32_t va, const std::string& name) {
    symbols_[va] = name;
    function_entries_.insert(va);
}

std::string Mn103Disassembler::format_reg_mask(uint8_t mask) {
    std::vector<std::string> regs;
    if (mask & 0x80u) regs.emplace_back("d2");
    if (mask & 0x40u) regs.emplace_back("d3");
    if (mask & 0x20u) regs.emplace_back("a2");
    if (mask & 0x10u) regs.emplace_back("a3");
    if (mask & 0x08u) regs.emplace_back("other");
    if (mask & 0x04u) regs.emplace_back("exreg0");
    if (mask & 0x02u) regs.emplace_back("exreg1");
    if (mask & 0x01u) regs.emplace_back("exother");
    std::string out = "[";
    for (size_t i = 0; i < regs.size(); ++i) {
        if (i > 0) out += ",";
        out += regs[i];
    }
    out += "]";
    return out;
}

std::string Mn103Disassembler::read_ascii_preview(uint32_t rom_offset, size_t max_len) const {
    const auto& rom = fw_.rom();
    if (rom_offset >= rom.size()) return {};
    std::string out;
    for (size_t i = 0; i < max_len && (rom_offset + i) < rom.size(); ++i) {
        uint8_t c = rom[rom_offset + i];
        if (c == 0) {
            if (out.size() >= 3) return out;
            return {};
        }
        if (c == '\n') {
            out += "\\n";
        } else if (c == '\r') {
            out += "\\r";
        } else if (c == '\t') {
            out += "\\t";
        } else if (c >= 0x20 && c < 0x7F) {
            out.push_back(static_cast<char>(c));
        } else {
            return {};
        }
    }
    return (out.size() >= 4) ? out : std::string{};
}

std::string Mn103Disassembler::read_osd_preview(uint32_t rom_offset, size_t max_chars) const {
    const auto& rom = fw_.rom();
    if (rom_offset + 4 >= rom.size() || (rom_offset & 1u) != 0u) return {};
    std::string out;
    for (size_t i = 0; i < max_chars && (rom_offset + i * 2 + 1) < rom.size(); ++i) {
        uint16_t w = fw_.read_u16_le(rom_offset + static_cast<uint32_t>(i * 2));
        if (w == 0x0003u) {
            return (out.size() >= 2) ? out : std::string{};
        }
        if (w >= 0x0020u && w < 0x007Fu) {
            out.push_back(static_cast<char>(w));
        } else {
            return {};
        }
    }
    return {};
}

std::string Mn103Disassembler::resolve_target_label(uint32_t target_va) const {
    auto it = symbols_.find(target_va);
    if (it != symbols_.end()) {
        return it->second;
    }
    if (function_entries_.count(target_va)) {
        char buf[32];
        std::snprintf(buf, sizeof(buf), "sub_%08X", target_va);
        return buf;
    }
    if (branch_labels_.count(target_va)) {
        char buf[32];
        std::snprintf(buf, sizeof(buf), "loc_%08X", target_va);
        return buf;
    }
    return hex32(target_va);
}

std::string Mn103Disassembler::build_ref_comment(uint32_t ref_va) const {
    if (auto it = symbols_.find(ref_va); it != symbols_.end()) {
        return it->second;
    }
    if (std::string mmio = resolve_mmio_name(ref_va); !mmio.empty()) {
        return "MMIO " + mmio;
    }
    if (ref_va >= FirmwareImage::kRomBaseVa && ref_va < FirmwareImage::kRomEndVa) {
        uint32_t off = ref_va - FirmwareImage::kRomBaseVa;
        if (off >= 0x224000u && off < 0x31F118u) {
            std::string osd = read_osd_preview(off);
            if (!osd.empty()) {
                return "OSD \"" + osd + "\"";
            }
        }
        std::string asc = read_ascii_preview(off);
        if (!asc.empty()) {
            return "str \"" + asc + "\"";
        }
    }
    if (ref_va >= FirmwareImage::kDataRamVa && ref_va < (FirmwareImage::kDataRamVa + FirmwareImage::kDataSize)) {
        uint32_t rom_off = FirmwareImage::kDataRomOff + (ref_va - FirmwareImage::kDataRamVa);
        uint32_t init_val = fw_.read_u32_le(rom_off);
        std::string asc = read_ascii_preview(rom_off);
        char buf[96];
        if (!asc.empty()) {
            std::snprintf(buf, sizeof(buf), ".data (ROM 0x%06X) str \"%s\"", rom_off, asc.c_str());
        } else {
            std::snprintf(buf, sizeof(buf), ".data (ROM 0x%06X, init=0x%08X)", rom_off, init_val);
        }
        return buf;
    }
    if (ref_va >= FirmwareImage::kBssRamStart && ref_va < FirmwareImage::kBssRamEnd) {
        return ".bss (SDRAM)";
    }
    if (ref_va >= 0x40000000u && ref_va < 0x40004000u) {
        return "On-Chip Fast RAM";
    }
    if (ref_va >= 0x98000000u && ref_va < 0x9A000000u) {
        return "Uncached DMA/Framebuffer SDRAM";
    }
    return {};
}

DecodedInstruction Mn103Disassembler::decode_one(uint32_t rom_offset) const {
    DecodedInstruction insn;
    insn.rom_offset = rom_offset;
    insn.va = FirmwareImage::rom_offset_to_va(rom_offset);

    const auto& rom = fw_.rom();
    if (rom_offset >= rom.size()) {
        insn.size = 1;
        insn.mnemonic = ".byte";
        insn.operands = "0xFF";
        return insn;
    }

    const size_t rem = rom.size() - rom_offset;
    const uint8_t b0 = rom[rom_offset];

    // 1. Function prologues & epilogues
    if (b0 == 0xCFu && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "movm";
        insn.operands = format_reg_mask(rom[rom_offset + 1]) + ", (sp)";
        return insn;
    }
    if (b0 == 0xCEu && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "movm";
        insn.operands = "(sp), " + format_reg_mask(rom[rom_offset + 1]);
        return insn;
    }
    if ((b0 == 0xDFu || b0 == 0xDEu) && rem >= 3) {
        insn.size = 3;
        insn.mnemonic = (b0 == 0xDFu) ? "ret" : "retf";
        insn.operands = format_reg_mask(rom[rom_offset + 1]) + ", " + std::to_string(rom[rom_offset + 2]);
        insn.is_return = true;
        return insn;
    }

    // 2. Single-byte instructions: nop (0xCB), setlb (0xDB), lbcc (0xD0..0xDA)
    if (b0 == 0xCBu) {
        insn.size = 1;
        insn.mnemonic = "nop";
        return insn;
    }
    if (b0 == 0xDBu) {
        insn.size = 1;
        insn.mnemonic = "setlb";
        insn.comment = "Load next 4 bytes into LIR hardware loop buffer";
        return insn;
    }
    if (b0 >= 0xD0u && b0 <= 0xDAu) {
        static constexpr const char* kLbNames[11] = {
            "lblt", "lbgt", "lbge", "lble", "lbcs", "lbhi", "lbcc", "lbls", "lbeq", "lbne", "lbra"
        };
        insn.size = 1;
        insn.mnemonic = kLbNames[b0 - 0xD0u];
        return insn;
    }

    // 3. Relative Calls and Jumps (0xCA, 0xCC, 0xCD, 0xDC, 0xDD)
    if (b0 >= 0xC0u && b0 <= 0xCAu && rem >= 2) {
        static constexpr const char* kBrNames[11] = {
            "blt", "bgt", "bge", "ble", "bcs", "bhi", "bcc", "bls", "beq", "bne", "bra"
        };
        int8_t disp8 = static_cast<int8_t>(rom[rom_offset + 1]);
        uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + disp8);
        insn.size = 2;
        insn.mnemonic = kBrNames[b0 - 0xC0u];
        insn.branch_target = target;
        insn.operands = resolve_target_label(target);
        return insn;
    }
    if (b0 == 0xCCu && rem >= 3) {
        int16_t disp16 = fw_.read_i16_le(rom_offset + 1);
        uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + disp16);
        insn.size = 3;
        insn.mnemonic = "jmp";
        insn.branch_target = target;
        insn.operands = resolve_target_label(target);
        return insn;
    }
    if (b0 == 0xDCu && rem >= 5) {
        int32_t disp32 = fw_.read_i32_le(rom_offset + 1);
        uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + disp32);
        insn.size = 5;
        insn.mnemonic = "jmp";
        insn.branch_target = target;
        insn.operands = resolve_target_label(target);
        return insn;
    }
    if (b0 == 0xCDu && rem >= 5) {
        int16_t disp16 = fw_.read_i16_le(rom_offset + 1);
        uint8_t mask = rom[rom_offset + 3];
        uint8_t stack_disp = rom[rom_offset + 4];
        uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + disp16);
        insn.size = 5;
        insn.mnemonic = "call";
        insn.is_call = true;
        insn.branch_target = target;
        insn.operands = resolve_target_label(target) + ", " + format_reg_mask(mask) + ", " + std::to_string(stack_disp);
        return insn;
    }
    if (b0 == 0xDDu && rem >= 7) {
        int32_t disp32 = fw_.read_i32_le(rom_offset + 1);
        uint8_t mask = rom[rom_offset + 5];
        uint8_t stack_disp = rom[rom_offset + 6];
        uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + disp32);
        insn.size = 7;
        insn.mnemonic = "call";
        insn.is_call = true;
        insn.branch_target = target;
        insn.operands = resolve_target_label(target) + ", " + format_reg_mask(mask) + ", " + std::to_string(stack_disp);
        return insn;
    }

    // 4. 6-byte Extended Instructions (0xFC <subop> <imm32/addr32>)
    if (b0 == 0xFCu && rem >= 6) {
        uint8_t sub = rom[rom_offset + 1];
        uint32_t v32 = fw_.read_u32_le(rom_offset + 2);
        insn.size = 6;
        insn.mem_or_imm_ref = v32;
        insn.comment = build_ref_comment(v32);

        if (sub >= 0xCCu && sub <= 0xCFu) {
            insn.mnemonic = "mov";
            insn.operands = hex32(v32) + ", " + kDRegs[sub - 0xCCu];
            return insn;
        }
        if (sub >= 0xDCu && sub <= 0xDFu) {
            insn.mnemonic = "mov";
            insn.operands = hex32(v32) + ", " + kARegs[sub - 0xDCu];
            return insn;
        }
        if (sub >= 0x80u && sub <= 0x83u) {
            insn.mnemonic = "mov";
            insn.operands = std::string(kDRegs[sub & 3u]) + ", (" + hex32(v32) + ")";
            return insn;
        }
        if (sub >= 0x84u && sub <= 0x87u) {
            insn.mnemonic = "movb";
            insn.operands = std::string(kDRegs[sub & 3u]) + ", (" + hex32(v32) + ")";
            return insn;
        }
        if (sub >= 0x88u && sub <= 0x8Bu) {
            insn.mnemonic = "movhu";
            insn.operands = std::string(kDRegs[sub & 3u]) + ", (" + hex32(v32) + ")";
            return insn;
        }
        if (sub >= 0xA0u && sub <= 0xA3u) {
            insn.mnemonic = "mov";
            insn.operands = "(" + hex32(v32) + "), " + kDRegs[sub & 3u];
            return insn;
        }
        if (sub >= 0xA4u && sub <= 0xA7u) {
            insn.mnemonic = "movbu";
            insn.operands = "(" + hex32(v32) + "), " + kDRegs[sub & 3u];
            return insn;
        }
        if (sub >= 0xACu && sub <= 0xAFu) {
            insn.mnemonic = "movhu";
            insn.operands = "(" + hex32(v32) + "), " + kDRegs[sub & 3u];
            return insn;
        }
        if (sub >= 0x90u && sub <= 0x93u) {
            insn.mnemonic = "mov";
            insn.operands = std::string(kARegs[sub & 3u]) + ", (" + hex32(v32) + ")";
            return insn;
        }
        if (sub >= 0xB0u && sub <= 0xB3u) {
            insn.mnemonic = "mov";
            insn.operands = "(" + hex32(v32) + "), " + kARegs[sub & 3u];
            return insn;
        }
        if (sub >= 0xD0u && sub <= 0xD3u) {
            insn.mnemonic = "add";
            insn.operands = hex32(v32) + ", " + kDRegs[sub & 3u];
            return insn;
        }
        if (sub >= 0xD4u && sub <= 0xD7u) {
            insn.mnemonic = "cmp";
            insn.operands = hex32(v32) + ", " + kDRegs[sub & 3u];
            return insn;
        }
        if (sub >= 0xE4u && sub <= 0xE7u) {
            insn.mnemonic = "and";
            insn.operands = hex32(v32) + ", " + kDRegs[sub & 3u];
            return insn;
        }
        if (sub >= 0xE8u && sub <= 0xEBu) {
            insn.mnemonic = "or";
            insn.operands = hex32(v32) + ", " + kDRegs[sub & 3u];
            return insn;
        }
        if (sub == 0xFFu) {
            uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + static_cast<int32_t>(v32));
            insn.mnemonic = "calls";
            insn.is_call = true;
            insn.branch_target = target;
            insn.operands = resolve_target_label(target);
            return insn;
        }
        insn.mnemonic = "ext_fc_" + hex8(sub).substr(2);
        insn.operands = hex32(v32);
        return insn;
    }

    // 5. 4-byte Extended Instructions (0xFA / 0xFB)
    if ((b0 == 0xFAu || b0 == 0xFBu) && rem >= 4) {
        uint8_t sub = rom[rom_offset + 1];
        uint16_t v16 = fw_.read_u16_le(rom_offset + 2);
        insn.size = 4;
        if (b0 == 0xFAu && sub == 0xFFu) {
            int16_t disp16 = static_cast<int16_t>(v16);
            uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + disp16);
            insn.mnemonic = "calls";
            insn.is_call = true;
            insn.branch_target = target;
            insn.operands = resolve_target_label(target);
            return insn;
        }
        if (b0 == 0xFAu && sub >= 0xC8u && sub <= 0xCFu) {
            int16_t disp16 = static_cast<int16_t>(v16);
            uint32_t target = static_cast<uint32_t>(static_cast<int64_t>(insn.va) + disp16);
            insn.mnemonic = "bxx16";
            insn.branch_target = target;
            insn.operands = resolve_target_label(target);
            return insn;
        }
        insn.mnemonic = (b0 == 0xFAu ? "ext_fa_" : "ext_fb_") + hex8(sub).substr(2);
        insn.operands = hex16(v16);
        return insn;
    }

    // 6. 3-byte Extended Instructions (0xF8 / 0xF9)
    if ((b0 == 0xF8u || b0 == 0xF9u) && rem >= 3) {
        uint8_t sub = rom[rom_offset + 1];
        uint8_t imm8 = rom[rom_offset + 2];
        insn.size = 3;
        if (b0 == 0xF8u && sub == 0xFEu) {
            insn.mnemonic = "add";
            insn.operands = std::to_string(static_cast<int8_t>(imm8)) + ", sp";
            return insn;
        }
        if (b0 == 0xF8u && (sub & 0xF0u) == 0x90u) {
            insn.mnemonic = "movbu";
            insn.operands = std::string(kDRegs[(sub >> 2) & 3u]) + ", (" + std::to_string(imm8) + ", " + kARegs[sub & 3u] + ")";
            return insn;
        }
        insn.mnemonic = (b0 == 0xF8u ? "ext_f8_" : "ext_f9_") + hex8(sub).substr(2);
        insn.operands = hex8(imm8);
        return insn;
    }

    // 7. 2-byte Extended Instructions (0xF0 .. 0xF7)
    if (b0 >= 0xF0u && b0 <= 0xF7u && rem >= 2) {
        uint8_t sub = rom[rom_offset + 1];
        insn.size = 2;
        if (b0 == 0xF0u) {
            if (sub == 0xFCu) {
                insn.mnemonic = "rets";
                insn.is_return = true;
                return insn;
            }
            if (sub == 0xFDu) {
                insn.mnemonic = "rti";
                insn.is_return = true;
                return insn;
            }
            if (sub >= 0xF0u && sub <= 0xF3u) {
                insn.mnemonic = "calls";
                insn.is_call = true;
                insn.operands = std::string("(") + kARegs[sub & 3u] + ")";
                return insn;
            }
            if (sub >= 0xF4u && sub <= 0xF7u) {
                insn.mnemonic = "jmp";
                insn.operands = std::string("(") + kARegs[sub & 3u] + ")";
                return insn;
            }
            if (sub == 0x00u) {
                insn.mnemonic = "nop2";
                return insn;
            }
        }
        insn.mnemonic = "ext_f" + std::to_string(b0 - 0xF0u) + "_" + hex8(sub).substr(2);
        return insn;
    }

    // 8. 5-byte (0xFD) and 7-byte (0xFE) extended opcodes
    if (b0 == 0xFDu && rem >= 5) {
        insn.size = 5;
        insn.mnemonic = "ext_fd_" + hex8(rom[rom_offset + 1]).substr(2);
        insn.operands = hex16(fw_.read_u16_le(rom_offset + 2)) + ", " + hex8(rom[rom_offset + 4]);
        return insn;
    }
    if (b0 == 0xFEu && rem >= 7) {
        insn.size = 7;
        insn.mnemonic = "ext_fe_" + hex8(rom[rom_offset + 1]).substr(2);
        insn.operands = hex32(fw_.read_u32_le(rom_offset + 2)) + ", " + hex8(rom[rom_offset + 6]);
        return insn;
    }

    // 9. Standard 1/2/3-byte MN10300 instructions
    if (b0 >= 0x80u && b0 <= 0x83u && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "mov";
        insn.operands = hex8(rom[rom_offset + 1]) + ", " + kDRegs[b0 - 0x80u];
        return insn;
    }
    if (b0 >= 0x90u && b0 <= 0x93u && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "mov";
        insn.operands = hex8(rom[rom_offset + 1]) + ", " + kARegs[b0 - 0x90u];
        return insn;
    }
    if (b0 >= 0x2Cu && b0 <= 0x2Fu && rem >= 3) {
        insn.size = 3;
        insn.mnemonic = "mov";
        insn.operands = hex16(fw_.read_u16_le(rom_offset + 1)) + ", " + kDRegs[b0 - 0x2Cu];
        return insn;
    }
    if (b0 >= 0x24u && b0 <= 0x27u && rem >= 3) {
        insn.size = 3;
        insn.mnemonic = "mov";
        insn.operands = hex16(fw_.read_u16_le(rom_offset + 1)) + ", " + kARegs[b0 - 0x24u];
        return insn;
    }
    if (b0 >= 0x20u && b0 <= 0x23u && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "add";
        insn.operands = std::to_string(static_cast<int8_t>(rom[rom_offset + 1])) + ", " + kDRegs[b0 - 0x20u];
        return insn;
    }
    if (b0 >= 0x28u && b0 <= 0x2Bu && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "cmp";
        insn.operands = hex8(rom[rom_offset + 1]) + ", " + kDRegs[b0 - 0x28u];
        return insn;
    }
    if (b0 >= 0x3Cu && b0 <= 0x3Fu && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "mov";
        insn.operands = std::string(kDRegs[b0 - 0x3Cu]) + ", (" + std::to_string(rom[rom_offset + 1]) + ", sp)";
        return insn;
    }
    if (b0 >= 0x40u && b0 <= 0x43u && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "mov";
        insn.operands = std::string(kARegs[b0 - 0x40u]) + ", (" + std::to_string(rom[rom_offset + 1]) + ", sp)";
        return insn;
    }
    if (b0 >= 0x58u && b0 <= 0x5Bu && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "mov";
        insn.operands = "(" + std::to_string(rom[rom_offset + 1]) + ", sp), " + kDRegs[b0 - 0x58u];
        return insn;
    }
    if (b0 >= 0x5Cu && b0 <= 0x5Fu && rem >= 2) {
        insn.size = 2;
        insn.mnemonic = "mov";
        insn.operands = "(" + std::to_string(rom[rom_offset + 1]) + ", sp), " + kARegs[b0 - 0x5Cu];
        return insn;
    }

    // 1-byte register operations
    insn.size = 1;
    if (b0 >= 0x84u && b0 <= 0x8Fu) {
        insn.mnemonic = "mov";
        insn.operands = std::string(kDRegs[(b0 >> 2) & 3u]) + ", " + kDRegs[b0 & 3u];
        return insn;
    }
    if (b0 >= 0x94u && b0 <= 0x9Fu) {
        insn.mnemonic = "mov";
        insn.operands = std::string(kARegs[(b0 >> 2) & 3u]) + ", " + kARegs[b0 & 3u];
        return insn;
    }
    if (b0 >= 0x60u && b0 <= 0x6Fu) {
        insn.mnemonic = "mov";
        insn.operands = std::string("(") + kARegs[b0 & 3u] + "), " + kDRegs[(b0 >> 2) & 3u];
        return insn;
    }
    if (b0 >= 0x70u && b0 <= 0x7Fu) {
        insn.mnemonic = "mov";
        insn.operands = std::string(kDRegs[(b0 >> 2) & 3u]) + ", (" + kARegs[b0 & 3u] + ")";
        return insn;
    }
    if (b0 >= 0xE0u && b0 <= 0xEFu) {
        insn.mnemonic = "add";
        insn.operands = std::string(kDRegs[(b0 >> 2) & 3u]) + ", " + kDRegs[b0 & 3u];
        return insn;
    }

    insn.mnemonic = "db_op_" + hex8(b0).substr(2);
    insn.operands = hex8(b0);
    return insn;
}

void Mn103Disassembler::run_discovery_pass(DisassemblyStats& stats) {
    struct Range {
        uint32_t start;
        uint32_t end;
        bool is_cave;
    };

    std::vector<Range> ranges = {
        {0x000000u, 0x001305u, false}, // Bootloader & Flash Updater
        {0x004000u, 0x0049F2u, false}, // Hardware Reset & Interrupt Vector Table + Kernel Init
        {0x01F02Cu, 0x1D8DC0u, false}, // CRT0 + Main Firmware .text
        {0x21BFC0u, 0x21F428u, false}  // High .text & Master IRQ Dispatcher
    };

    // Also include any non-0xFF bytes inside CAVE_MAIN_TEXT (0x21F428..0x224000)
    const auto& rom = fw_.rom();
    uint32_t cave_end = 0x21F428u;
    for (uint32_t off = 0x223FFFu; off >= 0x21F428u; --off) {
        if (rom[off] != 0xFFu) {
            cave_end = off + 1u;
            break;
        }
    }
    if (cave_end > 0x21F428u) {
        ranges.push_back({0x21F428u, cave_end, true});
    }

    for (const auto& r : ranges) {
        uint32_t pc = r.start;
        while (pc < r.end) {
            DecodedInstruction insn = decode_one(pc);
            stats.total_instructions++;
            if (r.is_cave) {
                stats.custom_cave_instructions++;
            }
            if (insn.mnemonic == "movm" && insn.operands.find(", (sp)") != std::string::npos) {
                function_entries_.insert(insn.va);
            }
            if (insn.branch_target) {
                uint32_t target = *insn.branch_target;
                if (target >= FirmwareImage::kRomBaseVa && target < FirmwareImage::kRomEndVa) {
                    if (insn.is_call) {
                        function_entries_.insert(target);
                        call_counts_[target]++;
                        stats.total_call_edges++;
                    } else {
                        branch_labels_.insert(target);
                    }
                }
            }
            if (insn.mem_or_imm_ref) {
                uint32_t ref = *insn.mem_or_imm_ref;
                if (!resolve_mmio_name(ref).empty()) {
                    stats.total_mmio_xrefs++;
                } else if (ref >= FirmwareImage::kDataRamVa && ref < FirmwareImage::kBssRamEnd) {
                    stats.total_sdram_xrefs++;
                } else if (ref >= FirmwareImage::kRomBaseVa && ref < FirmwareImage::kRomEndVa) {
                    uint32_t off = ref - FirmwareImage::kRomBaseVa;
                    if (!read_ascii_preview(off).empty() || !read_osd_preview(off).empty()) {
                        stats.total_string_xrefs++;
                    }
                }
            }
            pc += insn.size;
        }
    }

    stats.total_functions = function_entries_.size();
    stats.total_branch_labels = branch_labels_.size();
}

std::string Mn103Disassembler::disassemble_range_to_string(uint32_t start_rom_offset,
                                                           uint32_t end_rom_offset,
                                                           const std::string& section_title) {
    std::ostringstream out;
    out << "; ==============================================================================\n";
    out << "; Section: " << section_title << "\n";
    out << "; ROM Offset: 0x" << std::hex << std::uppercase << std::setw(6) << std::setfill('0') << start_rom_offset
        << " .. 0x" << std::setw(6) << end_rom_offset << "\n";
    out << "; Virtual Address: 0x" << std::setw(8) << FirmwareImage::rom_offset_to_va(start_rom_offset)
        << " .. 0x" << std::setw(8) << FirmwareImage::rom_offset_to_va(end_rom_offset) << "\n";
    out << "; Architecture: Matsushita MN10300 / MN103S (AM33) 32-bit RISC\n";
    out << "; ==============================================================================\n\n";

    const auto& rom = fw_.rom();
    uint32_t pc = start_rom_offset;
    while (pc < end_rom_offset && pc < rom.size()) {
        uint32_t va = FirmwareImage::rom_offset_to_va(pc);

        if (auto sym_it = symbols_.find(va); sym_it != symbols_.end()) {
            out << "\n; ------------------------------------------------------------------------------\n";
            out << "; FUNCTION: " << sym_it->second << " (VA 0x" << std::hex << std::uppercase << std::setw(8) << std::setfill('0') << va << ")\n";
            if (auto cnt_it = call_counts_.find(va); cnt_it != call_counts_.end()) {
                out << "; Call XREFs: " << std::dec << cnt_it->second << "\n";
            }
            out << "; ------------------------------------------------------------------------------\n";
            out << sym_it->second << ":\n";
        } else if (function_entries_.count(va)) {
            char fbuf[32];
            std::snprintf(fbuf, sizeof(fbuf), "sub_%08X", va);
            out << "\n; --- Function " << fbuf << " (callers: " << std::dec << call_counts_[va] << ") ---\n";
            out << fbuf << ":\n";
        } else if (branch_labels_.count(va)) {
            char lbuf[32];
            std::snprintf(lbuf, sizeof(lbuf), "loc_%08X", va);
            out << lbuf << ":\n";
        }

        DecodedInstruction insn = decode_one(pc);

        char hex_bytes[32] = {0};
        size_t pos = 0;
        for (uint8_t i = 0; i < insn.size && (pc + i) < rom.size(); ++i) {
            pos += static_cast<size_t>(std::snprintf(hex_bytes + pos, sizeof(hex_bytes) - pos, "%02X ", rom[pc + i]));
        }

        char line_buf[256];
        if (insn.comment.empty()) {
            std::snprintf(line_buf, sizeof(line_buf), "  %08X: %-21s %-10s %s\n",
                          va, hex_bytes, insn.mnemonic.c_str(), insn.operands.c_str());
        } else {
            std::snprintf(line_buf, sizeof(line_buf), "  %08X: %-21s %-10s %-30s ; %s\n",
                          va, hex_bytes, insn.mnemonic.c_str(), insn.operands.c_str(), insn.comment.c_str());
        }
        out << line_buf;

        pc += insn.size;
    }

    return out.str();
}

bool Mn103Disassembler::disassemble_all_to_dir(const std::string& out_dir,
                                               DisassemblyStats* out_stats,
                                               std::string* err) {
    namespace fs = std::filesystem;
    std::error_code ec;
    fs::create_directories(out_dir, ec);
    if (ec) {
        if (err) *err = "Failed to create disassembly directory: " + out_dir;
        return false;
    }

    DisassemblyStats stats{};
    run_discovery_pass(stats);

    std::string asm_boot = disassemble_range_to_string(
        0x000000u, 0x001305u, "00 - Bootloader & Flash Updater (0x55C7C000..0x55C7D305)");
    std::string asm_vecs = disassemble_range_to_string(
        0x004000u, 0x0049F2u, "01 - Hardware Reset & Interrupt Vector Table + Kernel Init (0x55C80000..0x55C809F2)");
    std::string asm_main = disassemble_range_to_string(
        0x01F02Cu, 0x1D8DC0u, "02 - CRT0 & Main Firmware .text (0x55C9B02C..0x55E54DC0)");
    std::string asm_high = disassemble_range_to_string(
        0x21BFC0u, 0x21F428u, "03 - High .text & Master Interrupt Dispatcher (0x55E97FC0..0x55E9B428)");

    // Check if CAVE_MAIN_TEXT (0x21F428..0x224000) contains any custom injected code/strings
    const auto& rom = fw_.rom();
    uint32_t cave_end = 0x21F428u;
    for (uint32_t off = 0x223FFFu; off >= 0x21F428u; --off) {
        if (rom[off] != 0xFFu) {
            cave_end = off + 1u;
            break;
        }
    }
    std::string asm_cave;
    if (cave_end > 0x21F428u) {
        asm_cave = disassemble_range_to_string(
            0x21F428u, cave_end, "04 - Injected Custom Feature Code Cave (CAVE_MAIN_TEXT 0x55E9B428+)");
    }

    // Write individual section .asm files
    auto write_text = [&](const std::string& filename, const std::string& content) -> bool {
        std::string full_path = (fs::path(out_dir) / filename).string();
        std::ofstream ofs(full_path, std::ios::binary | std::ios::trunc);
        if (!ofs) {
            if (err) *err = "Failed to write " + full_path;
            return false;
        }
        ofs.write(content.data(), static_cast<std::streamsize>(content.size()));
        return true;
    };

    if (!write_text("00_bootloader.asm", asm_boot)) return false;
    if (!write_text("01_vectors_and_init.asm", asm_vecs)) return false;
    if (!write_text("02_main_firmware.asm", asm_main)) return false;
    if (!write_text("03_high_irq_dispatcher.asm", asm_high)) return false;
    if (!asm_cave.empty()) {
        if (!write_text("04_custom_features.asm", asm_cave)) return false;
    }

    // Also write unified tz5_full.asm
    {
        std::string full_path = (fs::path(out_dir) / "tz5_full.asm").string();
        std::ofstream ofs(full_path, std::ios::binary | std::ios::trunc);
        if (!ofs) {
            if (err) *err = "Failed to write " + full_path;
            return false;
        }
        ofs << asm_boot << "\n" << asm_vecs << "\n" << asm_main << "\n" << asm_high;
        if (!asm_cave.empty()) {
            ofs << "\n" << asm_cave;
        }
    }

    // Write functions_and_xrefs.json
    {
        std::string json_path = (fs::path(out_dir) / "functions_and_xrefs.json").string();
        std::ofstream jfs(json_path, std::ios::binary | std::ios::trunc);
        if (!jfs) {
            if (err) *err = "Failed to write " + json_path;
            return false;
        }
        jfs << "{\n";
        jfs << "  \"architecture\": \"Matsushita MN10300 / MN103S (AM33)\",\n";
        jfs << "  \"rom_base_va\": \"0x55C7C000\",\n";
        jfs << "  \"total_instructions\": " << stats.total_instructions << ",\n";
        jfs << "  \"total_functions\": " << stats.total_functions << ",\n";
        jfs << "  \"total_call_edges\": " << stats.total_call_edges << ",\n";
        jfs << "  \"total_branch_labels\": " << stats.total_branch_labels << ",\n";
        jfs << "  \"total_string_xrefs\": " << stats.total_string_xrefs << ",\n";
        jfs << "  \"total_mmio_xrefs\": " << stats.total_mmio_xrefs << ",\n";
        jfs << "  \"total_sdram_xrefs\": " << stats.total_sdram_xrefs << ",\n";
        jfs << "  \"custom_cave_instructions\": " << stats.custom_cave_instructions << ",\n";
        jfs << "  \"named_symbols\": [\n";
        std::vector<std::pair<uint32_t, std::string>> sorted_syms(symbols_.begin(), symbols_.end());
        std::sort(sorted_syms.begin(), sorted_syms.end(), [](const auto& a, const auto& b) {
            return a.first < b.first;
        });
        for (size_t i = 0; i < sorted_syms.size(); ++i) {
            const auto& [va, name] = sorted_syms[i];
            jfs << "    {\"va\": \"" << hex32(va) << "\", \"name\": \"" << escape_json(name)
                << "\", \"callers\": " << call_counts_[va] << "}"
                << (i + 1 < sorted_syms.size() ? "," : "") << "\n";
        }
        jfs << "  ]\n";
        jfs << "}\n";
    }

    if (out_stats) {
        *out_stats = stats;
    }
    return true;
}

} // namespace tz5
