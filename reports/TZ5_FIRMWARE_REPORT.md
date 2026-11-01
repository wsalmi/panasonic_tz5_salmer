# Panasonic Lumix DMC-TZ5 (`TZ5_a.bin`) Firmware Reverse-Engineering Dossier

## 1. Executive Summary & Artifact Identity

| Property | Value | Evidence / Source |
| :--- | :--- | :--- |
| **Target File** | `/Users/wesleysalmi/source-me/tz5-rea/TZ5_a.bin` (copied from `/Users/wesleysalmi/Downloads/TZ5_a.bin`) | `ev_1cf44c8250c1950d01167e1b5fa490494ad935d33a222d53a01fef50e9be4c5c` |
| **Raw File Size** | `5,030,946` bytes (`0x4CC422` = `147,969 × 34` bytes) | [01_inspect_container.py](file:///Users/wesleysalmi/source-me/tz5-rea/scripts/01_inspect_container.py) |
| **Raw SHA-256** | `5f2e5ffd97d04722bee1eca61c363a87948d052747fde429806cb1105be28b96` | `ev_e51ff85f9cc79d24dfb128e8b91377ce8baf55e0fcf89b2310ee88cb8d0811d6` |
| **Raw MD5** | `a83c9d6392ee0a2b5310722cfa7eb1ec` | [01_container_profile.json](file:///Users/wesleysalmi/source-me/tz5-rea/output/01_container_profile.json) |
| **Unpacked Image** | `/Users/wesleysalmi/source-me/tz5-rea/output/TZ5_unpacked.bin` (`4,735,008` bytes = `0x484020`) | [02_unpack_firmware.py](file:///Users/wesleysalmi/source-me/tz5-rea/scripts/02_unpack_firmware.py) |
| **Unpacked SHA-256** | `39c3759ec4f7fda9906039a93fb2867442491320220647f651fd8f1491996860` | [02_unpack_manifest.json](file:///Users/wesleysalmi/source-me/tz5-rea/output/02_unpack_manifest.json) |
| **SoC / CPU Architecture** | Panasonic **Venus Engine IV** — **Matsushita MN10300 / MN103S (AM33)** 32-bit little-endian RISC | [04_arch_and_disasm.py](file:///Users/wesleysalmi/source-me/tz5-rea/scripts/04_arch_and_disasm.py) |
| **Original Compiler Build Targets** | `\TZ5.AHX` (`0x55E5FC34`) & `\TZ5E.AHX` (`0x55E5FC3D`), Firmware Version `1.02` (`0x008008`) | Observed in `.rodata` & `"Pana"` header |

---

## 2. Container Framing & Checksum Specification (100% Verified)

`TZ5_a.bin` is **not encrypted**. Instead, the raw ROM image is framed into **`147,969` contiguous 34-byte records** (`147,969 × 34 = 5,030,946` bytes). Because 2 checksum bytes are interleaved after every 32 bytes of raw code/data, instructions and strings that cross a 32-byte boundary appear split in the raw `.bin` file.

### Record Layout (34 Bytes)
- **Bytes `0..31` (32 bytes)**: Contiguous firmware payload ($16 \times \text{uint16\_be}$ words $w_0, w_1, \dots, w_{15}$).
- **Bytes `32..33` (2 bytes)**: Big-endian 16-bit two's-complement checksum word $w_{16}$:
  $$w_{16} = \left(-\sum_{k=0}^{15} w_k\right) \bmod 65536 \quad \Longleftrightarrow \quad \sum_{k=0}^{16} w_k \equiv 0 \pmod{65536}$$
- **Verification**: Verified across **`147,969 / 147,969` (`100.0000%`)** records in [02_unpack_firmware.py](file:///Users/wesleysalmi/source-me/tz5-rea/scripts/02_unpack_firmware.py).
  - Example: For a 32-byte `0xFF` padding block ($16 \times \text{0xFFFF} \equiv \text{0xFFF0} \pmod{65536}$), the checksum word is $-\text{0xFFF0} \equiv \text{0x0010} \pmod{65536}$, stored as bytes `00 10`.

---

## 3. Virtual Memory Map & Flash Partition Layout

By analyzing the hardware reset vectors (`0x004000`), kernel initialization (`0x0040D1`), and C runtime startup (`CRT0` at `0x01F02C`), we established the exact linear mapping between unpacked file offsets and the MN103S 32-bit virtual address space:

$$\text{Virtual Address (VA)} = \text{Unpacked File Offset} + \text{0x55C7C000}$$

| Partition / Region | Unpacked File Range | Raw `TZ5_a.bin` Range | Virtual Address (VA) | Size (Bytes) | Description & Runtime Role |
| :--- | :--- | :--- | :--- | ---: | :--- |
| **Partition 00 (`part_00`)** | `0x000000..0x001305` | `0x000000..0x001435` | `0x55C7C000..0x55C7D305` | `4,869` | **Early Boot & Flash Updater**: Initializes `0x9C00xxxx` clocks/memory controller, copies routines to fast RAM (`0x400001E4`, `0x4000071C`) and SDRAM (`0x54200000`), jumps to `0x54080000`. |
| *(0xFF Flash Padding)* | `0x001305..0x004000` | `0x001435..0x004400` | `0x55C7D305..0x55C80000` | `11,515` | Erased NOR flash padding (`0xFF`). |
| **Partition 01 (`part_01`)** | `0x004000..0x0049F2` | `0x004400..0x004E90` | `0x55C80000..0x55C809F2` | `2,546` | **System Reset & Interrupt Vector Table**: 8-byte vector slots at `0x55C80018..0x55C80048`; zeros kernel `.bss` (`0x5400042C..0x540127E4`) and copies kernel `.data` (`0x55C80638` $\to$ `0x54000400`). |
| *(0xFF Flash Padding)* | `0x0049F2..0x008000` | `0x004E90..0x008800` | `0x55C809F2..0x55C84000` | `13,838` | Erased NOR flash padding (`0xFF`). |
| **Partition 02a (Header & Data)** | `0x008000..0x013FFF` | `0x008800..0x0153FE` | `0x55C84000..0x55C8FFFF` | `49,152` | **`"Pana"` Firmware Header & Camera Descriptors**: Magic `00 00 50 61 6E 61 00 00` (`"Pana"`), version `01 00 02 00` (`v1.02`), calibration tables, and model ID block at `0x013F00` (`Panasonic`, `DMC-TZ5`, `_PANA`, `TZ5__`, `LUMIX`). |
| **Partition 02b (`.data` Image)** | `0x014000..0x01F02C` | `0x015400..0x020F2E` | `0x55C90000..0x55C9B02C` | `45,100` | **Initialized `.data` Segment**: Relocated at boot by `CRT0` (`0x55C9B02C`) to cached SDRAM `0x54012840..0x5401D86C`. |
| **Partition 02c (`.text` + `.rodata`)** | `0x01F02C..0x21F428` | `0x020F2E..0x24136A` | `0x55C9B02C..0x55E9B428` | `2,098,172` | **Main Firmware Executable (`\TZ5.AHX`)**: `CRT0` entry at `0x55C9B02C`, main application code (`0x55C9C000..`), FotoNation library, QuickTime `.MOV` muxer, Exif/PictBridge, service mode, and `.rodata` strings (`0x1D8DC0..0x21F428`). |
| *(0xFF Flash Padding)* | `0x21F428..0x224000` | `0x24136A..0x246400` | `0x55E9B428..0x55EA0000` | `19,416` | Erased NOR flash padding (`0xFF`). |
| **Partition 03 (`part_03`)** | `0x224000..0x31F118` | `0x246400..0x351028` | `0x55EA0000..0x55F9B118` | `1,028,376` | **OSD / UI / Font / Localization Partition**: Contains `0x0003`-terminated 16-bit UI strings (`ENGLISH`, `DEUTSCH`, `SERVICE MODE`, `INITIAL SETTINGS`, video/photo mode labels) and bitmap font glyphs. |
| *(0xFF Padding & Stub)* | `0x31F118..0x374000` | `0x351028..0x3AB400` | `0x55F9B118..0x55FF0000` | `347,880` | Erased padding (`0xFF`) with a 4-byte `cb cb cb cb` (`rets`) stub at `0x36B800` (`VA 0x55FE7800`). |
| **Partition 05 (`part_05`)** | `0x374000..0x480F08` | `0x3AB400..0x4C8FF8` | `0x55FF0000..0x560FCF08` | `1,101,576` | **Upper Resource & Master String Index Table**: `0x374000..0x384000` is 64 KB `0x00`; `0x384000` (`VA 0x56000000`) begins with magic `0x12345678` followed by the master 32-bit pointer table (`0x384004..0x3D4E98`) indexing localized OSD strings across `0x55EAxxxx` and `0x5605xxxx`. |
| **Partition 06 (Trailer)** | `0x484000..0x484020` | `0x4CC400..0x4CC422` | `0x56100000..0x56100020` | `32` | **32-Byte Firmware Image Integrity Trailer**: `18f8d9406631723fcc110b3b5c3c99af64c17a2d0e9b44d41d5fc6fe35f1e180`. |

### Runtime RAM & Peripheral Address Spaces
- **`0x40000000..0x40003FFF`**: On-chip fast instruction/data RAM (`0x400001E4`, `0x40000600`, `0x4000071C` populated by bootloader).
- **`0x54000000..0x542FFFFF`**: Cached SDRAM:
  - `0x54000400..0x5400042C`: Kernel initialized data (copied from `0x55C80638`).
  - `0x5400042C..0x540127E4`: Kernel `.bss` (zeroed at `0x55C800D1`, `74,680` bytes).
  - `0x54012840..0x5401D86C`: Application `.data` (copied from `0x55C90000..0x55C9B02C`, `45,100` bytes).
  - `0x5401D86C..0x54077238`: Application `.bss` (zeroed at `0x55C9B02C`, `367,052` bytes).
  - `0x5407FF00..0x54080000`: Initial stack / boot jump target.
- **`0x98000000..0x982FFFFF`**: Uncached SDRAM / Framebuffers / DMA buffers (`0x9809A400..0x980C0000` zeroed at boot; `0x98149800` used by EEPROM dumper; `0x98200000` used by flash updater).
- **`0x9C000000..0x9C01FFFF`**: Venus Engine IV Memory-Mapped I/O (MMIO) registers:
  - `0x9C012100..0x9C0121FF` (`640` code refs): Flash / Storage DMA & Serial Interface Controller.
  - `0x9C002000..0x9C002DFF` (`1,447` combined code refs): Venus Engine IV Image Signal Processor (ISP) & CCD/OIS hardware blocks.
  - `0x9C00C000..0x9C00C0FF` (`194` code refs): Interrupt Controller & Bus Arbiter.
  - `0x9C000000..0x9C0001FF` (`155` code refs): System Clock, PLL, and Power Control.

---

## 4. Key Disassembled Routines (`MN103S`)

### 4.1 C Runtime Startup (`CRT0` at `file+0x01F02C` / `VA 0x55C9B02C`)
```assembly
; Zero-fill Main Application .bss (0x5401d86c .. 0x54077238 = 367,052 bytes)
0x55c9b02c (file+0x01f02c): fc dc 6c d8 01 54     mov 0x5401d86c, a0
0x55c9b032 (file+0x01f032): fc dd 38 72 07 54     mov 0x54077238, a1
0x55c9b038 (file+0x01f038): b1                    clr d1
; [loop zeroing (a0++) until a0 == a1]

; Zero-fill Uncached SDRAM .bss (0x9809a400 .. 0x980c0000 = 154,624 bytes)
0x55c9b042 (file+0x01f042): fc dc 00 a4 09 98     mov 0x9809a400, a0
0x55c9b048 (file+0x01f048): fc dd 00 00 0c 98     mov 0x980c0000, a1
0x55c9b04e (file+0x01f04e): b1                    clr d1
; [loop zeroing (a0++) until a0 == a1]

; Copy Initialized .data from ROM (0x55c90000..0x55c9b02c) to SDRAM (0x54012840..0x5401d86c)
0x55c9b058 (file+0x01f058): fc dc 00 00 c9 55     mov 0x55c90000, a0
0x55c9b05e (file+0x01f05e): fc cd 2c b0 c9 55     mov 0x55c9b02c, d1
0x55c9b064 (file+0x01f064): f1 91                 sub a0, d1          ; d1 = 0x0000b02c (45,100 bytes)
0x55c9b066 (file+0x01f066): c8 10                 beq 0x55c9b076
0x55c9b068 (file+0x01f068): fc dd 40 28 01 54     mov 0x54012840, a1
; [byte copy loop from (a0++) to (a1++)]
```

### 4.2 Firmware Executable Loader (`\TZ5.AHX` / `\TZ5E.AHX` at `VA 0x55CE93F4`)
References `0x55E5FC34` (`"\TZ5.AHX"`) and `0x55E5FC3D` (`"\TZ5E.AHX"`):
```assembly
0x55ce9411 (file+0x06d411): 5c 08                 mov (8, sp), a0
0x55ce9413 (file+0x06d413): fc dd 34 fc e5 55     mov 0x55e5fc34, a1  ; "\\TZ5.AHX"
0x55ce9419 (file+0x06d419): 80 40                 mov 0x40, d0
0x55ce941b (file+0x06d41b): dd aa 42 fc ff 30 08  call 0x55cad6c5, [a2,a3], 8
0x55ce9422 (file+0x06d422): 5c 08                 mov (8, sp), a0
0x55ce9424 (file+0x06d424): 80 2e                 mov 0x2e, d0        ; '.'
0x55ce9426 (file+0x06d426): dd c1 42 fc ff 00 00  call 0x55cad6e7, 0x00, 0
```

### 4.3 ROM / Firmware Binary Dump & Load Handler (`VA 0x55D9C0B8`)
Selects between SD card (`B:\`) and internal flash memory (`A:\`) for `ROMDATA.BIN` and `FIRMWARE.BIN`:
```assembly
0x55d9c0c1 (file+0x1200c1): c9 15                 bne 0x55d9c0d6
0x55d9c0c3 (file+0x1200c3): fc dc 1c 1b e7 55     mov 0x55e71b1c, a0  ; "B:\\ROMDATA.BIN"
...
0x55d9c0ce (file+0x1200ce): fc dc 2b 1b e7 55     mov 0x55e71b2b, a0  ; "A:\\ROMDATA.BIN"
0x55d9c0d4 (file+0x1200d4): ca 13                 bra 0x55d9c0e7
0x55d9c0d6 (file+0x1200d6): fc dc 3a 1b e7 55     mov 0x55e71b3a, a0  ; "B:\\FIRMWARE.BIN"
...
0x55d9c0e1 (file+0x1200e1): fc dc 4a 1b e7 55     mov 0x55e71b4a, a0  ; "A:\\FIRMWARE.BIN"
0x55d9c0eb (file+0x1200eb): cd d6 86 f0 9c        call 0x55d947c1, [d2,d3,a2,a3], 156
```

### 4.4 Service Mode `CAMERA INFO.` Telemetry Screen (`VA 0x55D87488`)
Renders hardware usage counters (`NO.`, `PWRCNT`, `SHTCNT`, `STBCNT`, `PSVCNT`) and `CAMERA INFO.2` (`ClockSet Cnt`, `UnderCut Cnt`, `RTC Read Err`, `CCD_TEMP`):
```assembly
0x55d87491 (file+0x10b491): 2d 8a 03              mov 0x038a, d1
0x55d87494 (file+0x10b494): 25 0d 01              mov 0x010d, a1
0x55d87497 (file+0x10b497): fc dc 95 01 e7 55     mov 0x55e70195, a0  ; "CAMERA INFO."
0x55d8749d (file+0x10b49d): dd d4 45 fe ff f0 58  call 0x55d6ba71, [d2,d3,a2,a3], 88
```

---

## 5. Discovered Subsystems, Hidden Files, and Error Codes

1. **Dual Virtual Drives (`A:\` Internal NAND/NOR Flash vs. `B:\` SD/SDHC Card)**:
   - Calibration & Factory Files: `A:\EEPROM`, `A:\SETUP.ADJ`, `B:\SETUP.ADJ`, `A:\histlog.bin`, `B:\histlog.bin`, `A:\develop.bin`, `B:\develop.bin`, `ship.txt`.
   - Firmware & ROM Backup: `A:\ROMDATA.BIN`, `B:\ROMDATA.BIN`, `A:\FIRMWARE.BIN`, `B:\FIRMWARE.BIN`, `VER.BIN`, `\TZ5.AHX`, `\TZ5E.AHX`.
   - Retail Demo Mode: `JPN.DMO`, `FRA.DMO`, `ENG.DMO` (`0x1F70A0..0x1F70B0`).
   - Media & DPOF: `A:\DCIM`, `B:\DCIM`, `B:\PRIVATE1\ZOOMDATA.IDX`, `AUTPRINT.MRK`, `AUTPLAY0.MRK`..`AUTPLAY8.MRK`, `.JPG`, `.MOV`, `.RAW`, `.TIF`, `.THM`, `1.PCM`..`4.PCM`.
2. **Third-Party Embedded Libraries**:
   - **FotoNation Face Detection / Red-Eye Engine**: `Copyright (c) 2000-2007 by FotoNation. All rights reserved.` (`0x0384AF` / `VA 0x55CB44AF`).
3. **QuickTime `.MOV` (720p HD 30fps MJPEG) Multiplexer (`0x1F551C..0x1F573A`)**:
   - Generates QuickTime atoms (`moov`, `mdat`, `mvhd`, `trak`, `edts`, `elst`, `mdia`, `mdhd`, `hdlr`, `mhlr`, `vide`, `soun`, `alis`, `pana`, `smhd`, `dinf`, `dref`, `stbl`, `stsd`, `stts`, `stsc`, `stsz`, `stco`, `pnot`, `PICT`) with codec string `"Photo - JPEG"`.
4. **Hardware Diagnostic & Factory Error Codes (`0x1F365F..0x1F40B6`)**:
   - **Optical Image Stabilizer (OIS) & Gyro**: `OIS ADJ`, `OIS ERROR`, `X/Y POS SENSOR SMALL/BIG/SYSTEM ERROR`, `MREF ERROR`, `X/Y OFFSET ERROR`, `X/Y GAIN ERROR`, `AXIS OFFSET(U/D/L/R) ERROR`.
   - **Lens, Zoom & AutoFocus**: `FOCUS FREE ERROR`, `ZOOM FREE ERROR`, `FOCUS ERROR AT W/T`, `DEFOCUS1/2 ERROR`, `COLLAPSIBLE FREE ERROR`, `ROUGH/FINE ADJ ERROR`, `AF ERROR`, `ERR_BF_MR`, `IRIS POS1..5 NG`, `TELE/NORMAL/WIDE AF NG`.
   - **CCD Sensor, Thermal & Strobe/Flash**: `CCD LINEARITY ERROR`, `SHADING ERROR`, `32 TEMP FILTER ERROR`, `INSERT ND FILTER`, `CCD THERMO HI/LOW`, `BAT THERMO HI/LOW`, `1ST/2ND/3RD FLASH UNDER/OVER`, `IMPOSSIBLE PRE FLASH`, `STB CHARGE/ENVIRONMENT ERROR`.

---

## 6. Residual Unknowns & Verification Ledger

All observations, derived facts (including individual REA evidence IDs for `part_00`..`part_06`), and residual unknowns are recorded in the REA session ledger and exported to [evidence_bundle.json](file:///Users/wesleysalmi/source-me/tz5-rea/reports/evidence_bundle.json). See [PARTITIONS_SOURCE_AND_REBUILD_DOSSIER.md](file:///Users/wesleysalmi/source-me/tz5-rea/reports/PARTITIONS_SOURCE_AND_REBUILD_DOSSIER.md) for the complete modular partition source code architecture (`partitions_src/`).

- **`unk_21b305f469705176caca4dd2e8cad04950847a7003bb4e2f7ebc2a54b4328a4f`** (`resolved` / `verified`, `firmware-trailer-integrity`): **100% Solved (`part_06`, `0x484000..0x484020`)**. The 32-byte trailer (`18f8d9406631723fcc110b3b5c3c99af64c17a2d0e9b44d41d5fc6fe35f1e180`) is a vertical column-wise 16-bit big-endian two's-complement parity row across all `147,968` preceding 32-byte blocks (`c = 0..15`), forming a 2D zero-sum matrix (`147,969 × 17` words) with corner word `0x9E60`. Implemented in [part_06.cpp](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_06_parity_trailer/part_06.cpp).
- **`unk_0169c4a2de01959d177234f4757e01d17221c0da86971b2f5815bd31e0177d40`** (`low`, `venus-engine-iv-mmio`): Complete hardware register bitfield definitions for the proprietary Venus Engine IV MMIO blocks at `0x9C012100` (`640` refs) and `0x9C002000..0x9C002DFF` (`1,447` refs).

---

## 7. Firmware Build & Repackaging Pipeline

The build tool [05_build_firmware.py](file:///Users/wesleysalmi/source-me/tz5-rea/scripts/05_build_firmware.py) rebuilds and packages a camera-flashable `.bin` firmware container image from either the flat unpacked ROM or the extracted partition files.

### Build Verification & Metrics
- **Output File**: `/Users/wesleysalmi/source-me/tz5-rea/output/TZ5_built.bin`
- **Output Manifest**: [05_build_manifest.json](file:///Users/wesleysalmi/source-me/tz5-rea/output/05_build_manifest.json)
- **Built File Size**: `5,030,946` bytes (`147,969` records of 34 bytes)
- **Built SHA-256**: `5f2e5ffd97d04722bee1eca61c363a87948d052747fde429806cb1105be28b96`
- **Built MD5**: `a83c9d6392ee0a2b5310722cfa7eb1ec`
- **Block Checksum Integrity**: `147,969 / 147,969` records pass ($100.0000\%$)
- **Reference Identity**: Bit-for-bit identical ($100\%$ byte match) with original `TZ5_a.bin`

