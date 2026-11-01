#!/usr/bin/env python3
"""
Phase 1: Container & Entropy Profiling for Panasonic Lumix DMC-TZ5 (TZ5_a.bin).
Inspects header structure, magic bytes, sliding-window Shannon entropy,
byte frequency distribution, autocorrelation (repeating key lengths),
and initial plaintext strings.
"""

import hashlib
import json
import math
import os
import struct
from collections import Counter

FIRMWARE_PATH = "/Users/wesleysalmi/source-me/tz5-rea/TZ5_a.bin"
OUTPUT_DIR = "/Users/wesleysalmi/source-me/tz5-rea/output"


def shannon_entropy(data: bytes) -> float:
    if not data:
        return 0.0
    counts = Counter(data)
    length = len(data)
    return -sum((c / length) * math.log2(c / length) for c in counts.values())


def hexdump(data: bytes, base_offset: int = 0, lines: int = 32) -> str:
    out = []
    for i in range(0, min(len(data), lines * 16), 16):
        chunk = data[i : i + 16]
        hex_part = " ".join(f"{b:02x}" for b in chunk)
        ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        out.append(f"{base_offset + i:08x}  {hex_part:<47}  |{ascii_part}|")
    return "\n".join(out)


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    with open(FIRMWARE_PATH, "rb") as f:
        data = f.read()

    size = len(data)
    sha256 = hashlib.sha256(data).hexdigest()
    md5 = hashlib.md5(data).hexdigest()
    overall_entropy = shannon_entropy(data)

    print(f"File: {FIRMWARE_PATH}")
    print(f"Size: {size} bytes (0x{size:x})")
    print(f"SHA-256: {sha256}")
    print(f"MD5:     {md5}")
    print(f"Overall Shannon Entropy: {overall_entropy:.4f} bits/byte\n")

    print("=== First 512 bytes (0x0000 - 0x0200) ===")
    print(hexdump(data[:512], 0, 32))
    print("\n=== Bytes at 0x0200 - 0x0400 ===")
    print(hexdump(data[0x200:0x400], 0x200, 32))
    print("\n=== Bytes at 0x0800 - 0x0A00 ===")
    print(hexdump(data[0x800:0xA00], 0x800, 32))
    print("\n=== Bytes at 0x1000 - 0x1200 ===")
    print(hexdump(data[0x1000:0x1200], 0x1000, 32))
    print("\n=== Last 256 bytes ===")
    print(hexdump(data[-256:], size - 256, 16))

    # Sliding window entropy (16 KB windows)
    win_size = 16384
    windows = []
    for off in range(0, size, win_size):
        chunk = data[off : off + win_size]
        ent = shannon_entropy(chunk)
        top_byte, top_count = Counter(chunk).most_common(1)[0]
        windows.append(
            {
                "offset": f"0x{off:06x}",
                "offset_int": off,
                "length": len(chunk),
                "entropy": round(ent, 4),
                "top_byte": f"0x{top_byte:02x}",
                "top_byte_ratio": round(top_count / len(chunk), 4),
            }
        )

    # Check autocorrelation for periods 1..1024 on several sample regions
    sample_offsets = [0x2000, 0x10000, 0x80000, 0x100000, 0x200000, 0x400000]
    period_scores = {}
    for period in [4, 8, 12, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096]:
        matches = 0
        total = 0
        for s_off in sample_offsets:
            if s_off + 8192 + period < size:
                c1 = data[s_off : s_off + 8192]
                c2 = data[s_off + period : s_off + 8192 + period]
                matches += sum(1 for a, b in zip(c1, c2) if a == b)
                total += 8192
        if total > 0:
            period_scores[period] = round(matches / total, 5)

    print("\n=== Autocorrelation Coincidence Rates (Random = 0.00391) ===")
    for p, score in sorted(period_scores.items(), key=lambda x: -x[1]):
        print(f"  Period {p:4d}: {score:.5f} ({score / (1/256):.2f}x random)")

    # Print entropy transitions
    print("\n=== Entropy Regions Summary (16KB blocks) ===")
    prev_band = None
    band_start = 0
    for w in windows:
        ent = w["entropy"]
        if ent < 1.0:
            band = "VERY_LOW (<1.0)"
        elif ent < 4.5:
            band = "LOW_MED (1.0-4.5)"
        elif ent < 6.8:
            band = "CODE_TEXT (4.5-6.8)"
        elif ent < 7.8:
            band = "HIGH_COMP (6.8-7.8)"
        else:
            band = "VERY_HIGH (>7.8)"
        if band != prev_band:
            if prev_band is not None:
                print(f"  0x{band_start:06x} - 0x{w['offset_int']:06x}: {prev_band}")
            prev_band = band
            band_start = w["offset_int"]
    print(f"  0x{band_start:06x} - 0x{size:06x}: {prev_band}")

    profile = {
        "file": FIRMWARE_PATH,
        "size": size,
        "sha256": sha256,
        "md5": md5,
        "overall_entropy": round(overall_entropy, 4),
        "autocorrelation_coincidence": period_scores,
        "windows": windows,
    }
    out_json = os.path.join(OUTPUT_DIR, "01_container_profile.json")
    with open(out_json, "w") as f:
        json.dump(profile, f, indent=2)
    print(f"\nSaved container profile to {out_json}")


if __name__ == "__main__":
    main()
