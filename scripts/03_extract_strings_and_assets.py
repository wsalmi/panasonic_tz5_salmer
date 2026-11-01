#!/usr/bin/env python3
"""
Phase 3: String, Debug Symbol, and Embedded Resource Extraction for TZ5_unpacked.bin.
Inspects the 0x008000 'Pana' header, 0x384000 region, 0x484000 trailer,
extracts ASCII and UTF-16LE strings across the unpacked image, categorizes them
by subsystem, and carves embedded JPEGs/assets.
"""

import hashlib
import json
import os
import re
import struct

OUTPUT_DIR = "/Users/wesleysalmi/source-me/tz5-rea/output"
UNPACKED_PATH = os.path.join(OUTPUT_DIR, "TZ5_unpacked.bin")
ASSETS_DIR = os.path.join(OUTPUT_DIR, "assets")


def hexdump(data: bytes, base_offset: int = 0, lines: int = 16) -> str:
    out = []
    for i in range(0, min(len(data), lines * 16), 16):
        chunk = data[i : i + 16]
        hex_part = " ".join(f"{b:02x}" for b in chunk)
        ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        out.append(f"{base_offset + i:08x}  {hex_part:<47}  |{ascii_part}|")
    return "\n".join(out)


def extract_ascii_strings(data: bytes, min_len: int = 5):
    pattern = re.compile(rb"[\x20-\x7e]{" + str(min_len).encode() + rb",}\x00")
    results = []
    for m in pattern.finditer(data):
        s = m.group(0)[:-1].decode("ascii", errors="replace")
        results.append((m.start(), s))
    return results


def extract_utf16le_strings(data: bytes, min_len: int = 4):
    # Match sequences of printable ASCII in UTF-16LE terminated by 0x0000
    pattern = re.compile(rb"(?:[\x20-\x7e]\x00){" + str(min_len).encode() + rb",}\x00\x00")
    results = []
    for m in pattern.finditer(data):
        if m.start() % 2 == 0:
            s = m.group(0)[:-2].decode("utf-16le", errors="replace")
            results.append((m.start(), s))
    return results


def extract_osd_0003_strings(data: bytes, min_len: int = 3):
    """
    Panasonic Venus Engine IV OSD strings use 16-bit LE code units terminated by 0x0003 (03 00).
    """
    pattern = re.compile(rb"(?:[\x20-\x7e]\x00){" + str(min_len).encode() + rb",}\x03\x00")
    results = []
    for m in pattern.finditer(data):
        if m.start() % 2 == 0:
            s = m.group(0)[:-2].decode("utf-16le", errors="replace")
            results.append((m.start(), s))
    return results


def carve_jpegs(data: bytes):
    # Find JPEG SOI (FF D8 FF E0 or FF D8 FF E1 or FF D8 FF DB) and EOI (FF D9)
    jpegs = []
    pos = 0
    while True:
        idx = data.find(b"\xff\xd8\xff", pos)
        if idx == -1:
            break
        if idx + 3 < len(data) and data[idx + 3] in (0xC0, 0xDB, 0xE0, 0xE1, 0xFE):
            # Look for EOI within reasonable size (e.g., 512 bytes .. 256 KB)
            eoi = data.find(b"\xff\xd9", idx + 4)
            while eoi != -1 and (eoi - idx) < 262144:
                candidate = data[idx : eoi + 2]
                # Check if valid JPEG structure (contains SOF0 FF C0 and SOS FF DA)
                if b"\xff\xc0" in candidate and b"\xff\xda" in candidate and b"\xff\xdb" in candidate:
                    jpegs.append((idx, eoi + 2, candidate))
                    break
                eoi = data.find(b"\xff\xd9", eoi + 2)
        pos = idx + 3
    return jpegs


def main():
    os.makedirs(ASSETS_DIR, exist_ok=True)
    with open(UNPACKED_PATH, "rb") as f:
        data = f.read()

    print("=== Inspecting Key Boundaries in TZ5_unpacked.bin ===")
    print("\n--- 0x008000 ('Pana' Header + Table) ---")
    print(hexdump(data[0x008000 : 0x008000 + 512], 0x008000, 32))

    print("\n--- 0x01f000 - 0x020200 (Code/Data Transition) ---")
    print(hexdump(data[0x01F000 : 0x01F000 + 256], 0x01F000, 16))
    print(hexdump(data[0x020000 : 0x020000 + 256], 0x020000, 16))

    print("\n--- 0x384000 (Start of Upper Partition after 64KB 0x00 block) ---")
    print(hexdump(data[0x384000 : 0x384000 + 256], 0x384000, 16))

    ascii_strings = extract_ascii_strings(data, min_len=5)
    utf16_strings = extract_utf16le_strings(data, min_len=4)
    osd_strings = extract_osd_0003_strings(data, min_len=3)
    print(f"\nTotal null-terminated ASCII strings (len>=5): {len(ascii_strings)}")
    print(f"Total null-terminated UTF-16LE strings (len>=4): {len(utf16_strings)}")
    print(f"Total 0x0003-terminated OSD UTF-16LE strings (len>=3): {len(osd_strings)}")
    print("\n=== Sample 0x0003-Terminated OSD UI Strings ===")
    for off, s in osd_strings[:60]:
        print(f"  0x{off:06x} (VA 0x{0x55c7c000+off:08x}): {s}")

    # Categorize ASCII strings
    categories = {
        "source_files": [],
        "model_and_version": [],
        "rtos_and_tasks": [],
        "camera_isp_lens_af": [],
        "filesystem_sd_usb_ptp": [],
        "video_audio_hdmi": [],
        "service_debug_errors": [],
    }

    for off, s in ascii_strings:
        s_clean = s.strip()
        if len(s_clean) < 4:
            continue
        rec = {"offset": f"0x{off:06x}", "string": s}
        if re.search(r"\.[chCH]\b|\.cpp\b|\.s\b", s):
            categories["source_files"].append(rec)
        if re.search(r"DMC-|TZ5|Lumix|Panasonic|Ver\.|VERSION|Matsushita|VENUS|200[78]", s, re.I):
            categories["model_and_version"].append(rec)
        if re.search(r"task|sem|flg|mbx|mpf|cyc|isr|kernel|thread|stack|mutex|queue", s, re.I):
            categories["rtos_and_tasks"].append(rec)
        if re.search(r"lens|zoom|focus|af_|ae_|awb|ois|gyro|ccd|cmos|shutter|iris|flash|strobe|alc|agc", s, re.I):
            categories["camera_isp_lens_af"].append(rec)
        if re.search(r"fat|dcf|exif|dpof|sd_|mmc|card|usb|ptp|pictbridge|dps|mass_storage|fopen|fwrite", s, re.I):
            categories["filesystem_sd_usb_ptp"].append(rec)
        if re.search(r"mjpeg|mov|wave|audio|video|hdmi|ntsc|pal|hd_|720|1280", s, re.I):
            categories["video_audio_hdmi"].append(rec)
        if re.search(r"err|assert|warn|debug|test|fact|adj|rom|backup|eeprom|flash_rom|firm|upd", s, re.I):
            categories["service_debug_errors"].append(rec)

    print("\n=== Categorized String Counts ===")
    for k, v in categories.items():
        print(f"  {k:24s}: {len(v):5d} matches")
        for sample in v[:15]:
            print(f"    {sample['offset']}: {sample['string'][:90]}")

    print("\n=== Sample UTF-16LE Strings ===")
    for off, s in utf16_strings[:40]:
        print(f"  0x{off:06x}: {s[:80]}")

    # Carve JPEGs
    jpegs = carve_jpegs(data)
    print(f"\n=== Carved Embedded JPEGs: {len(jpegs)} ===")
    carved_manifest = []
    for idx, (s, e, blob) in enumerate(jpegs):
        fname = f"jpeg_{idx:02d}_0x{s:06x}_{e-s}B.jpg"
        fpath = os.path.join(ASSETS_DIR, fname)
        with open(fpath, "wb") as jf:
            jf.write(blob)
        sha = hashlib.sha256(blob).hexdigest()
        print(f"  [{idx:02d}] 0x{s:06x}..0x{e:06x} ({e-s:6d} bytes) -> {fname} (sha256={sha[:12]}...)")
        carved_manifest.append(
            {
                "index": idx,
                "offset_start": f"0x{s:06x}",
                "offset_end": f"0x{e:06x}",
                "size": e - s,
                "sha256": sha,
                "file": fpath,
            }
        )

    # Check if trailer at 0x484000 (32 bytes) or its 16-byte halves match any hash of 0..0x484000
    body = data[:0x484000]
    trailer = data[0x484000:0x484020]
    print("\n=== Trailer Analysis (0x484000..0x484020) ===")
    print(f"Trailer hex: {trailer.hex()}")
    print(f"MD5(0..0x484000):    {hashlib.md5(body).hexdigest()}")
    print(f"SHA1(0..0x484000):   {hashlib.sha1(body).hexdigest()}")
    print(f"SHA256(0..0x484000): {hashlib.sha256(body).hexdigest()}")

    out_summary = {
        "ascii_string_count": len(ascii_strings),
        "utf16le_string_count": len(utf16_strings),
        "osd_0003_string_count": len(osd_strings),
        "category_counts": {k: len(v) for k, v in categories.items()},
        "categories": {k: v[:200] for k, v in categories.items()},
        "utf16le_samples": [{"offset": f"0x{off:06x}", "string": s} for off, s in utf16_strings[:200]],
        "osd_0003_samples": [
            {"offset": f"0x{off:06x}", "va": f"0x{0x55c7c000+off:08x}", "string": s}
            for off, s in osd_strings[:400]
        ],
        "carved_jpegs": carved_manifest,
        "trailer_hex": trailer.hex(),
    }
    out_path = os.path.join(OUTPUT_DIR, "03_strings_and_assets.json")
    with open(out_path, "w") as f:
        json.dump(out_summary, f, indent=2)
    print(f"\nSaved strings and assets summary to {out_path}")


if __name__ == "__main__":
    main()
