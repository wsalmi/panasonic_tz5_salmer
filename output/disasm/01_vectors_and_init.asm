; ==============================================================================
; Section: 01 - Hardware Reset & Interrupt Vector Table + Kernel Init (0x55C80000..0x55C809F2)
; ROM Offset: 0x004000 .. 0x0049F2
; Virtual Address: 0x55C80000 .. 0x55C809F2
; Architecture: Matsushita MN10300 / MN103S (AM33) 32-bit RISC
; ==============================================================================


; ------------------------------------------------------------------------------
; FUNCTION: vec_hardware_reset (VA 0x55C80000)
; ------------------------------------------------------------------------------
vec_hardware_reset:
  55C80000: FC DD 50 00 C8 55     mov        0x55C80050, a1                 ; kernel_reset_handler
  55C80006: F0 F5                 jmp        (a1)

; ------------------------------------------------------------------------------
; FUNCTION: vec_nmi_entry (VA 0x55C80008)
; ------------------------------------------------------------------------------
vec_nmi_entry:
  55C80008: CC FF 00              jmp        nmi_watchdog_handler
  55C8000B: 00                    db_op_00   0x00
  55C8000C: 00                    db_op_00   0x00
  55C8000D: 00                    db_op_00   0x00
  55C8000E: 00                    db_op_00   0x00
  55C8000F: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_trap_rti (VA 0x55C80010)
; ------------------------------------------------------------------------------
vec_trap_rti:
  55C80010: F0 FD                 rti        
  55C80012: 00                    db_op_00   0x00
  55C80013: 00                    db_op_00   0x00
  55C80014: 00                    db_op_00   0x00
  55C80015: 00                    db_op_00   0x00
  55C80016: 00                    db_op_00   0x00
  55C80017: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_irq_group0 (VA 0x55C80018)
; ------------------------------------------------------------------------------
vec_irq_group0:
  55C80018: DC AF 7F 21 00        jmp        venus_master_irq_dispatcher
  55C8001D: 00                    db_op_00   0x00
  55C8001E: 00                    db_op_00   0x00
  55C8001F: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_irq_group1 (VA 0x55C80020)
; ------------------------------------------------------------------------------
vec_irq_group1:
  55C80020: DC A7 7F 21 00        jmp        venus_master_irq_dispatcher
  55C80025: 00                    db_op_00   0x00
  55C80026: 00                    db_op_00   0x00
  55C80027: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_irq_group2 (VA 0x55C80028)
; ------------------------------------------------------------------------------
vec_irq_group2:
  55C80028: DC 9F 7F 21 00        jmp        venus_master_irq_dispatcher
  55C8002D: 00                    db_op_00   0x00
  55C8002E: 00                    db_op_00   0x00
  55C8002F: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_irq_group3 (VA 0x55C80030)
; ------------------------------------------------------------------------------
vec_irq_group3:
  55C80030: DC 97 7F 21 00        jmp        venus_master_irq_dispatcher
  55C80035: 00                    db_op_00   0x00
  55C80036: 00                    db_op_00   0x00
  55C80037: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_irq_group4 (VA 0x55C80038)
; ------------------------------------------------------------------------------
vec_irq_group4:
  55C80038: DC 8F 7F 21 00        jmp        venus_master_irq_dispatcher
  55C8003D: 00                    db_op_00   0x00
  55C8003E: 00                    db_op_00   0x00
  55C8003F: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_irq_group5 (VA 0x55C80040)
; ------------------------------------------------------------------------------
vec_irq_group5:
  55C80040: DC 87 7F 21 00        jmp        venus_master_irq_dispatcher
  55C80045: 00                    db_op_00   0x00
  55C80046: 00                    db_op_00   0x00
  55C80047: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: vec_irq_group6 (VA 0x55C80048)
; ------------------------------------------------------------------------------
vec_irq_group6:
  55C80048: DC 7F 7F 21 00        jmp        venus_master_irq_dispatcher
  55C8004D: 00                    db_op_00   0x00
  55C8004E: 00                    db_op_00   0x00
  55C8004F: 00                    db_op_00   0x00

; ------------------------------------------------------------------------------
; FUNCTION: kernel_reset_handler (VA 0x55C80050)
; ------------------------------------------------------------------------------
kernel_reset_handler:
  55C80050: 04                    db_op_04   0x04
  55C80051: F2 F7                 ext_f2_F7  
  55C80053: CB                    nop        
  55C80054: CB                    nop        
  55C80055: FC DF 5E 00 C8 55     mov        0x55C8005E, a3
  55C8005B: CC A5 06              jmp        loc_55C80700
loc_55C8005E:
  55C8005E: 24 00 04              mov        0x0400, a0
  55C80061: FC D0 64 84 07 54     add        0x54078464, d0
  55C80067: F2 F0                 ext_f2_F0  
  55C80069: FC DF 71 00 C8 55     mov        0x55C80071, a3
  55C8006F: CA 62                 bra        kernel_early_ram_init
  55C80071: FC DF 7C 00 C8 55     mov        0x55C8007C, a3
  55C80077: DC B5 AF 01 00        jmp        crt0_main_firmware_entry
  55C8007C: 24 00 04              mov        0x0400, a0
  55C8007F: FC D0 64 84 07 54     add        0x54078464, d0
  55C80085: F2 F0                 ext_f2_F0  
  55C80087: FC FF C4 00 00 00     calls      sub_55C8014B
  55C8008D: FC CC 18 00 C8 55     mov        0x55C80018, d0                 ; vec_irq_group0
  55C80093: 03                    db_op_03   0x03
  55C80094: 00                    db_op_00   0x00
  55C80095: 80 FC                 mov        0xFC, d0
  55C80097: CC 20 00              jmp        loc_55C800B7
  55C8009A: C8 55                 beq        loc_55C800EF
  55C8009C: 03                    db_op_03   0x03
  55C8009D: 04                    db_op_04   0x04
  55C8009E: 80 FC                 mov        0xFC, d0
  55C800A0: CC 28 00              jmp        loc_55C800C8
  55C800A3: C8 55                 beq        loc_55C800F8
  55C800A5: 03                    db_op_03   0x03
  55C800A6: 08                    db_op_08   0x08
  55C800A7: 80 FC                 mov        0xFC, d0
  55C800A9: CC 30 00              jmp        loc_55C800D9
  55C800AC: C8 55                 beq        loc_55C80101
  55C800AE: 03                    db_op_03   0x03
  55C800AF: 0C                    db_op_0C   0x0C
  55C800B0: 80 FC                 mov        0xFC, d0
  55C800B2: CC 38 00              jmp        loc_55C800EA
  55C800B5: C8 55                 beq        loc_55C8010A
loc_55C800B7:
  55C800B7: 03                    db_op_03   0x03
  55C800B8: 10                    db_op_10   0x10
  55C800B9: 80 FC                 mov        0xFC, d0
  55C800BB: CC 40 00              jmp        loc_55C800FB
  55C800BE: C8 55                 beq        loc_55C80113
  55C800C0: 03                    db_op_03   0x03
  55C800C1: 14                    db_op_14   0x14
  55C800C2: 80 FC                 mov        0xFC, d0
  55C800C4: CC 48 00              jmp        loc_55C8010C
  55C800C7: C8 55                 beq        loc_55C8011C
  55C800C9: 03                    db_op_03   0x03
  55C800CA: 18                    db_op_18   0x18
  55C800CB: 80 DC                 mov        0xDC, d0
  55C800CD: F5 81                 ext_f5_81  
  55C800CF: 21 00                 add        0, d1

; ------------------------------------------------------------------------------
; FUNCTION: kernel_early_ram_init (VA 0x55C800D1)
; ------------------------------------------------------------------------------
kernel_early_ram_init:
  55C800D1: FC DC 2C 04 00 54     mov        0x5400042C, a0
  55C800D7: FC DD E4 27 01 54     mov        0x540127E4, a1
  55C800DD: B1                    db_op_B1   0xB1
  55C800DE: C8 09                 beq        loc_55C800E7
  55C800E0: 00                    db_op_00   0x00
  55C800E1: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C800E2: 60                    mov        (a0), d0
  55C800E3: 50                    db_op_50   0x50
  55C800E4: B4                    db_op_B4   0xB4
  55C800E5: CB                    nop        
  55C800E6: D4                    lbcs       
loc_55C800E7:
  55C800E7: FC DC 38 06 C8 55     mov        0x55C80638, a0
  55C800ED: FC CD 38 06 C8 55     mov        0x55C80638, d1
  55C800F3: F1 91                 ext_f1_91  
  55C800F5: C8 10                 beq        loc_55C80105
  55C800F7: FC DD 00 04 00 54     mov        0x54000400, a1
  55C800FD: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C800FE: 70                    mov        d0, (a0)
  55C800FF: 61                    mov        (a1), d0
  55C80100: 50                    db_op_50   0x50
loc_55C80101:
  55C80101: 51                    db_op_51   0x51
  55C80102: F1 A4                 ext_f1_A4  
  55C80104: D4                    lbcs       
loc_55C80105:
  55C80105: F0 F7                 jmp        (a3)

; ------------------------------------------------------------------------------
; FUNCTION: nmi_watchdog_handler (VA 0x55C80107)
; ------------------------------------------------------------------------------
nmi_watchdog_handler:
  55C80107: CB                    nop        
  55C80108: 42 00                 mov        a2, (0, sp)
loc_55C8010A:
  55C8010A: 80 40                 mov        0x40, d0
loc_55C8010C:
  55C8010C: FC 83 80 50 00 9C     mov        d3, (0x9C005080)               ; MMIO VENUS_TIMER_PWM_0x080
  55C80112: FC 83 90 50 00 9C     mov        d3, (0x9C005090)               ; MMIO VENUS_TIMER_PWM_0x090
  55C80118: 38                    db_op_38   0x38
  55C80119: 00                    db_op_00   0x00
  55C8011A: 89                    mov        d2, d1
  55C8011B: FA C0 A0 55           ext_fa_C0  0x55A0
  55C8011F: FC 83 88 50 00 9C     mov        d3, (0x9C005088)               ; MMIO VENUS_TIMER_PWM_0x088
  55C80125: F8 BC 04              ext_f8_BC  0x04
  55C80128: FC 83 96 50 00 9C     mov        d3, (0x9C005096)               ; MMIO VENUS_TIMER_PWM_0x096
  55C8012E: F8 BC 06              ext_f8_BC  0x06
  55C80131: FC 83 98 50 00 9C     mov        d3, (0x9C005098)               ; MMIO VENUS_TIMER_PWM_0x098
  55C80137: 80 07                 mov        0x07, d0
  55C80139: 03                    db_op_03   0x03
  55C8013A: 00                    db_op_00   0x00
  55C8013B: 89                    mov        d2, d1
  55C8013C: 38                    db_op_38   0x38
  55C8013D: 00                    db_op_00   0x00
  55C8013E: 89                    mov        d2, d1
  55C8013F: FC DC 0C D1 D0 55     mov        0x55D0D10C, a0
  55C80145: F0 F0                 calls      (a0)
  55C80147: 58 00                 mov        (0, sp), d0
  55C80149: F0 FD                 rti        

; --- Function sub_55C8014B (callers: 1) ---
sub_55C8014B:
  55C8014B: F8 FE EC              add        -20, sp
  55C8014E: DD B5 B6 01 00 00 04  call       sub_55C9B803, [], 4
  55C80155: F8 FE 14              add        20, sp
  55C80158: F0 FC                 rets       
  55C8015A: FF                    db_op_FF   0xFF
  55C8015B: FF                    db_op_FF   0xFF
  55C8015C: FC 88 20 28 01 54     movhu      d0, (0x54012820)
  55C80162: FC DE 24 28 01 54     mov        0x54012824, a2
  55C80168: 6E                    mov        (a2), d3
  55C80169: FC 1A 04 00 00 00     ext_fc_1A  0x00000004
  55C8016F: F2 E7                 ext_f2_E7  
  55C80171: FA FC FF F7           ext_fa_FC  0xF7FF
  55C80175: 8A                    mov        d2, d2
  55C80176: 08                    db_op_08   0x08
  55C80177: FC 5A 18 00 00 00     ext_fc_5A  0x00000018
  55C8017D: 08                    db_op_08   0x08
  55C8017E: FC 5A 1A 00 00 00     ext_fc_5A  0x0000001A
  55C80184: 3A                    db_op_3A   0x3A
  55C80185: 30                    db_op_30   0x30
  55C80186: 80 F8                 mov        0xF8, d0
  55C80188: E6                    add        d1, d2
  55C80189: 10                    db_op_10   0x10
  55C8018A: 0B                    db_op_0B   0x0B
  55C8018B: 30                    db_op_30   0x30
  55C8018C: 80 26                 mov        0x26, d0
  55C8018E: 01                    db_op_01   0x01
  55C8018F: 8C                    mov        d3, d0
  55C80190: 8A                    mov        d2, d2
  55C80191: 20 F0                 add        -16, d0
  55C80193: 5A 08                 mov        (8, sp), d2
  55C80195: F0 5A                 ext_f0_5A  
  55C80197: 0B                    db_op_0B   0x0B
  55C80198: 7C                    mov        d3, (a0)
  55C80199: 89                    mov        d2, d1
  55C8019A: 3A                    db_op_3A   0x3A
  55C8019B: 30                    db_op_30   0x30
  55C8019C: 80 FA                 mov        0xFA, d0
  55C8019E: E2                    add        d0, d2
  55C8019F: EF                    add        d3, d3
  55C801A0: FF                    db_op_FF   0xFF
  55C801A1: 0B                    db_op_0B   0x0B
  55C801A2: 30                    db_op_30   0x30
  55C801A3: 80 FC                 mov        0xFC, d0
  55C801A5: DE 28 28              retf       [a2,other], 40
  55C801A8: 01                    db_op_01   0x01
  55C801A9: 54                    db_op_54   0x54
  55C801AA: F2 FF                 ext_f2_FF  
  55C801AC: 7A                    mov        d2, (a2)
  55C801AD: FC 0E FC FF FF FF     ext_fc_0E  0xFFFFFFFC
  55C801B3: FC 2A F8 FF FF FF     ext_fc_2A  0xFFFFFFF8
  55C801B9: DF 00 00              ret        [], 0
  55C801BC: FC 89 28 28 01 54     movhu      d1, (0x54012828)
  55C801C2: 32                    db_op_32   0x32
  55C801C3: 00                    db_op_00   0x00
  55C801C4: 89                    mov        d2, d1
  55C801C5: F8 E2 02              ext_f8_E2  0x02
  55C801C8: C8 1A                 beq        loc_55C801E2
loc_55C801CA:
  55C801CA: 8A                    mov        d2, d2
  55C801CB: 00                    db_op_00   0x00
  55C801CC: FC 8B 2E 40 00 9C     movhu      d3, (0x9C00402E)               ; MMIO VENUS_SIO_UART_0x02E
  55C801D2: FC CE 58 C0 00 00     mov        0x0000C058, d2
  55C801D8: FC 8B 22 40 00 9C     movhu      d3, (0x9C004022)               ; MMIO VENUS_SIO_UART_0x022
  55C801DE: CB                    nop        
  55C801DF: CB                    nop        
  55C801E0: CA EA                 bra        loc_55C801CA
loc_55C801E2:
  55C801E2: 3A                    db_op_3A   0x3A
  55C801E3: 34                    db_op_34   0x34
  55C801E4: 80 F8                 mov        0xF8, d0
  55C801E6: EE                    add        d3, d2
  55C801E7: 80 C9                 mov        0xC9, d0
  55C801E9: 41 FC                 mov        a1, (252, sp)
  55C801EB: 88                    mov        d2, d0
  55C801EC: 20 28                 add        40, d0
  55C801EE: 01                    db_op_01   0x01
  55C801EF: 54                    db_op_54   0x54
  55C801F0: 3A                    db_op_3A   0x3A
  55C801F1: 30                    db_op_30   0x30
  55C801F2: 80 F8                 mov        0xF8, d0
  55C801F4: E6                    add        d1, d2
  55C801F5: 10                    db_op_10   0x10
  55C801F6: 0B                    db_op_0B   0x0B
  55C801F7: 30                    db_op_30   0x30
  55C801F8: 80 FA                 mov        0xFA, d0
  55C801FA: FC FF 7F 3A 34 80     calls      0xD5FC3C79
  55C80200: 0B                    db_op_0B   0x0B
  55C80201: 34                    db_op_34   0x34
  55C80202: 80 FC                 mov        0xFC, d0
  55C80204: DE 38 28              retf       [a2,a3,other], 40
  55C80207: 01                    db_op_01   0x01
  55C80208: 54                    db_op_54   0x54
  55C80209: F0 7A                 ext_f0_7A  
  55C8020B: 3A                    db_op_3A   0x3A
  55C8020C: 00                    db_op_00   0x00
  55C8020D: 89                    mov        d2, d1
  55C8020E: F8 7A 02              ext_f8_7A  0x02
  55C80211: FA FA 04 10           ext_fa_FA  0x1004
  55C80215: C8 0F                 beq        loc_55C80224
  55C80217: FA F6 04 10           ext_fa_F6  0x1004
  55C8021B: 3A                    db_op_3A   0x3A
  55C8021C: 30                    db_op_30   0x30
  55C8021D: 80 F8                 mov        0xF8, d0
  55C8021F: E6                    add        d1, d2
  55C80220: 20 0B                 add        11, d0
  55C80222: 30                    db_op_30   0x30
  55C80223: 80 DC                 mov        0xDC, d0
  55C80225: FE 00 00 00 FC 8C 1C  ext_fe_00  0x8CFC0000, 0x1C
  55C8022C: 28 01                 cmp        0x01, d0
  55C8022E: 54                    db_op_54   0x54
  55C8022F: FC DF 24 28 01 54     mov        0x54012824, a3
  55C80235: 6F                    mov        (a3), d3
  55C80236: FC 3B FC FF FF FF     ext_fc_3B  0xFFFFFFFC
  55C8023C: 3A                    db_op_3A   0x3A
  55C8023D: 30                    db_op_30   0x30
  55C8023E: 80 F8                 mov        0xF8, d0
  55C80240: E6                    add        d1, d2
  55C80241: 10                    db_op_10   0x10
  55C80242: 0B                    db_op_0B   0x0B
  55C80243: 30                    db_op_30   0x30
  55C80244: 80 26                 mov        0x26, d0
  55C80246: 01                    db_op_01   0x01
  55C80247: 8C                    mov        d3, d0
  55C80248: FA FA 00 09           ext_fa_FA  0x0900
  55C8024C: C9 6B                 bne        loc_55C802B7
  55C8024E: F8 4A FF              ext_f8_4A  0xFF
  55C80251: FC CA 36 00 00 00     ext_fc_CA  0x00000036
  55C80257: C2 60                 bge        loc_55C802B7
  55C80259: F8 EE 01              ext_f8_EE  0x01
  55C8025C: C9 5B                 bne        loc_55C802B7
  55C8025E: F8 EE 02              ext_f8_EE  0x02
  55C80261: C8 3E                 beq        loc_55C8029F
  55C80263: FC DF 2C 28 01 54     mov        0x5401282C, a3
  55C80269: FC 5B 11 00 00 00     ext_fc_5B  0x00000011
  55C8026F: F8 CA 02              ext_f8_CA  0x02
  55C80272: F8 E2 07              ext_f8_E2  0x07
  55C80275: F2 32                 ext_f2_32  
loc_55C80277:
  55C80277: F0 4E                 ext_f0_4E  
  55C80279: F8 E3 1E              ext_f8_E3  0x1E
  55C8027C: FA F2 00 20           ext_fa_F2  0x2000
  55C80280: F0 5E                 ext_f0_5E  
  55C80282: F0 4E                 ext_f0_4E  
loc_55C80284:
  55C80284: FA FA 00 80           ext_fa_FA  0x8000
  55C80288: C8 FC                 beq        loc_55C80284
  55C8028A: FA FA 00 09           ext_fa_FA  0x0900
  55C8028E: C9 29                 bne        loc_55C802B7
  55C80290: F8 4E FF              ext_f8_4E  0xFF
  55C80293: F0 5F                 ext_f0_5F  
  55C80295: 4D                    db_op_4D   0x4D
  55C80296: 48                    db_op_48   0x48
  55C80297: C9 E0                 bne        loc_55C80277
  55C80299: FC AA 3D 28 01 54     ext_fc_AA  0x5401283D
loc_55C8029F:
  55C8029F: FC DE 02 06 C8 55     mov        0x55C80602, a2
  55C802A5: FC DF A8 03 C8 55     mov        0x55C803A8, a3
  55C802AB: F4 BA                 ext_f4_BA  
  55C802AD: FC DE 2C 28 01 54     mov        0x5401282C, a2
  55C802B3: F1 6F                 ext_f1_6F  
  55C802B5: F0 F7                 jmp        (a3)
loc_55C802B7:
  55C802B7: DC 46 00 00 00        jmp        loc_55C802FD
loc_55C802BC:
  55C802BC: FC DE 2B 28 01 54     mov        0x5401282B, a2
loc_55C802C2:
  55C802C2: 08                    db_op_08   0x08
  55C802C3: FC CA CB 08 8F FF     ext_fc_CA  0xFF8F08CB
  55C802C9: FC DF 3C 28 01 54     mov        0x5401283C, a3
  55C802CF: FA FB 00 08           ext_fa_FB  0x0800
  55C802D3: C8 05                 beq        loc_55C802D8
  55C802D5: F8 E6 80              ext_f8_E6  0x80
loc_55C802D8:
  55C802D8: 27 01 8C              mov        0x8C01, a3
  55C802DB: FA CA F0 4A           bxx16      loc_55C84DCB
  55C802DF: 49                    db_op_49   0x49
  55C802E0: F8 5B FF              ext_f8_5B  0xFF
  55C802E3: FA F3 00 60           ext_fa_F3  0x6000
  55C802E7: FA F7 00 A1           ext_fa_F7  0xA100
  55C802EB: F8 5B FF              ext_f8_5B  0xFF
loc_55C802EE:
  55C802EE: FA FB 00 80           ext_fa_FB  0x8000
  55C802F2: C8 FC                 beq        loc_55C802EE
  55C802F4: FA FB 00 09           ext_fa_FB  0x0900
  55C802F8: C9 05                 bne        loc_55C802FD
  55C802FA: 4C                    db_op_4C   0x4C
  55C802FB: C9 E2                 bne        loc_55C802DD
loc_55C802FD:
  55C802FD: FC DE 24 28 01 54     mov        0x54012824, a2
  55C80303: 7E                    mov        d3, (a2)
  55C80304: FC 2E F8 FF FF FF     ext_fc_2E  0xFFFFFFF8
  55C8030A: FC 4A 18 00 00 00     ext_fc_4A  0x00000018
  55C80310: F8 EE 04              ext_f8_EE  0x04
  55C80313: C9 07                 bne        loc_55C8031A
  55C80315: DC 45 00 00 00        jmp        loc_55C8035A
loc_55C8031A:
  55C8031A: 8A                    mov        d2, d2
  55C8031B: FF                    db_op_FF   0xFF
  55C8031C: FC 1A 14 00 00 00     ext_fc_1A  0x00000014
  55C80322: FC DE 3C 28 01 54     mov        0x5401283C, a2
  55C80328: FA FA 00 02           ext_fa_FA  0x0200
  55C8032C: C9 1E                 bne        loc_55C8034A
  55C8032E: 5A 04                 mov        (4, sp), d2
  55C80330: FC 1A AC FF FF FF     ext_fc_1A  0xFFFFFFAC
  55C80336: FC CE A6 03 C8 55     mov        0x55C803A6, d2
  55C8033C: 4A                    db_op_4A   0x4A
  55C8033D: 04                    db_op_04   0x04
  55C8033E: 5A 00                 mov        (0, sp), d2
  55C80340: FA E2 FF 7F           ext_fa_E2  0x7FFF
  55C80344: FC 1A B0 FF FF FF     ext_fc_1A  0xFFFFFFB0
loc_55C8034A:
  55C8034A: FA E2 FF F7           ext_fa_E2  0xF7FF
  55C8034E: 4A                    db_op_4A   0x4A
  55C8034F: 00                    db_op_00   0x00
  55C80350: F0 4A                 ext_f0_4A  
  55C80352: F8 E2 FB              ext_f8_E2  0xFB
  55C80355: F8 E6 02              ext_f8_E6  0x02
  55C80358: F0 5A                 ext_f0_5A  
loc_55C8035A:
  55C8035A: 26 01 8C              mov        0x8C01, a2
  55C8035D: F0 4A                 ext_f0_4A  
  55C8035F: F8 EE 80              ext_f8_EE  0x80
  55C80362: C8 1B                 beq        loc_55C8037D
  55C80364: F8 EE 49              ext_f8_EE  0x49
  55C80367: C8 16                 beq        loc_55C8037D
  55C80369: F8 E2 36              ext_f8_E2  0x36
  55C8036C: FA F2 00 20           ext_fa_F2  0x2000
  55C80370: F0 5A                 ext_f0_5A  
  55C80372: F0 4A                 ext_f0_4A  
  55C80374: 2E 80 00              mov        0x0080, d2
  55C80377: 0B                    db_op_0B   0x0B
  55C80378: 34                    db_op_34   0x34
  55C80379: 80 3A                 mov        0x3A, d0
  55C8037B: 34                    db_op_34   0x34
  55C8037C: 80 8A                 mov        0x8A, d0
  55C8037E: FF                    db_op_FF   0xFF
  55C8037F: 0B                    db_op_0B   0x0B
  55C80380: 04                    db_op_04   0x04
  55C80381: 89                    mov        d2, d1
  55C80382: 0B                    db_op_0B   0x0B
  55C80383: 00                    db_op_00   0x00
  55C80384: 89                    mov        d2, d1
  55C80385: F8 BA 01              ext_f8_BA  0x01
  55C80388: F8 EE 80              ext_f8_EE  0x80
  55C8038B: C9 0C                 bne        loc_55C80397
  55C8038D: 3A                    db_op_3A   0x3A
  55C8038E: 30                    db_op_30   0x30
  55C8038F: 80 FA                 mov        0xFA, d0
  55C80391: E2                    add        d0, d2
  55C80392: EF                    add        d3, d3
  55C80393: FF                    db_op_FF   0xFF
  55C80394: 0B                    db_op_0B   0x0B
  55C80395: 30                    db_op_30   0x30
  55C80396: 80 FC                 mov        0xFC, d0
  55C80398: DE 28 28              retf       [a2,other], 40
  55C8039B: 01                    db_op_01   0x01
  55C8039C: 54                    db_op_54   0x54
  55C8039D: 7A                    mov        d2, (a2)
  55C8039E: FC 2A F8 FF FF FF     ext_fc_2A  0xFFFFFFF8
  55C803A4: F0 FD                 rti        
loc_55C803A6:
  55C803A6: CA 00                 bra        loc_55C803A6
  55C803A8: CC 55 FF              jmp        loc_55C802FD
  55C803AB: FA F2 10 01           ext_fa_F2  0x0110
  55C803AF: FA F6 10 08           ext_fa_F6  0x0810
  55C803B3: CC 13 FF              jmp        loc_55C802C6
  55C803B6: FA F6 10 0D           ext_fa_F6  0x0D10
  55C803BA: CC 0C FF              jmp        loc_55C802C6
  55C803BD: FC 2E 08 00 00 00     ext_fc_2E  0x00000008
  55C803C3: F0 4A                 ext_f0_4A  
  55C803C5: F0 5B                 ext_f0_5B  
  55C803C7: 4D                    db_op_4D   0x4D
  55C803C8: CA 19                 bra        loc_55C803E1
  55C803CA: FC 2E 08 00 00 00     ext_fc_2E  0x00000008
  55C803D0: F0 6A                 ext_f0_6A  
  55C803D2: F0 7B                 ext_f0_7B  
  55C803D4: 23 02                 add        2, d3
  55C803D6: CA 0B                 bra        loc_55C803E1
  55C803D8: FC 2E 08 00 00 00     ext_fc_2E  0x00000008
  55C803DE: 7A                    mov        d2, (a2)
  55C803DF: 6B                    mov        (a3), d2
  55C803E0: 53                    db_op_53   0x53
loc_55C803E1:
  55C803E1: FA FA 12 01           ext_fa_FA  0x0112
  55C803E5: C8 08                 beq        loc_55C803ED
  55C803E7: FC 3E 08 00 00 00     ext_fc_3E  0x00000008
loc_55C803ED:
  55C803ED: CC D9 FE              jmp        loc_55C802C6
  55C803F0: 7A                    mov        d2, (a2)
  55C803F1: FC 1A 08 00 00 00     ext_fc_1A  0x00000008
  55C803F7: F8 4A 04              ext_f8_4A  0x04
  55C803FA: FC 5A 12 00 00 00     ext_fc_5A  0x00000012
  55C80400: CC C6 FE              jmp        loc_55C802C6
  55C80403: FC 2E 08 00 00 00     ext_fc_2E  0x00000008
  55C80409: F0 4B                 ext_f0_4B  
  55C8040B: F0 5A                 ext_f0_5A  
  55C8040D: 8F                    mov        d3, d3
  55C8040E: FE 4D CA 3D F0 4E FC  ext_fe_4D  0x4EF03DCA, 0xFC
  55C80415: 2E 08 00              mov        0x0008, d2
  55C80418: 00                    db_op_00   0x00
  55C80419: 00                    db_op_00   0x00
  55C8041A: 4C                    db_op_4C   0x4C
  55C8041B: F1 DE                 ext_f1_DE  
  55C8041D: EE                    add        d3, d2
  55C8041E: FA FA 12 01           ext_fa_FA  0x0112
  55C80422: C8 08                 beq        loc_55C8042A
  55C80424: FC 1A 08 00 00 00     ext_fc_1A  0x00000008
loc_55C8042A:
  55C8042A: 9E                    mov        a3, a2
  55C8042B: F2 33                 ext_f2_33  
  55C8042D: 22 FF                 add        -1, d2
  55C8042F: CC 93 FE              jmp        loc_55C802C2
  55C80432: FC 2E 08 00 00 00     ext_fc_2E  0x00000008
  55C80438: F0 6B                 ext_f0_6B  
  55C8043A: F0 7A                 ext_f0_7A  
  55C8043C: 8F                    mov        d3, d3
  55C8043D: FD 23 02 CA 0D        ext_fd_23  0xCA02, 0x0D
  55C80442: FC 2E 08 00 00 00     ext_fc_2E  0x00000008
  55C80448: 7B                    mov        d2, (a3)
  55C80449: 6A                    mov        (a2), d2
  55C8044A: 8F                    mov        d3, d3
  55C8044B: FB 53 FA FA           ext_fb_53  0xFAFA
  55C8044F: 12                    db_op_12   0x12
  55C80450: 01                    db_op_01   0x01
  55C80451: C8 08                 beq        loc_55C80459
  55C80453: FC 3E 08 00 00 00     ext_fc_3E  0x00000008
loc_55C80459:
  55C80459: CC 63 FE              jmp        loc_55C802BC
  55C8045C: 2F FF 00              mov        0x00FF, d3
  55C8045F: FC CA CB F8 4E 04     ext_fc_CA  0x044EF8CB
  55C80465: F0 0E                 ext_f0_0E  
  55C80467: F8 5E 01              ext_f8_5E  0x01
  55C8046A: F0 4B                 ext_f0_4B  
  55C8046C: F0 5A                 ext_f0_5A  
  55C8046E: F0 5F                 ext_f0_5F  
  55C80470: F0 4B                 ext_f0_4B  
  55C80472: AB                    db_op_AB   0xAB
  55C80473: C8 07                 beq        loc_55C8047A
  55C80475: 8A                    mov        d2, d2
  55C80476: 02                    db_op_02   0x02
  55C80477: CC 50 FE              jmp        loc_55C802C7
loc_55C8047A:
  55C8047A: F1 DE                 ext_f1_DE  
  55C8047C: FC D2 E0 FF FF FF     add        0xFFFFFFE0, d2
  55C80482: 3F F2                 mov        d3, (242, sp)
  55C80484: F8 CF 08              ext_f8_CF  0x08
  55C80487: FC B7 04 00 00 00     ext_fc_B7  0x00000004
  55C8048D: AE                    db_op_AE   0xAE
  55C8048E: C6 1A                 bcc        loc_55C804A8
  55C80490: 2B FC                 cmp        0xFC, d3
  55C80492: AE                    db_op_AE   0xAE
  55C80493: C4 15                 bcs        loc_55C804A8
  55C80495: F8 E2 03              ext_f8_E2  0x03
  55C80498: FC 4E 21 00 00 00     ext_fc_4E  0x00000021
  55C8049E: FC C2 E8 FF FF FF     ext_fc_C2  0xFFFFFFE8
  55C804A4: F4 7A                 ext_f4_7A  
  55C804A6: CE 08                 movm       (sp), [other]
loc_55C804A8:
  55C804A8: F2 FC                 ext_f2_FC  
  55C804AA: FC 4E 31 00 00 00     ext_fc_4E  0x00000031
  55C804B0: AF                    db_op_AF   0xAF
  55C804B1: 2E C8 05              mov        0x05C8, d2
  55C804B4: CC 12 FE              jmp        loc_55C802C6
  55C804B7: 8F                    mov        d3, d3
  55C804B8: FE CC 03 FE FC CE 04  ext_fe_CC  0xCEFCFE03, 0x04
  55C804BF: E0                    add        d0, d0
  55C804C0: 10                    db_op_10   0x10
  55C804C1: 22 6A                 add        106, d2
  55C804C3: 8F                    mov        d3, d3
  55C804C4: FB CC F7 FD           ext_fb_CC  0xFDF7
  55C804C8: 9B                    mov        a2, a3
  55C804C9: FC CF 48 00 00 00     mov        0x00000048, d3
  55C804CF: FC D3 B8 FF FF FF     add        0xFFFFFFB8, d3
  55C804D5: F0 1E                 ext_f0_1E  
  55C804D7: 52                    db_op_52   0x52
  55C804D8: 6E                    mov        (a2), d3
  55C804D9: 8F                    mov        d3, d3
  55C804DA: F9 CC E1              ext_f9_CC  0xE1
  55C804DD: FD FC 0A 08 00        ext_fd_FC  0x080A, 0x00
  55C804E2: 00                    db_op_00   0x00
  55C804E3: 00                    db_op_00   0x00
  55C804E4: CA DE                 bra        loc_55C804C2
  55C804E6: FA FA 10 02           ext_fa_FA  0x0210
  55C804EA: C8 3F                 beq        loc_55C80529
  55C804EC: FE 00 ED 27 01 54 80  ext_fe_00  0x540127ED, 0x80
  55C804F3: 3A                    db_op_3A   0x3A
  55C804F4: 30                    db_op_30   0x30
  55C804F5: 80 F8                 mov        0xF8, d0
  55C804F7: EE                    add        d3, d2
  55C804F8: 20 C8                 add        -56, d0
  55C804FA: 0F                    db_op_0F   0x0F
  55C804FB: FA F2 10 10           ext_fa_F2  0x1010
  55C804FF: FA E2 DF FF           ext_fa_E2  0xFFDF
  55C80503: 0B                    db_op_0B   0x0B
  55C80504: 30                    db_op_30   0x30
  55C80505: 80 CA                 mov        0xCA, d0
  55C80507: 0C                    db_op_0C   0x0C
  55C80508: FA FA 10 02           ext_fa_FA  0x0210
  55C8050C: C8 1D                 beq        loc_55C80529
  55C8050E: FA F6 10 10           ext_fa_F6  0x1010
  55C80512: FC 0A BC FF FF FF     ext_fc_0A  0xFFFFFFBC
  55C80518: FA F6 10 02           ext_fa_F6  0x0210
  55C8051C: 4A                    db_op_4A   0x4A
  55C8051D: 04                    db_op_04   0x04
  55C8051E: FC 0A C0 FF FF FF     ext_fc_0A  0xFFFFFFC0
  55C80524: 4A                    db_op_4A   0x4A
  55C80525: 00                    db_op_00   0x00
  55C80526: CC A0 FD              jmp        loc_55C802C6
loc_55C80529:
  55C80529: 8A                    mov        d2, d2
  55C8052A: 01                    db_op_01   0x01
  55C8052B: CC 9C FD              jmp        loc_55C802C7
  55C8052E: FA FA 10 02           ext_fa_FA  0x0210
  55C80532: C9 06                 bne        loc_55C80538
  55C80534: FA F2 10 04           ext_fa_F2  0x0410
loc_55C80538:
  55C80538: CC 8E FD              jmp        loc_55C802C6
  55C8053B: FA FA 10 02           ext_fa_FA  0x0210
  55C8053F: C9 07                 bne        loc_55C80546
  55C80541: 8A                    mov        d2, d2
  55C80542: 01                    db_op_01   0x01
  55C80543: CC 84 FD              jmp        loc_55C802C7
loc_55C80546:
  55C80546: FC 0A BC FF FF FF     ext_fc_0A  0xFFFFFFBC
  55C8054C: 6A                    mov        (a2), d2
  55C8054D: FC 0A 0C 00 00 00     ext_fc_0A  0x0000000C
  55C80553: 52                    db_op_52   0x52
  55C80554: 6A                    mov        (a2), d2
  55C80555: 8F                    mov        d3, d3
  55C80556: F7 CC                 ext_f7_CC  
  55C80558: 65                    mov        (a1), d1
  55C80559: FD 8A 1C FC 5A        ext_fd_8A  0xFC1C, 0x5A
  55C8055E: 11                    db_op_11   0x11
  55C8055F: 00                    db_op_00   0x00
  55C80560: 00                    db_op_00   0x00
  55C80561: 00                    db_op_00   0x00
  55C80562: FC D2 E0 FF FF FF     add        0xFFFFFFE0, d2
  55C80568: 3F F2                 mov        d3, (242, sp)
  55C8056A: F8 CF 08              ext_f8_CF  0x08
  55C8056D: F2 FC                 ext_f2_FC  
  55C8056F: 23 08                 add        8, d3
  55C80571: FC 3E D8 FF FF FF     ext_fc_3E  0xFFFFFFD8
  55C80577: FC 4A 31 00 00 00     ext_fc_4A  0x00000031
  55C8057D: AA                    db_op_AA   0xAA
  55C8057E: 16                    db_op_16   0x16
  55C8057F: C8 33                 beq        loc_55C805B2
  55C80581: AA                    db_op_AA   0xAA
  55C80582: 1C                    db_op_1C   0x1C
  55C80583: C8 18                 beq        loc_55C8059B
  55C80585: FC 6A 20 00 00 00     ext_fc_6A  0x00000020
  55C8058B: F8 C2 02              ext_f8_C2  0x02
  55C8058E: 8F                    mov        d3, d3
  55C8058F: FB FC D2 D7           ext_fb_FC  0xD7D2
  55C80593: FF                    db_op_FF   0xFF
  55C80594: FF                    db_op_FF   0xFF
  55C80595: FF                    db_op_FF   0xFF
  55C80596: F1 6A                 ext_f1_6A  
  55C80598: CC 2A FD              jmp        loc_55C802C2
loc_55C8059B:
  55C8059B: FC D2 D7 FF FF FF     add        0xFFFFFFD7, d2
  55C805A1: FC CF B7 FF FF FF     mov        0xFFFFFFB7, d3
  55C805A7: CC 1B FD              jmp        loc_55C802C2
  55C805AA: FC D2 B8 FF FF FF     add        0xFFFFFFB8, d2
  55C805B0: CA 1D                 bra        loc_55C805CD
loc_55C805B2:
  55C805B2: FC 6A 24 00 00 00     ext_fc_6A  0x00000024
  55C805B8: FC 0E 20 00 00 00     ext_fc_0E  0x00000020
  55C805BE: FC D2 D8 FF FF FF     add        0xFFFFFFD8, d2
  55C805C4: F8 C2 02              ext_f8_C2  0x02
  55C805C7: F3 7A                 ext_f3_7A  
  55C805C9: AA                    db_op_AA   0xAA
  55C805CA: 00                    db_op_00   0x00
  55C805CB: C9 21                 bne        loc_55C805EC
loc_55C805CD:
  55C805CD: F0 0E                 ext_f0_0E  
  55C805CF: F1 DE                 ext_f1_DE  
  55C805D1: 23 F8                 add        -8, d3
  55C805D3: F8 EE 03              ext_f8_EE  0x03
  55C805D6: C9 26                 bne        loc_55C805FC
  55C805D8: 5B 04                 mov        (4, sp), d3
  55C805DA: F8 1F 04              ext_f8_1F  0x04
  55C805DD: F8 0B 04              ext_f8_0B  0x04
  55C805E0: AB                    db_op_AB   0xAB
  55C805E1: C9 1B                 bne        loc_55C805FC
  55C805E3: 5B 00                 mov        (0, sp), d3
  55C805E5: 6F                    mov        (a3), d3
  55C805E6: 7B                    mov        d2, (a3)
  55C805E7: AB                    db_op_AB   0xAB
  55C805E8: C9 14                 bne        loc_55C805FC
  55C805EA: F2 FC                 ext_f2_FC  
loc_55C805EC:
  55C805EC: FC D2 08 00 00 00     add        0x00000008, d2
  55C805F2: 3F F2                 mov        d3, (242, sp)
  55C805F4: F8 CE 08              ext_f8_CE  0x08
  55C805F7: F2 FC                 ext_f2_FC  
  55C805F9: CC CD FC              jmp        loc_55C802C6
loc_55C805FC:
  55C805FC: 8A                    mov        d2, d2
  55C805FD: 03                    db_op_03   0x03
  55C805FE: CC C9 FC              jmp        loc_55C802C7
  55C80601: 00                    db_op_00   0x00
  55C80602: 03                    db_op_03   0x03
  55C80603: 00                    db_op_00   0x00
  55C80604: 15                    db_op_15   0x15
  55C80605: 00                    db_op_00   0x00
  55C80606: 0E                    db_op_0E   0x0E
  55C80607: 00                    db_op_00   0x00
  55C80608: 22 00                 add        0, d2
  55C8060A: 14                    db_op_14   0x14
  55C8060B: 01                    db_op_01   0x01
  55C8060C: 00                    db_op_00   0x00
  55C8060D: 00                    db_op_00   0x00
  55C8060E: 20 01                 add        1, d0
  55C80610: 30                    db_op_30   0x30
  55C80611: 00                    db_op_00   0x00
  55C80612: 5B 00                 mov        (0, sp), d3
  55C80614: 48                    db_op_48   0x48
  55C80615: 00                    db_op_00   0x00
  55C80616: 8A                    mov        d2, d2
  55C80617: 00                    db_op_00   0x00
  55C80618: BA                    db_op_BA   0xBA
  55C80619: 01                    db_op_01   0x01
  55C8061A: 9A                    mov        a2, a2
  55C8061B: 00                    db_op_00   0x00
  55C8061C: 00                    db_op_00   0x00
  55C8061D: 00                    db_op_00   0x00
  55C8061E: B2                    db_op_B2   0xB2
  55C8061F: 01                    db_op_01   0x01
  55C80620: 00                    db_op_00   0x00
  55C80621: 00                    db_op_00   0x00
  55C80622: 3E 01                 mov        d2, (1, sp)
  55C80624: 6A                    mov        (a2), d2
  55C80625: 00                    db_op_00   0x00
  55C80626: 60                    mov        (a0), d0
  55C80627: 01                    db_op_01   0x01
  55C80628: BA                    db_op_BA   0xBA
  55C80629: 01                    db_op_01   0x01
  55C8062A: 86                    mov        d1, d2
  55C8062B: 01                    db_op_01   0x01
  55C8062C: 00                    db_op_00   0x00
  55C8062D: 00                    db_op_00   0x00
  55C8062E: 93 01                 mov        0x01, a3
  55C80630: B4                    db_op_B4   0xB4
  55C80631: 00                    db_op_00   0x00
  55C80632: 02                    db_op_02   0x02
  55C80633: 02                    db_op_02   0x02
  55C80634: BA                    db_op_BA   0xBA
  55C80635: 00                    db_op_00   0x00
  55C80636: 36                    db_op_36   0x36
  55C80637: 01                    db_op_01   0x01
  55C80638: FF                    db_op_FF   0xFF
  55C80639: FF                    db_op_FF   0xFF
  55C8063A: FF                    db_op_FF   0xFF
  55C8063B: FF                    db_op_FF   0xFF
  55C8063C: FF                    db_op_FF   0xFF
  55C8063D: FF                    db_op_FF   0xFF
  55C8063E: FF                    db_op_FF   0xFF
  55C8063F: FF                    db_op_FF   0xFF
  55C80640: FF                    db_op_FF   0xFF
  55C80641: FF                    db_op_FF   0xFF
  55C80642: FF                    db_op_FF   0xFF
  55C80643: FF                    db_op_FF   0xFF
  55C80644: FF                    db_op_FF   0xFF
  55C80645: FF                    db_op_FF   0xFF
  55C80646: FF                    db_op_FF   0xFF
  55C80647: FF                    db_op_FF   0xFF
  55C80648: FF                    db_op_FF   0xFF
  55C80649: FF                    db_op_FF   0xFF
  55C8064A: FF                    db_op_FF   0xFF
  55C8064B: FF                    db_op_FF   0xFF
  55C8064C: FF                    db_op_FF   0xFF
  55C8064D: FF                    db_op_FF   0xFF
  55C8064E: FF                    db_op_FF   0xFF
  55C8064F: FF                    db_op_FF   0xFF
  55C80650: FF                    db_op_FF   0xFF
  55C80651: FF                    db_op_FF   0xFF
  55C80652: FF                    db_op_FF   0xFF
  55C80653: FF                    db_op_FF   0xFF
  55C80654: FF                    db_op_FF   0xFF
  55C80655: FF                    db_op_FF   0xFF
  55C80656: FF                    db_op_FF   0xFF
  55C80657: FF                    db_op_FF   0xFF
  55C80658: FF                    db_op_FF   0xFF
  55C80659: FF                    db_op_FF   0xFF
  55C8065A: FF                    db_op_FF   0xFF
  55C8065B: FF                    db_op_FF   0xFF
  55C8065C: FF                    db_op_FF   0xFF
  55C8065D: FF                    db_op_FF   0xFF
  55C8065E: FF                    db_op_FF   0xFF
  55C8065F: FF                    db_op_FF   0xFF
  55C80660: FF                    db_op_FF   0xFF
  55C80661: FF                    db_op_FF   0xFF
  55C80662: FF                    db_op_FF   0xFF
  55C80663: FF                    db_op_FF   0xFF
  55C80664: FF                    db_op_FF   0xFF
  55C80665: FF                    db_op_FF   0xFF
  55C80666: FF                    db_op_FF   0xFF
  55C80667: FF                    db_op_FF   0xFF
  55C80668: FF                    db_op_FF   0xFF
  55C80669: FF                    db_op_FF   0xFF
  55C8066A: FF                    db_op_FF   0xFF
  55C8066B: FF                    db_op_FF   0xFF
  55C8066C: FF                    db_op_FF   0xFF
  55C8066D: FF                    db_op_FF   0xFF
  55C8066E: FF                    db_op_FF   0xFF
  55C8066F: FF                    db_op_FF   0xFF
  55C80670: FF                    db_op_FF   0xFF
  55C80671: FF                    db_op_FF   0xFF
  55C80672: FF                    db_op_FF   0xFF
  55C80673: FF                    db_op_FF   0xFF
  55C80674: FF                    db_op_FF   0xFF
  55C80675: FF                    db_op_FF   0xFF
  55C80676: FF                    db_op_FF   0xFF
  55C80677: FF                    db_op_FF   0xFF
  55C80678: FF                    db_op_FF   0xFF
  55C80679: FF                    db_op_FF   0xFF
  55C8067A: FF                    db_op_FF   0xFF
  55C8067B: FF                    db_op_FF   0xFF
  55C8067C: FF                    db_op_FF   0xFF
  55C8067D: FF                    db_op_FF   0xFF
  55C8067E: FF                    db_op_FF   0xFF
  55C8067F: FF                    db_op_FF   0xFF
  55C80680: FF                    db_op_FF   0xFF
  55C80681: FF                    db_op_FF   0xFF
  55C80682: FF                    db_op_FF   0xFF
  55C80683: FF                    db_op_FF   0xFF
  55C80684: FF                    db_op_FF   0xFF
  55C80685: FF                    db_op_FF   0xFF
  55C80686: FF                    db_op_FF   0xFF
  55C80687: FF                    db_op_FF   0xFF
  55C80688: FF                    db_op_FF   0xFF
  55C80689: FF                    db_op_FF   0xFF
  55C8068A: FF                    db_op_FF   0xFF
  55C8068B: FF                    db_op_FF   0xFF
  55C8068C: FF                    db_op_FF   0xFF
  55C8068D: FF                    db_op_FF   0xFF
  55C8068E: FF                    db_op_FF   0xFF
  55C8068F: FF                    db_op_FF   0xFF
  55C80690: FF                    db_op_FF   0xFF
  55C80691: FF                    db_op_FF   0xFF
  55C80692: FF                    db_op_FF   0xFF
  55C80693: FF                    db_op_FF   0xFF
  55C80694: FF                    db_op_FF   0xFF
  55C80695: FF                    db_op_FF   0xFF
  55C80696: FF                    db_op_FF   0xFF
  55C80697: FF                    db_op_FF   0xFF
  55C80698: FF                    db_op_FF   0xFF
  55C80699: FF                    db_op_FF   0xFF
  55C8069A: FF                    db_op_FF   0xFF
  55C8069B: FF                    db_op_FF   0xFF
  55C8069C: FF                    db_op_FF   0xFF
  55C8069D: FF                    db_op_FF   0xFF
  55C8069E: FF                    db_op_FF   0xFF
  55C8069F: FF                    db_op_FF   0xFF
  55C806A0: 20 01                 add        1, d0
  55C806A2: 3A                    db_op_3A   0x3A
  55C806A3: 00                    db_op_00   0x00
  55C806A4: 17                    db_op_17   0x17
  55C806A5: 06                    db_op_06   0x06
  55C806A6: 00                    db_op_00   0x00
  55C806A7: 22 18                 add        24, d2
  55C806A9: 00                    db_op_00   0x00
  55C806AA: 88                    mov        d2, d0
  55C806AB: 00                    db_op_00   0x00
  55C806AC: 57                    db_op_57   0x57
  55C806AD: 22 17                 add        23, d2
  55C806AF: 06                    db_op_06   0x06
  55C806B0: 00                    db_op_00   0x00
  55C806B1: 08                    db_op_08   0x08
  55C806B2: 39                    db_op_39   0x39
  55C806B3: 00                    db_op_00   0x00
  55C806B4: FF                    db_op_FF   0xFF
  55C806B5: FF                    db_op_FF   0xFF
  55C806B6: FF                    db_op_FF   0xFF
  55C806B7: FF                    db_op_FF   0xFF
  55C806B8: FF                    db_op_FF   0xFF
  55C806B9: FF                    db_op_FF   0xFF
  55C806BA: FF                    db_op_FF   0xFF
  55C806BB: FF                    db_op_FF   0xFF
  55C806BC: FF                    db_op_FF   0xFF
  55C806BD: FF                    db_op_FF   0xFF
  55C806BE: FF                    db_op_FF   0xFF
  55C806BF: FF                    db_op_FF   0xFF
  55C806C0: FF                    db_op_FF   0xFF
  55C806C1: FF                    db_op_FF   0xFF
  55C806C2: FF                    db_op_FF   0xFF
  55C806C3: FF                    db_op_FF   0xFF
  55C806C4: FF                    db_op_FF   0xFF
  55C806C5: FF                    db_op_FF   0xFF
  55C806C6: FF                    db_op_FF   0xFF
  55C806C7: FF                    db_op_FF   0xFF
  55C806C8: FF                    db_op_FF   0xFF
  55C806C9: FF                    db_op_FF   0xFF
  55C806CA: FF                    db_op_FF   0xFF
  55C806CB: FF                    db_op_FF   0xFF
  55C806CC: FF                    db_op_FF   0xFF
  55C806CD: FF                    db_op_FF   0xFF
  55C806CE: FF                    db_op_FF   0xFF
  55C806CF: FF                    db_op_FF   0xFF
  55C806D0: FF                    db_op_FF   0xFF
  55C806D1: FF                    db_op_FF   0xFF
  55C806D2: FF                    db_op_FF   0xFF
  55C806D3: FF                    db_op_FF   0xFF
  55C806D4: FF                    db_op_FF   0xFF
  55C806D5: FF                    db_op_FF   0xFF
  55C806D6: FF                    db_op_FF   0xFF
  55C806D7: FF                    db_op_FF   0xFF
  55C806D8: FF                    db_op_FF   0xFF
  55C806D9: FF                    db_op_FF   0xFF
  55C806DA: FF                    db_op_FF   0xFF
  55C806DB: FF                    db_op_FF   0xFF
  55C806DC: FF                    db_op_FF   0xFF
  55C806DD: FF                    db_op_FF   0xFF
  55C806DE: FF                    db_op_FF   0xFF
  55C806DF: FF                    db_op_FF   0xFF
  55C806E0: FF                    db_op_FF   0xFF
  55C806E1: FF                    db_op_FF   0xFF
  55C806E2: FF                    db_op_FF   0xFF
  55C806E3: FF                    db_op_FF   0xFF
  55C806E4: FF                    db_op_FF   0xFF
  55C806E5: FF                    db_op_FF   0xFF
  55C806E6: FF                    db_op_FF   0xFF
  55C806E7: FF                    db_op_FF   0xFF
  55C806E8: FF                    db_op_FF   0xFF
  55C806E9: FF                    db_op_FF   0xFF
  55C806EA: FF                    db_op_FF   0xFF
  55C806EB: FF                    db_op_FF   0xFF
  55C806EC: FF                    db_op_FF   0xFF
  55C806ED: FF                    db_op_FF   0xFF
  55C806EE: FF                    db_op_FF   0xFF
  55C806EF: FF                    db_op_FF   0xFF
  55C806F0: FF                    db_op_FF   0xFF
  55C806F1: FF                    db_op_FF   0xFF
  55C806F2: FF                    db_op_FF   0xFF
  55C806F3: FF                    db_op_FF   0xFF
  55C806F4: FF                    db_op_FF   0xFF
  55C806F5: FF                    db_op_FF   0xFF
  55C806F6: FF                    db_op_FF   0xFF
  55C806F7: FF                    db_op_FF   0xFF
  55C806F8: FF                    db_op_FF   0xFF
  55C806F9: FF                    db_op_FF   0xFF
  55C806FA: FF                    db_op_FF   0xFF
  55C806FB: FF                    db_op_FF   0xFF
  55C806FC: FF                    db_op_FF   0xFF
  55C806FD: FF                    db_op_FF   0xFF
  55C806FE: FF                    db_op_FF   0xFF
  55C806FF: FF                    db_op_FF   0xFF
loc_55C80700:
  55C80700: FC CC 00 00 C8 55     mov        0x55C80000, d0                 ; vec_hardware_reset
  55C80706: 01                    db_op_01   0x01
  55C80707: 1C                    db_op_1C   0x1C
  55C80708: 80 2C                 mov        0x2C, d0
  55C8070A: 01                    db_op_01   0x01
  55C8070B: 03                    db_op_03   0x03
  55C8070C: FC 83 42 00 00 9C     mov        d3, (0x9C000042)               ; MMIO VENUS_SYSCLK_PLL_0x042
  55C80712: 80 00                 mov        0x00, d0
  55C80714: FC 83 4A 00 00 9C     mov        d3, (0x9C00004A)               ; MMIO VENUS_SYSCLK_PLL_0x04A
  55C8071A: 2C FF 0F              mov        0x0FFF, d0
  55C8071D: FC 83 4C 00 00 9C     mov        d3, (0x9C00004C)               ; MMIO VENUS_SYSCLK_PLL_0x04C
  55C80723: FC AC 44 00 00 9C     movhu      (0x9C000044), d0               ; MMIO VENUS_SYSCLK_PLL_0x044
  55C80729: FA E0 3F FF           ext_fa_E0  0xFF3F
  55C8072D: F8 E4 80              ext_f8_E4  0x80
  55C80730: FC 83 44 00 00 9C     mov        d3, (0x9C000044)               ; MMIO VENUS_SYSCLK_PLL_0x044
  55C80736: FC CC 3E C3 00 00     mov        0x0000C33E, d0
  55C8073C: FC 83 46 00 00 9C     mov        d3, (0x9C000046)               ; MMIO VENUS_SYSCLK_PLL_0x046
  55C80742: FC AC 4A 00 00 9C     movhu      (0x9C00004A), d0               ; MMIO VENUS_SYSCLK_PLL_0x04A
  55C80748: FA E4 00 91           ext_fa_E4  0x9100
  55C8074C: FC 83 4A 00 00 9C     mov        d3, (0x9C00004A)               ; MMIO VENUS_SYSCLK_PLL_0x04A
  55C80752: 2C 70 01              mov        0x0170, d0
  55C80755: FC 83 48 00 00 9C     mov        d3, (0x9C000048)               ; MMIO VENUS_SYSCLK_PLL_0x048
  55C8075B: FC AC 4E 00 00 9C     movhu      (0x9C00004E), d0               ; MMIO VENUS_SYSCLK_PLL_0x04E
  55C80761: F8 E4 02              ext_f8_E4  0x02
  55C80764: FC 83 4E 00 00 9C     mov        d3, (0x9C00004E)               ; MMIO VENUS_SYSCLK_PLL_0x04E
  55C8076A: FC AC 50 00 00 9C     movhu      (0x9C000050), d0               ; MMIO VENUS_SYSCLK_PLL_0x050
  55C80770: F8 E4 02              ext_f8_E4  0x02
  55C80773: FC 83 50 00 00 9C     mov        d3, (0x9C000050)               ; MMIO VENUS_SYSCLK_PLL_0x050
  55C80779: 80 00                 mov        0x00, d0
  55C8077B: FC 83 CC C0 00 9C     mov        d3, (0x9C00C0CC)               ; MMIO VENUS_INTC_0x0CC
  55C80781: 2C 00 36              mov        0x3600, d0
  55C80784: FC 83 60 C0 00 9C     mov        d3, (0x9C00C060)               ; MMIO VENUS_INTC_0x060
  55C8078A: 2C 5C 1F              mov        0x1F5C, d0
  55C8078D: FC 83 62 C0 00 9C     mov        d3, (0x9C00C062)               ; MMIO VENUS_INTC_0x062
  55C80793: FC CC 01 80 00 00     mov        0x00008001, d0
  55C80799: FC 83 64 C0 00 9C     mov        d3, (0x9C00C064)               ; MMIO VENUS_INTC_0x064
  55C8079F: 2C 48 7F              mov        0x7F48, d0
  55C807A2: FC 83 66 C0 00 9C     mov        d3, (0x9C00C066)               ; MMIO VENUS_INTC_0x066
  55C807A8: FC CC FA FF 00 00     mov        0x0000FFFA, d0
  55C807AE: FC 83 68 C0 00 9C     mov        d3, (0x9C00C068)               ; MMIO VENUS_INTC_0x068
  55C807B4: FC CC 0F 80 00 00     mov        0x0000800F, d0
  55C807BA: FC 83 6A C0 00 9C     mov        d3, (0x9C00C06A)               ; MMIO VENUS_INTC_0x06A
  55C807C0: 80 00                 mov        0x00, d0
  55C807C2: FC 83 6C C0 00 9C     mov        d3, (0x9C00C06C)               ; MMIO VENUS_INTC_0x06C
  55C807C8: 80 00                 mov        0x00, d0
  55C807CA: FC 83 6E C0 00 9C     mov        d3, (0x9C00C06E)               ; MMIO VENUS_INTC_0x06E
  55C807D0: 80 00                 mov        0x00, d0
  55C807D2: FC 83 70 C0 00 9C     mov        d3, (0x9C00C070)               ; MMIO VENUS_INTC_0x070
  55C807D8: 80 10                 mov        0x10, d0
  55C807DA: FC 83 72 C0 00 9C     mov        d3, (0x9C00C072)               ; MMIO VENUS_INTC_0x072
  55C807E0: FC CC 88 88 00 00     mov        0x00008888, d0
  55C807E6: FC 83 00 C0 00 9C     mov        d3, (0x9C00C000)               ; MMIO VENUS_INTC_0x000
  55C807EC: FC CC 80 88 00 00     mov        0x00008880, d0
  55C807F2: FC 83 02 C0 00 9C     mov        d3, (0x9C00C002)               ; MMIO VENUS_INTC_0x002
  55C807F8: FC CC 88 88 00 00     mov        0x00008888, d0
  55C807FE: FC 83 04 C0 00 9C     mov        d3, (0x9C00C004)               ; MMIO VENUS_INTC_0x004
  55C80804: FC CC 00 8A 00 00     mov        0x00008A00, d0
  55C8080A: FC 83 06 C0 00 9C     mov        d3, (0x9C00C006)               ; MMIO VENUS_INTC_0x006
  55C80810: 2C 88 08              mov        0x0888, d0
  55C80813: FC 83 08 C0 00 9C     mov        d3, (0x9C00C008)               ; MMIO VENUS_INTC_0x008
  55C80819: FC CC 88 B3 00 00     mov        0x0000B388, d0
  55C8081F: FC 83 0A C0 00 9C     mov        d3, (0x9C00C00A)               ; MMIO VENUS_INTC_0x00A
  55C80825: 2C 33 33              mov        0x3333, d0
  55C80828: FC 83 0C C0 00 9C     mov        d3, (0x9C00C00C)               ; MMIO VENUS_INTC_0x00C
  55C8082E: FC CC B3 BB 00 00     mov        0x0000BBB3, d0
  55C80834: FC 83 0E C0 00 9C     mov        d3, (0x9C00C00E)               ; MMIO VENUS_INTC_0x00E
  55C8083A: FC CC B8 BB 00 00     mov        0x0000BBB8, d0
  55C80840: FC 83 10 C0 00 9C     mov        d3, (0x9C00C010)               ; MMIO VENUS_INTC_0x010
  55C80846: FC CC BB BB 00 00     mov        0x0000BBBB, d0
  55C8084C: FC 83 12 C0 00 9C     mov        d3, (0x9C00C012)               ; MMIO VENUS_INTC_0x012
  55C80852: 2C 8B 19              mov        0x198B, d0
  55C80855: FC 83 14 C0 00 9C     mov        d3, (0x9C00C014)               ; MMIO VENUS_INTC_0x014
  55C8085B: FC CC 39 8B 00 00     mov        0x00008B39, d0
  55C80861: FC 83 16 C0 00 9C     mov        d3, (0x9C00C016)               ; MMIO VENUS_INTC_0x016
  55C80867: FC CC 00 82 00 00     mov        0x00008200, d0
  55C8086D: FC 83 18 C0 00 9C     mov        d3, (0x9C00C018)               ; MMIO VENUS_INTC_0x018
  55C80873: 2C 38 33              mov        0x3338, d0
  55C80876: FC 83 1A C0 00 9C     mov        d3, (0x9C00C01A)               ; MMIO VENUS_INTC_0x01A
  55C8087C: 80 00                 mov        0x00, d0
  55C8087E: FC 83 1C C0 00 9C     mov        d3, (0x9C00C01C)               ; MMIO VENUS_INTC_0x01C
  55C80884: FC CC 00 B0 00 00     mov        0x0000B000, d0
  55C8088A: FC 83 1E C0 00 9C     mov        d3, (0x9C00C01E)               ; MMIO VENUS_INTC_0x01E
  55C80890: FC CC 3B B8 00 00     mov        0x0000B83B, d0
  55C80896: FC 83 20 C0 00 9C     mov        d3, (0x9C00C020)               ; MMIO VENUS_INTC_0x020
  55C8089C: FC CC 80 88 00 00     mov        0x00008880, d0
  55C808A2: FC 83 22 C0 00 9C     mov        d3, (0x9C00C022)               ; MMIO VENUS_INTC_0x022
  55C808A8: FC CC 88 80 00 00     mov        0x00008088, d0
  55C808AE: FC 83 24 C0 00 9C     mov        d3, (0x9C00C024)               ; MMIO VENUS_INTC_0x024
  55C808B4: FC CC 88 88 00 00     mov        0x00008888, d0
  55C808BA: FC 83 26 C0 00 9C     mov        d3, (0x9C00C026)               ; MMIO VENUS_INTC_0x026
  55C808C0: FC CC 88 88 00 00     mov        0x00008888, d0
  55C808C6: FC 83 28 C0 00 9C     mov        d3, (0x9C00C028)               ; MMIO VENUS_INTC_0x028
  55C808CC: 80 00                 mov        0x00, d0
  55C808CE: FC 83 2A C0 00 9C     mov        d3, (0x9C00C02A)               ; MMIO VENUS_INTC_0x02A
  55C808D4: 80 00                 mov        0x00, d0
  55C808D6: FC 83 2C C0 00 9C     mov        d3, (0x9C00C02C)               ; MMIO VENUS_INTC_0x02C
  55C808DC: 80 00                 mov        0x00, d0
  55C808DE: FC 83 2E C0 00 9C     mov        d3, (0x9C00C02E)               ; MMIO VENUS_INTC_0x02E
  55C808E4: 80 00                 mov        0x00, d0
  55C808E6: FC 83 30 C0 00 9C     mov        d3, (0x9C00C030)               ; MMIO VENUS_INTC_0x030
  55C808EC: FC CC 00 99 00 00     mov        0x00009900, d0
  55C808F2: FC 83 32 C0 00 9C     mov        d3, (0x9C00C032)               ; MMIO VENUS_INTC_0x032
  55C808F8: FC CC 88 88 00 00     mov        0x00008888, d0
  55C808FE: FC 83 34 C0 00 9C     mov        d3, (0x9C00C034)               ; MMIO VENUS_INTC_0x034
  55C80904: FC CC 88 88 00 00     mov        0x00008888, d0
  55C8090A: FC 83 36 C0 00 9C     mov        d3, (0x9C00C036)               ; MMIO VENUS_INTC_0x036
  55C80910: FC CC 88 88 00 00     mov        0x00008888, d0
  55C80916: FC 83 38 C0 00 9C     mov        d3, (0x9C00C038)               ; MMIO VENUS_INTC_0x038
  55C8091C: FC CC 88 88 00 00     mov        0x00008888, d0
  55C80922: FC 83 3A C0 00 9C     mov        d3, (0x9C00C03A)               ; MMIO VENUS_INTC_0x03A
  55C80928: FC CC 88 88 00 00     mov        0x00008888, d0
  55C8092E: FC 83 3C C0 00 9C     mov        d3, (0x9C00C03C)               ; MMIO VENUS_INTC_0x03C
  55C80934: FC CC 88 88 00 00     mov        0x00008888, d0
  55C8093A: FC 83 3E C0 00 9C     mov        d3, (0x9C00C03E)               ; MMIO VENUS_INTC_0x03E
  55C80940: FC CC 88 88 00 00     mov        0x00008888, d0
  55C80946: FC 83 40 C0 00 9C     mov        d3, (0x9C00C040)               ; MMIO VENUS_INTC_0x040
  55C8094C: FC CC CC CC 00 00     mov        0x0000CCCC, d0
  55C80952: FC 83 42 C0 00 9C     mov        d3, (0x9C00C042)               ; MMIO VENUS_INTC_0x042
  55C80958: FC CC CC CC 00 00     mov        0x0000CCCC, d0
  55C8095E: FC 83 44 C0 00 9C     mov        d3, (0x9C00C044)               ; MMIO VENUS_INTC_0x044
  55C80964: FC CC 88 88 00 00     mov        0x00008888, d0
  55C8096A: FC 83 46 C0 00 9C     mov        d3, (0x9C00C046)               ; MMIO VENUS_INTC_0x046
  55C80970: FC CC 88 88 00 00     mov        0x00008888, d0
  55C80976: FC 83 48 C0 00 9C     mov        d3, (0x9C00C048)               ; MMIO VENUS_INTC_0x048
  55C8097C: 80 08                 mov        0x08, d0
  55C8097E: FC 83 4A C0 00 9C     mov        d3, (0x9C00C04A)               ; MMIO VENUS_INTC_0x04A
  55C80984: FC CC 57 ED 00 00     mov        0x0000ED57, d0
  55C8098A: FC 83 A0 C0 00 9C     mov        d3, (0x9C00C0A0)               ; MMIO VENUS_INTC_0x0A0
  55C80990: FC CC FF FF 00 00     mov        0x0000FFFF, d0
  55C80996: FC 83 A4 C0 00 9C     mov        d3, (0x9C00C0A4)               ; MMIO VENUS_INTC_0x0A4
  55C8099C: FC CC 1F FF 00 00     mov        0x0000FF1F, d0
  55C809A2: FC 83 A6 C0 00 9C     mov        d3, (0x9C00C0A6)               ; MMIO VENUS_INTC_0x0A6
  55C809A8: FC CC FD FF 00 00     mov        0x0000FFFD, d0
  55C809AE: FC 83 A8 C0 00 9C     mov        d3, (0x9C00C0A8)               ; MMIO VENUS_INTC_0x0A8
  55C809B4: FC CC 0F E8 00 00     mov        0x0000E80F, d0
  55C809BA: FC 83 AA C0 00 9C     mov        d3, (0x9C00C0AA)               ; MMIO VENUS_INTC_0x0AA
  55C809C0: 2C F0 38              mov        0x38F0, d0
  55C809C3: FC 83 AC C0 00 9C     mov        d3, (0x9C00C0AC)               ; MMIO VENUS_INTC_0x0AC
  55C809C9: 2C C0 0E              mov        0x0EC0, d0
  55C809CC: FC 83 E8 C0 00 9C     mov        d3, (0x9C00C0E8)               ; MMIO VENUS_INTC_0x0E8
  55C809D2: 80 03                 mov        0x03, d0
  55C809D4: FC 83 EA C0 00 9C     mov        d3, (0x9C00C0EA)               ; MMIO VENUS_INTC_0x0EA
  55C809DA: FC CC FF FF 00 00     mov        0x0000FFFF, d0
  55C809E0: FC 83 E0 C0 00 9C     mov        d3, (0x9C00C0E0)               ; MMIO VENUS_INTC_0x0E0
  55C809E6: 2C F7 03              mov        0x03F7, d0
  55C809E9: FC 83 E2 C0 00 9C     mov        d3, (0x9C00C0E2)               ; MMIO VENUS_INTC_0x0E2
  55C809EF: CC 6F F6              jmp        loc_55C8005E
