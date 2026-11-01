#!/usr/bin/env python3
"""
Phase 5: Firmware Builder / Packager for Panasonic Lumix DMC-TZ5.
Reconstructs and packages a flashable container firmware file (.bin)
from either:
  1) An unpacked flat ROM image (e.g. output/TZ5_unpacked.bin), or
  2) Extracted partitions + manifest (e.g. output/partitions/ + 02_unpack_manifest.json).

Applies the verified Panasonic Venus Engine IV container framing:
  - 34-byte records composed of 32 data bytes (16 x uint16_be)
  - Followed by 2-byte big-endian two's-complement checksum word:
      chk_word = (-sum(payload_words_be)) & 0xFFFF
  - Verifies sum(17 words) == 0 (mod 65536) for 100% of records.
"""

import argparse
import hashlib
import json
import os
import struct
import sys
import time

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_UNPACKED_IMAGE = os.path.join(BASE_DIR, "output", "TZ5_unpacked.bin")
DEFAULT_PARTITIONS_DIR = os.path.join(BASE_DIR, "output", "partitions")
DEFAULT_MANIFEST = os.path.join(BASE_DIR, "output", "02_unpack_manifest.json")
DEFAULT_OUTPUT_BIN = os.path.join(BASE_DIR, "output", "TZ5_built.bin")
DEFAULT_BUILD_MANIFEST = os.path.join(BASE_DIR, "output", "05_build_manifest.json")
REFERENCE_BIN = os.path.join(BASE_DIR, "TZ5_a.bin")


def pack_payload(payload: bytes) -> tuple[bytes, int]:
    """
    Packs raw payload bytes into Panasonic 34-byte record framed format.
    Pads to 32-byte boundary with 0xFF if necessary.
    Returns (packed_bytes, record_count).
    """
    remainder = len(payload) % 32
    if remainder != 0:
        pad_len = 32 - remainder
        print(f"[!] Warning: Payload size {len(payload)} is not a multiple of 32. Padding with {pad_len} bytes of 0xFF.")
        payload += b"\xff" * pad_len

    num_records = len(payload) // 32
    packed_blocks = []

    for i in range(num_records):
        chunk = payload[i * 32 : (i + 1) * 32]
        words = struct.unpack(">16H", chunk)
        chk = (-sum(words)) & 0xFFFF
        packed_blocks.append(chunk + struct.pack(">H", chk))

    packed_data = b"".join(packed_blocks)
    return packed_data, num_records


def verify_built_image(packed_data: bytes) -> dict:
    """
    Verifies container framing and checksums across all records.
    """
    assert len(packed_data) % 34 == 0, f"Packed data size {len(packed_data)} is not a multiple of 34"
    num_records = len(packed_data) // 34
    valid_count = 0
    failures = []

    for i in range(num_records):
        record = packed_data[i * 34 : (i + 1) * 34]
        words = struct.unpack(">17H", record)
        if sum(words) % 65536 == 0:
            valid_count += 1
        else:
            if len(failures) < 5:
                failures.append(i)

    return {
        "total_records": num_records,
        "valid_records": valid_count,
        "success_rate_percent": (valid_count / num_records) * 100.0 if num_records > 0 else 0.0,
        "failures_count": len(failures),
        "sample_failures": failures,
    }


def build_from_partitions(manifest_path: str, partitions_dir: str) -> bytes:
    """
    Reconstructs the linear flash image using partition definitions and flash erase state (0xFF).
    """
    if not os.path.exists(manifest_path):
        raise FileNotFoundError(f"Manifest not found: {manifest_path}")

    with open(manifest_path, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    target_size = manifest.get("unpacked_size", 4735008)
    image = bytearray(b"\xff" * target_size)

    partitions = manifest.get("partitions", [])
    print(f"[*] Reconstructing ROM image from {len(partitions)} partitions...")

    for part in partitions:
        p_idx = part["index"]
        p_start = int(part["unpacked_start"], 16)
        p_end = int(part["unpacked_end"], 16)
        p_size = part["unpacked_size"]

        part_filename = os.path.basename(part["path"])
        part_file = os.path.join(partitions_dir, part_filename)

        if not os.path.exists(part_file):
            # Try path directly
            part_file = part["path"]
            if not os.path.exists(part_file):
                raise FileNotFoundError(f"Partition file missing: {part_file}")

        with open(part_file, "rb") as pf:
            part_bytes = pf.read()

        if len(part_bytes) != p_size:
            print(f"[!] Warning: Partition {p_idx} size mismatch (expected {p_size}, got {len(part_bytes)})")

        image[p_start : p_start + len(part_bytes)] = part_bytes
        print(f"    - Partition {p_idx:02d}: offset 0x{p_start:06x}..0x{p_start + len(part_bytes):06x} ({len(part_bytes)} bytes)")

    return bytes(image)


def main():
    parser = argparse.ArgumentParser(description="Build and package Panasonic Lumix DMC-TZ5 firmware image.")
    parser.add_argument(
        "--mode",
        choices=["unpacked", "partitions"],
        default="unpacked",
        help="Source mode: 'unpacked' for direct raw ROM image, 'partitions' to assemble from extracted partition files (default: unpacked).",
    )
    parser.add_argument(
        "--input",
        "-i",
        default=None,
        help="Input raw file (for --mode unpacked) or manifest JSON path (for --mode partitions).",
    )
    parser.add_argument(
        "--partitions-dir",
        default=DEFAULT_PARTITIONS_DIR,
        help="Partitions directory (for --mode partitions).",
    )
    parser.add_argument(
        "--output",
        "-o",
        default=DEFAULT_OUTPUT_BIN,
        help="Output built firmware file path (default: output/TZ5_built.bin).",
    )
    parser.add_argument(
        "--verify-against",
        default=REFERENCE_BIN if os.path.exists(REFERENCE_BIN) else None,
        help="Reference .bin container to compare bit-for-bit against (default: TZ5_a.bin if present).",
    )

    args = parser.parse_args()

    print("=================================================================")
    print(" Panasonic Lumix DMC-TZ5 Firmware Builder & Packager")
    print("=================================================================")

    start_time = time.time()

    # 1. Obtain raw uncompressed payload
    if args.mode == "partitions":
        manifest_file = args.input or DEFAULT_MANIFEST
        print(f"[*] Mode: Assembling partitions via manifest: {manifest_file}")
        raw_payload = build_from_partitions(manifest_file, args.partitions_dir)
    else:
        input_file = args.input or DEFAULT_UNPACKED_IMAGE
        print(f"[*] Mode: Reading flat unpacked ROM: {input_file}")
        if not os.path.exists(input_file):
            print(f"[-] Error: Input file not found: {input_file}")
            sys.exit(1)
        with open(input_file, "rb") as f:
            raw_payload = f.read()

    unpacked_sha256 = hashlib.sha256(raw_payload).hexdigest()
    unpacked_md5 = hashlib.md5(raw_payload).hexdigest()
    print(f"[*] Unpacked ROM size: {len(raw_payload):,} bytes (0x{len(raw_payload):x})")
    print(f"    SHA-256: {unpacked_sha256}")
    print(f"    MD5:     {unpacked_md5}")

    # 2. Pack and calculate checksums
    print(f"[*] Packaging records with 16-bit big-endian two's complement checksums...")
    packed_data, num_records = pack_payload(raw_payload)
    print(f"[*] Generated {num_records:,} 34-byte records ({len(packed_data):,} total bytes)")

    # 3. Verify built container integrity
    verification = verify_built_image(packed_data)
    print(f"[*] Record Verification: {verification['valid_records']:,} / {verification['total_records']:,} records valid ({verification['success_rate_percent']:.4f}%)")
    if verification["failures_count"] > 0:
        print(f"[-] Warning: {verification['failures_count']} records failed checksum verification!")
        sys.exit(1)

    # 4. Save output
    os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
    with open(args.output, "wb") as f:
        f.write(packed_data)
    built_sha256 = hashlib.sha256(packed_data).hexdigest()
    built_md5 = hashlib.md5(packed_data).hexdigest()
    print(f"[+] Successfully wrote firmware build to: {args.output}")
    print(f"    Built File Size: {len(packed_data):,} bytes (0x{len(packed_data):x})")
    print(f"    Built SHA-256:   {built_sha256}")
    print(f"    Built MD5:       {built_md5}")

    # 5. Reference comparison (if requested/available)
    match_ref = None
    if args.verify_against and os.path.exists(args.verify_against):
        with open(args.verify_against, "rb") as f:
            ref_data = f.read()
        match_ref = (packed_data == ref_data)
        ref_sha256 = hashlib.sha256(ref_data).hexdigest()
        print(f"[*] Comparison against reference: {args.verify_against}")
        print(f"    Reference SHA-256: {ref_sha256}")
        if match_ref:
            print("    [MATCH] Perfect bit-for-bit identity with reference firmware (100% matched)!")
        else:
            print(f"    [DIFF] Output differs from reference firmware.")

    # 6. Generate Build Manifest
    build_manifest = {
        "timestamp": time.strftime("%Y-%m-%dT%H:%M:%S%z"),
        "mode": args.mode,
        "input_source": args.input or (DEFAULT_MANIFEST if args.mode == "partitions" else DEFAULT_UNPACKED_IMAGE),
        "output_path": args.output,
        "unpacked_size": len(raw_payload),
        "unpacked_sha256": unpacked_sha256,
        "unpacked_md5": unpacked_md5,
        "built_size": len(packed_data),
        "built_records": num_records,
        "built_sha256": built_sha256,
        "built_md5": built_md5,
        "verification": verification,
        "reference_comparison": {
            "reference_path": args.verify_against,
            "bit_for_bit_match": match_ref,
        } if match_ref is not None else None,
        "elapsed_seconds": round(time.time() - start_time, 3),
    }

    with open(DEFAULT_BUILD_MANIFEST, "w", encoding="utf-8") as f:
        json.dump(build_manifest, f, indent=2)
    print(f"[+] Build manifest written to: {DEFAULT_BUILD_MANIFEST}")
    print(f"[*] Completed in {build_manifest['elapsed_seconds']}s")
    print("=================================================================")


if __name__ == "__main__":
    main()
