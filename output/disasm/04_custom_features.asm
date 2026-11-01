; ==============================================================================
; Section: 04 - Injected Custom Feature Code Cave (CAVE_MAIN_TEXT 0x55E9B428+)
; ROM Offset: 0x21F428 .. 0x21F480
; Virtual Address: 0x55E9B428 .. 0x55E9B480
; Architecture: Matsushita MN10300 / MN103S (AM33) 32-bit RISC
; ==============================================================================

  55E9B428: FF                    db_op_FF   0xFF
  55E9B429: FF                    db_op_FF   0xFF
  55E9B42A: FF                    db_op_FF   0xFF
  55E9B42B: FF                    db_op_FF   0xFF
  55E9B42C: FF                    db_op_FF   0xFF
  55E9B42D: FF                    db_op_FF   0xFF
  55E9B42E: FF                    db_op_FF   0xFF
  55E9B42F: FF                    db_op_FF   0xFF
  55E9B430: 54                    db_op_54   0x54
  55E9B431: 5A 35                 mov        (53, sp), d2
  55E9B433: 20 43                 add        67, d0
  55E9B435: 55                    db_op_55   0x55
  55E9B436: 53                    db_op_53   0x53
  55E9B437: 54                    db_op_54   0x54
  55E9B438: 4F                    db_op_4F   0x4F
  55E9B439: 4D                    db_op_4D   0x4D
  55E9B43A: 20 46                 add        70, d0
  55E9B43C: 57                    db_op_57   0x57
  55E9B43D: 20 76                 add        118, d0
  55E9B43F: 31                    db_op_31   0x31
  55E9B440: 2E 39 39              mov        0x3939, d2
  55E9B443: 20 5B                 add        91, d0
  55E9B445: 4D                    db_op_4D   0x4D
  55E9B446: 4F                    db_op_4F   0x4F
  55E9B447: 44                    db_op_44   0x44
  55E9B448: 5D 00                 mov        (0, sp), a1
  55E9B44A: FF                    db_op_FF   0xFF
  55E9B44B: FF                    db_op_FF   0xFF
  55E9B44C: 4C                    db_op_4C   0x4C
  55E9B44D: 00                    db_op_00   0x00
  55E9B44E: 55                    db_op_55   0x55
  55E9B44F: 00                    db_op_00   0x00
  55E9B450: 4D                    db_op_4D   0x4D
  55E9B451: 00                    db_op_00   0x00
  55E9B452: 49                    db_op_49   0x49
  55E9B453: 00                    db_op_00   0x00
  55E9B454: 58 00                 mov        (0, sp), d0
  55E9B456: 2D 00 50              mov        0x5000, d1
  55E9B459: 00                    db_op_00   0x00
  55E9B45A: 52                    db_op_52   0x52
  55E9B45B: 00                    db_op_00   0x00
  55E9B45C: 4F                    db_op_4F   0x4F
  55E9B45D: 00                    db_op_00   0x00
  55E9B45E: 2D 00 4D              mov        0x4D00, d1
  55E9B461: 00                    db_op_00   0x00
  55E9B462: 4F                    db_op_4F   0x4F
  55E9B463: 00                    db_op_00   0x00
  55E9B464: 44                    db_op_44   0x44
  55E9B465: 00                    db_op_00   0x00
  55E9B466: 03                    db_op_03   0x03
  55E9B467: 00                    db_op_00   0x00

; --- Function sub_55E9B468 (callers: 1) ---
sub_55E9B468:
  55E9B468: FC A2 00 72 07 54     mov        (0x54077200), d2               ; .bss (SDRAM)
  55E9B46E: 22 01                 add        1, d2
  55E9B470: FC 82 00 72 07 54     mov        d2, (0x54077200)               ; .bss (SDRAM)
  55E9B476: FC DC 30 B4 E9 55     mov        0x55E9B430, a0                 ; str "TZ5 CUSTOM FW v1.99 [MOD]"
  55E9B47C: DC F5 05 ED FF        jmp        ui_draw_ascii_label
