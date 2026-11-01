#!/usr/bin/env python3
"""
Phase 2: De-framing, Checksum Verification, and Partition Unpacking for TZ5_a.bin.
Verifies the 34-byte block structure (32 data bytes + 2 checksum bytes),
reconstructs the contiguous 4,735,008-byte ROM image, and maps its internal regions.
"""

import hashlib
import json
import os
import struct

FIRMWARE_PATH = "/Users/wesleysalmi/source-me/tz5-rea/TZ5_a.bin"
OUTPUT_DIR = "/Users/wesleysalmi/source-me/tz5-rea/output"
PARTITIONS_DIR = os.path.join(OUTPUT_DIR, "partitions")


def verify_checksum_algorithms(data: bytes):
    num_blocks = len(data) // 34
    # Test candidate 16-bit checksum formulas on all blocks
    # Candidate A: 0 - sum(16-bit LE words) mod 65536, stored as BE or LE
    # Candidate B: 0 - sum(16-bit BE words) mod 65536, stored as BE or LE
    # Candidate C: independent byte sums: (-sum(even_bytes) & 0xff, -sum(odd_bytes) & 0xff)
    matches = {
        "neg_sum_u16_le_stored_le": 0,
        "neg_sum_u16_le_stored_be": 0,
        "neg_sum_u16_be_stored_be": 0,
        "neg_sum_u16_be_stored_le": 0,
        "independent_byte_neg_sum": 0,
    }
    mismatches_ind = []

    for i in range(num_blocks):
        blk = data[i * 34 : (i + 1) * 34]
        payload = blk[:32]
        chk_bytes = blk[32:34]
        chk_le = struct.unpack("<H", chk_bytes)[0]
        chk_be = struct.unpack(">H", chk_bytes)[0]

        words_le = struct.unpack("<16H", payload)
        words_be = struct.unpack(">16H", payload)

        neg_le = (-sum(words_le)) & 0xFFFF
        neg_be = (-sum(words_be)) & 0xFFFF

        if neg_le == chk_le:
            matches["neg_sum_u16_le_stored_le"] += 1
        if neg_le == chk_be:
            matches["neg_sum_u16_le_stored_be"] += 1
        if neg_be == chk_be:
            matches["neg_sum_u16_be_stored_be"] += 1
        if neg_be == chk_le:
            matches["neg_sum_u16_be_stored_le"] += 1

        b0 = (-sum(payload[0::2])) & 0xFF
        b1 = (-sum(payload[1::2])) & 0xFF
        if chk_bytes[0] == b0 and chk_bytes[1] == b1:
            matches["independent_byte_neg_sum"] += 1
        else:
            if len(mismatches_ind) < 10:
                mismatches_ind.append((i, i * 34, chk_bytes.hex(), f"{b0:02x}{b1:02x}"))

    return num_blocks, matches, mismatches_ind


def hexdump(data: bytes, base_offset: int = 0, lines: int = 16) -> str:
    out = []
    for i in range(0, min(len(data), lines * 16), 16):
        chunk = data[i : i + 16]
        hex_part = " ".join(f"{b:02x}" for b in chunk)
        ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        out.append(f"{base_offset + i:08x}  {hex_part:<47}  |{ascii_part}|")
    return "\n".join(out)


def main():
    os.makedirs(PARTITIONS_DIR, exist_ok=True)
    with open(FIRMWARE_PATH, "rb") as f:
        raw = f.read()

    assert len(raw) % 34 == 0, f"Expected multiple of 34, got {len(raw)}"
    num_blocks, matches, mismatches_ind = verify_checksum_algorithms(raw)

    print(f"Total 34-byte blocks: {num_blocks}")
    print("Checksum formula match counts:")
    for k, v in matches.items():
        print(f"  {k:28s}: {v} / {num_blocks} ({v/num_blocks*100:.4f}%)")
    if mismatches_ind:
        print("Mismatches for independent_byte_neg_sum:", mismatches_ind)

    # Reconstruct contiguous payload by taking first 32 bytes of each 34-byte block
    chunks = [raw[i * 34 : i * 34 + 32] for i in range(num_blocks)]
    unpacked = b"".join(chunks)

    unpacked_path = os.path.join(OUTPUT_DIR, "TZ5_unpacked.bin")
    with open(unpacked_path, "wb") as f:
        f.write(unpacked)

    unpacked_sha256 = hashlib.sha256(unpacked).hexdigest()
    print(f"\nWrote reconstructed image: {unpacked_path}")
    print(f"Unpacked size:   {len(unpacked)} bytes (0x{len(unpacked):x})")
    print(f"Unpacked SHA256: {unpacked_sha256}")

    print("\n=== Unpacked Image First 256 bytes (0x000000 - 0x000100) ===")
    print(hexdump(unpacked[:256], 0, 16))

    print("\n=== Unpacked Image Last 128 bytes (0x483fa0 - 0x484020) ===")
    print(hexdump(unpacked[-128:], len(unpacked) - 128, 8))

    # Find large 0xFF or 0x00 padding runs to identify partition boundaries
    runs = []
    i = 0
    n = len(unpacked)
    while i < n:
        if unpacked[i] in (0x00, 0xFF):
            val = unpacked[i]
            j = i + 1
            while j < n and unpacked[j] == val:
                j += 1
            if j - i >= 2048:
                runs.append((i, j, j - i, f"0x{val:02x}"))
            i = j
        else:
            i += 1

    print("\n=== Major Padding Runs (>= 2 KB of 0x00 or 0xFF) ===")
    for start, end, length, val in runs:
        print(f"  0x{start:06x} - 0x{end:06x} ({length:8d} bytes = {length/1024:6.1f} KB) fill {val}")

    # Check non-padding regions separated by large (>= 16 KB) 0xFF runs
    ff_runs = [(s, e) for s, e, l, v in runs if v == "0xff" and l >= 4096]
    regions = []
    cur = 0
    for s, e in ff_runs:
        if s > cur:
            regions.append((cur, s))
        cur = e
    if cur < n:
        regions.append((cur, n))

    print("\n=== Major Data/Code Partitions Separated by >= 4KB 0xFF Runs ===")
    manifest_partitions = []
    for idx, (s, e) in enumerate(regions):
        part_data = unpacked[s:e]
        part_sha = hashlib.sha256(part_data).hexdigest()
        part_file = os.path.join(PARTITIONS_DIR, f"part_{idx:02d}_0x{s:06x}_0x{e:06x}.bin")
        with open(part_file, "wb") as pf:
            pf.write(part_data)
        raw_start = (s // 32) * 34 + (s % 32)
        raw_end = (e // 32) * 34 + (e % 32)
        print(
            f"  Partition {idx:02d}: unpacked 0x{s:06x}..0x{e:06x} ({e-s:8d} B) | "
            f"raw 0x{raw_start:06x}..0x{raw_end:06x} | sha256={part_sha[:16]}..."
        )
        print(hexdump(part_data[:64], s, 4))
        manifest_partitions.append(
            {
                "index": idx,
                "unpacked_start": f"0x{s:06x}",
                "unpacked_end": f"0x{e:06x}",
                "unpacked_size": e - s,
                "raw_start_approx": f"0x{raw_start:06x}",
                "raw_end_approx": f"0x{raw_end:06x}",
                "sha256": part_sha,
                "path": part_file,
            }
        )

    manifest = {
        "source_file": FIRMWARE_PATH,
        "source_size": len(raw),
        "source_sha256": hashlib.sha256(raw).hexdigest(),
        "record_size": 34,
        "payload_bytes_per_record": 32,
        "checksum_bytes_per_record": 2,
        "total_records": num_blocks,
        "checksum_algorithm": "Even/odd byte two's-complement sum: chk[0] = (-sum(payload[0::2])) & 0xFF, chk[1] = (-sum(payload[1::2])) & 0xFF",
        "checksum_matches": matches,
        "unpacked_file": unpacked_path,
        "unpacked_size": len(unpacked),
        "unpacked_sha256": unpacked_sha256,
        "partitions": manifest_partitions,
    }
    manifest_path = os.path.join(OUTPUT_DIR, "02_unpack_manifest.json")
    with open(manifest_path, "w") as f:
        json.dump(manifest, f, indent=2)
    print(f"\nSaved unpack manifest to {manifest_path}")


if __name__ == "__main__":
    main()
