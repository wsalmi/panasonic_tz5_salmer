; ==============================================================================
; Section: 03 - High .text & Master Interrupt Dispatcher (0x55E97FC0..0x55E9B428)
; ROM Offset: 0x21BFC0 .. 0x21F428
; Virtual Address: 0x55E97FC0 .. 0x55E9B428
; Architecture: Matsushita MN10300 / MN103S (AM33) 32-bit RISC
; ==============================================================================

  55E97FC0: F0 24                 ext_f0_24  
  55E97FC2: F8 FE 04              add        4, sp
  55E97FC5: F0 FC                 rets       

; ------------------------------------------------------------------------------
; FUNCTION: venus_master_irq_dispatcher (VA 0x55E97FC7)
; ------------------------------------------------------------------------------
venus_master_irq_dispatcher:
  55E97FC7: CF 88                 movm       [d2,other], (sp)
  55E97FC9: F8 FE F0              add        -16, sp
  55E97FCC: F6 D0                 ext_f6_D0  
  55E97FCE: F2 E5                 ext_f2_E5  
  55E97FD0: 46                    db_op_46   0x46
  55E97FD1: 04                    db_op_04   0x04
  55E97FD2: 42 08                 mov        a2, (8, sp)
  55E97FD4: F6 C0                 ext_f6_C0  
  55E97FD6: 42 0C                 mov        a2, (12, sp)
  55E97FD8: F6 F0                 ext_f6_F0  
  55E97FDA: 42 10                 mov        a2, (16, sp)
  55E97FDC: 38                    db_op_38   0x38
  55E97FDD: 00                    db_op_00   0x00
  55E97FDE: 8A                    mov        d2, d2
  55E97FDF: FC A4 28 F3 08 54     movbu      (0x5408F328), d0
  55E97FE5: A0                    db_op_A0   0xA0
  55E97FE6: 00                    db_op_00   0x00
  55E97FE7: C8 11                 beq        loc_55E97FF8
  55E97FE9: F2 E4                 ext_f2_E4  
  55E97FEB: F8 C4 08              ext_f8_C4  0x08
  55E97FEE: F8 E0 07              ext_f8_E0  0x07
  55E97FF1: DD 2E 4D E0 FF 00 00  call       sub_55C9CD1F, [], 0
loc_55E97FF8:
  55E97FF8: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E97FFE: A0                    db_op_A0   0xA0
  55E97FFF: 00                    db_op_00   0x00
  55E98000: C9 10                 bne        loc_55E98010
  55E98002: 24 00 10              mov        0x1000, a0
  55E98005: FC D0 60 74 07 54     add        0x54077460, d0
  55E9800B: F8 F4 04              ext_f8_F4  0x04
  55E9800E: F2 F0                 ext_f2_F0  
loc_55E98010:
  55E98010: F2 E5                 ext_f2_E5  
  55E98012: F8 C5 06              ext_f8_C5  0x06
  55E98015: F8 E1 1C              ext_f8_E1  0x1C
  55E98018: FC DC 34 F3 08 54     mov        0x5408F334, a0
  55E9801E: F3 84                 ext_f3_84  
  55E98020: 40 FC                 mov        a0, (252, sp)
  55E98022: 82 08                 mov        0x08, d2
  55E98024: F4 08                 ext_f4_08  
  55E98026: 54                    db_op_54   0x54
  55E98027: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E9802D: F8 E4 01              ext_f8_E4  0x01
  55E98030: FC 82 0C F4 08 54     mov        d2, (0x5408F40C)
  55E98036: F0 F0                 calls      (a0)
  55E98038: FA FC FF F7           ext_fa_FC  0xF7FF
  55E9803C: CB                    nop        
  55E9803D: 2C 00 08              mov        0x0800, d0
  55E98040: F2 F3                 ext_f2_F3  
  55E98042: FC A9 08 F4 08 54     ext_fc_A9  0x5408F408
  55E98048: 29 FF                 cmp        0xFF, d1
  55E9804A: C8 1C                 beq        loc_55E98066
  55E9804C: FC 86 08 F4 08 54     movb       d2, (0x5408F408)
  55E98052: FC A4 28 F3 08 54     movbu      (0x5408F328), d0
  55E98058: A0                    db_op_A0   0xA0
  55E98059: 00                    db_op_00   0x00
  55E9805A: C8 09                 beq        loc_55E98063
  55E9805C: DD C6 4C E0 FF 00 00  call       sub_55C9CD22, [], 0
loc_55E98063:
  55E98063: CC 9D 00              jmp        loc_55E98100
loc_55E98066:
  55E98066: FC A8 0D F4 08 54     ext_fc_A8  0x5408F40D
  55E9806C: A0                    db_op_A0   0xA0
  55E9806D: 00                    db_op_00   0x00
  55E9806E: C9 2E                 bne        loc_55E9809C
  55E98070: FC A8 69 F3 08 54     ext_fc_A8  0x5408F369
  55E98076: 28 FF                 cmp        0xFF, d0
  55E98078: C6 24                 bcc        loc_55E9809C
  55E9807A: FC 82 69 F3 08 54     mov        d2, (0x5408F369)
  55E98080: FA FC FF F7           ext_fa_FC  0xF7FF
  55E98084: 5C 04                 mov        (4, sp), a0
  55E98086: F8 60 34              ext_f8_60  0x34
  55E98089: F2 F3                 ext_f2_F3  
  55E9808B: CD BA 25 F0 1C        call       sub_55E9A645, [d2,d3,a2,a3], 28
  55E98090: FA FC FF F7           ext_fa_FC  0xF7FF
  55E98094: CB                    nop        
  55E98095: 2C 00 08              mov        0x0800, d0
  55E98098: F2 F3                 ext_f2_F3  
  55E9809A: CA CC                 bra        loc_55E98066
loc_55E9809C:
  55E9809C: FC A4 28 F3 08 54     movbu      (0x5408F328), d0
  55E980A2: A0                    db_op_A0   0xA0
  55E980A3: 00                    db_op_00   0x00
  55E980A4: C8 15                 beq        loc_55E980B9
  55E980A6: DD 7C 4C E0 FF 00 00  call       sub_55C9CD22, [], 0
  55E980AD: FC CC 00 00 00 20     mov        0x20000000, d0
  55E980B3: FC 81 2C F3 08 54     mov        d1, (0x5408F32C)
loc_55E980B9:
  55E980B9: 00                    db_op_00   0x00
  55E980BA: FC 82 08 F4 08 54     mov        d2, (0x5408F408)
  55E980C0: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E980C6: FC E0 FE FF FF FF     ext_fc_E0  0xFFFFFFFE
  55E980CC: FC 82 0C F4 08 54     mov        d2, (0x5408F40C)
  55E980D2: 2C 00 0F              mov        0x0F00, d0
  55E980D5: FC 81 FC F3 08 54     mov        d1, (0x5408F3FC)
  55E980DB: 5C 04                 mov        (4, sp), a0
  55E980DD: F2 F0                 ext_f2_F0  
  55E980DF: CD 14 1F A0 0C        call       sub_55E99FF3, [d2,a2], 12
  55E980E4: 00                    db_op_00   0x00
  55E980E5: FC 81 2C F3 08 54     mov        d1, (0x5408F32C)
  55E980EB: CD 74 0C 00 00        call       sub_55E98D5F, [], 0
  55E980F0: A0                    db_op_A0   0xA0
  55E980F1: 00                    db_op_00   0x00
  55E980F2: C8 0E                 beq        loc_55E98100
  55E980F4: F8 BD 34              ext_f8_BD  0x34
  55E980F7: F2 F7                 ext_f2_F7  
  55E980F9: CB                    nop        
  55E980FA: CB                    nop        
  55E980FB: CD 80 0C F0 24        call       sub_55E98D7B, [d2,d3,a2,a3], 36
loc_55E98100:
  55E98100: 58 04                 mov        (4, sp), d0
  55E98102: F8 E0 08              ext_f8_E0  0x08
  55E98105: CB                    nop        
  55E98106: F2 E5                 ext_f2_E5  
  55E98108: F2 11                 ext_f2_11  
  55E9810A: F2 F7                 ext_f2_F7  
  55E9810C: 59 08                 mov        (8, sp), d1
  55E9810E: 58 0C                 mov        (12, sp), d0
  55E98110: F5 11                 ext_f5_11  
  55E98112: 58 10                 mov        (16, sp), d0
  55E98114: F5 00                 ext_f5_00  
  55E98116: F8 FE 10              add        16, sp
  55E98119: CE 88                 movm       (sp), [d2,other]
  55E9811B: F0 FD                 rti        
  55E9811D: 00                    db_op_00   0x00

; --- Function sub_55E9811E (callers: 1) ---
sub_55E9811E:
  55E9811E: 00                    db_op_00   0x00
  55E9811F: 85                    mov        d1, d1
  55E98120: 3F A1                 mov        d3, (161, sp)
  55E98122: C7 13                 bls        loc_55E98135
  55E98124: FC DC 70 72 07 54     mov        0x54077270, a0
  55E9812A: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9812B: F0 10                 ext_f0_10  
  55E9812D: F8 30 04              ext_f8_30  0x04
  55E98130: 40 20                 mov        a0, (32, sp)
  55E98132: 08                    db_op_08   0x08
  55E98133: A4                    db_op_A4   0xA4
  55E98134: D4                    lbcs       
loc_55E98135:
  55E98135: 04                    db_op_04   0x04
  55E98136: 80 00                 mov        0x00, d0
  55E98138: A4                    db_op_A4   0xA4
  55E98139: C7 0F                 bls        loc_55E98148
  55E9813B: FC DC 34 F3 08 54     mov        0x5408F334, a0
  55E98141: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E98142: 08                    db_op_08   0x08
  55E98143: 68                    mov        (a0), d2
  55E98144: 44                    db_op_44   0x44
  55E98145: 50                    db_op_50   0x50
  55E98146: A1                    db_op_A1   0xA1
  55E98147: D4                    lbcs       
loc_55E98148:
  55E98148: A0                    db_op_A0   0xA0
  55E98149: 07                    db_op_07   0x07
  55E9814A: C6 19                 bcc        loc_55E98163
  55E9814C: 81 55                 mov        0x55, d1
  55E9814E: F1 E4                 ext_f1_E4  
  55E98150: FC D0 34 F3 08 54     add        0x5408F334, d0
  55E98156: FC CD 7B 7F E9 55     mov        0x55E97F7B, d1
  55E9815C: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9815D: 64                    mov        (a0), d1
  55E9815E: 40 50                 mov        a0, (80, sp)
  55E98160: A0                    db_op_A0   0xA0
  55E98161: 07                    db_op_07   0x07
  55E98162: D4                    lbcs       
loc_55E98163:
  55E98163: DE 80 04              retf       [d2], 4

; --- Function sub_55E98166 (callers: 1) ---
sub_55E98166:
  55E98166: B0                    db_op_B0   0xB0
  55E98167: 00                    db_op_00   0x00
  55E98168: C9 31                 bne        loc_55E98199
  55E9816A: 18                    db_op_18   0x18
  55E9816B: A0                    db_op_A0   0xA0
  55E9816C: 00                    db_op_00   0x00
  55E9816D: C0 13                 blt        loc_55E98180
  55E9816F: 54                    db_op_54   0x54
  55E98170: FC CD 7B 7F E9 55     mov        0x55E97F7B, d1
  55E98176: FC DC 34 F3 08 54     mov        0x5408F334, a0
  55E9817C: F3 50                 ext_f3_50  
  55E9817E: CA 4E                 bra        loc_55E981CC
loc_55E98180:
  55E98180: A0                    db_op_A0   0xA0
  55E98181: FF                    db_op_FF   0xFF
  55E98182: C0 46                 blt        loc_55E981C8
  55E98184: A0                    db_op_A0   0xA0
  55E98185: FF                    db_op_FF   0xFF
  55E98186: C1 42                 bgt        loc_55E981C8
  55E98188: F2 30                 ext_f2_30  
  55E9818A: 40 54                 mov        a0, (84, sp)
  55E9818C: F1 E1                 ext_f1_E1  
  55E9818E: FC D1 50 F3 08 54     add        0x5408F350, d1
  55E98194: F8 31 FC              ext_f8_31  0xFC
  55E98197: CA 35                 bra        loc_55E981CC
loc_55E98199:
  55E98199: 18                    db_op_18   0x18
  55E9819A: A0                    db_op_A0   0xA0
  55E9819B: 00                    db_op_00   0x00
  55E9819C: C0 10                 blt        loc_55E981AC
  55E9819E: F8 20 04              ext_f8_20  0x04
  55E981A1: 54                    db_op_54   0x54
  55E981A2: FC DD 34 F3 08 54     mov        0x5408F334, a1
  55E981A8: F3 C1                 ext_f3_C1  
  55E981AA: CA 22                 bra        loc_55E981CC
loc_55E981AC:
  55E981AC: A0                    db_op_A0   0xA0
  55E981AD: FF                    db_op_FF   0xFF
  55E981AE: C0 1A                 blt        loc_55E981C8
  55E981B0: A0                    db_op_A0   0xA0
  55E981B1: FF                    db_op_FF   0xFF
  55E981B2: C1 16                 bgt        loc_55E981C8
  55E981B4: F8 24 04              ext_f8_24  0x04
  55E981B7: F2 30                 ext_f2_30  
  55E981B9: 40 54                 mov        a0, (84, sp)
  55E981BB: F1 E0                 ext_f1_E0  
  55E981BD: FC D0 50 F3 08 54     add        0x5408F350, d0
  55E981C3: F8 34 FC              ext_f8_34  0xFC
  55E981C6: CA 06                 bra        loc_55E981CC
loc_55E981C8:
  55E981C8: 80 EF                 mov        0xEF, d0
  55E981CA: CA 03                 bra        loc_55E981CD
loc_55E981CC:
  55E981CC: 00                    db_op_00   0x00
loc_55E981CD:
  55E981CD: DE 00 00              retf       [], 0

; --- Function sub_55E981D0 (callers: 1) ---
sub_55E981D0:
  55E981D0: 8F                    mov        d3, d3
  55E981D1: 0C                    db_op_0C   0x0C
  55E981D2: F1 53                 ext_f1_53  
  55E981D4: 9F                    mov        a3, a3
  55E981D5: 08                    db_op_08   0x08
  55E981D6: F1 6F                 ext_f1_6F  
  55E981D8: F0 63                 ext_f0_63  
  55E981DA: FC DD 70 72 07 54     mov        0x54077270, a1
  55E981E0: F8 C8 02              ext_f8_C8  0x02
  55E981E3: F8 C0 03              ext_f8_C0  0x03
  55E981E6: F1 54                 ext_f1_54  
  55E981E8: 28 F8                 cmp        0xF8, d0
  55E981EA: 60                    mov        (a0), d0
  55E981EB: F0 63                 ext_f0_63  
  55E981ED: F8 C8 02              ext_f8_C8  0x02
  55E981F0: F8 C0 03              ext_f8_C0  0x03
  55E981F3: F1 E2                 ext_f1_E2  
  55E981F5: F1 76                 ext_f1_76  
  55E981F7: F8 2A FC              ext_f8_2A  0xFC
  55E981FA: F8 38 04              ext_f8_38  0x04
  55E981FD: F0 12                 ext_f0_12  
  55E981FF: F0 63                 ext_f0_63  
  55E98201: F8 C8 02              ext_f8_C8  0x02
  55E98204: F8 C0 03              ext_f8_C0  0x03
  55E98207: F1 61                 ext_f1_61  
  55E98209: F8 31 FC              ext_f8_31  0xFC
  55E9820C: F0 63                 ext_f0_63  
  55E9820E: FA E0 FC FF           ext_fa_E0  0xFFFC
  55E98212: FC C0 00 89 00 00     ext_fc_C0  0x00008900
  55E98218: F1 E2                 ext_f1_E2  
  55E9821A: 3C F1                 mov        d0, (241, sp)
  55E9821C: D2                    lbge       
  55E9821D: 2A 04                 cmp        0x04, d2
  55E9821F: F1 E8                 ext_f1_E8  
  55E98221: CD F0 FC 00 00        call       sub_55E97F11, [], 0
  55E98226: F0 66                 ext_f0_66  
  55E98228: F1 EC                 ext_f1_EC  
  55E9822A: F8 40 10              ext_f8_40  0x10
  55E9822D: FA E1 FF 0F           ext_fa_E1  0x0FFF
  55E98231: F8 C0 0C              ext_f8_C0  0x0C
  55E98234: F2 11                 ext_f2_11  
  55E98236: F0 76                 ext_f0_76  
  55E98238: F0 62                 ext_f0_62  
  55E9823A: F8 93 06              movbu      d0, (6, a3)
  55E9823D: F1 E8                 ext_f1_E8  
  55E9823F: CD E7 FC 00 00        call       sub_55E97F26, [], 0
  55E98244: 00                    db_op_00   0x00
  55E98245: DF F0 18              ret        [d2,d3,a2,a3], 24
  55E98248: 1C                    db_op_1C   0x1C
  55E98249: 42 08                 mov        a2, (8, sp)
  55E9824B: F1 E4                 ext_f1_E4  
  55E9824D: 81 F8                 mov        0xF8, d1
  55E9824F: C8 02                 beq        loc_55E98251
loc_55E98251:
  55E98251: F8 C0 03              ext_f8_C0  0x03
  55E98254: FC C0 70 72 07 54     ext_fc_C0  0x54077270
  55E9825A: 28 F8                 cmp        0xF8, d0
  55E9825C: 42 04                 mov        a2, (4, sp)
  55E9825E: F1 E3                 ext_f1_E3  
  55E98260: 73                    mov        d0, (a3)
  55E98261: FA E1 FC FF           ext_fa_E1  0xFFFC
  55E98265: FC CE 00 89 00 00     mov        0x00008900, d2
  55E9826B: E6                    add        d1, d2
  55E9826C: F1 9C                 ext_f1_9C  
  55E9826E: C8 50                 beq        loc_55E982BE
  55E98270: 3D F1                 mov        d1, (241, sp)
  55E98272: D7                    lbls       
  55E98273: 2B 10                 cmp        0x10, d3
  55E98275: F1 D0                 ext_f1_D0  
  55E98277: 1C                    db_op_1C   0x1C
  55E98278: 42 0C                 mov        a2, (12, sp)
loc_55E9827A:
  55E9827A: F0 0F                 ext_f0_0F  
  55E9827C: 59 08                 mov        (8, sp), d1
  55E9827E: 9A                    mov        a2, a2
  55E9827F: 0C                    db_op_0C   0x0C
  55E98280: F1 7E                 ext_f1_7E  
  55E98282: F8 62 08              ext_f8_62  0x08
  55E98285: A4                    db_op_A4   0xA4
  55E98286: C9 32                 bne        loc_55E982B8
  55E98288: F8 22 0C              ext_f8_22  0x0C
  55E9828B: F8 02 04              ext_f8_02  0x04
  55E9828E: F0 F0                 calls      (a0)
  55E98290: F0 42                 ext_f0_42  
  55E98292: F8 EC 02              ext_f8_EC  0x02
  55E98295: C8 23                 beq        loc_55E982B8
  55E98297: F1 EC                 ext_f1_EC  
  55E98299: CD 78 FC 00 00        call       sub_55E97F11, [], 0
  55E9829E: F1 E8                 ext_f1_E8  
  55E982A0: F0 60                 ext_f0_60  
  55E982A2: FA E0 00 FF           ext_fa_E0  0xFF00
  55E982A6: 59 0C                 mov        (12, sp), d1
  55E982A8: F2 14                 ext_f2_14  
  55E982AA: F0 70                 ext_f0_70  
  55E982AC: F0 60                 ext_f0_60  
  55E982AE: F8 93 12              movbu      d0, (18, a3)
  55E982B1: F1 EC                 ext_f1_EC  
  55E982B3: CD 73 FC 00 00        call       sub_55E97F26, [], 0
loc_55E982B8:
  55E982B8: 73                    mov        d0, (a3)
  55E982B9: 59 04                 mov        (4, sp), d1
  55E982BB: A4                    db_op_A4   0xA4
  55E982BC: C9 BE                 bne        loc_55E9827A
loc_55E982BE:
  55E982BE: DF F0 24              ret        [d2,d3,a2,a3], 36
  55E982C1: FC DC 70 72 07 54     mov        0x54077270, a0
  55E982C7: FC DD 50 F4 08 54     mov        0x5408F450, a1
  55E982CD: B1                    db_op_B1   0xB1
  55E982CE: C8 09                 beq        loc_55E982D7
  55E982D0: 00                    db_op_00   0x00
  55E982D1: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E982D2: 60                    mov        (a0), d0
  55E982D3: 50                    db_op_50   0x50
  55E982D4: B4                    db_op_B4   0xB4
  55E982D5: CB                    nop        
  55E982D6: D4                    lbcs       
loc_55E982D7:
  55E982D7: FC DC F0 B3 E9 55     mov        0x55E9B3F0, a0
  55E982DD: FC CD 28 B4 E9 55     mov        0x55E9B428, d1
  55E982E3: F1 91                 ext_f1_91  
  55E982E5: C8 10                 beq        loc_55E982F5
  55E982E7: FC DD 38 72 07 54     mov        0x54077238, a1
  55E982ED: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E982EE: 70                    mov        d0, (a0)
  55E982EF: 61                    mov        (a1), d0
  55E982F0: 50                    db_op_50   0x50
  55E982F1: 51                    db_op_51   0x51
  55E982F2: F1 A4                 ext_f1_A4  
  55E982F4: D4                    lbcs       
loc_55E982F5:
  55E982F5: 24 00 04              mov        0x0400, a0
  55E982F8: FC D0 64 84 07 54     add        0x54078464, d0
  55E982FE: F2 F0                 ext_f2_F0  
  55E98300: CA 02                 bra        loc_55E98302
loc_55E98302:
  55E98302: F8 FE FC              add        -4, sp
  55E98305: CD 53 07 00 00        call       sub_55E98A58, [], 0
  55E9830A: CD AC 22 00 00        call       sub_55E9A5B6, [], 0
  55E9830F: CD F8 17 C0 0C        call       sub_55E99B07, [d2,d3], 12
  55E98314: CD 04 F9 00 04        call       sub_55E97C18, [], 4
  55E98319: CD BB 06 00 04        call       sub_55E989D4, [], 4
  55E9831E: CD F1 01 00 04        call       sub_55E9850F, [], 4
  55E98323: CD E2 01 00 00        call       sub_55E98505, [], 0
  55E98328: CD 13 07 20 08        call       sub_55E98A3B, [a2], 8
  55E9832D: CD F3 00 00 00        call       sub_55E98420, [], 0
  55E98332: CD DE 00 00 00        call       sub_55E98410, [], 0
  55E98337: CD 9A 00 C0 0C        call       sub_55E983D1, [d2,d3], 12
  55E9833C: CD 12 01 20 08        call       sub_55E9844E, [a2], 8
  55E98341: CD 1A 00 00 0C        call       sub_55E9835B, [], 12
  55E98346: 80 00                 mov        0x00, d0
  55E98348: A0                    db_op_A0   0xA0
  55E98349: 01                    db_op_01   0x01
  55E9834A: C9 09                 bne        loc_55E98353
  55E9834C: CD F0 24 00 04        call       sub_55E9A83C, [], 4
  55E98351: CA 07                 bra        loc_55E98358
loc_55E98353:
  55E98353: CD E4 24 00 00        call       sub_55E9A837, [], 0
loc_55E98358:
  55E98358: DF 00 04              ret        [], 4

; --- Function sub_55E9835B (callers: 1) ---
sub_55E9835B:
  55E9835B: 3C 50                 mov        d0, (80, sp)
  55E9835D: CD 95 FB 00 00        call       sub_55E97EF2, [], 0
  55E98362: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E98368: 40 FC                 mov        a0, (252, sp)
  55E9836A: 82 08                 mov        0x08, d2
  55E9836C: F4 08                 ext_f4_08  
  55E9836E: 54                    db_op_54   0x54
  55E9836F: FE 00 0C F4 08 54 01  ext_fe_00  0x5408F40C, 0x01
  55E98376: 58 04                 mov        (4, sp), d0
  55E98378: CD 8E FB 00 00        call       sub_55E97F06, [], 0
  55E9837D: 2C 00 0F              mov        0x0F00, d0
  55E98380: CD 86 FB 00 00        call       sub_55E97F06, [], 0
  55E98385: CD D6 06 00 00        call       sub_55E98A5B, [], 0
  55E9838A: CD 7D 22 A0 0C        call       sub_55E9A607, [d2,a2], 12
  55E9838F: CD 0E FB 00 00        call       sub_55E97E9D, [], 0
  55E98394: 3C 20                 mov        d0, (32, sp)
  55E98396: 08                    db_op_08   0x08
  55E98397: CD 5B FB 00 00        call       sub_55E97EF2, [], 0
  55E9839C: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E983A2: 85                    mov        d1, d1
  55E983A3: 01                    db_op_01   0x01
  55E983A4: 28 FF                 cmp        0xFF, d0
  55E983A6: FC 82 08 F4 08 54     mov        d2, (0x5408F408)
  55E983AC: 14                    db_op_14   0x14
  55E983AD: A0                    db_op_A0   0xA0
  55E983AE: 00                    db_op_00   0x00
  55E983AF: C9 03                 bne        loc_55E983B2
  55E983B1: 04                    db_op_04   0x04
loc_55E983B2:
  55E983B2: A5                    db_op_A5   0xA5
  55E983B3: 00                    db_op_00   0x00
  55E983B4: C9 09                 bne        loc_55E983BD
  55E983B6: FE 01 0C F4 08 54 01  ext_fe_01  0x5408F40C, 0x01
loc_55E983BD:
  55E983BD: 58 08                 mov        (8, sp), d0
  55E983BF: CD 47 FB 00 00        call       sub_55E97F06, [], 0
  55E983C4: CD 2F 1C A0 0C        call       sub_55E99FF3, [d2,a2], 12
  55E983C9: CD ED FA 00 00        call       sub_55E97EB6, [], 0
  55E983CE: DF 00 0C              ret        [], 12

; --- Function sub_55E983D1 (callers: 1) ---
sub_55E983D1:
  55E983D1: FC AC A6 B3 E9 55     movhu      (0x55E9B3A6), d0
  55E983D7: 0C                    db_op_0C   0x0C
  55E983D8: 18                    db_op_18   0x18
  55E983D9: AC                    db_op_AC   0xAC
  55E983DA: C3 33                 ble        loc_55E9840D
  55E983DC: 8E                    mov        d3, d2
loc_55E983DD:
  55E983DD: FC A4 18 F4 08 54     movbu      (0x5408F418), d0
  55E983E3: E8                    add        d2, d0
  55E983E4: F1 E0                 ext_f1_E0  
  55E983E6: F8 60 10              ext_f8_60  0x10
  55E983E9: A0                    db_op_A0   0xA0
  55E983EA: 00                    db_op_00   0x00
  55E983EB: C8 15                 beq        loc_55E98400
  55E983ED: 95                    mov        a1, a1
  55E983EE: 44                    db_op_44   0x44
  55E983EF: F1 71                 ext_f1_71  
  55E983F1: F0 41                 ext_f0_41  
  55E983F3: F8 EC 02              ext_f8_EC  0x02
  55E983F6: C8 0A                 beq        loc_55E98400
  55E983F8: F8 01 04              ext_f8_01  0x04
  55E983FB: CD A4 F8 A0 0C        call       sub_55E97C9F, [d2,a2], 12
loc_55E98400:
  55E98400: FC AC A6 B3 E9 55     movhu      (0x55E9B3A6), d0
  55E98406: 4C                    db_op_4C   0x4C
  55E98407: 2A 70                 cmp        0x70, d2
  55E98409: 18                    db_op_18   0x18
  55E9840A: A3                    db_op_A3   0xA3
  55E9840B: C0 D2                 blt        loc_55E983DD
loc_55E9840D:
  55E9840D: DF C0 0C              ret        [d2,d3], 12

; --- Function sub_55E98410 (callers: 1) ---
sub_55E98410:
  55E98410: 00                    db_op_00   0x00
  55E98411: FC 83 14 F4 08 54     mov        d3, (0x5408F414)
  55E98417: FC 81 10 F4 08 54     mov        d1, (0x5408F410)
  55E9841D: DE 00 00              retf       [], 0

; --- Function sub_55E98420 (callers: 1) ---
sub_55E98420:
  55E98420: 00                    db_op_00   0x00
  55E98421: FC 82 08 F4 08 54     mov        d2, (0x5408F408)
  55E98427: FC 82 09 F4 08 54     mov        d2, (0x5408F409)
  55E9842D: FC 82 0A F4 08 54     mov        d2, (0x5408F40A)
  55E98433: FC 82 0B F4 08 54     mov        d2, (0x5408F40B)
  55E98439: FC 82 0C F4 08 54     mov        d2, (0x5408F40C)
  55E9843F: FC 82 0D F4 08 54     mov        d2, (0x5408F40D)
  55E98445: FC 82 0E F4 08 54     mov        d2, (0x5408F40E)
  55E9844B: DE 00 00              retf       [], 0

; --- Function sub_55E9844E (callers: 1) ---
sub_55E9844E:
  55E9844E: FC AC DC B3 E9 55     movhu      (0x55E9B3DC), d0
  55E98454: FC DE 6C F3 08 54     mov        0x5408F36C, a2
  55E9845A: 40 FC                 mov        a0, (252, sp)
  55E9845C: 83 74                 mov        0x74, d3
  55E9845E: F3 08                 ext_f3_08  
  55E98460: 54                    db_op_54   0x54
  55E98461: FC 83 76 F3 08 54     mov        d3, (0x5408F376)
  55E98467: FC 83 BC F3 08 54     mov        d3, (0x5408F3BC)
  55E9846D: 00                    db_op_00   0x00
  55E9846E: FC 83 7C F3 08 54     mov        d3, (0x5408F37C)
  55E98474: 85                    mov        d1, d1
  55E98475: 01                    db_op_01   0x01
  55E98476: FC 87 78 F3 08 54     movb       d3, (0x5408F378)
  55E9847C: 00                    db_op_00   0x00
  55E9847D: FC 83 7A F3 08 54     mov        d3, (0x5408F37A)
  55E98483: FC 82 80 F3 08 54     mov        d2, (0x5408F380)
  55E98489: FC 82 81 F3 08 54     mov        d2, (0x5408F381)
  55E9848F: FC 82 82 F3 08 54     mov        d2, (0x5408F382)
  55E98495: 80 02                 mov        0x02, d0
  55E98497: FC 82 B0 F3 08 54     mov        d2, (0x5408F3B0)
  55E9849D: FC CC 68 84 07 54     mov        0x54078468, d0
  55E984A3: FC 81 C4 F3 08 54     mov        d1, (0x5408F3C4)
  55E984A9: 2C 00 04              mov        0x0400, d0
  55E984AC: FC 81 C0 F3 08 54     mov        d1, (0x5408F3C0)
  55E984B2: 80 00                 mov        0x00, d0
  55E984B4: A4                    db_op_A4   0xA4
  55E984B5: C9 0A                 bne        loc_55E984BF
  55E984B7: FC CC 39 A8 E9 55     mov        0x55E9A839, d0
  55E984BD: CA 08                 bra        loc_55E984C5
loc_55E984BF:
  55E984BF: FC CC 37 A8 E9 55     mov        0x55E9A837, d0
loc_55E984C5:
  55E984C5: FC 81 B8 F3 08 54     mov        d1, (0x5408F3B8)
  55E984CB: FC 87 9C F3 08 54     movb       d3, (0x5408F39C)
  55E984D1: 00                    db_op_00   0x00
  55E984D2: FC 81 A0 F3 08 54     mov        d1, (0x5408F3A0)
  55E984D8: FC 81 A4 F3 08 54     mov        d1, (0x5408F3A4)
  55E984DE: FC 81 B4 F3 08 54     mov        d1, (0x5408F3B4)
  55E984E4: FC 81 90 F3 08 54     mov        d1, (0x5408F390)
  55E984EA: FC 81 A8 F3 08 54     mov        d1, (0x5408F3A8)
  55E984F0: FC 81 AC F3 08 54     mov        d1, (0x5408F3AC)
  55E984F6: 98                    mov        a2, a0
  55E984F7: CD 3B 08 20 04        call       sub_55E98D32, [a2], 4
  55E984FC: FC 88 F8 F3 08 54     movhu      d0, (0x5408F3F8)
  55E98502: DF 20 08              ret        [a2], 8

; --- Function sub_55E98505 (callers: 1) ---
sub_55E98505:
  55E98505: 00                    db_op_00   0x00
  55E98506: FC 82 69 F3 08 54     mov        d2, (0x5408F369)
  55E9850C: DE 00 00              retf       [], 0

; --- Function sub_55E9850F (callers: 1) ---
sub_55E9850F:
  55E9850F: CD 58 00 B0 10        call       sub_55E98567, [d2,a2,a3], 16
  55E98514: CD 9E 00 A0 08        call       sub_55E985B2, [d2,a2], 8
  55E98519: CD D5 00 B0 10        call       sub_55E985EE, [d2,a2,a3], 16
  55E9851E: CD 1A 01 B0 10        call       sub_55E98638, [d2,a2,a3], 16
  55E98523: CD 5E 01 B0 10        call       sub_55E98681, [d2,a2,a3], 16
  55E98528: CD A3 01 B0 10        call       sub_55E986CB, [d2,a2,a3], 16
  55E9852D: CD E7 01 A0 0C        call       sub_55E98714, [d2,a2], 12
  55E98532: CD 64 02 B0 10        call       sub_55E98796, [d2,a2,a3], 16
  55E98537: CD A9 02 B0 10        call       sub_55E987E0, [d2,a2,a3], 16
  55E9853C: CD EE 02 B0 10        call       sub_55E9882A, [d2,a2,a3], 16
  55E98541: CD 33 03 B0 10        call       sub_55E98874, [d2,a2,a3], 16
  55E98546: CD 78 03 B0 10        call       sub_55E988BE, [d2,a2,a3], 16
  55E9854B: CD BE 03 B0 10        call       sub_55E98909, [d2,a2,a3], 16
  55E98550: CD 04 04 00 00        call       sub_55E98954, [], 0
  55E98555: CD 19 04 20 08        call       sub_55E9896E, [a2], 8
  55E9855A: CD 3D 04 30 0C        call       sub_55E98997, [a2,a3], 12
  55E9855F: CD F7 01 20 08        call       sub_55E98756, [a2], 8
  55E98564: DF 00 04              ret        [], 4

; --- Function sub_55E98567 (callers: 1) ---
sub_55E98567:
  55E98567: FC DF 40 AD E9 55     mov        0x55E9AD40, a3
loc_55E9856D:
  55E9856D: F0 63                 ext_f0_63  
  55E9856F: A0                    db_op_A0   0xA0
  55E98570: 00                    db_op_00   0x00
  55E98571: C8 3E                 beq        loc_55E985AF
  55E98573: FC A5 18 F4 08 54     movbu      (0x5408F418), d1
  55E98579: 18                    db_op_18   0x18
  55E9857A: 9E                    mov        a3, a2
  55E9857B: 52                    db_op_52   0x52
  55E9857C: 8A                    mov        d2, d2
  55E9857D: 70                    mov        d0, (a0)
  55E9857E: F2 48                 ext_f2_48  
  55E98580: E1                    add        d0, d1
  55E98581: F0 63                 ext_f0_63  
  55E98583: FC DC 90 FF FF FF     mov        0xFFFFFF90, a0
  55E98589: F1 64                 ext_f1_64  
  55E9858B: F8 70 10              ext_f8_70  0x10
  55E9858E: 95                    mov        a1, a1
  55E9858F: 44                    db_op_44   0x44
  55E98590: F1 71                 ext_f1_71  
  55E98592: 85                    mov        d1, d1
  55E98593: FA DB 72 52           ext_fa_DB  0x5272
  55E98597: 61                    mov        (a1), d0
  55E98598: 51                    db_op_51   0x51
  55E98599: 44                    db_op_44   0x44
  55E9859A: D9                    lbne       
  55E9859B: CD 76 ED B0 10        call       sub_55E97311, [d2,a2,a3], 16
  55E985A0: A0                    db_op_A0   0xA0
  55E985A1: DF C9 09              ret        [d2,d3,other,exother], 9
  55E985A4: 80 82                 mov        0x82, d0
  55E985A6: CD B5 F8 00 00        call       sub_55E97E5B, [], 0
  55E985AB: 23 1C                 add        28, d3
  55E985AD: CA C0                 bra        loc_55E9856D
loc_55E985AF:
  55E985AF: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E985B2 (callers: 1) ---
sub_55E985B2:
  55E985B2: FC DD C4 AF E9 55     mov        0x55E9AFC4, a1
  55E985B8: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E985B9: F0 61                 ext_f0_61  
  55E985BB: A0                    db_op_A0   0xA0
  55E985BC: 00                    db_op_00   0x00
  55E985BD: C8 2E                 beq        loc_55E985EB
  55E985BF: 18                    db_op_18   0x18
  55E985C0: FC A6 18 F4 08 54     movbu      (0x5408F418), d2
  55E985C6: 85                    mov        d1, d1
  55E985C7: 70                    mov        d0, (a0)
  55E985C8: F2 41                 ext_f2_41  
  55E985CA: F1 E4                 ext_f1_E4  
  55E985CC: F1 68                 ext_f1_68  
  55E985CE: F8 64 A0              ext_f8_64  0xA0
  55E985D1: 00                    db_op_00   0x00
  55E985D2: A1                    db_op_A1   0xA1
  55E985D3: C8 0D                 beq        loc_55E985E0
  55E985D5: F0 61                 ext_f0_61  
  55E985D7: 85                    mov        d1, d1
  55E985D8: 70                    mov        d0, (a0)
  55E985D9: 18                    db_op_18   0x18
  55E985DA: F2 44                 ext_f2_44  
  55E985DC: E2                    add        d0, d2
  55E985DD: 80 90                 mov        0x90, d0
  55E985DF: E8                    add        d2, d0
loc_55E985E0:
  55E985E0: F8 21 08              ext_f8_21  0x08
  55E985E3: F1 E2                 ext_f1_E2  
  55E985E5: F8 32 34              ext_f8_32  0x34
  55E985E8: 21 0C                 add        12, d1
  55E985EA: DA                    lbra       
loc_55E985EB:
  55E985EB: DF A0 08              ret        [d2,a2], 8

; --- Function sub_55E985EE (callers: 1) ---
sub_55E985EE:
  55E985EE: FC DF D0 AF E9 55     mov        0x55E9AFD0, a3
loc_55E985F4:
  55E985F4: F0 63                 ext_f0_63  
  55E985F6: A0                    db_op_A0   0xA0
  55E985F7: 00                    db_op_00   0x00
  55E985F8: C8 3D                 beq        loc_55E98635
  55E985FA: FC A5 1C F4 08 54     movbu      (0x5408F41C), d1
  55E98600: 18                    db_op_18   0x18
  55E98601: 9E                    mov        a3, a2
  55E98602: 52                    db_op_52   0x52
  55E98603: 8A                    mov        d2, d2
  55E98604: 1C                    db_op_1C   0x1C
  55E98605: F2 48                 ext_f2_48  
  55E98607: E1                    add        d0, d1
  55E98608: F0 63                 ext_f0_63  
  55E9860A: FC DC E4 FF FF FF     mov        0xFFFFFFE4, a0
  55E98610: F1 64                 ext_f1_64  
  55E98612: F0 70                 ext_f0_70  
  55E98614: 95                    mov        a1, a1
  55E98615: 0C                    db_op_0C   0x0C
  55E98616: F1 71                 ext_f1_71  
  55E98618: 85                    mov        d1, d1
  55E98619: FD DB 72 52 61        ext_fd_DB  0x5272, 0x61
  55E9861E: 51                    db_op_51   0x51
  55E9861F: 44                    db_op_44   0x44
  55E98620: D9                    lbne       
  55E98621: CD 5E ED 00 00        call       sub_55E9737F, [], 0
  55E98626: A0                    db_op_A0   0xA0
  55E98627: 00                    db_op_00   0x00
  55E98628: C8 09                 beq        loc_55E98631
  55E9862A: 80 82                 mov        0x82, d0
  55E9862C: CD 2F F8 00 00        call       sub_55E97E5B, [], 0
loc_55E98631:
  55E98631: 23 10                 add        16, d3
  55E98633: CA C1                 bra        loc_55E985F4
loc_55E98635:
  55E98635: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E98638 (callers: 1) ---
sub_55E98638:
  55E98638: FC DF 70 B0 E9 55     mov        0x55E9B070, a3
loc_55E9863E:
  55E9863E: F0 63                 ext_f0_63  
  55E98640: A0                    db_op_A0   0xA0
  55E98641: 00                    db_op_00   0x00
  55E98642: C8 3C                 beq        loc_55E9867E
  55E98644: FC A5 20 F4 08 54     movbu      (0x5408F420), d1
  55E9864A: 18                    db_op_18   0x18
  55E9864B: 9D                    mov        a3, a1
  55E9864C: 51                    db_op_51   0x51
  55E9864D: 8A                    mov        d2, d2
  55E9864E: 18                    db_op_18   0x18
  55E9864F: F2 48                 ext_f2_48  
  55E98651: E1                    add        d0, d1
  55E98652: F0 63                 ext_f0_63  
  55E98654: FC DC E8 FF FF FF     mov        0xFFFFFFE8, a0
  55E9865A: F1 64                 ext_f1_64  
  55E9865C: F0 70                 ext_f0_70  
  55E9865E: 71                    mov        d0, (a1)
  55E9865F: F8 05 04              ext_f8_05  0x04
  55E98662: 9A                    mov        a2, a2
  55E98663: 0C                    db_op_0C   0x0C
  55E98664: F1 72                 ext_f1_72  
  55E98666: 62                    mov        (a2), d0
  55E98667: F8 16 04              ext_f8_16  0x04
  55E9866A: CD 2A ED 00 00        call       sub_55E97394, [], 0
  55E9866F: A0                    db_op_A0   0xA0
  55E98670: 00                    db_op_00   0x00
  55E98671: C8 09                 beq        loc_55E9867A
  55E98673: 80 82                 mov        0x82, d0
  55E98675: CD E6 F7 00 00        call       sub_55E97E5B, [], 0
loc_55E9867A:
  55E9867A: 23 0C                 add        12, d3
  55E9867C: CA C2                 bra        loc_55E9863E
loc_55E9867E:
  55E9867E: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E98681 (callers: 1) ---
sub_55E98681:
  55E98681: FC DF B8 B0 E9 55     mov        0x55E9B0B8, a3
loc_55E98687:
  55E98687: F0 63                 ext_f0_63  
  55E98689: A0                    db_op_A0   0xA0
  55E9868A: 00                    db_op_00   0x00
  55E9868B: C8 3D                 beq        loc_55E986C8
  55E9868D: FC A5 24 F4 08 54     movbu      (0x5408F424), d1
  55E98693: 18                    db_op_18   0x18
  55E98694: 9E                    mov        a3, a2
  55E98695: 52                    db_op_52   0x52
  55E98696: 8A                    mov        d2, d2
  55E98697: 30                    db_op_30   0x30
  55E98698: F2 48                 ext_f2_48  
  55E9869A: E1                    add        d0, d1
  55E9869B: F0 63                 ext_f0_63  
  55E9869D: FC DC D0 FF FF FF     mov        0xFFFFFFD0, a0
  55E986A3: F1 64                 ext_f1_64  
  55E986A5: F0 70                 ext_f0_70  
  55E986A7: 95                    mov        a1, a1
  55E986A8: 14                    db_op_14   0x14
  55E986A9: F1 71                 ext_f1_71  
  55E986AB: 85                    mov        d1, d1
  55E986AC: FD DB 72 52 61        ext_fd_DB  0x5272, 0x61
  55E986B1: 51                    db_op_51   0x51
  55E986B2: 44                    db_op_44   0x44
  55E986B3: D9                    lbne       
  55E986B4: CD F5 EC B0 10        call       sub_55E973A9, [d2,a2,a3], 16
  55E986B9: A0                    db_op_A0   0xA0
  55E986BA: 00                    db_op_00   0x00
  55E986BB: C8 09                 beq        loc_55E986C4
  55E986BD: 80 82                 mov        0x82, d0
  55E986BF: CD 9C F7 00 00        call       sub_55E97E5B, [], 0
loc_55E986C4:
  55E986C4: 23 10                 add        16, d3
  55E986C6: CA C1                 bra        loc_55E98687
loc_55E986C8:
  55E986C8: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E986CB (callers: 1) ---
sub_55E986CB:
  55E986CB: FC DF 58 B2 E9 55     mov        0x55E9B258, a3
loc_55E986D1:
  55E986D1: F0 63                 ext_f0_63  
  55E986D3: A0                    db_op_A0   0xA0
  55E986D4: 00                    db_op_00   0x00
  55E986D5: C8 3C                 beq        loc_55E98711
  55E986D7: FC A5 28 F4 08 54     movbu      (0x5408F428), d1
  55E986DD: 18                    db_op_18   0x18
  55E986DE: 9D                    mov        a3, a1
  55E986DF: 51                    db_op_51   0x51
  55E986E0: 8A                    mov        d2, d2
  55E986E1: 1C                    db_op_1C   0x1C
  55E986E2: F2 48                 ext_f2_48  
  55E986E4: E1                    add        d0, d1
  55E986E5: F0 63                 ext_f0_63  
  55E986E7: FC DC E4 FF FF FF     mov        0xFFFFFFE4, a0
  55E986ED: F1 64                 ext_f1_64  
  55E986EF: F0 70                 ext_f0_70  
  55E986F1: 71                    mov        d0, (a1)
  55E986F2: F8 05 04              ext_f8_05  0x04
  55E986F5: 9A                    mov        a2, a2
  55E986F6: 0C                    db_op_0C   0x0C
  55E986F7: F1 72                 ext_f1_72  
  55E986F9: 62                    mov        (a2), d0
  55E986FA: F8 16 04              ext_f8_16  0x04
  55E986FD: CD 16 ED 00 00        call       sub_55E97413, [], 0
  55E98702: A0                    db_op_A0   0xA0
  55E98703: 00                    db_op_00   0x00
  55E98704: C8 09                 beq        loc_55E9870D
  55E98706: 80 82                 mov        0x82, d0
  55E98708: CD 53 F7 00 00        call       sub_55E97E5B, [], 0
loc_55E9870D:
  55E9870D: 23 0C                 add        12, d3
  55E9870F: CA C2                 bra        loc_55E986D1
loc_55E98711:
  55E98711: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E98714 (callers: 1) ---
sub_55E98714:
  55E98714: FC DE 64 B2 E9 55     mov        0x55E9B264, a2
loc_55E9871A:
  55E9871A: F0 62                 ext_f0_62  
  55E9871C: A0                    db_op_A0   0xA0
  55E9871D: 00                    db_op_00   0x00
  55E9871E: C8 35                 beq        loc_55E98753
  55E98720: FC A5 2C F4 08 54     movbu      (0x5408F42C), d1
  55E98726: 18                    db_op_18   0x18
  55E98727: 8A                    mov        d2, d2
  55E98728: 1C                    db_op_1C   0x1C
  55E98729: F2 48                 ext_f2_48  
  55E9872B: E1                    add        d0, d1
  55E9872C: F0 62                 ext_f0_62  
  55E9872E: FC DC E4 FF FF FF     mov        0xFFFFFFE4, a0
  55E98734: F1 64                 ext_f1_64  
  55E98736: F8 70 08              ext_f8_70  0x08
  55E98739: F8 02 04              ext_f8_02  0x04
  55E9873C: F8 10 14              ext_f8_10  0x14
  55E9873F: CD EB EC 00 00        call       sub_55E9742A, [], 0
  55E98744: A0                    db_op_A0   0xA0
  55E98745: 00                    db_op_00   0x00
  55E98746: C8 09                 beq        loc_55E9874F
  55E98748: 80 82                 mov        0x82, d0
  55E9874A: CD 11 F7 00 00        call       sub_55E97E5B, [], 0
loc_55E9874F:
  55E9874F: 22 08                 add        8, d2
  55E98751: CA C9                 bra        loc_55E9871A
loc_55E98753:
  55E98753: DF A0 0C              ret        [d2,a2], 12

; --- Function sub_55E98756 (callers: 1) ---
sub_55E98756:
  55E98756: FC DE A0 B3 E9 55     mov        0x55E9B3A0, a2
loc_55E9875C:
  55E9875C: F0 62                 ext_f0_62  
  55E9875E: A0                    db_op_A0   0xA0
  55E9875F: 00                    db_op_00   0x00
  55E98760: C8 33                 beq        loc_55E98793
  55E98762: FC A5 4C F4 08 54     movbu      (0x5408F44C), d1
  55E98768: 18                    db_op_18   0x18
  55E98769: F8 C0 04              ext_f8_C0  0x04
  55E9876C: E1                    add        d0, d1
  55E9876D: F0 62                 ext_f0_62  
  55E9876F: FC DC F0 FF FF FF     mov        0xFFFFFFF0, a0
  55E98775: F1 64                 ext_f1_64  
  55E98777: F0 70                 ext_f0_70  
  55E98779: F8 02 04              ext_f8_02  0x04
  55E9877C: F8 10 0C              ext_f8_10  0x0C
  55E9877F: CD AB EE 00 00        call       sub_55E9762A, [], 0
  55E98784: A0                    db_op_A0   0xA0
  55E98785: 00                    db_op_00   0x00
  55E98786: C8 09                 beq        loc_55E9878F
  55E98788: 80 82                 mov        0x82, d0
  55E9878A: CD D1 F6 00 00        call       sub_55E97E5B, [], 0
loc_55E9878F:
  55E9878F: 22 08                 add        8, d2
  55E98791: CA CB                 bra        loc_55E9875C
loc_55E98793:
  55E98793: DF 20 08              ret        [a2], 8

; --- Function sub_55E98796 (callers: 1) ---
sub_55E98796:
  55E98796: FC DF 6C B2 E9 55     mov        0x55E9B26C, a3
loc_55E9879C:
  55E9879C: F0 63                 ext_f0_63  
  55E9879E: A0                    db_op_A0   0xA0
  55E9879F: 00                    db_op_00   0x00
  55E987A0: C8 3D                 beq        loc_55E987DD
  55E987A2: FC A5 30 F4 08 54     movbu      (0x5408F430), d1
  55E987A8: 18                    db_op_18   0x18
  55E987A9: 9E                    mov        a3, a2
  55E987AA: 52                    db_op_52   0x52
  55E987AB: 8A                    mov        d2, d2
  55E987AC: 38                    db_op_38   0x38
  55E987AD: F2 48                 ext_f2_48  
  55E987AF: E1                    add        d0, d1
  55E987B0: F0 63                 ext_f0_63  
  55E987B2: FC DC C8 FF FF FF     mov        0xFFFFFFC8, a0
  55E987B8: F1 64                 ext_f1_64  
  55E987BA: F0 70                 ext_f0_70  
  55E987BC: 95                    mov        a1, a1
  55E987BD: 14                    db_op_14   0x14
  55E987BE: F1 71                 ext_f1_71  
  55E987C0: 85                    mov        d1, d1
  55E987C1: FC DB 72 52 61 51     ext_fc_DB  0x51615272
  55E987C7: 44                    db_op_44   0x44
  55E987C8: D9                    lbne       
  55E987C9: CD 7B EC B0 10        call       sub_55E97444, [d2,a2,a3], 16
  55E987CE: A0                    db_op_A0   0xA0
  55E987CF: 00                    db_op_00   0x00
  55E987D0: C8 09                 beq        loc_55E987D9
  55E987D2: 80 82                 mov        0x82, d0
  55E987D4: CD 87 F6 00 00        call       sub_55E97E5B, [], 0
loc_55E987D9:
  55E987D9: 23 14                 add        20, d3
  55E987DB: CA C1                 bra        loc_55E9879C
loc_55E987DD:
  55E987DD: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E987E0 (callers: 1) ---
sub_55E987E0:
  55E987E0: FC DF 80 B2 E9 55     mov        0x55E9B280, a3
loc_55E987E6:
  55E987E6: F0 63                 ext_f0_63  
  55E987E8: A0                    db_op_A0   0xA0
  55E987E9: 00                    db_op_00   0x00
  55E987EA: C8 3D                 beq        loc_55E98827
  55E987EC: FC A5 34 F4 08 54     movbu      (0x5408F434), d1
  55E987F2: 18                    db_op_18   0x18
  55E987F3: 9E                    mov        a3, a2
  55E987F4: 52                    db_op_52   0x52
  55E987F5: 8A                    mov        d2, d2
  55E987F6: 24 F2 48              mov        0x48F2, a0
  55E987F9: E1                    add        d0, d1
  55E987FA: F0 63                 ext_f0_63  
  55E987FC: FC DC DC FF FF FF     mov        0xFFFFFFDC, a0
  55E98802: F1 64                 ext_f1_64  
  55E98804: F0 70                 ext_f0_70  
  55E98806: 95                    mov        a1, a1
  55E98807: 14                    db_op_14   0x14
  55E98808: F1 71                 ext_f1_71  
  55E9880A: 85                    mov        d1, d1
  55E9880B: FD DB 72 52 61        ext_fd_DB  0x5272, 0x61
  55E98810: 51                    db_op_51   0x51
  55E98811: 44                    db_op_44   0x44
  55E98812: D9                    lbne       
  55E98813: CD 8F EC 00 00        call       sub_55E974A2, [], 0
  55E98818: A0                    db_op_A0   0xA0
  55E98819: 00                    db_op_00   0x00
  55E9881A: C8 09                 beq        loc_55E98823
  55E9881C: 80 82                 mov        0x82, d0
  55E9881E: CD 3D F6 00 00        call       sub_55E97E5B, [], 0
loc_55E98823:
  55E98823: 23 10                 add        16, d3
  55E98825: CA C1                 bra        loc_55E987E6
loc_55E98827:
  55E98827: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E9882A (callers: 1) ---
sub_55E9882A:
  55E9882A: FC DF 90 B2 E9 55     mov        0x55E9B290, a3
loc_55E98830:
  55E98830: F0 63                 ext_f0_63  
  55E98832: A0                    db_op_A0   0xA0
  55E98833: 00                    db_op_00   0x00
  55E98834: C8 3D                 beq        loc_55E98871
  55E98836: FC A5 38 F4 08 54     movbu      (0x5408F438), d1
  55E9883C: 18                    db_op_18   0x18
  55E9883D: 9E                    mov        a3, a2
  55E9883E: 52                    db_op_52   0x52
  55E9883F: 8A                    mov        d2, d2
  55E98840: 24 F2 48              mov        0x48F2, a0
  55E98843: E1                    add        d0, d1
  55E98844: F0 63                 ext_f0_63  
  55E98846: FC DC DC FF FF FF     mov        0xFFFFFFDC, a0
  55E9884C: F1 64                 ext_f1_64  
  55E9884E: F0 70                 ext_f0_70  
  55E98850: 95                    mov        a1, a1
  55E98851: 0C                    db_op_0C   0x0C
  55E98852: F1 71                 ext_f1_71  
  55E98854: 85                    mov        d1, d1
  55E98855: FC DB 72 52 61 51     ext_fc_DB  0x51615272
  55E9885B: 44                    db_op_44   0x44
  55E9885C: D9                    lbne       
  55E9885D: CD 57 EC F0 20        call       sub_55E974B4, [d2,d3,a2,a3], 32
  55E98862: A0                    db_op_A0   0xA0
  55E98863: 00                    db_op_00   0x00
  55E98864: C8 09                 beq        loc_55E9886D
  55E98866: 80 82                 mov        0x82, d0
  55E98868: CD F3 F5 00 00        call       sub_55E97E5B, [], 0
loc_55E9886D:
  55E9886D: 23 14                 add        20, d3
  55E9886F: CA C1                 bra        loc_55E98830
loc_55E98871:
  55E98871: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E98874 (callers: 1) ---
sub_55E98874:
  55E98874: FC DF E0 B2 E9 55     mov        0x55E9B2E0, a3
loc_55E9887A:
  55E9887A: F0 63                 ext_f0_63  
  55E9887C: A0                    db_op_A0   0xA0
  55E9887D: 00                    db_op_00   0x00
  55E9887E: C8 3D                 beq        loc_55E988BB
  55E98880: FC A5 3C F4 08 54     movbu      (0x5408F43C), d1
  55E98886: 18                    db_op_18   0x18
  55E98887: 9E                    mov        a3, a2
  55E98888: 52                    db_op_52   0x52
  55E98889: 8A                    mov        d2, d2
  55E9888A: 24 F2 48              mov        0x48F2, a0
  55E9888D: E1                    add        d0, d1
  55E9888E: F0 63                 ext_f0_63  
  55E98890: FC DC DC FF FF FF     mov        0xFFFFFFDC, a0
  55E98896: F1 64                 ext_f1_64  
  55E98898: F0 70                 ext_f0_70  
  55E9889A: 95                    mov        a1, a1
  55E9889B: 0C                    db_op_0C   0x0C
  55E9889C: F1 71                 ext_f1_71  
  55E9889E: 85                    mov        d1, d1
  55E9889F: FD DB 72 52 61        ext_fd_DB  0x5272, 0x61
  55E988A4: 51                    db_op_51   0x51
  55E988A5: 44                    db_op_44   0x44
  55E988A6: D9                    lbne       
  55E988A7: CD DA EC B0 10        call       sub_55E97581, [d2,a2,a3], 16
  55E988AC: A0                    db_op_A0   0xA0
  55E988AD: 00                    db_op_00   0x00
  55E988AE: C8 09                 beq        loc_55E988B7
  55E988B0: 80 82                 mov        0x82, d0
  55E988B2: CD A9 F5 00 00        call       sub_55E97E5B, [], 0
loc_55E988B7:
  55E988B7: 23 10                 add        16, d3
  55E988B9: CA C1                 bra        loc_55E9887A
loc_55E988BB:
  55E988BB: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E988BE (callers: 1) ---
sub_55E988BE:
  55E988BE: FC DF F0 B2 E9 55     mov        0x55E9B2F0, a3
loc_55E988C4:
  55E988C4: F0 63                 ext_f0_63  
  55E988C6: A0                    db_op_A0   0xA0
  55E988C7: 00                    db_op_00   0x00
  55E988C8: C8 3E                 beq        loc_55E98906
  55E988CA: FC A5 40 F4 08 54     movbu      (0x5408F440), d1
  55E988D0: 18                    db_op_18   0x18
  55E988D1: 9E                    mov        a3, a2
  55E988D2: 52                    db_op_52   0x52
  55E988D3: 8A                    mov        d2, d2
  55E988D4: 24 F2 48              mov        0x48F2, a0
  55E988D7: E1                    add        d0, d1
  55E988D8: F0 63                 ext_f0_63  
  55E988DA: FC DC DC FF FF FF     mov        0xFFFFFFDC, a0
  55E988E0: F1 64                 ext_f1_64  
  55E988E2: F8 70 08              ext_f8_70  0x08
  55E988E5: 95                    mov        a1, a1
  55E988E6: 10                    db_op_10   0x10
  55E988E7: F1 71                 ext_f1_71  
  55E988E9: 85                    mov        d1, d1
  55E988EA: FB DB 72 52           ext_fb_DB  0x5272
  55E988EE: 61                    mov        (a1), d0
  55E988EF: 51                    db_op_51   0x51
  55E988F0: 44                    db_op_44   0x44
  55E988F1: D9                    lbne       
  55E988F2: CD F7 EC 00 00        call       sub_55E975E9, [], 0
  55E988F7: A0                    db_op_A0   0xA0
  55E988F8: 00                    db_op_00   0x00
  55E988F9: C8 09                 beq        loc_55E98902
  55E988FB: 80 82                 mov        0x82, d0
  55E988FD: CD 5E F5 00 00        call       sub_55E97E5B, [], 0
loc_55E98902:
  55E98902: 23 18                 add        24, d3
  55E98904: CA C0                 bra        loc_55E988C4
loc_55E98906:
  55E98906: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E98909 (callers: 1) ---
sub_55E98909:
  55E98909: FC DF 08 B3 E9 55     mov        0x55E9B308, a3
loc_55E9890F:
  55E9890F: F0 63                 ext_f0_63  
  55E98911: A0                    db_op_A0   0xA0
  55E98912: 00                    db_op_00   0x00
  55E98913: C8 3E                 beq        loc_55E98951
  55E98915: FC A5 44 F4 08 54     movbu      (0x5408F444), d1
  55E9891B: 18                    db_op_18   0x18
  55E9891C: 9E                    mov        a3, a2
  55E9891D: 52                    db_op_52   0x52
  55E9891E: 8A                    mov        d2, d2
  55E9891F: 1C                    db_op_1C   0x1C
  55E98920: F2 48                 ext_f2_48  
  55E98922: E1                    add        d0, d1
  55E98923: F0 63                 ext_f0_63  
  55E98925: FC DC E4 FF FF FF     mov        0xFFFFFFE4, a0
  55E9892B: F1 64                 ext_f1_64  
  55E9892D: F8 70 08              ext_f8_70  0x08
  55E98930: 95                    mov        a1, a1
  55E98931: 10                    db_op_10   0x10
  55E98932: F1 71                 ext_f1_71  
  55E98934: 85                    mov        d1, d1
  55E98935: FD DB 72 52 61        ext_fd_DB  0x5272, 0x61
  55E9893A: 51                    db_op_51   0x51
  55E9893B: 44                    db_op_44   0x44
  55E9893C: D9                    lbne       
  55E9893D: CD E6 EC 00 00        call       sub_55E97623, [], 0
  55E98942: A0                    db_op_A0   0xA0
  55E98943: 00                    db_op_00   0x00
  55E98944: C8 09                 beq        loc_55E9894D
  55E98946: 80 82                 mov        0x82, d0
  55E98948: CD 13 F5 00 00        call       sub_55E97E5B, [], 0
loc_55E9894D:
  55E9894D: 23 10                 add        16, d3
  55E9894F: CA C0                 bra        loc_55E9890F
loc_55E98951:
  55E98951: DF B0 10              ret        [d2,a2,a3], 16

; --- Function sub_55E98954 (callers: 1) ---
sub_55E98954:
  55E98954: FC A0 1C B3 E9 55     mov        (0x55E9B31C), d0
  55E9895A: 00                    db_op_00   0x00
  55E9895B: FC 81 04 F4 08 54     mov        d1, (0x5408F404)
  55E98961: B0                    db_op_B0   0xB0
  55E98962: 00                    db_op_00   0x00
  55E98963: C8 08                 beq        loc_55E9896B
  55E98965: FC 80 04 F4 08 54     mov        d0, (0x5408F404)
loc_55E9896B:
  55E9896B: DE 00 00              retf       [], 0

; --- Function sub_55E9896E (callers: 1) ---
sub_55E9896E:
  55E9896E: FC DE 20 B3 E9 55     mov        0x55E9B320, a2
loc_55E98974:
  55E98974: 98                    mov        a2, a0
  55E98975: 50                    db_op_50   0x50
  55E98976: F8 00 04              ext_f8_00  0x04
  55E98979: A0                    db_op_A0   0xA0
  55E9897A: 00                    db_op_00   0x00
  55E9897B: C8 19                 beq        loc_55E98994
  55E9897D: F0 62                 ext_f0_62  
  55E9897F: 18                    db_op_18   0x18
  55E98980: CD E6 F7 00 00        call       sub_55E98166, [], 0
  55E98985: A0                    db_op_A0   0xA0
  55E98986: 00                    db_op_00   0x00
  55E98987: C8 09                 beq        loc_55E98990
  55E98989: 80 88                 mov        0x88, d0
  55E9898B: CD D0 F4 00 00        call       sub_55E97E5B, [], 0
loc_55E98990:
  55E98990: 22 0C                 add        12, d2
  55E98992: CA E2                 bra        loc_55E98974
loc_55E98994:
  55E98994: DF 20 08              ret        [a2], 8

; --- Function sub_55E98997 (callers: 1) ---
sub_55E98997:
  55E98997: FC DF 68 B3 E9 55     mov        0x55E9B368, a3
loc_55E9899D:
  55E9899D: F8 23 0C              ext_f8_23  0x0C
  55E989A0: B0                    db_op_B0   0xB0
  55E989A1: 00                    db_op_00   0x00
  55E989A2: C8 2F                 beq        loc_55E989D1
  55E989A4: 80 20                 mov        0x20, d0
  55E989A6: CD 0E 1B F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E989AB: 00                    db_op_00   0x00
  55E989AC: F8 70 08              ext_f8_70  0x08
  55E989AF: 9E                    mov        a3, a2
  55E989B0: 95                    mov        a1, a1
  55E989B1: 0C                    db_op_0C   0x0C
  55E989B2: F1 71                 ext_f1_71  
  55E989B4: 85                    mov        d1, d1
  55E989B5: FB DB 72 52           ext_fb_DB  0x5272
  55E989B9: 61                    mov        (a1), d0
  55E989BA: 51                    db_op_51   0x51
  55E989BB: 44                    db_op_44   0x44
  55E989BC: D9                    lbne       
  55E989BD: CD 13 F8 F0 18        call       sub_55E981D0, [d2,d3,a2,a3], 24
  55E989C2: A0                    db_op_A0   0xA0
  55E989C3: 00                    db_op_00   0x00
  55E989C4: C8 09                 beq        loc_55E989CD
  55E989C6: 80 82                 mov        0x82, d0
  55E989C8: CD 93 F4 00 00        call       sub_55E97E5B, [], 0
loc_55E989CD:
  55E989CD: 23 14                 add        20, d3
  55E989CF: CA CE                 bra        loc_55E9899D
loc_55E989D1:
  55E989D1: DF 30 0C              ret        [a2,a3], 12

; --- Function sub_55E989D4 (callers: 1) ---
sub_55E989D4:
  55E989D4: FC AC DC B3 E9 55     movhu      (0x55E9B3DC), d0
  55E989DA: 04                    db_op_04   0x04
  55E989DB: 40 18                 mov        a0, (24, sp)
  55E989DD: A4                    db_op_A4   0xA4
  55E989DE: C0 13                 blt        loc_55E989F1
  55E989E0: FC DC 68 88 07 54     mov        0x54078868, a0
  55E989E6: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E989E7: F0 10                 ext_f0_10  
  55E989E9: F8 30 04              ext_f8_30  0x04
  55E989EC: 44                    db_op_44   0x44
  55E989ED: 20 08                 add        8, d0
  55E989EF: A1                    db_op_A1   0xA1
  55E989F0: D3                    lble       
loc_55E989F1:
  55E989F1: FC CC 68 88 07 54     mov        0x54078868, d0
  55E989F7: FC 81 F4 F3 08 54     mov        d1, (0x5408F3F4)
  55E989FD: FC DC DC F3 08 54     mov        0x5408F3DC, a0
  55E98A03: FC 80 DC F3 08 54     mov        d0, (0x5408F3DC)
  55E98A09: FC 80 E0 F3 08 54     mov        d0, (0x5408F3E0)
  55E98A0F: FC DC E4 F3 08 54     mov        0x5408F3E4, a0
  55E98A15: FC 80 E4 F3 08 54     mov        d0, (0x5408F3E4)
  55E98A1B: FC 80 E8 F3 08 54     mov        d0, (0x5408F3E8)
  55E98A21: FC DC EC F3 08 54     mov        0x5408F3EC, a0
  55E98A27: FC 80 EC F3 08 54     mov        d0, (0x5408F3EC)
  55E98A2D: FC 80 F0 F3 08 54     mov        d0, (0x5408F3F0)
  55E98A33: CD EB F6 80 04        call       sub_55E9811E, [d2], 4
  55E98A38: DF 00 04              ret        [], 4

; --- Function sub_55E98A3B (callers: 1) ---
sub_55E98A3B:
  55E98A3B: FC DE 94 B3 E9 55     mov        0x55E9B394, a2
loc_55E98A41:
  55E98A41: 90 08                 mov        0x08, a0
  55E98A43: F1 78                 ext_f1_78  
  55E98A45: 70                    mov        d0, (a0)
  55E98A46: A0                    db_op_A0   0xA0
  55E98A47: 00                    db_op_00   0x00
  55E98A48: C8 0D                 beq        loc_55E98A55
  55E98A4A: F0 00                 nop2       
  55E98A4C: F8 02 04              ext_f8_02  0x04
  55E98A4F: 22 0C                 add        12, d2
  55E98A51: F0 F0                 calls      (a0)
  55E98A53: CA EE                 bra        loc_55E98A41
loc_55E98A55:
  55E98A55: DF 20 08              ret        [a2], 8

; --- Function sub_55E98A58 (callers: 1) ---
sub_55E98A58:
  55E98A58: DE 00 00              retf       [], 0

; --- Function sub_55E98A5B (callers: 1) ---
sub_55E98A5B:
  55E98A5B: FE 00 68 F3 08 54 01  ext_fe_00  0x5408F368, 0x01
  55E98A62: DE 00 00              retf       [], 0

; --- Function sub_55E98A65 (callers: 6) ---
sub_55E98A65:
  55E98A65: 92 82                 mov        0x82, a2
  55E98A67: 1A                    db_op_1A   0x1A
  55E98A68: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E98A6E: 85                    mov        d1, d1
  55E98A6F: 01                    db_op_01   0x01
  55E98A70: A0                    db_op_A0   0xA0
  55E98A71: 00                    db_op_00   0x00
  55E98A72: C9 03                 bne        loc_55E98A75
  55E98A74: 04                    db_op_04   0x04
loc_55E98A75:
  55E98A75: A5                    db_op_A5   0xA5
  55E98A76: 01                    db_op_01   0x01
  55E98A77: C8 0C                 beq        loc_55E98A83
  55E98A79: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E98A7F: A5                    db_op_A5   0xA5
  55E98A80: 01                    db_op_01   0x01
  55E98A81: C9 06                 bne        loc_55E98A87
loc_55E98A83:
  55E98A83: 8A                    mov        d2, d2
  55E98A84: E7                    add        d1, d3
  55E98A85: CA 73                 bra        loc_55E98AF8
loc_55E98A87:
  55E98A87: AA                    db_op_AA   0xAA
  55E98A88: 01                    db_op_01   0x01
  55E98A89: C0 0C                 blt        loc_55E98A95
  55E98A8B: FC AD C6 B3 E9 55     movhu      (0x55E9B3C6), d1
  55E98A91: 19                    db_op_19   0x19
  55E98A92: A6                    db_op_A6   0xA6
  55E98A93: C3 06                 ble        loc_55E98A99
loc_55E98A95:
  55E98A95: 8A                    mov        d2, d2
  55E98A96: EE                    add        d3, d2
  55E98A97: CA 61                 bra        loc_55E98AF8
loc_55E98A99:
  55E98A99: F1 D1                 ext_f1_D1  
  55E98A9B: F8 ED 03              ext_f8_ED  0x03
  55E98A9E: C8 06                 beq        loc_55E98AA4
  55E98AA0: 8A                    mov        d2, d2
  55E98AA1: EF                    add        d3, d3
  55E98AA2: CA 56                 bra        loc_55E98AF8
loc_55E98AA4:
  55E98AA4: CD F9 F3 00 00        call       sub_55E97E9D, [], 0
  55E98AA9: FC A4 38 F4 08 54     movbu      (0x5408F438), d0
  55E98AAF: 85                    mov        d1, d1
  55E98AB0: 24 F2 46              mov        0x46F2, a0
  55E98AB3: E8                    add        d2, d0
  55E98AB4: FC DC DC FF FF FF     mov        0xFFFFFFDC, a0
  55E98ABA: F1 60                 ext_f1_60  
  55E98ABC: F0 60                 ext_f0_60  
  55E98ABE: A0                    db_op_A0   0xA0
  55E98ABF: 00                    db_op_00   0x00
  55E98AC0: C9 04                 bne        loc_55E98AC4
  55E98AC2: 90 00                 mov        0x00, a0
loc_55E98AC4:
  55E98AC4: 8A                    mov        d2, d2
  55E98AC5: D6                    lbcc       
  55E98AC6: B0                    db_op_B0   0xB0
  55E98AC7: 00                    db_op_00   0x00
  55E98AC8: C8 2B                 beq        loc_55E98AF3
  55E98ACA: 95                    mov        a1, a1
  55E98ACB: 20 F1                 add        -15, d0
  55E98ACD: 71                    mov        d0, (a1)
  55E98ACE: 71                    mov        d0, (a1)
  55E98ACF: 8A                    mov        d2, d2
  55E98AD0: CE A0                 movm       (sp), [d2,a2]
  55E98AD2: 00                    db_op_00   0x00
  55E98AD3: C8 20                 beq        loc_55E98AF3
  55E98AD5: 85                    mov        d1, d1
  55E98AD6: 01                    db_op_01   0x01
  55E98AD7: F1 04                 ext_f1_04  
  55E98AD9: 61                    mov        (a1), d0
  55E98ADA: FC A1 F8 F3 08 54     mov        (0x5408F3F8), d1
  55E98AE0: 20 1C                 add        28, d0
  55E98AE2: F8 61 10              ext_f8_61  0x10
  55E98AE5: F0 04                 ext_f0_04  
  55E98AE7: 08                    db_op_08   0x08
  55E98AE8: F8 71 06              ext_f8_71  0x06
  55E98AEB: 70                    mov        d0, (a0)
  55E98AEC: 28 08                 cmp        0x08, d0
  55E98AEE: 62                    mov        (a2), d0
  55E98AEF: F0 04                 ext_f0_04  
  55E98AF1: 71                    mov        d0, (a1)
  55E98AF2: 60                    mov        (a0), d0
loc_55E98AF3:
  55E98AF3: CD C3 F3 00 00        call       sub_55E97EB6, [], 0
loc_55E98AF8:
  55E98AF8: 88                    mov        d2, d0
  55E98AF9: DF A0 0C              ret        [d2,a2], 12

; --- Function sub_55E98AFC (callers: 7) ---
sub_55E98AFC:
  55E98AFC: 18                    db_op_18   0x18
  55E98AFD: 83 FC                 mov        0xFC, d3
  55E98AFF: AA                    db_op_AA   0xAA
  55E98B00: 08                    db_op_08   0x08
  55E98B01: F4 08                 ext_f4_08  
  55E98B03: 54                    db_op_54   0x54
  55E98B04: 85                    mov        d1, d1
  55E98B05: 01                    db_op_01   0x01
  55E98B06: AA                    db_op_AA   0xAA
  55E98B07: 00                    db_op_00   0x00
  55E98B08: C9 03                 bne        loc_55E98B0B
  55E98B0A: 04                    db_op_04   0x04
loc_55E98B0B:
  55E98B0B: A5                    db_op_A5   0xA5
  55E98B0C: 01                    db_op_01   0x01
  55E98B0D: C8 0C                 beq        loc_55E98B19
  55E98B0F: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E98B15: A5                    db_op_A5   0xA5
  55E98B16: 01                    db_op_01   0x01
  55E98B17: C9 07                 bne        loc_55E98B1E
loc_55E98B19:
  55E98B19: 80 E7                 mov        0xE7, d0
  55E98B1B: DF C0 0C              ret        [d2,d3], 12
loc_55E98B1E:
  55E98B1E: 1B                    db_op_1B   0x1B
  55E98B1F: AF                    db_op_AF   0xAF
  55E98B20: 01                    db_op_01   0x01
  55E98B21: C0 0C                 blt        loc_55E98B2D
  55E98B23: FC AD AA B3 E9 55     movhu      (0x55E9B3AA), d1
  55E98B29: 19                    db_op_19   0x19
  55E98B2A: A7                    db_op_A7   0xA7
  55E98B2B: C3 06                 ble        loc_55E98B31
loc_55E98B2D:
  55E98B2D: 80 EE                 mov        0xEE, d0
  55E98B2F: CA 4A                 bra        loc_55E98B79
loc_55E98B31:
  55E98B31: CD 6C F3 00 00        call       sub_55E97E9D, [], 0
  55E98B36: FC A5 1C F4 08 54     movbu      (0x5408F41C), d1
  55E98B3C: 80 1C                 mov        0x1C, d0
  55E98B3E: F2 43                 ext_f2_43  
  55E98B40: ED                    add        d3, d1
  55E98B41: 29 E4                 cmp        0xE4, d1
  55E98B43: F1 E4                 ext_f1_E4  
  55E98B45: F0 68                 ext_f0_68  
  55E98B47: 84                    mov        d1, d0
  55E98B48: AA                    db_op_AA   0xAA
  55E98B49: 00                    db_op_00   0x00
  55E98B4A: C9 03                 bne        loc_55E98B4D
  55E98B4C: 00                    db_op_00   0x00
loc_55E98B4D:
  55E98B4D: A0                    db_op_A0   0xA0
  55E98B4E: 00                    db_op_00   0x00
  55E98B4F: C9 0B                 bne        loc_55E98B5A
  55E98B51: CD 65 F3 00 00        call       sub_55E97EB6, [], 0
  55E98B56: 80 D6                 mov        0xD6, d0
  55E98B58: CA 21                 bra        loc_55E98B79
loc_55E98B5A:
  55E98B5A: 90 18                 mov        0x18, a0
  55E98B5C: F1 60                 ext_f1_60  
  55E98B5E: 70                    mov        d0, (a0)
  55E98B5F: A0                    db_op_A0   0xA0
  55E98B60: 01                    db_op_01   0x01
  55E98B61: C4 09                 bcs        loc_55E98B6A
  55E98B63: 85                    mov        d1, d1
  55E98B64: 01                    db_op_01   0x01
  55E98B65: F1 04                 ext_f1_04  
  55E98B67: 60                    mov        (a0), d0
  55E98B68: CA 0B                 bra        loc_55E98B73
loc_55E98B6A:
  55E98B6A: CD 4C F3 00 00        call       sub_55E97EB6, [], 0
  55E98B6F: 80 CE                 mov        0xCE, d0
  55E98B71: CA 08                 bra        loc_55E98B79
loc_55E98B73:
  55E98B73: CD 43 F3 00 00        call       sub_55E97EB6, [], 0
  55E98B78: 00                    db_op_00   0x00
loc_55E98B79:
  55E98B79: DF C0 0C              ret        [d2,d3], 12

; --- Function sub_55E98B7C (callers: 6) ---
sub_55E98B7C:
  55E98B7C: 92 82                 mov        0x82, a2
  55E98B7E: 1A                    db_op_1A   0x1A
  55E98B7F: 00                    db_op_00   0x00
  55E98B80: 42 08                 mov        a2, (8, sp)
  55E98B82: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E98B88: 85                    mov        d1, d1
  55E98B89: 01                    db_op_01   0x01
  55E98B8A: A0                    db_op_A0   0xA0
  55E98B8B: 00                    db_op_00   0x00
  55E98B8C: C9 03                 bne        loc_55E98B8F
  55E98B8E: 04                    db_op_04   0x04
loc_55E98B8F:
  55E98B8F: A5                    db_op_A5   0xA5
  55E98B90: 01                    db_op_01   0x01
  55E98B91: C8 0C                 beq        loc_55E98B9D
  55E98B93: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E98B99: A5                    db_op_A5   0xA5
  55E98B9A: 01                    db_op_01   0x01
  55E98B9B: C9 07                 bne        loc_55E98BA2
loc_55E98B9D:
  55E98B9D: 80 E7                 mov        0xE7, d0
  55E98B9F: DF F0 1C              ret        [d2,d3,a2,a3], 28
loc_55E98BA2:
  55E98BA2: AA                    db_op_AA   0xAA
  55E98BA3: 01                    db_op_01   0x01
  55E98BA4: C0 0C                 blt        loc_55E98BB0
  55E98BA6: FC AD B2 B3 E9 55     movhu      (0x55E9B3B2), d1
  55E98BAC: 19                    db_op_19   0x19
  55E98BAD: A6                    db_op_A6   0xA6
  55E98BAE: C3 07                 ble        loc_55E98BB5
loc_55E98BB0:
  55E98BB0: 80 EE                 mov        0xEE, d0
  55E98BB2: DF F0 1C              ret        [d2,d3,a2,a3], 28
loc_55E98BB5:
  55E98BB5: CD E8 F2 00 00        call       sub_55E97E9D, [], 0
  55E98BBA: FC A5 24 F4 08 54     movbu      (0x5408F424), d1
  55E98BC0: 80 30                 mov        0x30, d0
  55E98BC2: F2 42                 ext_f2_42  
  55E98BC4: E9                    add        d2, d1
  55E98BC5: 8F                    mov        d3, d3
  55E98BC6: D0                    lblt       
  55E98BC7: E7                    add        d1, d3
  55E98BC8: F1 EC                 ext_f1_EC  
  55E98BCA: F0 68                 ext_f0_68  
  55E98BCC: AA                    db_op_AA   0xAA
  55E98BCD: 00                    db_op_00   0x00
  55E98BCE: C9 03                 bne        loc_55E98BD1
  55E98BD0: 0C                    db_op_0C   0x0C
loc_55E98BD1:
  55E98BD1: AF                    db_op_AF   0xAF
  55E98BD2: 00                    db_op_00   0x00
  55E98BD3: C9 06                 bne        loc_55E98BD9
  55E98BD5: 80 D6                 mov        0xD6, d0
  55E98BD7: CA 7F                 bra        loc_55E98C56
loc_55E98BD9:
  55E98BD9: 8A                    mov        d2, d2
  55E98BDA: 2C EE F1              mov        0xF1EE, d0
  55E98BDD: E8                    add        d2, d0
  55E98BDE: 74                    mov        d1, (a0)
  55E98BDF: 90 14                 mov        0x14, a0
  55E98BE1: F1 6C                 ext_f1_6C  
  55E98BE3: 43 04                 mov        a3, (4, sp)
  55E98BE5: F8 00 04              ext_f8_00  0x04
  55E98BE8: A1                    db_op_A1   0xA1
  55E98BE9: C8 52                 beq        loc_55E98C3B
  55E98BEB: 95                    mov        a1, a1
  55E98BEC: 24 F1 6D              mov        0x6DF1, a0
  55E98BEF: F0 01                 ext_f0_01  
  55E98BF1: 9F                    mov        a3, a3
  55E98BF2: 28 70                 cmp        0x70, d0
  55E98BF4: F1 6F                 ext_f1_6F  
  55E98BF6: 62                    mov        (a2), d0
  55E98BF7: 75                    mov        d1, (a1)
  55E98BF8: 73                    mov        d0, (a3)
  55E98BF9: A1                    db_op_A1   0xA1
  55E98BFA: C9 09                 bne        loc_55E98C03
  55E98BFC: 5C 04                 mov        (4, sp), a0
  55E98BFE: F8 00 08              ext_f8_00  0x08
  55E98C01: CA 05                 bra        loc_55E98C06
loc_55E98C03:
  55E98C03: 71                    mov        d0, (a1)
  55E98C04: 28 04                 cmp        0x04, d0
loc_55E98C06:
  55E98C06: 61                    mov        (a1), d0
  55E98C07: F1 E8                 ext_f1_E8  
  55E98C09: 70                    mov        d0, (a0)
  55E98C0A: F1 EE                 ext_f1_EE  
  55E98C0C: 40 60                 mov        a0, (96, sp)
  55E98C0E: 52                    db_op_52   0x52
  55E98C0F: 72                    mov        d0, (a2)
  55E98C10: F1 98                 ext_f1_98  
  55E98C12: C8 46                 beq        loc_55E98C58
  55E98C14: F0 02                 ext_f0_02  
  55E98C16: 95                    mov        a1, a1
  55E98C17: 20 F8                 add        -8, d0
  55E98C19: 00                    db_op_00   0x00
  55E98C1A: 60                    mov        (a0), d0
  55E98C1B: F1 6D                 ext_f1_6D  
  55E98C1D: F0 01                 ext_f0_01  
  55E98C1F: 60                    mov        (a0), d0
  55E98C20: 75                    mov        d1, (a1)
  55E98C21: 73                    mov        d0, (a3)
  55E98C22: A1                    db_op_A1   0xA1
  55E98C23: C9 09                 bne        loc_55E98C2C
  55E98C25: 5C 04                 mov        (4, sp), a0
  55E98C27: F8 00 08              ext_f8_00  0x08
  55E98C2A: CA 05                 bra        loc_55E98C2F
loc_55E98C2C:
  55E98C2C: 71                    mov        d0, (a1)
  55E98C2D: 28 04                 cmp        0x04, d0
loc_55E98C2F:
  55E98C2F: 61                    mov        (a1), d0
  55E98C30: F1 E8                 ext_f1_E8  
  55E98C32: 70                    mov        d0, (a0)
  55E98C33: 85                    mov        d1, d1
  55E98C34: 01                    db_op_01   0x01
  55E98C35: F1 04                 ext_f1_04  
  55E98C37: 60                    mov        (a0), d0
  55E98C38: 76                    mov        d1, (a2)
  55E98C39: CA 11                 bra        loc_55E98C4A
loc_55E98C3B:
  55E98C3B: F1 ED                 ext_f1_ED  
  55E98C3D: 51                    db_op_51   0x51
  55E98C3E: 71                    mov        d0, (a1)
  55E98C3F: F1 94                 ext_f1_94  
  55E98C41: C8 13                 beq        loc_55E98C54
  55E98C43: F0 01                 ext_f0_01  
  55E98C45: F8 00 60              ext_f8_00  0x60
  55E98C48: 62                    mov        (a2), d0
  55E98C49: 75                    mov        d1, (a1)
loc_55E98C4A:
  55E98C4A: F1 E4                 ext_f1_E4  
  55E98C4C: 00                    db_op_00   0x00
  55E98C4D: CD 21 02 30 0C        call       sub_55E98E6E, [a2,a3], 12
  55E98C52: CA 06                 bra        loc_55E98C58
loc_55E98C54:
  55E98C54: 80 CE                 mov        0xCE, d0
loc_55E98C56:
  55E98C56: 42 08                 mov        a2, (8, sp)
loc_55E98C58:
  55E98C58: CD 5E F2 00 00        call       sub_55E97EB6, [], 0
  55E98C5D: 58 08                 mov        (8, sp), d0
  55E98C5F: DF F0 1C              ret        [d2,d3,a2,a3], 28

; --- Function sub_55E98C62 (callers: 22) ---
sub_55E98C62:
  55E98C62: F1 E7                 ext_f1_E7  
  55E98C64: 82 1A                 mov        0x1A, d2
  55E98C66: 0C                    db_op_0C   0x0C
  55E98C67: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E98C6D: 85                    mov        d1, d1
  55E98C6E: 01                    db_op_01   0x01
  55E98C6F: AC                    db_op_AC   0xAC
  55E98C70: C9 03                 bne        loc_55E98C73
  55E98C72: 8D                    mov        d3, d1
loc_55E98C73:
  55E98C73: A5                    db_op_A5   0xA5
  55E98C74: 01                    db_op_01   0x01
  55E98C75: C8 0C                 beq        loc_55E98C81
  55E98C77: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E98C7D: A5                    db_op_A5   0xA5
  55E98C7E: 01                    db_op_01   0x01
  55E98C7F: C9 07                 bne        loc_55E98C86
loc_55E98C81:
  55E98C81: 8F                    mov        d3, d3
  55E98C82: E7                    add        d1, d3
  55E98C83: CC 82 00              jmp        loc_55E98D05
loc_55E98C86:
  55E98C86: AA                    db_op_AA   0xAA
  55E98C87: 01                    db_op_01   0x01
  55E98C88: C0 0C                 blt        loc_55E98C94
  55E98C8A: FC AD B2 B3 E9 55     movhu      (0x55E9B3B2), d1
  55E98C90: 19                    db_op_19   0x19
  55E98C91: A6                    db_op_A6   0xA6
  55E98C92: C3 06                 ble        loc_55E98C98
loc_55E98C94:
  55E98C94: 8F                    mov        d3, d3
  55E98C95: EE                    add        d3, d2
  55E98C96: CA 6F                 bra        loc_55E98D05
loc_55E98C98:
  55E98C98: CD 05 F2 00 00        call       sub_55E97E9D, [], 0
  55E98C9D: FC A5 24 F4 08 54     movbu      (0x5408F424), d1
  55E98CA3: 80 30                 mov        0x30, d0
  55E98CA5: F2 42                 ext_f2_42  
  55E98CA7: E9                    add        d2, d1
  55E98CA8: 29 D0                 cmp        0xD0, d1
  55E98CAA: F1 E4                 ext_f1_E4  
  55E98CAC: F0 68                 ext_f0_68  
  55E98CAE: AE                    db_op_AE   0xAE
  55E98CAF: C9 03                 bne        loc_55E98CB2
  55E98CB1: 04                    db_op_04   0x04
loc_55E98CB2:
  55E98CB2: AD                    db_op_AD   0xAD
  55E98CB3: C9 06                 bne        loc_55E98CB9
  55E98CB5: 8F                    mov        d3, d3
  55E98CB6: D6                    lbcc       
  55E98CB7: CA 49                 bra        loc_55E98D00
loc_55E98CB9:
  55E98CB9: 95                    mov        a1, a1
  55E98CBA: 0C                    db_op_0C   0x0C
  55E98CBB: F1 65                 ext_f1_65  
  55E98CBD: 71                    mov        d0, (a1)
  55E98CBE: F1 94                 ext_f1_94  
  55E98CC0: C8 12                 beq        loc_55E98CD2
  55E98CC2: F0 01                 ext_f0_01  
  55E98CC4: 8C                    mov        d3, d0
  55E98CC5: F8 3C 60              ext_f8_3C  0x60
  55E98CC8: 75                    mov        d1, (a1)
  55E98CC9: F1 E4                 ext_f1_E4  
  55E98CCB: CD A3 01 30 0C        call       sub_55E98E6E, [a2,a3], 12
  55E98CD0: CA 30                 bra        loc_55E98D00
loc_55E98CD2:
  55E98CD2: 9A                    mov        a2, a2
  55E98CD3: 2C F1 66              mov        0x66F1, d0
  55E98CD6: 72                    mov        d0, (a2)
  55E98CD7: AC                    db_op_AC   0xAC
  55E98CD8: C7 26                 bls        loc_55E98CFE
  55E98CDA: 95                    mov        a1, a1
  55E98CDB: 20 F1                 add        -15, d0
  55E98CDD: 65                    mov        (a1), d1
  55E98CDE: F0 01                 ext_f0_01  
  55E98CE0: F0 1C                 ext_f0_1C  
  55E98CE2: 71                    mov        d0, (a1)
  55E98CE3: F1 E4                 ext_f1_E4  
  55E98CE5: F8 20 28              ext_f8_20  0x28
  55E98CE8: F1 90                 ext_f1_90  
  55E98CEA: C9 09                 bne        loc_55E98CF3
  55E98CEC: F1 E4                 ext_f1_E4  
  55E98CEE: F8 00 1C              ext_f8_00  0x1C
  55E98CF1: CA 04                 bra        loc_55E98CF5
loc_55E98CF3:
  55E98CF3: 28 04                 cmp        0x04, d0
loc_55E98CF5:
  55E98CF5: 61                    mov        (a1), d0
  55E98CF6: 72                    mov        d0, (a2)
  55E98CF7: 85                    mov        d1, d1
  55E98CF8: 01                    db_op_01   0x01
  55E98CF9: F1 04                 ext_f1_04  
  55E98CFB: 62                    mov        (a2), d0
  55E98CFC: CA 04                 bra        loc_55E98D00
loc_55E98CFE:
  55E98CFE: 8F                    mov        d3, d3
  55E98CFF: CE CD                 movm       (sp), [d2,d3,other,exreg0,exother]
  55E98D01: B6                    db_op_B6   0xB6
  55E98D02: F1 00                 ext_f1_00  
  55E98D04: 00                    db_op_00   0x00
loc_55E98D05:
  55E98D05: 8C                    mov        d3, d0
  55E98D06: DF F0 14              ret        [d2,d3,a2,a3], 20

; --- Function sub_55E98D09 (callers: 8) ---
sub_55E98D09:
  55E98D09: 93 73                 mov        0x73, a3
  55E98D0B: F1 9C                 ext_f1_9C  
  55E98D0D: C8 16                 beq        loc_55E98D23
  55E98D0F: F8 65 08              ext_f8_65  0x08
  55E98D12: 19                    db_op_19   0x19
  55E98D13: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E98D14: F0 0B                 ext_f0_0B  
  55E98D16: F8 62 08              ext_f8_62  0x08
  55E98D19: 18                    db_op_18   0x18
  55E98D1A: A1                    db_op_A1   0xA1
  55E98D1B: C0 08                 blt        loc_55E98D23
  55E98D1D: F0 0F                 ext_f0_0F  
  55E98D1F: 73                    mov        d0, (a3)
  55E98D20: F1 90                 ext_f1_90  
  55E98D22: D9                    lbne       
loc_55E98D23:
  55E98D23: 73                    mov        d0, (a3)
  55E98D24: 61                    mov        (a1), d0
  55E98D25: F8 3D 04              ext_f8_3D  0x04
  55E98D28: F0 0B                 ext_f0_0B  
  55E98D2A: F8 36 04              ext_f8_36  0x04
  55E98D2D: F0 17                 ext_f0_17  
  55E98D2F: DE 30 08              retf       [a2,a3], 8

; --- Function sub_55E98D32 (callers: 6) ---
sub_55E98D32:
  55E98D32: F8 60 08              ext_f8_60  0x08
  55E98D35: FC A1 F4 F3 08 54     mov        (0x5408F3F4), d1
  55E98D3B: 18                    db_op_18   0x18
  55E98D3C: F8 C0 03              ext_f8_C0  0x03
  55E98D3F: FC C0 68 88 07 54     ext_fc_C0  0x54078868
  55E98D45: F1 A1                 ext_f1_A1  
  55E98D47: C7 08                 bls        loc_55E98D4F
  55E98D49: FC 81 F4 F3 08 54     mov        d1, (0x5408F3F4)
loc_55E98D4F:
  55E98D4F: 60                    mov        (a0), d0
  55E98D50: F1 E2                 ext_f1_E2  
  55E98D52: 52                    db_op_52   0x52
  55E98D53: F0 06                 ext_f0_06  
  55E98D55: F8 34 04              ext_f8_34  0x04
  55E98D58: F0 11                 ext_f0_11  
  55E98D5A: F0 12                 ext_f0_12  
  55E98D5C: DE 20 04              retf       [a2], 4

; --- Function sub_55E98D5F (callers: 1) ---
sub_55E98D5F:
  55E98D5F: FC A0 F8 F3 08 54     mov        (0x5408F3F8), d0
  55E98D65: F8 60 30              ext_f8_60  0x30
  55E98D68: A0                    db_op_A0   0xA0
  55E98D69: 01                    db_op_01   0x01
  55E98D6A: C9 05                 bne        loc_55E98D6F
  55E98D6C: 00                    db_op_00   0x00
  55E98D6D: CA 0B                 bra        loc_55E98D78
loc_55E98D6F:
  55E98D6F: F1 D0                 ext_f1_D0  
  55E98D71: 90 38                 mov        0x38, a0
  55E98D73: F1 60                 ext_f1_60  
  55E98D75: 70                    mov        d0, (a0)
  55E98D76: 04                    db_op_04   0x04
  55E98D77: 64                    mov        (a0), d1
loc_55E98D78:
  55E98D78: DE 00 00              retf       [], 0

; --- Function sub_55E98D7B (callers: 1) ---
sub_55E98D7B:
  55E98D7B: 3C 20                 mov        d0, (32, sp)
  55E98D7D: 10                    db_op_10   0x10
  55E98D7E: 43 08                 mov        a3, (8, sp)
  55E98D80: 82 CD                 mov        0xCD, d2
  55E98D82: 71                    mov        d0, (a1)
  55E98D83: F1 00                 ext_f1_00  
  55E98D85: 00                    db_op_00   0x00
  55E98D86: FC A4 F8 F3 08 54     movbu      (0x5408F3F8), d0
  55E98D8C: 9F                    mov        a3, a3
  55E98D8D: 38                    db_op_38   0x38
  55E98D8E: 28 30                 cmp        0x30, d0
  55E98D90: 42 04                 mov        a2, (4, sp)
  55E98D92: FC A7 F8 F3 08 54     movbu      (0x5408F3F8), d3
  55E98D98: FC A4 F8 F3 08 54     movbu      (0x5408F3F8), d0
  55E98D9E: 2B 34                 cmp        0x34, d3
  55E98DA0: 28 48                 cmp        0x48, d0
  55E98DA2: 42 0C                 mov        a2, (12, sp)
  55E98DA4: FC A4 F8 F3 08 54     movbu      (0x5408F3F8), d0
  55E98DAA: F1 63                 ext_f1_63  
loc_55E98DAC:
  55E98DAC: 5C 04                 mov        (4, sp), a0
  55E98DAE: 80 01                 mov        0x01, d0
  55E98DB0: F0 70                 ext_f0_70  
  55E98DB2: F1 EC                 ext_f1_EC  
  55E98DB4: F0 08                 ext_f0_08  
  55E98DB6: 58 10                 mov        (16, sp), d0
  55E98DB8: CD 4E F1 00 00        call       sub_55E97F06, [], 0
  55E98DBD: 5C 0C                 mov        (12, sp), a0
  55E98DBF: 88                    mov        d2, d0
  55E98DC0: 74                    mov        d1, (a0)
  55E98DC1: F0 F2                 calls      (a2)
  55E98DC3: 5C 08                 mov        (8, sp), a0
  55E98DC5: CD 2D F1 00 00        call       sub_55E97EF2, [], 0
  55E98DCA: F1 EC                 ext_f1_EC  
  55E98DCC: 70                    mov        d0, (a0)
  55E98DCD: A0                    db_op_A0   0xA0
  55E98DCE: 00                    db_op_00   0x00
  55E98DCF: C8 0E                 beq        loc_55E98DDD
  55E98DD1: 5C 04                 mov        (4, sp), a0
  55E98DD3: 00                    db_op_00   0x00
  55E98DD4: F0 70                 ext_f0_70  
  55E98DD6: 7B                    mov        d2, (a3)
  55E98DD7: A2                    db_op_A2   0xA2
  55E98DD8: C8 05                 beq        loc_55E98DDD
  55E98DDA: 63                    mov        (a3), d0
  55E98DDB: CA D1                 bra        loc_55E98DAC
loc_55E98DDD:
  55E98DDD: 58 10                 mov        (16, sp), d0
  55E98DDF: CD 27 F1 00 00        call       sub_55E97F06, [], 0
  55E98DE4: DF F0 24              ret        [d2,d3,a2,a3], 36

; --- Function sub_55E98DE7 (callers: 6) ---
sub_55E98DE7:
  55E98DE7: 46                    db_op_46   0x46
  55E98DE8: 04                    db_op_04   0x04
  55E98DE9: 04                    db_op_04   0x04
  55E98DEA: F8 14 40              ext_f8_14  0x40
  55E98DED: F8 65 02              ext_f8_65  0x02
  55E98DF0: 14                    db_op_14   0x14
  55E98DF1: F8 74 0E              ext_f8_74  0x0E
  55E98DF4: F0 65                 ext_f0_65  
  55E98DF6: F1 D2                 ext_f1_D2  
  55E98DF8: F8 74 12              ext_f8_74  0x12
  55E98DFB: 85                    mov        d1, d1
  55E98DFC: 04                    db_op_04   0x04
  55E98DFD: F8 74 0C              ext_f8_74  0x0C
  55E98E00: 85                    mov        d1, d1
  55E98E01: 01                    db_op_01   0x01
  55E98E02: F2 01                 ext_f2_01  
  55E98E04: F8 54 17              ext_f8_54  0x17
  55E98E07: 59 04                 mov        (4, sp), d1
  55E98E09: F8 EC 01              ext_f8_EC  0x01
  55E98E0C: F8 14 5C              ext_f8_14  0x5C
  55E98E0F: F0 0C                 ext_f0_0C  
  55E98E11: 50                    db_op_50   0x50
  55E98E12: F0 08                 ext_f0_08  
  55E98E14: F8 3B 04              ext_f8_3B  0x04
  55E98E17: F0 1E                 ext_f0_1E  
  55E98E19: C8 0D                 beq        loc_55E98E26
  55E98E1B: 5C 04                 mov        (4, sp), a0
  55E98E1D: F1 E9                 ext_f1_E9  
  55E98E1F: CD EA FE 30 08        call       sub_55E98D09, [a2,a3], 8
  55E98E24: CA 10                 bra        loc_55E98E34
loc_55E98E26:
  55E98E26: 58 04                 mov        (4, sp), d0
  55E98E28: F1 E9                 ext_f1_E9  
  55E98E2A: 61                    mov        (a1), d0
  55E98E2B: 5F 04                 mov        (4, sp), a3
  55E98E2D: 53                    db_op_53   0x53
  55E98E2E: F0 0B                 ext_f0_0B  
  55E98E30: F0 18                 ext_f0_18  
  55E98E32: 6A                    mov        (a2), d2
  55E98E33: 6B                    mov        (a3), d2
loc_55E98E34:
  55E98E34: CD BF 11 A0 0C        call       sub_55E99FF3, [d2,a2], 12
  55E98E39: DF B0 14              ret        [d2,a2,a3], 20

; --- Function sub_55E98E3C (callers: 1) ---
sub_55E98E3C:
  55E98E3C: 04                    db_op_04   0x04
  55E98E3D: F8 14 40              ext_f8_14  0x40
  55E98E40: F8 70 0E              ext_f8_70  0x0E
  55E98E43: 95                    mov        a1, a1
  55E98E44: 12                    db_op_12   0x12
  55E98E45: F1 71                 ext_f1_71  
  55E98E47: F0 61                 ext_f0_61  
  55E98E49: 93 F0                 mov        0xF0, a3
  55E98E4B: 71                    mov        d0, (a1)
  55E98E4C: 80 04                 mov        0x04, d0
  55E98E4E: F8 70 0C              ext_f8_70  0x0C
  55E98E51: 00                    db_op_00   0x00
  55E98E52: F8 50 17              ext_f8_50  0x17
  55E98E55: F8 10 5C              ext_f8_10  0x5C
  55E98E58: F0 08                 ext_f0_08  
  55E98E5A: 53                    db_op_53   0x53
  55E98E5B: F0 07                 ext_f0_07  
  55E98E5D: F8 36 04              ext_f8_36  0x04
  55E98E60: F0 19                 ext_f0_19  
  55E98E62: F0 10                 ext_f0_10  
  55E98E64: F0 13                 ext_f0_13  
  55E98E66: CD 8D 11 A0 0C        call       sub_55E99FF3, [d2,a2], 12
  55E98E6B: DF 30 0C              ret        [a2,a3], 12

; --- Function sub_55E98E6E (callers: 6) ---
sub_55E98E6E:
  55E98E6E: F8 10 40              ext_f8_10  0x40
  55E98E71: 95                    mov        a1, a1
  55E98E72: 24 F1 71              mov        0x71F1, a0
  55E98E75: 71                    mov        d0, (a1)
  55E98E76: A0                    db_op_A0   0xA0
  55E98E77: 00                    db_op_00   0x00
  55E98E78: C8 12                 beq        loc_55E98E8A
  55E98E7A: 00                    db_op_00   0x00
  55E98E7B: 61                    mov        (a1), d0
  55E98E7C: 95                    mov        a1, a1
  55E98E7D: 1C                    db_op_1C   0x1C
  55E98E7E: F1 71                 ext_f1_71  
  55E98E80: F0 09                 ext_f0_09  
  55E98E82: F8 25 04              ext_f8_25  0x04
  55E98E85: F8 36 04              ext_f8_36  0x04
  55E98E88: F0 19                 ext_f0_19  
loc_55E98E8A:
  55E98E8A: 93 F0                 mov        0xF0, a3
  55E98E8C: 08                    db_op_08   0x08
  55E98E8D: 53                    db_op_53   0x53
  55E98E8E: F0 07                 ext_f0_07  
  55E98E90: F8 36 04              ext_f8_36  0x04
  55E98E93: F0 19                 ext_f0_19  
  55E98E95: 95                    mov        a1, a1
  55E98E96: 0C                    db_op_0C   0x0C
  55E98E97: F1 71                 ext_f1_71  
  55E98E99: F0 61                 ext_f0_61  
  55E98E9B: A0                    db_op_A0   0xA0
  55E98E9C: 0C                    db_op_0C   0x0C
  55E98E9D: C9 0C                 bne        loc_55E98EA9
  55E98E9F: 80 08                 mov        0x08, d0
  55E98EA1: F0 71                 ext_f0_71  
  55E98EA3: F0 10                 ext_f0_10  
  55E98EA5: F0 13                 ext_f0_13  
  55E98EA7: CA 10                 bra        loc_55E98EB7
loc_55E98EA9:
  55E98EA9: 80 02                 mov        0x02, d0
  55E98EAB: F0 71                 ext_f0_71  
  55E98EAD: CD 85 FE 20 04        call       sub_55E98D32, [a2], 4
  55E98EB2: CD 41 11 A0 0C        call       sub_55E99FF3, [d2,a2], 12
loc_55E98EB7:
  55E98EB7: DF 30 0C              ret        [a2,a3], 12

; --- Function sub_55E98EBA (callers: 8) ---
sub_55E98EBA:
  55E98EBA: F8 10 40              ext_f8_10  0x40
  55E98EBD: 95                    mov        a1, a1
  55E98EBE: 24 F1 71              mov        0x71F1, a0
  55E98EC1: 71                    mov        d0, (a1)
  55E98EC2: A0                    db_op_A0   0xA0
  55E98EC3: 00                    db_op_00   0x00
  55E98EC4: C8 12                 beq        loc_55E98ED6
  55E98EC6: 00                    db_op_00   0x00
  55E98EC7: 61                    mov        (a1), d0
  55E98EC8: 95                    mov        a1, a1
  55E98EC9: 1C                    db_op_1C   0x1C
  55E98ECA: F1 71                 ext_f1_71  
  55E98ECC: F0 09                 ext_f0_09  
  55E98ECE: F8 25 04              ext_f8_25  0x04
  55E98ED1: F8 36 04              ext_f8_36  0x04
  55E98ED4: F0 19                 ext_f0_19  
loc_55E98ED6:
  55E98ED6: 93 F0                 mov        0xF0, a3
  55E98ED8: 08                    db_op_08   0x08
  55E98ED9: 53                    db_op_53   0x53
  55E98EDA: F0 07                 ext_f0_07  
  55E98EDC: F8 36 04              ext_f8_36  0x04
  55E98EDF: F0 19                 ext_f0_19  
  55E98EE1: 95                    mov        a1, a1
  55E98EE2: 0C                    db_op_0C   0x0C
  55E98EE3: F1 71                 ext_f1_71  
  55E98EE5: F0 61                 ext_f0_61  
  55E98EE7: A0                    db_op_A0   0xA0
  55E98EE8: 0C                    db_op_0C   0x0C
  55E98EE9: C9 0C                 bne        loc_55E98EF5
  55E98EEB: 80 08                 mov        0x08, d0
  55E98EED: F0 71                 ext_f0_71  
  55E98EEF: F0 10                 ext_f0_10  
  55E98EF1: F0 13                 ext_f0_13  
  55E98EF3: CA 0B                 bra        loc_55E98EFE
loc_55E98EF5:
  55E98EF5: 80 02                 mov        0x02, d0
  55E98EF7: F0 71                 ext_f0_71  
  55E98EF9: CD 39 FE 20 04        call       sub_55E98D32, [a2], 4
loc_55E98EFE:
  55E98EFE: DF 30 0C              ret        [a2,a3], 12

; --- Function sub_55E98F01 (callers: 1) ---
sub_55E98F01:
  55E98F01: 95                    mov        a1, a1
  55E98F02: 0C                    db_op_0C   0x0C
  55E98F03: F1 71                 ext_f1_71  
  55E98F05: F0 61                 ext_f0_61  
  55E98F07: A0                    db_op_A0   0xA0
  55E98F08: 04                    db_op_04   0x04
  55E98F09: C9 08                 bne        loc_55E98F11
  55E98F0B: 80 0C                 mov        0x0C, d0
  55E98F0D: F0 71                 ext_f0_71  
  55E98F0F: CA 1F                 bra        loc_55E98F2E
loc_55E98F11:
  55E98F11: F8 EC 03              ext_f8_EC  0x03
  55E98F14: C8 1A                 beq        loc_55E98F2E
  55E98F16: 80 08                 mov        0x08, d0
  55E98F18: F0 71                 ext_f0_71  
  55E98F1A: F0 08                 ext_f0_08  
  55E98F1C: 93 53                 mov        0x53, a3
  55E98F1E: F0 07                 ext_f0_07  
  55E98F20: F8 36 04              ext_f8_36  0x04
  55E98F23: F0 19                 ext_f0_19  
  55E98F25: F0 10                 ext_f0_10  
  55E98F27: F0 13                 ext_f0_13  
  55E98F29: CD CA 10 A0 0C        call       sub_55E99FF3, [d2,a2], 12
loc_55E98F2E:
  55E98F2E: DF 30 0C              ret        [a2,a3], 12

; --- Function sub_55E98F31 (callers: 1) ---
sub_55E98F31:
  55E98F31: 95                    mov        a1, a1
  55E98F32: 0C                    db_op_0C   0x0C
  55E98F33: F1 71                 ext_f1_71  
  55E98F35: F0 61                 ext_f0_61  
  55E98F37: A0                    db_op_A0   0xA0
  55E98F38: 0C                    db_op_0C   0x0C
  55E98F39: C9 08                 bne        loc_55E98F41
  55E98F3B: 80 04                 mov        0x04, d0
  55E98F3D: F0 71                 ext_f0_71  
  55E98F3F: CA 10                 bra        loc_55E98F4F
loc_55E98F41:
  55E98F41: 80 02                 mov        0x02, d0
  55E98F43: F0 71                 ext_f0_71  
  55E98F45: CD ED FD 20 04        call       sub_55E98D32, [a2], 4
  55E98F4A: CD A9 10 A0 0C        call       sub_55E99FF3, [d2,a2], 12
loc_55E98F4F:
  55E98F4F: DF 00 04              ret        [], 4
  55E98F52: 93 90                 mov        0x90, a3
  55E98F54: 28 F1                 cmp        0xF1, d0
  55E98F56: 7C                    mov        d3, (a0)
  55E98F57: 83 70                 mov        0x70, d3
  55E98F59: F1 90                 ext_f1_90  
  55E98F5B: C8 1C                 beq        loc_55E98F77
  55E98F5D: 90 14                 mov        0x14, a0
  55E98F5F: F1 60                 ext_f1_60  
  55E98F61: F0 40                 ext_f0_40  
  55E98F63: A0                    db_op_A0   0xA0
  55E98F64: 03                    db_op_03   0x03
  55E98F65: C8 06                 beq        loc_55E98F6B
  55E98F67: A0                    db_op_A0   0xA0
  55E98F68: 02                    db_op_02   0x02
  55E98F69: C9 0E                 bne        loc_55E98F77
loc_55E98F6B:
  55E98F6B: F8 67 08              ext_f8_67  0x08
  55E98F6E: 8C                    mov        d3, d0
  55E98F6F: 19                    db_op_19   0x19
  55E98F70: 18                    db_op_18   0x18
  55E98F71: A1                    db_op_A1   0xA1
  55E98F72: C2 05                 bge        loc_55E98F77
  55E98F74: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E98F77:
  55E98F77: F8 7F 08              ext_f8_7F  0x08
  55E98F7A: 90 0C                 mov        0x0C, a0
  55E98F7C: F1 7C                 ext_f1_7C  
  55E98F7E: F0 60                 ext_f0_60  
  55E98F80: F8 EC 03              ext_f8_EC  0x03
  55E98F83: C8 15                 beq        loc_55E98F98
  55E98F85: F0 07                 ext_f0_07  
  55E98F87: F8 23 04              ext_f8_23  0x04
  55E98F8A: F8 31 04              ext_f8_31  0x04
  55E98F8D: F0 14                 ext_f0_14  
  55E98F8F: 9C                    mov        a3, a0
  55E98F90: CD A2 FD 20 04        call       sub_55E98D32, [a2], 4
  55E98F95: CC 77 01              jmp        loc_55E9910C
loc_55E98F98:
  55E98F98: F8 EC 04              ext_f8_EC  0x04
  55E98F9B: C9 05                 bne        loc_55E98FA0
  55E98F9D: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E98FA0:
  55E98FA0: 9A                    mov        a2, a2
  55E98FA1: 0E                    db_op_0E   0x0E
  55E98FA2: F1 7E                 ext_f1_7E  
  55E98FA4: F0 62                 ext_f0_62  
  55E98FA6: FA C8 00 01           bxx16      loc_55E990A6
  55E98FAA: C9 66                 bne        loc_55E99010
  55E98FAC: 90 12                 mov        0x12, a0
  55E98FAE: F1 7C                 ext_f1_7C  
  55E98FB0: F0 60                 ext_f0_60  
  55E98FB2: FC A6 30 F4 08 54     movbu      (0x5408F430), d2
  55E98FB8: 18                    db_op_18   0x18
  55E98FB9: 85                    mov        d1, d1
  55E98FBA: 38                    db_op_38   0x38
  55E98FBB: F2 44                 ext_f2_44  
  55E98FBD: E8                    add        d2, d0
  55E98FBE: F1 E1                 ext_f1_E1  
  55E98FC0: F8 65 C8              ext_f8_65  0xC8
  55E98FC3: 9A                    mov        a2, a2
  55E98FC4: 00                    db_op_00   0x00
  55E98FC5: A5                    db_op_A5   0xA5
  55E98FC6: 00                    db_op_00   0x00
  55E98FC7: C8 12                 beq        loc_55E98FD9
  55E98FC9: F0 60                 ext_f0_60  
  55E98FCB: 85                    mov        d1, d1
  55E98FCC: 38                    db_op_38   0x38
  55E98FCD: 18                    db_op_18   0x18
  55E98FCE: F2 44                 ext_f2_44  
  55E98FD0: E2                    add        d0, d2
  55E98FD1: FC DE C8 FF FF FF     mov        0xFFFFFFC8, a2
  55E98FD7: F1 6A                 ext_f1_6A  
loc_55E98FD9:
  55E98FD9: F8 42 14              ext_f8_42  0x14
  55E98FDC: F8 EC 01              ext_f8_EC  0x01
  55E98FDF: C9 05                 bne        loc_55E98FE4
  55E98FE1: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E98FE4:
  55E98FE4: F8 27 04              ext_f8_27  0x04
  55E98FE7: 8A                    mov        d2, d2
  55E98FE8: 04                    db_op_04   0x04
  55E98FE9: F1 5A                 ext_f1_5A  
  55E98FEB: F1 E8                 ext_f1_E8  
  55E98FED: 7C                    mov        d3, (a0)
  55E98FEE: F0 03                 ext_f0_03  
  55E98FF0: F8 34 04              ext_f8_34  0x04
  55E98FF3: F0 11                 ext_f0_11  
  55E98FF5: F8 23 5C              ext_f8_23  0x5C
  55E98FF8: 9D                    mov        a3, a1
  55E98FF9: CD 10 FD 30 08        call       sub_55E98D09, [a2,a3], 8
  55E98FFE: F1 E8                 ext_f1_E8  
  55E99000: 70                    mov        d0, (a0)
  55E99001: A3                    db_op_A3   0xA3
  55E99002: C9 05                 bne        loc_55E99007
  55E99004: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E99007:
  55E99007: 98                    mov        a2, a0
  55E99008: CD 1B 03 30 0C        call       sub_55E99323, [a2,a3], 12
  55E9900D: CC FF 00              jmp        loc_55E9910C
loc_55E99010:
  55E99010: FA C8 00 40           bxx16      loc_55E9D010
  55E99014: C9 67                 bne        loc_55E9907B
  55E99016: 95                    mov        a1, a1
  55E99017: 12                    db_op_12   0x12
  55E99018: F1 7D                 ext_f1_7D  
  55E9901A: F0 61                 ext_f0_61  
  55E9901C: FC A5 3C F4 08 54     movbu      (0x5408F43C), d1
  55E99022: 18                    db_op_18   0x18
  55E99023: 8A                    mov        d2, d2
  55E99024: 24 F2 42              mov        0x42F2, a0
  55E99027: F1 E8                 ext_f1_E8  
  55E99029: F1 64                 ext_f1_64  
  55E9902B: F8 60 DC              ext_f8_60  0xDC
  55E9902E: 9A                    mov        a2, a2
  55E9902F: 00                    db_op_00   0x00
  55E99030: A0                    db_op_A0   0xA0
  55E99031: 00                    db_op_00   0x00
  55E99032: C8 12                 beq        loc_55E99044
  55E99034: F0 61                 ext_f0_61  
  55E99036: 8A                    mov        d2, d2
  55E99037: 24 18 F2              mov        0xF218, a0
  55E9903A: 48                    db_op_48   0x48
  55E9903B: E1                    add        d0, d1
  55E9903C: FC DE DC FF FF FF     mov        0xFFFFFFDC, a2
  55E99042: F1 66                 ext_f1_66  
loc_55E99044:
  55E99044: F8 42 0C              ext_f8_42  0x0C
  55E99047: F8 EC 01              ext_f8_EC  0x01
  55E9904A: C9 05                 bne        loc_55E9904F
  55E9904C: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E9904F:
  55E9904F: F8 27 04              ext_f8_27  0x04
  55E99052: 8A                    mov        d2, d2
  55E99053: 04                    db_op_04   0x04
  55E99054: F1 5A                 ext_f1_5A  
  55E99056: F1 E8                 ext_f1_E8  
  55E99058: 7C                    mov        d3, (a0)
  55E99059: F0 03                 ext_f0_03  
  55E9905B: F8 34 04              ext_f8_34  0x04
  55E9905E: F0 11                 ext_f0_11  
  55E99060: F8 23 5C              ext_f8_23  0x5C
  55E99063: 9D                    mov        a3, a1
  55E99064: CD A5 FC 30 08        call       sub_55E98D09, [a2,a3], 8
  55E99069: F1 E8                 ext_f1_E8  
  55E9906B: 70                    mov        d0, (a0)
  55E9906C: A3                    db_op_A3   0xA3
  55E9906D: C9 05                 bne        loc_55E99072
  55E9906F: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E99072:
  55E99072: 98                    mov        a2, a0
  55E99073: CD 09 03 F0 14        call       sub_55E9937C, [d2,d3,a2,a3], 20
  55E99078: CC 94 00              jmp        loc_55E9910C
loc_55E9907B:
  55E9907B: 8A                    mov        d2, d2
  55E9907C: 17                    db_op_17   0x17
  55E9907D: F1 5E                 ext_f1_5E  
  55E9907F: F1 E8                 ext_f1_E8  
  55E99081: F0 40                 ext_f0_40  
  55E99083: A0                    db_op_A0   0xA0
  55E99084: 00                    db_op_00   0x00
  55E99085: C9 05                 bne        loc_55E9908A
  55E99087: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E9908A:
  55E9908A: F0 07                 ext_f0_07  
  55E9908C: F8 23 04              ext_f8_23  0x04
  55E9908F: F8 31 04              ext_f8_31  0x04
  55E99092: F0 14                 ext_f0_14  
  55E99094: F8 23 5C              ext_f8_23  0x5C
  55E99097: 9D                    mov        a3, a1
  55E99098: CD 71 FC 30 08        call       sub_55E98D09, [a2,a3], 8
  55E9909D: F0 62                 ext_f0_62  
  55E9909F: FA C8 80 00           bxx16      loc_55E9911F
  55E990A3: C8 05                 beq        loc_55E990A8
  55E990A5: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E990A8:
  55E990A8: F1 E8                 ext_f1_E8  
  55E990AA: F0 40                 ext_f0_40  
  55E990AC: A0                    db_op_A0   0xA0
  55E990AD: 02                    db_op_02   0x02
  55E990AE: C9 63                 bne        loc_55E99111
  55E990B0: 23 12                 add        18, d3
  55E990B2: F0 63                 ext_f0_63  
  55E990B4: FC A5 2C F4 08 54     movbu      (0x5408F42C), d1
  55E990BA: 18                    db_op_18   0x18
  55E990BB: 8A                    mov        d2, d2
  55E990BC: 1C                    db_op_1C   0x1C
  55E990BD: F2 48                 ext_f2_48  
  55E990BF: E4                    add        d1, d0
  55E990C0: F1 E0                 ext_f1_E0  
  55E990C2: F8 68 EC              ext_f8_68  0xEC
  55E990C5: 00                    db_op_00   0x00
  55E990C6: A2                    db_op_A2   0xA2
  55E990C7: C8 0D                 beq        loc_55E990D4
  55E990C9: F0 63                 ext_f0_63  
  55E990CB: 8A                    mov        d2, d2
  55E990CC: 1C                    db_op_1C   0x1C
  55E990CD: 18                    db_op_18   0x18
  55E990CE: F2 48                 ext_f2_48  
  55E990D0: E1                    add        d0, d1
  55E990D1: 80 E4                 mov        0xE4, d0
  55E990D3: E4                    add        d1, d0
loc_55E990D4:
  55E990D4: 95                    mov        a1, a1
  55E990D5: 18                    db_op_18   0x18
  55E990D6: F1 61                 ext_f1_61  
  55E990D8: F0 61                 ext_f0_61  
  55E990DA: FC A0 18 F4 08 54     mov        (0x5408F418), d0
  55E990E0: 18                    db_op_18   0x18
  55E990E1: 85                    mov        d1, d1
  55E990E2: 70                    mov        d0, (a0)
  55E990E3: F2 44                 ext_f2_44  
  55E990E5: F1 50                 ext_f1_50  
  55E990E7: F1 E2                 ext_f1_E2  
  55E990E9: F8 6A A0              ext_f8_6A  0xA0
  55E990EC: 04                    db_op_04   0x04
  55E990ED: A6                    db_op_A6   0xA6
  55E990EE: C8 0E                 beq        loc_55E990FC
  55E990F0: F0 61                 ext_f0_61  
  55E990F2: 85                    mov        d1, d1
  55E990F3: 70                    mov        d0, (a0)
  55E990F4: 18                    db_op_18   0x18
  55E990F5: F2 44                 ext_f2_44  
  55E990F7: F1 D1                 ext_f1_D1  
  55E990F9: E1                    add        d0, d1
  55E990FA: 29 90                 cmp        0x90, d1
loc_55E990FC:
  55E990FC: F1 E4                 ext_f1_E4  
  55E990FE: F8 68 08              ext_f8_68  0x08
  55E99101: 1B                    db_op_1B   0x1B
  55E99102: 1A                    db_op_1A   0x1A
  55E99103: AE                    db_op_AE   0xAE
  55E99104: C3 0D                 ble        loc_55E99111
  55E99106: 8C                    mov        d3, d0
  55E99107: CD 0D 00 F0 18        call       sub_55E99114, [d2,d3,a2,a3], 24
loc_55E9910C:
  55E9910C: CD E7 0E A0 0C        call       sub_55E99FF3, [d2,a2], 12
loc_55E99111:
  55E99111: DF F0 14              ret        [d2,d3,a2,a3], 20

; --- Function sub_55E99114 (callers: 1) ---
sub_55E99114:
  55E99114: 91 83                 mov        0x83, a1
  55E99116: 1B                    db_op_1B   0x1B
  55E99117: 4E                    db_op_4E   0x4E
  55E99118: 04                    db_op_04   0x04
loc_55E99119:
  55E99119: F8 7D 08              ext_f8_7D  0x08
  55E9911C: 90 0C                 mov        0x0C, a0
  55E9911E: F1 74                 ext_f1_74  
  55E99120: F0 60                 ext_f0_60  
  55E99122: F8 EC 04              ext_f8_EC  0x04
  55E99125: C9 05                 bne        loc_55E9912A
  55E99127: CC 8A 00              jmp        loc_55E991B1
loc_55E9912A:
  55E9912A: F8 61 0E              ext_f8_61  0x0E
  55E9912D: FA C8 80 00           bxx16      loc_55E991AD
  55E99131: C8 04                 beq        loc_55E99135
  55E99133: CA 7E                 bra        loc_55E991B1
loc_55E99135:
  55E99135: F8 41 17              ext_f8_41  0x17
  55E99138: A0                    db_op_A0   0xA0
  55E99139: 02                    db_op_02   0x02
  55E9913A: C9 77                 bne        loc_55E991B1
  55E9913C: 90 12                 mov        0x12, a0
  55E9913E: F1 74                 ext_f1_74  
  55E99140: F0 60                 ext_f0_60  
  55E99142: FC A5 2C F4 08 54     movbu      (0x5408F42C), d1
  55E99148: 18                    db_op_18   0x18
  55E99149: 8A                    mov        d2, d2
  55E9914A: 1C                    db_op_1C   0x1C
  55E9914B: F2 48                 ext_f2_48  
  55E9914D: E4                    add        d1, d0
  55E9914E: F1 E2                 ext_f1_E2  
  55E99150: F8 6A EC              ext_f8_6A  0xEC
  55E99153: 00                    db_op_00   0x00
  55E99154: A2                    db_op_A2   0xA2
  55E99155: C8 0D                 beq        loc_55E99162
  55E99157: F0 60                 ext_f0_60  
  55E99159: 8A                    mov        d2, d2
  55E9915A: 1C                    db_op_1C   0x1C
  55E9915B: 18                    db_op_18   0x18
  55E9915C: F2 48                 ext_f2_48  
  55E9915E: E1                    add        d0, d1
  55E9915F: 80 E4                 mov        0xE4, d0
  55E99161: E4                    add        d1, d0
loc_55E99162:
  55E99162: 90 18                 mov        0x18, a0
  55E99164: F1 60                 ext_f1_60  
  55E99166: F0 60                 ext_f0_60  
  55E99168: FC A6 18 F4 08 54     movbu      (0x5408F418), d2
  55E9916E: 18                    db_op_18   0x18
  55E9916F: 85                    mov        d1, d1
  55E99170: 70                    mov        d0, (a0)
  55E99171: F2 44                 ext_f2_44  
  55E99173: E8                    add        d2, d0
  55E99174: F1 E2                 ext_f1_E2  
  55E99176: F8 66 A0              ext_f8_66  0xA0
  55E99179: 9F                    mov        a3, a3
  55E9917A: 00                    db_op_00   0x00
  55E9917B: A5                    db_op_A5   0xA5
  55E9917C: 00                    db_op_00   0x00
  55E9917D: C8 12                 beq        loc_55E9918F
  55E9917F: F0 60                 ext_f0_60  
  55E99181: 85                    mov        d1, d1
  55E99182: 70                    mov        d0, (a0)
  55E99183: 18                    db_op_18   0x18
  55E99184: F2 44                 ext_f2_44  
  55E99186: E2                    add        d0, d2
  55E99187: FC DF 90 FF FF FF     mov        0xFFFFFF90, a3
  55E9918D: F1 6B                 ext_f1_6B  
loc_55E9918F:
  55E9918F: F0 09                 ext_f0_09  
  55E99191: F8 21 04              ext_f8_21  0x04
  55E99194: F8 32 04              ext_f8_32  0x04
  55E99197: F0 18                 ext_f0_18  
  55E99199: F8 21 5C              ext_f8_21  0x5C
  55E9919C: CD 6D FB 30 08        call       sub_55E98D09, [a2,a3], 8
  55E991A1: F8 63 08              ext_f8_63  0x08
  55E991A4: 59 04                 mov        (4, sp), d1
  55E991A6: 18                    db_op_18   0x18
  55E991A7: A4                    db_op_A4   0xA4
  55E991A8: C1 05                 bgt        loc_55E991AD
  55E991AA: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E991AD:
  55E991AD: 9D                    mov        a3, a1
  55E991AE: CC 6B FF              jmp        loc_55E99119
loc_55E991B1:
  55E991B1: F0 60                 ext_f0_60  
  55E991B3: F8 EC 03              ext_f8_EC  0x03
  55E991B6: C8 15                 beq        loc_55E991CB
  55E991B8: F0 01                 ext_f0_01  
  55E991BA: F8 29 04              ext_f8_29  0x04
  55E991BD: F8 38 04              ext_f8_38  0x04
  55E991C0: F0 12                 ext_f0_12  
  55E991C2: 94                    mov        a1, a0
  55E991C3: CD 6F FB 20 04        call       sub_55E98D32, [a2], 4
  55E991C8: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E991CB:
  55E991CB: A0                    db_op_A0   0xA0
  55E991CC: 08                    db_op_08   0x08
  55E991CD: C9 05                 bne        loc_55E991D2
  55E991CF: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E991D2:
  55E991D2: 9A                    mov        a2, a2
  55E991D3: 0E                    db_op_0E   0x0E
  55E991D4: F1 76                 ext_f1_76  
  55E991D6: F0 62                 ext_f0_62  
  55E991D8: FA C8 00 01           bxx16      loc_55E992D8
  55E991DC: C9 66                 bne        loc_55E99242
  55E991DE: 9A                    mov        a2, a2
  55E991DF: 12                    db_op_12   0x12
  55E991E0: F1 76                 ext_f1_76  
  55E991E2: F0 62                 ext_f0_62  
  55E991E4: FC A5 30 F4 08 54     movbu      (0x5408F430), d1
  55E991EA: 18                    db_op_18   0x18
  55E991EB: 8A                    mov        d2, d2
  55E991EC: 38                    db_op_38   0x38
  55E991ED: F2 42                 ext_f2_42  
  55E991EF: F1 E8                 ext_f1_E8  
  55E991F1: F1 64                 ext_f1_64  
  55E991F3: F8 60 C8              ext_f8_60  0xC8
  55E991F6: 9F                    mov        a3, a3
  55E991F7: 00                    db_op_00   0x00
  55E991F8: A0                    db_op_A0   0xA0
  55E991F9: 00                    db_op_00   0x00
  55E991FA: C8 12                 beq        loc_55E9920C
  55E991FC: F0 62                 ext_f0_62  
  55E991FE: 8A                    mov        d2, d2
  55E991FF: 38                    db_op_38   0x38
  55E99200: 18                    db_op_18   0x18
  55E99201: F2 48                 ext_f2_48  
  55E99203: E1                    add        d0, d1
  55E99204: FC DF C8 FF FF FF     mov        0xFFFFFFC8, a3
  55E9920A: F1 67                 ext_f1_67  
loc_55E9920C:
  55E9920C: F8 43 14              ext_f8_43  0x14
  55E9920F: F8 EC 01              ext_f8_EC  0x01
  55E99212: C9 05                 bne        loc_55E99217
  55E99214: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E99217:
  55E99217: F0 09                 ext_f0_09  
  55E99219: 8A                    mov        d2, d2
  55E9921A: 04                    db_op_04   0x04
  55E9921B: F1 5E                 ext_f1_5E  
  55E9921D: F1 E8                 ext_f1_E8  
  55E9921F: 7C                    mov        d3, (a0)
  55E99220: F8 21 04              ext_f8_21  0x04
  55E99223: F8 32 04              ext_f8_32  0x04
  55E99226: F0 18                 ext_f0_18  
  55E99228: F8 21 5C              ext_f8_21  0x5C
  55E9922B: CD DE FA 30 08        call       sub_55E98D09, [a2,a3], 8
  55E99230: F1 E8                 ext_f1_E8  
  55E99232: 70                    mov        d0, (a0)
  55E99233: A3                    db_op_A3   0xA3
  55E99234: C9 05                 bne        loc_55E99239
  55E99236: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E99239:
  55E99239: 9C                    mov        a3, a0
  55E9923A: CD E9 00 30 0C        call       sub_55E99323, [a2,a3], 12
  55E9923F: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E99242:
  55E99242: FA C8 00 40           bxx16      loc_55E9D242
  55E99246: C9 5F                 bne        loc_55E992A5
  55E99248: 9A                    mov        a2, a2
  55E99249: 12                    db_op_12   0x12
  55E9924A: F1 76                 ext_f1_76  
  55E9924C: F0 62                 ext_f0_62  
  55E9924E: FC A5 3C F4 08 54     movbu      (0x5408F43C), d1
  55E99254: 18                    db_op_18   0x18
  55E99255: 8A                    mov        d2, d2
  55E99256: 24 F2 42              mov        0x42F2, a0
  55E99259: F1 E8                 ext_f1_E8  
  55E9925B: F1 64                 ext_f1_64  
  55E9925D: F8 60 DC              ext_f8_60  0xDC
  55E99260: 9F                    mov        a3, a3
  55E99261: 00                    db_op_00   0x00
  55E99262: A0                    db_op_A0   0xA0
  55E99263: 00                    db_op_00   0x00
  55E99264: C8 12                 beq        loc_55E99276
  55E99266: F0 62                 ext_f0_62  
  55E99268: 8A                    mov        d2, d2
  55E99269: 24 18 F2              mov        0xF218, a0
  55E9926C: 48                    db_op_48   0x48
  55E9926D: E1                    add        d0, d1
  55E9926E: FC DF DC FF FF FF     mov        0xFFFFFFDC, a3
  55E99274: F1 67                 ext_f1_67  
loc_55E99276:
  55E99276: F8 43 0C              ext_f8_43  0x0C
  55E99279: F8 EC 01              ext_f8_EC  0x01
  55E9927C: C8 42                 beq        loc_55E992BE
  55E9927E: F0 09                 ext_f0_09  
  55E99280: 8A                    mov        d2, d2
  55E99281: 04                    db_op_04   0x04
  55E99282: F1 5E                 ext_f1_5E  
  55E99284: F1 E8                 ext_f1_E8  
  55E99286: 7C                    mov        d3, (a0)
  55E99287: F8 21 04              ext_f8_21  0x04
  55E9928A: F8 32 04              ext_f8_32  0x04
  55E9928D: F0 18                 ext_f0_18  
  55E9928F: F8 21 5C              ext_f8_21  0x5C
  55E99292: CD 77 FA 30 08        call       sub_55E98D09, [a2,a3], 8
  55E99297: F1 E8                 ext_f1_E8  
  55E99299: 70                    mov        d0, (a0)
  55E9929A: A3                    db_op_A3   0xA3
  55E9929B: C8 23                 beq        loc_55E992BE
  55E9929D: 9C                    mov        a3, a0
  55E9929E: CD DE 00 F0 14        call       sub_55E9937C, [d2,d3,a2,a3], 20
  55E992A3: CA 1B                 bra        loc_55E992BE
loc_55E992A5:
  55E992A5: F8 41 17              ext_f8_41  0x17
  55E992A8: A0                    db_op_A0   0xA0
  55E992A9: 00                    db_op_00   0x00
  55E992AA: C8 14                 beq        loc_55E992BE
  55E992AC: F0 01                 ext_f0_01  
  55E992AE: F8 29 04              ext_f8_29  0x04
  55E992B1: F8 38 04              ext_f8_38  0x04
  55E992B4: F0 12                 ext_f0_12  
  55E992B6: F8 21 5C              ext_f8_21  0x5C
  55E992B9: CD 50 FA 30 08        call       sub_55E98D09, [a2,a3], 8
loc_55E992BE:
  55E992BE: DF F0 18              ret        [d2,d3,a2,a3], 24

; --- Function sub_55E992C1 (callers: 2) ---
sub_55E992C1:
  55E992C1: 42 04                 mov        a2, (4, sp)
  55E992C3: 47                    db_op_47   0x47
  55E992C4: 0C                    db_op_0C   0x0C
  55E992C5: F1 D4                 ext_f1_D4  
  55E992C7: 28 24                 cmp        0x24, d0
  55E992C9: 42 10                 mov        a2, (16, sp)
  55E992CB: 92 F1                 mov        0xF1, a2
  55E992CD: E0                    add        d0, d0
  55E992CE: F8 01 20              ext_f8_01  0x20
  55E992D1: F0 0C                 ext_f0_0C  
  55E992D3: 42 08                 mov        a2, (8, sp)
  55E992D5: F8 09 2C              ext_f8_09  0x2C
loc_55E992D8:
  55E992D8: 58 04                 mov        (4, sp), d0
  55E992DA: F1 1E                 ext_f1_1E  
  55E992DC: A2                    db_op_A2   0xA2
  55E992DD: C7 0F                 bls        loc_55E992EC
  55E992DF: 9C                    mov        a3, a0
  55E992E0: 99                    mov        a2, a1
  55E992E1: CD 64 15 80 04        call       sub_55E9A845, [d2], 4
  55E992E6: 58 04                 mov        (4, sp), d0
  55E992E8: F1 5C                 ext_f1_5C  
  55E992EA: CA 29                 bra        loc_55E99313
loc_55E992EC:
  55E992EC: A2                    db_op_A2   0xA2
  55E992ED: C9 0D                 bne        loc_55E992FA
  55E992EF: 99                    mov        a2, a1
  55E992F0: 9C                    mov        a3, a0
  55E992F1: CD 54 15 80 04        call       sub_55E9A845, [d2], 4
  55E992F6: 58 08                 mov        (8, sp), d0
  55E992F8: CA 1B                 bra        loc_55E99313
loc_55E992FA:
  55E992FA: 83 F1                 mov        0xF1, d3
  55E992FC: 0B                    db_op_0B   0x0B
  55E992FD: 99                    mov        a2, a1
  55E992FE: 88                    mov        d2, d0
  55E992FF: 9C                    mov        a3, a0
  55E99300: CD 45 15 80 04        call       sub_55E9A845, [d2], 4
  55E99305: 5C 08                 mov        (8, sp), a0
  55E99307: F1 6A                 ext_f1_6A  
  55E99309: 8C                    mov        d3, d0
  55E9930A: 99                    mov        a2, a1
  55E9930B: CD 3A 15 80 04        call       sub_55E9A845, [d2], 4
  55E99310: 58 08                 mov        (8, sp), d0
  55E99312: EC                    add        d3, d0
loc_55E99313:
  55E99313: 5C 10                 mov        (16, sp), a0
  55E99315: 60                    mov        (a0), d0
  55E99316: 5E 0C                 mov        (12, sp), a2
  55E99318: 59 04                 mov        (4, sp), d1
  55E9931A: 22 30                 add        48, d2
  55E9931C: 72                    mov        d0, (a2)
  55E9931D: F1 04                 ext_f1_04  
  55E9931F: 62                    mov        (a2), d0
  55E99320: DF F0 24              ret        [d2,d3,a2,a3], 36

; --- Function sub_55E99323 (callers: 4) ---
sub_55E99323:
  55E99323: 93 9E                 mov        0x9E, a3
  55E99325: 52                    db_op_52   0x52
  55E99326: 72                    mov        d0, (a2)
  55E99327: F1 98                 ext_f1_98  
  55E99329: C8 23                 beq        loc_55E9934C
loc_55E9932B:
  55E9932B: F0 02                 ext_f0_02  
  55E9932D: F8 24 64              ext_f8_24  0x64
  55E99330: F8 00 60              ext_f8_00  0x60
  55E99333: 9C                    mov        a3, a0
  55E99334: CD 1B 00 B0 14        call       sub_55E9934F, [d2,a2,a3], 20
  55E99339: 14                    db_op_14   0x14
  55E9933A: A0                    db_op_A0   0xA0
  55E9933B: 01                    db_op_01   0x01
  55E9933C: C9 10                 bne        loc_55E9934C
  55E9933E: 72                    mov        d0, (a2)
  55E9933F: F1 E0                 ext_f1_E0  
  55E99341: 00                    db_op_00   0x00
  55E99342: CD 78 FB 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E99347: 72                    mov        d0, (a2)
  55E99348: F1 98                 ext_f1_98  
  55E9934A: C9 E1                 bne        loc_55E9932B
loc_55E9934C:
  55E9934C: DF 30 0C              ret        [a2,a3], 12

; --- Function sub_55E9934F (callers: 1) ---
sub_55E9934F:
  55E9934F: 42 04                 mov        a2, (4, sp)
  55E99351: 92 F8                 mov        0xF8, a2
  55E99353: 0A                    db_op_0A   0x0A
  55E99354: 30                    db_op_30   0x30
  55E99355: 59 04                 mov        (4, sp), d1
  55E99357: 97                    mov        a1, a3
  55E99358: 29 04                 cmp        0x04, d1
  55E9935A: 00                    db_op_00   0x00
  55E9935B: A9                    db_op_A9   0xA9
  55E9935C: C5 1C                 bhi        loc_55E99378
  55E9935E: 3C 50                 mov        d0, (80, sp)
  55E99360: 99                    mov        a2, a1
  55E99361: 80 04                 mov        0x04, d0
  55E99363: CD 5E FF F0 24        call       sub_55E992C1, [d2,d3,a2,a3], 36
  55E99368: 58 04                 mov        (4, sp), d0
  55E9936A: 99                    mov        a2, a1
  55E9936B: 9C                    mov        a3, a0
  55E9936C: CD 55 FF F0 24        call       sub_55E992C1, [d2,d3,a2,a3], 36
  55E99371: 22 34                 add        52, d2
  55E99373: 72                    mov        d0, (a2)
  55E99374: 40 62                 mov        a0, (98, sp)
  55E99376: 80 01                 mov        0x01, d0
loc_55E99378:
  55E99378: 14                    db_op_14   0x14
  55E99379: DF B0 14              ret        [d2,a2,a3], 20

; --- Function sub_55E9937C (callers: 4) ---
sub_55E9937C:
  55E9937C: F1 D3                 ext_f1_D3  
  55E9937E: 8A                    mov        d2, d2
  55E9937F: 04                    db_op_04   0x04
  55E99380: EE                    add        d3, d2
  55E99381: F1 E8                 ext_f1_E8  
  55E99383: F0 08                 ext_f0_08  
  55E99385: B2                    db_op_B2   0xB2
  55E99386: C8 40                 beq        loc_55E993C6
loc_55E99388:
  55E99388: 9F                    mov        a3, a3
  55E99389: 60                    mov        (a0), d0
  55E9938A: F1 7B                 ext_f1_7B  
  55E9938C: 73                    mov        d0, (a3)
  55E9938D: F1 EC                 ext_f1_EC  
  55E9938F: CD 3A 00 80 08        call       sub_55E993C9, [d2], 8
  55E99394: F1 D0                 ext_f1_D0  
  55E99396: A0                    db_op_A0   0xA0
  55E99397: 00                    db_op_00   0x00
  55E99398: C8 2E                 beq        loc_55E993C6
  55E9939A: F8 27 04              ext_f8_27  0x04
  55E9939D: 85                    mov        d1, d1
  55E9939E: 14                    db_op_14   0x14
  55E9939F: 61                    mov        (a1), d0
  55E993A0: F1 ED                 ext_f1_ED  
  55E993A2: F1 04                 ext_f1_04  
  55E993A4: F1 E0                 ext_f1_E0  
  55E993A6: F0 61                 ext_f0_61  
  55E993A8: F8 70 10              ext_f8_70  0x10
  55E993AB: F8 62 10              ext_f8_62  0x10
  55E993AE: F8 70 12              ext_f8_70  0x12
  55E993B1: 98                    mov        a2, a0
  55E993B2: 00                    db_op_00   0x00
  55E993B3: CD 07 FB 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E993B8: F8 02 40              ext_f8_02  0x40
  55E993BB: A0                    db_op_A0   0xA0
  55E993BC: 00                    db_op_00   0x00
  55E993BD: C9 09                 bne        loc_55E993C6
  55E993BF: F1 E8                 ext_f1_E8  
  55E993C1: F0 08                 ext_f0_08  
  55E993C3: B2                    db_op_B2   0xB2
  55E993C4: C9 C4                 bne        loc_55E99388
loc_55E993C6:
  55E993C6: DF F0 14              ret        [d2,d3,a2,a3], 20

; --- Function sub_55E993C9 (callers: 1) ---
sub_55E993C9:
  55E993C9: F8 08 20              ext_f8_08  0x20
  55E993CC: 85                    mov        d1, d1
  55E993CD: 18                    db_op_18   0x18
  55E993CE: F1 51                 ext_f1_51  
  55E993D0: A6                    db_op_A6   0xA6
  55E993D1: C9 06                 bne        loc_55E993D7
  55E993D3: 90 00                 mov        0x00, a0
  55E993D5: CA 07                 bra        loc_55E993DC
loc_55E993D7:
  55E993D7: CD 08 00 F0 10        call       sub_55E993DF, [d2,d3,a2,a3], 16
loc_55E993DC:
  55E993DC: DF 80 08              ret        [d2], 8

; --- Function sub_55E993DF (callers: 1) ---
sub_55E993DF:
  55E993DF: 28 18                 cmp        0x18, d0
  55E993E1: 85                    mov        d1, d1
  55E993E2: 01                    db_op_01   0x01
  55E993E3: F1 04                 ext_f1_04  
  55E993E5: FC E0 FC FF FF FF     ext_fc_E0  0xFFFFFFFC
  55E993EB: 9F                    mov        a3, a3
  55E993EC: 18                    db_op_18   0x18
  55E993ED: F1 73                 ext_f1_73  
  55E993EF: 9E                    mov        a3, a2
  55E993F0: 8F                    mov        d3, d3
  55E993F1: 20 F1                 add        -15, d0
  55E993F3: 53                    db_op_53   0x53
  55E993F4: F1 EC                 ext_f1_EC  
  55E993F6: F0 00                 nop2       
loc_55E993F8:
  55E993F8: BC                    db_op_BC   0xBC
  55E993F9: C9 06                 bne        loc_55E993FF
  55E993FB: 90 00                 mov        0x00, a0
  55E993FD: CA 4E                 bra        loc_55E9944B
loc_55E993FF:
  55E993FF: 95                    mov        a1, a1
  55E99400: 0C                    db_op_0C   0x0C
  55E99401: F1 71                 ext_f1_71  
  55E99403: 79                    mov        d2, (a1)
  55E99404: F1 02                 ext_f1_02  
  55E99406: AA                    db_op_AA   0xAA
  55E99407: 00                    db_op_00   0x00
  55E99408: C2 08                 bge        loc_55E99410
  55E9940A: 92 F8                 mov        0xF8, a2
  55E9940C: 20 08                 add        8, d0
  55E9940E: CA EA                 bra        loc_55E993F8
loc_55E99410:
  55E99410: AA                    db_op_AA   0xAA
  55E99411: 18                    db_op_18   0x18
  55E99412: C4 20                 bcs        loc_55E99432
  55E99414: 69                    mov        (a1), d2
  55E99415: F1 D1                 ext_f1_D1  
  55E99417: E9                    add        d2, d1
  55E99418: F1 E6                 ext_f1_E6  
  55E9941A: F8 12 0C              ext_f8_12  0x0C
  55E9941D: 70                    mov        d0, (a0)
  55E9941E: 62                    mov        (a2), d0
  55E9941F: 64                    mov        (a0), d1
  55E99420: F0 06                 ext_f0_06  
  55E99422: 00                    db_op_00   0x00
  55E99423: F8 15 04              ext_f8_15  0x04
  55E99426: F8 32 04              ext_f8_32  0x04
  55E99429: F8 12 08              ext_f8_12  0x08
  55E9942C: 90 14                 mov        0x14, a0
  55E9942E: F1 64                 ext_f1_64  
  55E99430: CA 1B                 bra        loc_55E9944B
loc_55E99432:
  55E99432: BE                    db_op_BE   0xBE
  55E99433: C9 0C                 bne        loc_55E9943F
  55E99435: 95                    mov        a1, a1
  55E99436: 08                    db_op_08   0x08
  55E99437: F1 71                 ext_f1_71  
  55E99439: 71                    mov        d0, (a1)
  55E9943A: F1 EE                 ext_f1_EE  
  55E9943C: 62                    mov        (a2), d0
  55E9943D: CA 0A                 bra        loc_55E99447
loc_55E9943F:
  55E9943F: 95                    mov        a1, a1
  55E99440: 08                    db_op_08   0x08
  55E99441: F1 71                 ext_f1_71  
  55E99443: 71                    mov        d0, (a1)
  55E99444: F8 12 08              ext_f8_12  0x08
loc_55E99447:
  55E99447: 00                    db_op_00   0x00
  55E99448: 61                    mov        (a1), d0
  55E99449: 20 14                 add        20, d0
loc_55E9944B:
  55E9944B: DE F0 10              retf       [d2,d3,a2,a3], 16

; --- Function sub_55E9944E (callers: 3) ---
sub_55E9944E:
  55E9944E: 87                    mov        d1, d3
  55E9944F: 82 1A                 mov        0x1A, d2
  55E99451: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E99457: 85                    mov        d1, d1
  55E99458: 01                    db_op_01   0x01
  55E99459: A0                    db_op_A0   0xA0
  55E9945A: 00                    db_op_00   0x00
  55E9945B: C9 03                 bne        loc_55E9945E
  55E9945D: 04                    db_op_04   0x04
loc_55E9945E:
  55E9945E: A5                    db_op_A5   0xA5
  55E9945F: 01                    db_op_01   0x01
  55E99460: C8 0C                 beq        loc_55E9946C
  55E99462: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E99468: A5                    db_op_A5   0xA5
  55E99469: 01                    db_op_01   0x01
  55E9946A: C9 06                 bne        loc_55E99470
loc_55E9946C:
  55E9946C: 8A                    mov        d2, d2
  55E9946D: E7                    add        d1, d3
  55E9946E: CA 6C                 bra        loc_55E994DA
loc_55E99470:
  55E99470: AA                    db_op_AA   0xAA
  55E99471: 01                    db_op_01   0x01
  55E99472: C0 0C                 blt        loc_55E9947E
  55E99474: FC AD A6 B3 E9 55     movhu      (0x55E9B3A6), d1
  55E9947A: 19                    db_op_19   0x19
  55E9947B: A6                    db_op_A6   0xA6
  55E9947C: C3 0A                 ble        loc_55E99486
loc_55E9947E:
  55E9947E: AA                    db_op_AA   0xAA
  55E9947F: 00                    db_op_00   0x00
  55E99480: C8 06                 beq        loc_55E99486
  55E99482: 8A                    mov        d2, d2
  55E99483: EE                    add        d3, d2
  55E99484: CA 56                 bra        loc_55E994DA
loc_55E99486:
  55E99486: AF                    db_op_AF   0xAF
  55E99487: 00                    db_op_00   0x00
  55E99488: C9 06                 bne        loc_55E9948E
  55E9948A: 8A                    mov        d2, d2
  55E9948B: EF                    add        d3, d3
  55E9948C: CA 4E                 bra        loc_55E994DA
loc_55E9948E:
  55E9948E: CD 0F EA 00 00        call       sub_55E97E9D, [], 0
  55E99493: FC A1 F8 F3 08 54     mov        (0x5408F3F8), d1
  55E99499: AA                    db_op_AA   0xAA
  55E9949A: 00                    db_op_00   0x00
  55E9949B: C8 1B                 beq        loc_55E994B6
  55E9949D: FC A4 18 F4 08 54     movbu      (0x5408F418), d0
  55E994A3: 85                    mov        d1, d1
  55E994A4: 70                    mov        d0, (a0)
  55E994A5: F2 46                 ext_f2_46  
  55E994A7: E8                    add        d2, d0
  55E994A8: 28 90                 cmp        0x90, d0
  55E994AA: F1 E0                 ext_f1_E0  
  55E994AC: F8 68 10              ext_f8_68  0x10
  55E994AF: AA                    db_op_AA   0xAA
  55E994B0: 00                    db_op_00   0x00
  55E994B1: C9 03                 bne        loc_55E994B4
  55E994B3: 00                    db_op_00   0x00
loc_55E994B4:
  55E994B4: F1 E1                 ext_f1_E1  
loc_55E994B6:
  55E994B6: 8A                    mov        d2, d2
  55E994B7: D6                    lbcc       
  55E994B8: B5                    db_op_B5   0xB5
  55E994B9: 00                    db_op_00   0x00
  55E994BA: C8 1B                 beq        loc_55E994D5
  55E994BC: F8 61 0C              ext_f8_61  0x0C
  55E994BF: A0                    db_op_A0   0xA0
  55E994C0: 10                    db_op_10   0x10
  55E994C1: C8 09                 beq        loc_55E994CA
  55E994C3: F8 21 34              ext_f8_21  0x34
  55E994C6: B0                    db_op_B0   0xB0
  55E994C7: 00                    db_op_00   0x00
  55E994C8: C9 06                 bne        loc_55E994CE
loc_55E994CA:
  55E994CA: 8A                    mov        d2, d2
  55E994CB: D7                    lbls       
  55E994CC: CA 09                 bra        loc_55E994D5
loc_55E994CE:
  55E994CE: 21 38                 add        56, d1
  55E994D0: 71                    mov        d0, (a1)
  55E994D1: 08                    db_op_08   0x08
  55E994D2: F2 1C                 ext_f2_1C  
  55E994D4: 61                    mov        (a1), d0
loc_55E994D5:
  55E994D5: CD E1 E9 00 00        call       sub_55E97EB6, [], 0
loc_55E994DA:
  55E994DA: 88                    mov        d2, d0
  55E994DB: DF C0 0C              ret        [d2,d3], 12

; --- Function sub_55E994DE (callers: 20) ---
sub_55E994DE:
  55E994DE: 92 82                 mov        0x82, a2
  55E994E0: 1A                    db_op_1A   0x1A
  55E994E1: 00                    db_op_00   0x00
  55E994E2: 42 08                 mov        a2, (8, sp)
  55E994E4: 85                    mov        d1, d1
  55E994E5: 01                    db_op_01   0x01
  55E994E6: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E994EC: A0                    db_op_A0   0xA0
  55E994ED: 00                    db_op_00   0x00
  55E994EE: C9 03                 bne        loc_55E994F1
  55E994F0: 04                    db_op_04   0x04
loc_55E994F1:
  55E994F1: A5                    db_op_A5   0xA5
  55E994F2: 01                    db_op_01   0x01
  55E994F3: C9 07                 bne        loc_55E994FA
  55E994F5: 80 E7                 mov        0xE7, d0
  55E994F7: DF F0 1C              ret        [d2,d3,a2,a3], 28
loc_55E994FA:
  55E994FA: AA                    db_op_AA   0xAA
  55E994FB: 01                    db_op_01   0x01
  55E994FC: C0 0C                 blt        loc_55E99508
  55E994FE: FC AD B2 B3 E9 55     movhu      (0x55E9B3B2), d1
  55E99504: 19                    db_op_19   0x19
  55E99505: A6                    db_op_A6   0xA6
  55E99506: C3 07                 ble        loc_55E9950D
loc_55E99508:
  55E99508: 80 EE                 mov        0xEE, d0
  55E9950A: DF F0 1C              ret        [d2,d3,a2,a3], 28
loc_55E9950D:
  55E9950D: CD 90 E9 00 00        call       sub_55E97E9D, [], 0
  55E99512: FC A5 24 F4 08 54     movbu      (0x5408F424), d1
  55E99518: 80 30                 mov        0x30, d0
  55E9951A: F2 42                 ext_f2_42  
  55E9951C: E9                    add        d2, d1
  55E9951D: 8F                    mov        d3, d3
  55E9951E: D0                    lblt       
  55E9951F: E7                    add        d1, d3
  55E99520: F1 EC                 ext_f1_EC  
  55E99522: F0 68                 ext_f0_68  
  55E99524: AA                    db_op_AA   0xAA
  55E99525: 00                    db_op_00   0x00
  55E99526: C9 03                 bne        loc_55E99529
  55E99528: 0C                    db_op_0C   0x0C
loc_55E99529:
  55E99529: AF                    db_op_AF   0xAF
  55E9952A: 00                    db_op_00   0x00
  55E9952B: C9 07                 bne        loc_55E99532
  55E9952D: 80 D6                 mov        0xD6, d0
  55E9952F: CC 9F 00              jmp        loc_55E995CE
loc_55E99532:
  55E99532: 9F                    mov        a3, a3
  55E99533: 2C F1 6F              mov        0x6FF1, d0
  55E99536: 77                    mov        d1, (a3)
  55E99537: 90 14                 mov        0x14, a0
  55E99539: F1 6C                 ext_f1_6C  
  55E9953B: 43 04                 mov        a3, (4, sp)
  55E9953D: F8 00 04              ext_f8_00  0x04
  55E99540: FC A6 F8 F3 08 54     movbu      (0x5408F3F8), d2
  55E99546: A1                    db_op_A1   0xA1
  55E99547: C8 51                 beq        loc_55E99598
  55E99549: 95                    mov        a1, a1
  55E9954A: 24 F1 6D              mov        0x6DF1, a0
  55E9954D: F0 01                 ext_f0_01  
  55E9954F: 8A                    mov        d2, d2
  55E99550: 28 70                 cmp        0x70, d0
  55E99552: EE                    add        d3, d2
  55E99553: 62                    mov        (a2), d0
  55E99554: 75                    mov        d1, (a1)
  55E99555: F1 E8                 ext_f1_E8  
  55E99557: 70                    mov        d0, (a0)
  55E99558: A1                    db_op_A1   0xA1
  55E99559: C9 09                 bne        loc_55E99562
  55E9955B: 5C 04                 mov        (4, sp), a0
  55E9955D: F8 00 08              ext_f8_00  0x08
  55E99560: CA 05                 bra        loc_55E99565
loc_55E99562:
  55E99562: 71                    mov        d0, (a1)
  55E99563: 28 04                 cmp        0x04, d0
loc_55E99565:
  55E99565: 61                    mov        (a1), d0
  55E99566: 73                    mov        d0, (a3)
  55E99567: F1 EE                 ext_f1_EE  
  55E99569: 40 63                 mov        a0, (99, sp)
  55E9956B: 52                    db_op_52   0x52
  55E9956C: 72                    mov        d0, (a2)
  55E9956D: F1 98                 ext_f1_98  
  55E9956F: C8 69                 beq        loc_55E995D8
  55E99571: F0 02                 ext_f0_02  
  55E99573: 95                    mov        a1, a1
  55E99574: 20 F8                 add        -8, d0
  55E99576: 00                    db_op_00   0x00
  55E99577: 60                    mov        (a0), d0
  55E99578: F1 6D                 ext_f1_6D  
  55E9957A: F0 01                 ext_f0_01  
  55E9957C: 60                    mov        (a0), d0
  55E9957D: 75                    mov        d1, (a1)
  55E9957E: F1 E8                 ext_f1_E8  
  55E99580: 70                    mov        d0, (a0)
  55E99581: A1                    db_op_A1   0xA1
  55E99582: C9 09                 bne        loc_55E9958B
  55E99584: 5C 04                 mov        (4, sp), a0
  55E99586: F8 00 08              ext_f8_00  0x08
  55E99589: CA 05                 bra        loc_55E9958E
loc_55E9958B:
  55E9958B: 71                    mov        d0, (a1)
  55E9958C: 28 04                 cmp        0x04, d0
loc_55E9958E:
  55E9958E: 61                    mov        (a1), d0
  55E9958F: 73                    mov        d0, (a3)
  55E99590: 85                    mov        d1, d1
  55E99591: 01                    db_op_01   0x01
  55E99592: F1 04                 ext_f1_04  
  55E99594: 63                    mov        (a3), d0
  55E99595: 76                    mov        d1, (a2)
  55E99596: CA 11                 bra        loc_55E995A7
loc_55E99598:
  55E99598: F1 ED                 ext_f1_ED  
  55E9959A: 51                    db_op_51   0x51
  55E9959B: 71                    mov        d0, (a1)
  55E9959C: F1 94                 ext_f1_94  
  55E9959E: C8 13                 beq        loc_55E995B1
  55E995A0: F0 01                 ext_f0_01  
  55E995A2: F8 00 60              ext_f8_00  0x60
  55E995A5: 62                    mov        (a2), d0
  55E995A6: 75                    mov        d1, (a1)
loc_55E995A7:
  55E995A7: F1 E4                 ext_f1_E4  
  55E995A9: 00                    db_op_00   0x00
  55E995AA: CD C4 F8 30 0C        call       sub_55E98E6E, [a2,a3], 12
  55E995AF: CA 29                 bra        loc_55E995D8
loc_55E995B1:
  55E995B1: F1 EC                 ext_f1_EC  
  55E995B3: F1 ED                 ext_f1_ED  
  55E995B5: 2B 0C                 cmp        0x0C, d3
  55E995B7: 8D                    mov        d3, d1
  55E995B8: 80 20                 mov        0x20, d0
  55E995BA: F8 70 02              ext_f8_70  0x02
  55E995BD: F1 E8                 ext_f1_E8  
  55E995BF: 00                    db_op_00   0x00
  55E995C0: CD 27 F8 B0 14        call       sub_55E98DE7, [d2,a2,a3], 20
  55E995C5: 90 40                 mov        0x40, a0
  55E995C7: F1 68                 ext_f1_68  
  55E995C9: 70                    mov        d0, (a0)
  55E995CA: A0                    db_op_A0   0xA0
  55E995CB: 00                    db_op_00   0x00
  55E995CC: C8 06                 beq        loc_55E995D2
loc_55E995CE:
  55E995CE: 42 08                 mov        a2, (8, sp)
  55E995D0: CA 08                 bra        loc_55E995D8
loc_55E995D2:
  55E995D2: F1 E8                 ext_f1_E8  
  55E995D4: F8 04 60              ext_f8_04  0x60
  55E995D7: 66                    mov        (a2), d1
loc_55E995D8:
  55E995D8: CD DE E8 00 00        call       sub_55E97EB6, [], 0
  55E995DD: 58 08                 mov        (8, sp), d0
  55E995DF: DF F0 1C              ret        [d2,d3,a2,a3], 28

; --- Function sub_55E995E2 (callers: 2) ---
sub_55E995E2:
  55E995E2: 92 82                 mov        0x82, a2
  55E995E4: 1A                    db_op_1A   0x1A
  55E995E5: 0C                    db_op_0C   0x0C
  55E995E6: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E995EC: 85                    mov        d1, d1
  55E995ED: 01                    db_op_01   0x01
  55E995EE: AC                    db_op_AC   0xAC
  55E995EF: C9 03                 bne        loc_55E995F2
  55E995F1: 8D                    mov        d3, d1
loc_55E995F2:
  55E995F2: A5                    db_op_A5   0xA5
  55E995F3: 01                    db_op_01   0x01
  55E995F4: C8 0C                 beq        loc_55E99600
  55E995F6: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E995FC: A5                    db_op_A5   0xA5
  55E995FD: 01                    db_op_01   0x01
  55E995FE: C9 06                 bne        loc_55E99604
loc_55E99600:
  55E99600: 8F                    mov        d3, d3
  55E99601: E7                    add        d1, d3
  55E99602: CA 6D                 bra        loc_55E9966F
loc_55E99604:
  55E99604: AA                    db_op_AA   0xAA
  55E99605: 01                    db_op_01   0x01
  55E99606: C0 0C                 blt        loc_55E99612
  55E99608: FC AD B2 B3 E9 55     movhu      (0x55E9B3B2), d1
  55E9960E: 19                    db_op_19   0x19
  55E9960F: A6                    db_op_A6   0xA6
  55E99610: C3 06                 ble        loc_55E99616
loc_55E99612:
  55E99612: 8F                    mov        d3, d3
  55E99613: EE                    add        d3, d2
  55E99614: CA 5B                 bra        loc_55E9966F
loc_55E99616:
  55E99616: CD 87 E8 00 00        call       sub_55E97E9D, [], 0
  55E9961B: FC A5 24 F4 08 54     movbu      (0x5408F424), d1
  55E99621: 80 30                 mov        0x30, d0
  55E99623: F2 42                 ext_f2_42  
  55E99625: E9                    add        d2, d1
  55E99626: 29 D0                 cmp        0xD0, d1
  55E99628: F1 E4                 ext_f1_E4  
  55E9962A: F0 68                 ext_f0_68  
  55E9962C: 91 AE                 mov        0xAE, a1
  55E9962E: C9 04                 bne        loc_55E99632
  55E99630: 95                    mov        a1, a1
  55E99631: 00                    db_op_00   0x00
loc_55E99632:
  55E99632: B5                    db_op_B5   0xB5
  55E99633: 00                    db_op_00   0x00
  55E99634: C9 06                 bne        loc_55E9963A
  55E99636: 8F                    mov        d3, d3
  55E99637: D6                    lbcc       
  55E99638: CA 32                 bra        loc_55E9966A
loc_55E9963A:
  55E9963A: 94                    mov        a1, a0
  55E9963B: 50                    db_op_50   0x50
  55E9963C: 70                    mov        d0, (a0)
  55E9963D: F1 90                 ext_f1_90  
  55E9963F: C8 09                 beq        loc_55E99648
  55E99641: F0 00                 nop2       
  55E99643: F8 60 10              ext_f8_60  0x10
  55E99646: CA 03                 bra        loc_55E99649
loc_55E99648:
  55E99648: 00                    db_op_00   0x00
loc_55E99649:
  55E99649: F0 72                 ext_f0_72  
  55E9964B: 90 0C                 mov        0x0C, a0
  55E9964D: F1 74                 ext_f1_74  
  55E9964F: 70                    mov        d0, (a0)
  55E99650: F1 90                 ext_f1_90  
  55E99652: C8 09                 beq        loc_55E9965B
  55E99654: F0 00                 nop2       
  55E99656: F8 60 10              ext_f8_60  0x10
  55E99659: CA 03                 bra        loc_55E9965C
loc_55E9965B:
  55E9965B: 00                    db_op_00   0x00
loc_55E9965C:
  55E9965C: F8 72 02              ext_f8_72  0x02
  55E9965F: F8 05 18              ext_f8_05  0x18
  55E99662: F8 09 2C              ext_f8_09  0x2C
  55E99665: F1 09                 ext_f1_09  
  55E99667: F8 16 04              ext_f8_16  0x04
loc_55E9966A:
  55E9966A: CD 4C E8 00 00        call       sub_55E97EB6, [], 0
loc_55E9966F:
  55E9966F: 8C                    mov        d3, d0
  55E99670: DF E0 10              ret        [d2,d3,a2], 16
  55E99673: 93 18                 mov        0x18, a3
  55E99675: 83 FC                 mov        0xFC, d3
  55E99677: AA                    db_op_AA   0xAA
  55E99678: 08                    db_op_08   0x08
  55E99679: F4 08                 ext_f4_08  
  55E9967B: 54                    db_op_54   0x54
  55E9967C: 85                    mov        d1, d1
  55E9967D: 01                    db_op_01   0x01
  55E9967E: AA                    db_op_AA   0xAA
  55E9967F: 00                    db_op_00   0x00
  55E99680: C9 03                 bne        loc_55E99683
  55E99682: 04                    db_op_04   0x04
loc_55E99683:
  55E99683: A5                    db_op_A5   0xA5
  55E99684: 01                    db_op_01   0x01
  55E99685: C8 0C                 beq        loc_55E99691
  55E99687: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9968D: A5                    db_op_A5   0xA5
  55E9968E: 01                    db_op_01   0x01
  55E9968F: C9 07                 bne        loc_55E99696
loc_55E99691:
  55E99691: 80 E7                 mov        0xE7, d0
  55E99693: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E99696:
  55E99696: 1B                    db_op_1B   0x1B
  55E99697: AF                    db_op_AF   0xAF
  55E99698: 01                    db_op_01   0x01
  55E99699: C0 0C                 blt        loc_55E996A5
  55E9969B: FC AD AA B3 E9 55     movhu      (0x55E9B3AA), d1
  55E996A1: 19                    db_op_19   0x19
  55E996A2: A7                    db_op_A7   0xA7
  55E996A3: C3 06                 ble        loc_55E996A9
loc_55E996A5:
  55E996A5: 80 EE                 mov        0xEE, d0
  55E996A7: CA 4A                 bra        loc_55E996F1
loc_55E996A9:
  55E996A9: CD F4 E7 00 00        call       sub_55E97E9D, [], 0
  55E996AE: FC A5 1C F4 08 54     movbu      (0x5408F41C), d1
  55E996B4: 80 1C                 mov        0x1C, d0
  55E996B6: F2 43                 ext_f2_43  
  55E996B8: ED                    add        d3, d1
  55E996B9: FC DD E4 FF FF FF     mov        0xFFFFFFE4, a1
  55E996BF: F1 65                 ext_f1_65  
  55E996C1: F0 61                 ext_f0_61  
  55E996C3: A0                    db_op_A0   0xA0
  55E996C4: 00                    db_op_00   0x00
  55E996C5: C9 04                 bne        loc_55E996C9
  55E996C7: 95                    mov        a1, a1
  55E996C8: 00                    db_op_00   0x00
loc_55E996C9:
  55E996C9: B5                    db_op_B5   0xB5
  55E996CA: 00                    db_op_00   0x00
  55E996CB: C9 0B                 bne        loc_55E996D6
  55E996CD: CD E9 E7 00 00        call       sub_55E97EB6, [], 0
  55E996D2: 80 D6                 mov        0xD6, d0
  55E996D4: CA 1D                 bra        loc_55E996F1
loc_55E996D6:
  55E996D6: 96                    mov        a1, a2
  55E996D7: 52                    db_op_52   0x52
  55E996D8: F0 02                 ext_f0_02  
  55E996DA: B8                    db_op_B8   0xB8
  55E996DB: C8 07                 beq        loc_55E996E2
  55E996DD: F8 60 10              ext_f8_60  0x10
  55E996E0: CA 03                 bra        loc_55E996E3
loc_55E996E2:
  55E996E2: 00                    db_op_00   0x00
loc_55E996E3:
  55E996E3: F0 73                 ext_f0_73  
  55E996E5: F8 01 18              ext_f8_01  0x18
  55E996E8: F8 13 04              ext_f8_13  0x04
  55E996EB: CD CB E7 00 00        call       sub_55E97EB6, [], 0
  55E996F0: 00                    db_op_00   0x00
loc_55E996F1:
  55E996F1: DF F0 14              ret        [d2,d3,a2,a3], 20

; --- Function sub_55E996F4 (callers: 1) ---
sub_55E996F4:
  55E996F4: 92 18                 mov        0x18, a2
  55E996F6: 83 FC                 mov        0xFC, d3
  55E996F8: AA                    db_op_AA   0xAA
  55E996F9: 08                    db_op_08   0x08
  55E996FA: F4 08                 ext_f4_08  
  55E996FC: 54                    db_op_54   0x54
  55E996FD: 85                    mov        d1, d1
  55E996FE: 01                    db_op_01   0x01
  55E996FF: AA                    db_op_AA   0xAA
  55E99700: 00                    db_op_00   0x00
  55E99701: C9 03                 bne        loc_55E99704
  55E99703: 04                    db_op_04   0x04
loc_55E99704:
  55E99704: A5                    db_op_A5   0xA5
  55E99705: 01                    db_op_01   0x01
  55E99706: C8 0C                 beq        loc_55E99712
  55E99708: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9970E: A5                    db_op_A5   0xA5
  55E9970F: 01                    db_op_01   0x01
  55E99710: C9 06                 bne        loc_55E99716
loc_55E99712:
  55E99712: 8A                    mov        d2, d2
  55E99713: E7                    add        d1, d3
  55E99714: CA 6B                 bra        loc_55E9977F
loc_55E99716:
  55E99716: 1B                    db_op_1B   0x1B
  55E99717: AF                    db_op_AF   0xAF
  55E99718: 01                    db_op_01   0x01
  55E99719: C0 0C                 blt        loc_55E99725
  55E9971B: FC AD A6 B3 E9 55     movhu      (0x55E9B3A6), d1
  55E99721: 19                    db_op_19   0x19
  55E99722: A7                    db_op_A7   0xA7
  55E99723: C3 0A                 ble        loc_55E9972D
loc_55E99725:
  55E99725: AF                    db_op_AF   0xAF
  55E99726: 00                    db_op_00   0x00
  55E99727: C8 06                 beq        loc_55E9972D
  55E99729: 8A                    mov        d2, d2
  55E9972A: EE                    add        d3, d2
  55E9972B: CA 54                 bra        loc_55E9977F
loc_55E9972D:
  55E9972D: CD 70 E7 00 00        call       sub_55E97E9D, [], 0
  55E99732: FC A0 F8 F3 08 54     mov        (0x5408F3F8), d0
  55E99738: AF                    db_op_AF   0xAF
  55E99739: 00                    db_op_00   0x00
  55E9973A: C8 1C                 beq        loc_55E99756
  55E9973C: FC A5 18 F4 08 54     movbu      (0x5408F418), d1
  55E99742: 80 70                 mov        0x70, d0
  55E99744: F2 43                 ext_f2_43  
  55E99746: ED                    add        d3, d1
  55E99747: 29 90                 cmp        0x90, d1
  55E99749: F1 E4                 ext_f1_E4  
  55E9974B: F8 68 10              ext_f8_68  0x10
  55E9974E: 84                    mov        d1, d0
  55E9974F: AA                    db_op_AA   0xAA
  55E99750: 00                    db_op_00   0x00
  55E99751: C9 03                 bne        loc_55E99754
  55E99753: 00                    db_op_00   0x00
loc_55E99754:
  55E99754: F1 E0                 ext_f1_E0  
loc_55E99756:
  55E99756: 8A                    mov        d2, d2
  55E99757: D6                    lbcc       
  55E99758: B0                    db_op_B0   0xB0
  55E99759: 00                    db_op_00   0x00
  55E9975A: C8 20                 beq        loc_55E9977A
  55E9975C: F8 60 0C              ext_f8_60  0x0C
  55E9975F: A0                    db_op_A0   0xA0
  55E99760: 10                    db_op_10   0x10
  55E99761: C8 09                 beq        loc_55E9976A
  55E99763: F8 24 34              ext_f8_24  0x34
  55E99766: B5                    db_op_B5   0xB5
  55E99767: 00                    db_op_00   0x00
  55E99768: C9 06                 bne        loc_55E9976E
loc_55E9976A:
  55E9976A: 8A                    mov        d2, d2
  55E9976B: D7                    lbls       
  55E9976C: CA 0E                 bra        loc_55E9977A
loc_55E9976E:
  55E9976E: F8 60 30              ext_f8_60  0x30
  55E99771: 08                    db_op_08   0x08
  55E99772: F0 72                 ext_f0_72  
  55E99774: F8 00 38              ext_f8_00  0x38
  55E99777: F8 12 04              ext_f8_12  0x04
loc_55E9977A:
  55E9977A: CD 3C E7 00 00        call       sub_55E97EB6, [], 0
loc_55E9977F:
  55E9977F: 88                    mov        d2, d0
  55E99780: DF E0 10              ret        [d2,d3,a2], 16

; --- Function sub_55E99783 (callers: 7) ---
sub_55E99783:
  55E99783: 43 04                 mov        a3, (4, sp)
  55E99785: 83 1B                 mov        0x1B, d3
  55E99787: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E9978D: 85                    mov        d1, d1
  55E9978E: 01                    db_op_01   0x01
  55E9978F: A0                    db_op_A0   0xA0
  55E99790: 00                    db_op_00   0x00
  55E99791: C9 03                 bne        loc_55E99794
  55E99793: 04                    db_op_04   0x04
loc_55E99794:
  55E99794: A5                    db_op_A5   0xA5
  55E99795: 01                    db_op_01   0x01
  55E99796: C8 0C                 beq        loc_55E997A2
  55E99798: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9979E: A5                    db_op_A5   0xA5
  55E9979F: 01                    db_op_01   0x01
  55E997A0: C9 07                 bne        loc_55E997A7
loc_55E997A2:
  55E997A2: 8A                    mov        d2, d2
  55E997A3: E7                    add        d1, d3
  55E997A4: CC C0 00              jmp        loc_55E99864
loc_55E997A7:
  55E997A7: AF                    db_op_AF   0xAF
  55E997A8: 01                    db_op_01   0x01
  55E997A9: C0 0C                 blt        loc_55E997B5
  55E997AB: FC AD C6 B3 E9 55     movhu      (0x55E9B3C6), d1
  55E997B1: 19                    db_op_19   0x19
  55E997B2: A7                    db_op_A7   0xA7
  55E997B3: C3 07                 ble        loc_55E997BA
loc_55E997B5:
  55E997B5: 8A                    mov        d2, d2
  55E997B6: EE                    add        d3, d2
  55E997B7: CC AD 00              jmp        loc_55E99864
loc_55E997BA:
  55E997BA: 92 F1                 mov        0xF1, a2
  55E997BC: D8                    lbeq       
  55E997BD: F8 E0 03              ext_f8_E0  0x03
  55E997C0: C8 07                 beq        loc_55E997C7
  55E997C2: 8A                    mov        d2, d2
  55E997C3: EF                    add        d3, d3
  55E997C4: CC A0 00              jmp        loc_55E99864
loc_55E997C7:
  55E997C7: CD D6 E6 00 00        call       sub_55E97E9D, [], 0
  55E997CC: FC A4 38 F4 08 54     movbu      (0x5408F438), d0
  55E997D2: 85                    mov        d1, d1
  55E997D3: 24 F2 47              mov        0x47F2, a0
  55E997D6: EC                    add        d3, d0
  55E997D7: FC DC DC FF FF FF     mov        0xFFFFFFDC, a0
  55E997DD: F1 60                 ext_f1_60  
  55E997DF: F0 60                 ext_f0_60  
  55E997E1: F1 D3                 ext_f1_D3  
  55E997E3: A0                    db_op_A0   0xA0
  55E997E4: 00                    db_op_00   0x00
  55E997E5: C9 03                 bne        loc_55E997E8
  55E997E7: 0C                    db_op_0C   0x0C
loc_55E997E8:
  55E997E8: 8A                    mov        d2, d2
  55E997E9: D6                    lbcc       
  55E997EA: AF                    db_op_AF   0xAF
  55E997EB: 00                    db_op_00   0x00
  55E997EC: C8 73                 beq        loc_55E9985F
  55E997EE: 90 0C                 mov        0x0C, a0
  55E997F0: F1 6C                 ext_f1_6C  
  55E997F2: F8 04 0C              ext_f8_04  0x0C
  55E997F5: F1 DA                 ext_f1_DA  
  55E997F7: 2A F8                 cmp        0xF8, d2
  55E997F9: F1 EB                 ext_f1_EB  
  55E997FB: 88                    mov        d2, d0
  55E997FC: F1 04                 ext_f1_04  
  55E997FE: F8 04 08              ext_f8_04  0x08
  55E99801: 08                    db_op_08   0x08
  55E99802: 29 08                 cmp        0x08, d1
  55E99804: F2 FA                 ext_f2_FA  
  55E99806: 82 F2                 mov        0xF2, d2
  55E99808: 76                    mov        d1, (a2)
  55E99809: F2 E2                 ext_f2_E2  
  55E9980B: AA                    db_op_AA   0xAA
  55E9980C: 00                    db_op_00   0x00
  55E9980D: C9 1B                 bne        loc_55E99828
  55E9980F: F8 08 04              ext_f8_08  0x04
  55E99812: 4E                    db_op_4E   0x4E
  55E99813: 08                    db_op_08   0x08
  55E99814: 0C                    db_op_0C   0x0C
  55E99815: F2 FE                 ext_f2_FE  
  55E99817: F2 74                 ext_f2_74  
  55E99819: 5B 08                 mov        (8, sp), d3
  55E9981B: A8                    db_op_A8   0xA8
  55E9981C: C6 0C                 bcc        loc_55E99828
  55E9981E: 9A                    mov        a2, a2
  55E9981F: 06                    db_op_06   0x06
  55E99820: F1 7E                 ext_f1_7E  
  55E99822: F0 62                 ext_f0_62  
  55E99824: A0                    db_op_A0   0xA0
  55E99825: 00                    db_op_00   0x00
  55E99826: C9 06                 bne        loc_55E9982C
loc_55E99828:
  55E99828: 8A                    mov        d2, d2
  55E99829: EF                    add        d3, d3
  55E9982A: CA 35                 bra        loc_55E9985F
loc_55E9982C:
  55E9982C: F1 ED                 ext_f1_ED  
  55E9982E: 51                    db_op_51   0x51
  55E9982F: F0 01                 ext_f0_01  
  55E99831: B4                    db_op_B4   0xB4
  55E99832: C8 1A                 beq        loc_55E9984C
  55E99834: F8 60 10              ext_f8_60  0x10
  55E99837: F0 72                 ext_f0_72  
  55E99839: F8 24 60              ext_f8_24  0x60
  55E9983C: 58 04                 mov        (4, sp), d0
  55E9983E: 61                    mov        (a1), d0
  55E9983F: 00                    db_op_00   0x00
  55E99840: CD 7A F6 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E99845: CD AE 07 A0 0C        call       sub_55E99FF3, [d2,a2], 12
  55E9984A: CA 14                 bra        loc_55E9985E
loc_55E9984C:
  55E9984C: 95                    mov        a1, a1
  55E9984D: 20 F1                 add        -15, d0
  55E9984F: 6D                    mov        (a1), d3
  55E99850: 71                    mov        d0, (a1)
  55E99851: 90 1C                 mov        0x1C, a0
  55E99853: 40 61                 mov        a0, (97, sp)
  55E99855: F1 6C                 ext_f1_6C  
  55E99857: 00                    db_op_00   0x00
  55E99858: F0 72                 ext_f0_72  
  55E9985A: 70                    mov        d0, (a0)
  55E9985B: 63                    mov        (a3), d0
  55E9985C: F0 1C                 ext_f0_1C  
loc_55E9985E:
  55E9985E: 08                    db_op_08   0x08
loc_55E9985F:
  55E9985F: CD 57 E6 00 00        call       sub_55E97EB6, [], 0
loc_55E99864:
  55E99864: 88                    mov        d2, d0
  55E99865: DF F0 1C              ret        [d2,d3,a2,a3], 28

; --- Function sub_55E99868 (callers: 2) ---
sub_55E99868:
  55E99868: 18                    db_op_18   0x18
  55E99869: 83 FC                 mov        0xFC, d3
  55E9986B: AA                    db_op_AA   0xAA
  55E9986C: 08                    db_op_08   0x08
  55E9986D: F4 08                 ext_f4_08  
  55E9986F: 54                    db_op_54   0x54
  55E99870: 85                    mov        d1, d1
  55E99871: 01                    db_op_01   0x01
  55E99872: AA                    db_op_AA   0xAA
  55E99873: 00                    db_op_00   0x00
  55E99874: C9 03                 bne        loc_55E99877
  55E99876: 04                    db_op_04   0x04
loc_55E99877:
  55E99877: A5                    db_op_A5   0xA5
  55E99878: 01                    db_op_01   0x01
  55E99879: C8 0C                 beq        loc_55E99885
  55E9987B: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E99881: A5                    db_op_A5   0xA5
  55E99882: 01                    db_op_01   0x01
  55E99883: C9 07                 bne        loc_55E9988A
loc_55E99885:
  55E99885: 80 E7                 mov        0xE7, d0
  55E99887: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E9988A:
  55E9988A: 1B                    db_op_1B   0x1B
  55E9988B: AF                    db_op_AF   0xAF
  55E9988C: 01                    db_op_01   0x01
  55E9988D: C0 0C                 blt        loc_55E99899
  55E9988F: FC AD A6 B3 E9 55     movhu      (0x55E9B3A6), d1
  55E99895: 19                    db_op_19   0x19
  55E99896: A7                    db_op_A7   0xA7
  55E99897: C3 07                 ble        loc_55E9989E
loc_55E99899:
  55E99899: 80 EE                 mov        0xEE, d0
  55E9989B: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E9989E:
  55E9989E: CD FF E5 00 00        call       sub_55E97E9D, [], 0
  55E998A3: FC A5 18 F4 08 54     movbu      (0x5408F418), d1
  55E998A9: 80 70                 mov        0x70, d0
  55E998AB: F2 43                 ext_f2_43  
  55E998AD: ED                    add        d3, d1
  55E998AE: FC DE 90 FF FF FF     mov        0xFFFFFF90, a2
  55E998B4: F1 66                 ext_f1_66  
  55E998B6: F8 62 10              ext_f8_62  0x10
  55E998B9: A0                    db_op_A0   0xA0
  55E998BA: 00                    db_op_00   0x00
  55E998BB: C9 04                 bne        loc_55E998BF
  55E998BD: 9A                    mov        a2, a2
  55E998BE: 00                    db_op_00   0x00
loc_55E998BF:
  55E998BF: BA                    db_op_BA   0xBA
  55E998C0: 00                    db_op_00   0x00
  55E998C1: C9 0C                 bne        loc_55E998CD
  55E998C3: CD F3 E5 00 00        call       sub_55E97EB6, [], 0
  55E998C8: 80 D6                 mov        0xD6, d0
  55E998CA: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E998CD:
  55E998CD: FC A0 F8 F3 08 54     mov        (0x5408F3F8), d0
  55E998D3: B2                    db_op_B2   0xB2
  55E998D4: C8 0A                 beq        loc_55E998DE
  55E998D6: F8 62 0C              ext_f8_62  0x0C
  55E998D9: F8 EC 04              ext_f8_EC  0x04
  55E998DC: C9 0C                 bne        loc_55E998E8
loc_55E998DE:
  55E998DE: CD D8 E5 00 00        call       sub_55E97EB6, [], 0
  55E998E3: 80 D7                 mov        0xD7, d0
  55E998E5: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E998E8:
  55E998E8: F8 6A 0E              ext_f8_6A  0x0E
  55E998EB: FA CA 00 01           bxx16      loc_55E999EB
  55E998EF: C9 2A                 bne        loc_55E99919
  55E998F1: 90 12                 mov        0x12, a0
  55E998F3: F1 78                 ext_f1_78  
  55E998F5: F0 60                 ext_f0_60  
  55E998F7: FC A5 30 F4 08 54     movbu      (0x5408F430), d1
  55E998FD: 18                    db_op_18   0x18
  55E998FE: 8F                    mov        d3, d3
  55E998FF: 38                    db_op_38   0x38
  55E99900: F2 4C                 ext_f2_4C  
  55E99902: E4                    add        d1, d0
  55E99903: F1 E1                 ext_f1_E1  
  55E99905: F8 6D C8              ext_f8_6D  0xC8
  55E99908: 00                    db_op_00   0x00
  55E99909: A3                    db_op_A3   0xA3
  55E9990A: C8 3C                 beq        loc_55E99946
  55E9990C: F0 60                 ext_f0_60  
  55E9990E: 8F                    mov        d3, d3
  55E9990F: 38                    db_op_38   0x38
  55E99910: 18                    db_op_18   0x18
  55E99911: F2 4C                 ext_f2_4C  
  55E99913: E1                    add        d0, d1
  55E99914: 80 C8                 mov        0xC8, d0
  55E99916: E4                    add        d1, d0
  55E99917: CA 2F                 bra        loc_55E99946
loc_55E99919:
  55E99919: FA CA 00 40           bxx16      loc_55E9D919
  55E9991D: C9 2E                 bne        loc_55E9994B
  55E9991F: 95                    mov        a1, a1
  55E99920: 12                    db_op_12   0x12
  55E99921: F1 79                 ext_f1_79  
  55E99923: F0 61                 ext_f0_61  
  55E99925: FC A7 3C F4 08 54     movbu      (0x5408F43C), d3
  55E9992B: 18                    db_op_18   0x18
  55E9992C: 85                    mov        d1, d1
  55E9992D: 24 F2 41              mov        0x41F2, a0
  55E99930: F1 E4                 ext_f1_E4  
  55E99932: F1 6C                 ext_f1_6C  
  55E99934: F8 64 DC              ext_f8_64  0xDC
  55E99937: 00                    db_op_00   0x00
  55E99938: A1                    db_op_A1   0xA1
  55E99939: C8 0D                 beq        loc_55E99946
  55E9993B: F0 61                 ext_f0_61  
  55E9993D: 85                    mov        d1, d1
  55E9993E: 24 18 F2              mov        0xF218, a0
  55E99941: 44                    db_op_44   0x44
  55E99942: E3                    add        d0, d3
  55E99943: 80 DC                 mov        0xDC, d0
  55E99945: EC                    add        d3, d0
loc_55E99946:
  55E99946: F1 E3                 ext_f1_E3  
  55E99948: F8 0F 04              ext_f8_0F  0x04
loc_55E9994B:
  55E9994B: 98                    mov        a2, a0
  55E9994C: 80 CF                 mov        0xCF, d0
  55E9994E: CD 6C F5 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E99953: FA CA 00 01           bxx16      loc_55E99A53
  55E99957: C9 15                 bne        loc_55E9996C
  55E99959: F1 AE                 ext_f1_AE  
  55E9995B: C9 11                 bne        loc_55E9996C
  55E9995D: 9D                    mov        a3, a1
  55E9995E: 51                    db_op_51   0x51
  55E9995F: 71                    mov        d0, (a1)
  55E99960: F1 94                 ext_f1_94  
  55E99962: C8 21                 beq        loc_55E99983
  55E99964: 9C                    mov        a3, a0
  55E99965: CD BE F9 30 0C        call       sub_55E99323, [a2,a3], 12
  55E9996A: CA 19                 bra        loc_55E99983
loc_55E9996C:
  55E9996C: FA CA 00 40           bxx16      loc_55E9D96C
  55E99970: C9 13                 bne        loc_55E99983
  55E99972: F1 AE                 ext_f1_AE  
  55E99974: C9 0F                 bne        loc_55E99983
  55E99976: 9D                    mov        a3, a1
  55E99977: 51                    db_op_51   0x51
  55E99978: 71                    mov        d0, (a1)
  55E99979: F1 94                 ext_f1_94  
  55E9997B: C8 08                 beq        loc_55E99983
  55E9997D: 9C                    mov        a3, a0
  55E9997E: CD FE F9 F0 14        call       sub_55E9937C, [d2,d3,a2,a3], 20
loc_55E99983:
  55E99983: CD 70 06 A0 0C        call       sub_55E99FF3, [d2,a2], 12
  55E99988: CD 2E E5 00 00        call       sub_55E97EB6, [], 0
  55E9998D: 00                    db_op_00   0x00
  55E9998E: DF F0 14              ret        [d2,d3,a2,a3], 20
  55E99991: 82 1A                 mov        0x1A, d2
  55E99993: AA                    db_op_AA   0xAA
  55E99994: 00                    db_op_00   0x00
  55E99995: C9 72                 bne        loc_55E99A07
  55E99997: FC AE 3E 72 07 54     movhu      (0x5407723E), d2
  55E9999D: FC AC AA B3 E9 55     movhu      (0x55E9B3AA), d0
  55E999A3: FC AD A8 B3 E9 55     movhu      (0x55E9B3A8), d1
  55E999A9: 18                    db_op_18   0x18
  55E999AA: 19                    db_op_19   0x19
  55E999AB: F1 04                 ext_f1_04  
  55E999AD: A2                    db_op_A2   0xA2
  55E999AE: C0 05                 blt        loc_55E999B3
  55E999B0: 08                    db_op_08   0x08
  55E999B1: CA 3C                 bra        loc_55E999ED
loc_55E999B3:
  55E999B3: FC AD 3C 72 07 54     movhu      (0x5407723C), d1
  55E999B9: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E999BA: FC A1 1C F4 08 54     mov        (0x5408F41C), d1
  55E999C0: 86                    mov        d1, d2
  55E999C1: 1A                    db_op_1A   0x1A
  55E999C2: 80 1C                 mov        0x1C, d0
  55E999C4: F2 48                 ext_f2_48  
  55E999C6: F1 61                 ext_f1_61  
  55E999C8: F8 61 E4              ext_f8_61  0xE4
  55E999CB: A0                    db_op_A0   0xA0
  55E999CC: 00                    db_op_00   0x00
  55E999CD: C9 0A                 bne        loc_55E999D7
  55E999CF: FC 87 3C 72 07 54     movb       d3, (0x5407723C)
  55E999D5: CA 18                 bra        loc_55E999ED
loc_55E999D7:
  55E999D7: 48                    db_op_48   0x48
  55E999D8: 89                    mov        d2, d1
  55E999D9: FC AE AA B3 E9 55     movhu      (0x55E9B3AA), d2
  55E999DF: 84                    mov        d1, d0
  55E999E0: 1A                    db_op_1A   0x1A
  55E999E1: 18                    db_op_18   0x18
  55E999E2: A8                    db_op_A8   0xA8
  55E999E3: D3                    lble       
  55E999E4: FC AD A8 B3 E9 55     movhu      (0x55E9B3A8), d1
  55E999EA: 19                    db_op_19   0x19
loc_55E999EB:
  55E999EB: 44                    db_op_44   0x44
  55E999EC: DA                    lbra       
loc_55E999ED:
  55E999ED: 89                    mov        d2, d1
  55E999EE: 84                    mov        d1, d0
  55E999EF: 19                    db_op_19   0x19
  55E999F0: A5                    db_op_A5   0xA5
  55E999F1: 00                    db_op_00   0x00
  55E999F2: C9 06                 bne        loc_55E999F8
  55E999F4: 80 DE                 mov        0xDE, d0
  55E999F6: CA 53                 bra        loc_55E99A49
loc_55E999F8:
  55E999F8: FC AD 3E 72 07 54     movhu      (0x5407723E), d1
  55E999FE: 44                    db_op_44   0x44
  55E999FF: FC 87 3E 72 07 54     movb       d3, (0x5407723E)
  55E99A05: CA 27                 bra        loc_55E99A2C
loc_55E99A07:
  55E99A07: FC AD A8 B3 E9 55     movhu      (0x55E9B3A8), d1
  55E99A0D: 19                    db_op_19   0x19
  55E99A0E: A6                    db_op_A6   0xA6
  55E99A0F: C3 06                 ble        loc_55E99A15
  55E99A11: 80 EE                 mov        0xEE, d0
  55E99A13: CA 36                 bra        loc_55E99A49
loc_55E99A15:
  55E99A15: FC A1 1C F4 08 54     mov        (0x5408F41C), d1
  55E99A1B: 85                    mov        d1, d1
  55E99A1C: 1C                    db_op_1C   0x1C
  55E99A1D: F2 46                 ext_f2_46  
  55E99A1F: F1 69                 ext_f1_69  
  55E99A21: F8 65 E4              ext_f8_65  0xE4
  55E99A24: A5                    db_op_A5   0xA5
  55E99A25: 00                    db_op_00   0x00
  55E99A26: C8 06                 beq        loc_55E99A2C
  55E99A28: 80 D7                 mov        0xD7, d0
  55E99A2A: CA 1F                 bra        loc_55E99A49
loc_55E99A2C:
  55E99A2C: FC A5 1C F4 08 54     movbu      (0x5408F41C), d1
  55E99A32: 83 1B                 mov        0x1B, d3
  55E99A34: 8A                    mov        d2, d2
  55E99A35: 1C                    db_op_1C   0x1C
  55E99A36: F2 4E                 ext_f2_4E  
  55E99A38: E9                    add        d2, d1
  55E99A39: F1 E5                 ext_f1_E5  
  55E99A3B: F8 71 E4              ext_f8_71  0xE4
  55E99A3E: FC A5 1C F4 08 54     movbu      (0x5408F41C), d1
  55E99A44: 8C                    mov        d3, d0
  55E99A45: E9                    add        d2, d1
  55E99A46: 29 E4                 cmp        0xE4, d1
  55E99A48: 64                    mov        (a0), d1
loc_55E99A49:
  55E99A49: DF C0 08              ret        [d2,d3], 8
  55E99A4C: 82 1A                 mov        0x1A, d2
  55E99A4E: AA                    db_op_AA   0xAA
  55E99A4F: 00                    db_op_00   0x00
  55E99A50: C9 72                 bne        loc_55E99AC2
  55E99A52: FC AE 62 72 07 54     movhu      (0x54077262), d2
  55E99A58: FC AC CE B3 E9 55     movhu      (0x55E9B3CE), d0
  55E99A5E: FC AD CC B3 E9 55     movhu      (0x55E9B3CC), d1
  55E99A64: 18                    db_op_18   0x18
  55E99A65: 19                    db_op_19   0x19
  55E99A66: F1 04                 ext_f1_04  
  55E99A68: A2                    db_op_A2   0xA2
  55E99A69: C0 05                 blt        loc_55E99A6E
  55E99A6B: 08                    db_op_08   0x08
  55E99A6C: CA 3C                 bra        loc_55E99AA8
loc_55E99A6E:
  55E99A6E: FC AD 60 72 07 54     movhu      (0x54077260), d1
  55E99A74: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99A75: FC A1 40 F4 08 54     mov        (0x5408F440), d1
  55E99A7B: 86                    mov        d1, d2
  55E99A7C: 1A                    db_op_1A   0x1A
  55E99A7D: 80 24                 mov        0x24, d0
  55E99A7F: F2 48                 ext_f2_48  
  55E99A81: F1 61                 ext_f1_61  
  55E99A83: F8 61 E4              ext_f8_61  0xE4
  55E99A86: A0                    db_op_A0   0xA0
  55E99A87: 00                    db_op_00   0x00
  55E99A88: C9 0A                 bne        loc_55E99A92
  55E99A8A: FC 87 60 72 07 54     movb       d3, (0x54077260)
  55E99A90: CA 18                 bra        loc_55E99AA8
loc_55E99A92:
  55E99A92: 48                    db_op_48   0x48
  55E99A93: 89                    mov        d2, d1
  55E99A94: FC AE CE B3 E9 55     movhu      (0x55E9B3CE), d2
  55E99A9A: 84                    mov        d1, d0
  55E99A9B: 1A                    db_op_1A   0x1A
  55E99A9C: 18                    db_op_18   0x18
  55E99A9D: A8                    db_op_A8   0xA8
  55E99A9E: D3                    lble       
  55E99A9F: FC AD CC B3 E9 55     movhu      (0x55E9B3CC), d1
  55E99AA5: 19                    db_op_19   0x19
  55E99AA6: 44                    db_op_44   0x44
  55E99AA7: DA                    lbra       
loc_55E99AA8:
  55E99AA8: 89                    mov        d2, d1
  55E99AA9: 84                    mov        d1, d0
  55E99AAA: 19                    db_op_19   0x19
  55E99AAB: A5                    db_op_A5   0xA5
  55E99AAC: 00                    db_op_00   0x00
  55E99AAD: C9 06                 bne        loc_55E99AB3
  55E99AAF: 80 DE                 mov        0xDE, d0
  55E99AB1: CA 53                 bra        loc_55E99B04
loc_55E99AB3:
  55E99AB3: FC AD 62 72 07 54     movhu      (0x54077262), d1
  55E99AB9: 44                    db_op_44   0x44
  55E99ABA: FC 87 62 72 07 54     movb       d3, (0x54077262)
  55E99AC0: CA 27                 bra        loc_55E99AE7
loc_55E99AC2:
  55E99AC2: FC AD CC B3 E9 55     movhu      (0x55E9B3CC), d1
  55E99AC8: 19                    db_op_19   0x19
  55E99AC9: A6                    db_op_A6   0xA6
  55E99ACA: C3 06                 ble        loc_55E99AD0
  55E99ACC: 80 EE                 mov        0xEE, d0
  55E99ACE: CA 36                 bra        loc_55E99B04
loc_55E99AD0:
  55E99AD0: FC A1 40 F4 08 54     mov        (0x5408F440), d1
  55E99AD6: 85                    mov        d1, d1
  55E99AD7: 24 F2 46              mov        0x46F2, a0
  55E99ADA: F1 69                 ext_f1_69  
  55E99ADC: F8 65 E4              ext_f8_65  0xE4
  55E99ADF: A5                    db_op_A5   0xA5
  55E99AE0: 00                    db_op_00   0x00
  55E99AE1: C8 06                 beq        loc_55E99AE7
  55E99AE3: 80 D7                 mov        0xD7, d0
  55E99AE5: CA 1F                 bra        loc_55E99B04
loc_55E99AE7:
  55E99AE7: FC A5 40 F4 08 54     movbu      (0x5408F440), d1
  55E99AED: 83 1B                 mov        0x1B, d3
  55E99AEF: 8A                    mov        d2, d2
  55E99AF0: 24 F2 4E              mov        0x4EF2, a0
  55E99AF3: E9                    add        d2, d1
  55E99AF4: F1 E5                 ext_f1_E5  
  55E99AF6: F8 71 E4              ext_f8_71  0xE4
  55E99AF9: FC A5 40 F4 08 54     movbu      (0x5408F440), d1
  55E99AFF: 8C                    mov        d3, d0
  55E99B00: E9                    add        d2, d1
  55E99B01: 29 DC                 cmp        0xDC, d1
  55E99B03: 64                    mov        (a0), d1
loc_55E99B04:
  55E99B04: DF C0 08              ret        [d2,d3], 8

; --- Function sub_55E99B07 (callers: 1) ---
sub_55E99B07:
  55E99B07: FC AC A6 B3 E9 55     movhu      (0x55E9B3A6), d0
  55E99B0D: 18                    db_op_18   0x18
  55E99B0E: A0                    db_op_A0   0xA0
  55E99B0F: 00                    db_op_00   0x00
  55E99B10: C3 49                 ble        loc_55E99B59
  55E99B12: FC AC A6 B3 E9 55     movhu      (0x55E9B3A6), d0
  55E99B18: 85                    mov        d1, d1
  55E99B19: 70                    mov        d0, (a0)
  55E99B1A: 18                    db_op_18   0x18
  55E99B1B: F2 54                 ext_f2_54  
  55E99B1D: CD 97 09 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99B22: FC 80 18 F4 08 54     mov        d0, (0x5408F418)
  55E99B28: B0                    db_op_B0   0xB0
  55E99B29: 00                    db_op_00   0x00
  55E99B2A: C9 09                 bne        loc_55E99B33
  55E99B2C: 80 83                 mov        0x83, d0
  55E99B2E: CD 2D E3 00 00        call       sub_55E97E5B, [], 0
loc_55E99B33:
  55E99B33: FC AC A6 B3 E9 55     movhu      (0x55E9B3A6), d0
  55E99B39: 08                    db_op_08   0x08
  55E99B3A: 18                    db_op_18   0x18
  55E99B3B: A8                    db_op_A8   0xA8
  55E99B3C: C3 1D                 ble        loc_55E99B59
  55E99B3E: 89                    mov        d2, d1
  55E99B3F: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99B40: FC A4 18 F4 08 54     movbu      (0x5408F418), d0
  55E99B46: 0C                    db_op_0C   0x0C
  55E99B47: E4                    add        d1, d0
  55E99B48: F1 E0                 ext_f1_E0  
  55E99B4A: F8 7C 10              ext_f8_7C  0x10
  55E99B4D: FC AC A6 B3 E9 55     movhu      (0x55E9B3A6), d0
  55E99B53: 48                    db_op_48   0x48
  55E99B54: 29 70                 cmp        0x70, d1
  55E99B56: 18                    db_op_18   0x18
  55E99B57: A2                    db_op_A2   0xA2
  55E99B58: D0                    lblt       
loc_55E99B59:
  55E99B59: FC AC AA B3 E9 55     movhu      (0x55E9B3AA), d0
  55E99B5F: 18                    db_op_18   0x18
  55E99B60: A0                    db_op_A0   0xA0
  55E99B61: 00                    db_op_00   0x00
  55E99B62: C3 45                 ble        loc_55E99BA7
  55E99B64: FC AC AA B3 E9 55     movhu      (0x55E9B3AA), d0
  55E99B6A: 85                    mov        d1, d1
  55E99B6B: 1C                    db_op_1C   0x1C
  55E99B6C: 18                    db_op_18   0x18
  55E99B6D: F2 54                 ext_f2_54  
  55E99B6F: CD 45 09 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99B74: FC 80 1C F4 08 54     mov        d0, (0x5408F41C)
  55E99B7A: B0                    db_op_B0   0xB0
  55E99B7B: 00                    db_op_00   0x00
  55E99B7C: C9 09                 bne        loc_55E99B85
  55E99B7E: 80 83                 mov        0x83, d0
  55E99B80: CD DB E2 00 00        call       sub_55E97E5B, [], 0
loc_55E99B85:
  55E99B85: FC AC AA B3 E9 55     movhu      (0x55E9B3AA), d0
  55E99B8B: 08                    db_op_08   0x08
  55E99B8C: 18                    db_op_18   0x18
  55E99B8D: A8                    db_op_A8   0xA8
  55E99B8E: C3 19                 ble        loc_55E99BA7
  55E99B90: 89                    mov        d2, d1
  55E99B91: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99B92: FC A0 1C F4 08 54     mov        (0x5408F41C), d0
  55E99B98: 00                    db_op_00   0x00
  55E99B99: F4 C4                 ext_f4_C4  
  55E99B9B: FC AC AA B3 E9 55     movhu      (0x55E9B3AA), d0
  55E99BA1: 48                    db_op_48   0x48
  55E99BA2: 29 1C                 cmp        0x1C, d1
  55E99BA4: 18                    db_op_18   0x18
  55E99BA5: A2                    db_op_A2   0xA2
  55E99BA6: D0                    lblt       
loc_55E99BA7:
  55E99BA7: FC AC AE B3 E9 55     movhu      (0x55E9B3AE), d0
  55E99BAD: 18                    db_op_18   0x18
  55E99BAE: A0                    db_op_A0   0xA0
  55E99BAF: 00                    db_op_00   0x00
  55E99BB0: C3 45                 ble        loc_55E99BF5
  55E99BB2: FC AC AE B3 E9 55     movhu      (0x55E9B3AE), d0
  55E99BB8: 85                    mov        d1, d1
  55E99BB9: 18                    db_op_18   0x18
  55E99BBA: 18                    db_op_18   0x18
  55E99BBB: F2 54                 ext_f2_54  
  55E99BBD: CD F7 08 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99BC2: FC 80 20 F4 08 54     mov        d0, (0x5408F420)
  55E99BC8: B0                    db_op_B0   0xB0
  55E99BC9: 00                    db_op_00   0x00
  55E99BCA: C9 09                 bne        loc_55E99BD3
  55E99BCC: 80 83                 mov        0x83, d0
  55E99BCE: CD 8D E2 00 00        call       sub_55E97E5B, [], 0
loc_55E99BD3:
  55E99BD3: FC AC AE B3 E9 55     movhu      (0x55E9B3AE), d0
  55E99BD9: 08                    db_op_08   0x08
  55E99BDA: 18                    db_op_18   0x18
  55E99BDB: A8                    db_op_A8   0xA8
  55E99BDC: C3 19                 ble        loc_55E99BF5
  55E99BDE: 89                    mov        d2, d1
  55E99BDF: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99BE0: FC A0 20 F4 08 54     mov        (0x5408F420), d0
  55E99BE6: 00                    db_op_00   0x00
  55E99BE7: F4 C4                 ext_f4_C4  
  55E99BE9: FC AC AE B3 E9 55     movhu      (0x55E9B3AE), d0
  55E99BEF: 48                    db_op_48   0x48
  55E99BF0: 29 18                 cmp        0x18, d1
  55E99BF2: 18                    db_op_18   0x18
  55E99BF3: A2                    db_op_A2   0xA2
  55E99BF4: D0                    lblt       
loc_55E99BF5:
  55E99BF5: FC AC B2 B3 E9 55     movhu      (0x55E9B3B2), d0
  55E99BFB: 18                    db_op_18   0x18
  55E99BFC: A0                    db_op_A0   0xA0
  55E99BFD: 00                    db_op_00   0x00
  55E99BFE: C3 45                 ble        loc_55E99C43
  55E99C00: FC AC B2 B3 E9 55     movhu      (0x55E9B3B2), d0
  55E99C06: 85                    mov        d1, d1
  55E99C07: 30                    db_op_30   0x30
  55E99C08: 18                    db_op_18   0x18
  55E99C09: F2 54                 ext_f2_54  
  55E99C0B: CD A9 08 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99C10: FC 80 24 F4 08 54     mov        d0, (0x5408F424)
  55E99C16: B0                    db_op_B0   0xB0
  55E99C17: 00                    db_op_00   0x00
  55E99C18: C9 09                 bne        loc_55E99C21
  55E99C1A: 80 83                 mov        0x83, d0
  55E99C1C: CD 3F E2 00 00        call       sub_55E97E5B, [], 0
loc_55E99C21:
  55E99C21: FC AC B2 B3 E9 55     movhu      (0x55E9B3B2), d0
  55E99C27: 08                    db_op_08   0x08
  55E99C28: 18                    db_op_18   0x18
  55E99C29: A8                    db_op_A8   0xA8
  55E99C2A: C3 19                 ble        loc_55E99C43
  55E99C2C: 89                    mov        d2, d1
  55E99C2D: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99C2E: FC A0 24 F4 08 54     mov        (0x5408F424), d0
  55E99C34: 00                    db_op_00   0x00
  55E99C35: F4 C4                 ext_f4_C4  
  55E99C37: FC AC B2 B3 E9 55     movhu      (0x55E9B3B2), d0
  55E99C3D: 48                    db_op_48   0x48
  55E99C3E: 29 30                 cmp        0x30, d1
  55E99C40: 18                    db_op_18   0x18
  55E99C41: A2                    db_op_A2   0xA2
  55E99C42: D0                    lblt       
loc_55E99C43:
  55E99C43: FC AC B6 B3 E9 55     movhu      (0x55E9B3B6), d0
  55E99C49: 18                    db_op_18   0x18
  55E99C4A: A0                    db_op_A0   0xA0
  55E99C4B: 00                    db_op_00   0x00
  55E99C4C: C3 45                 ble        loc_55E99C91
  55E99C4E: FC AC B6 B3 E9 55     movhu      (0x55E9B3B6), d0
  55E99C54: 85                    mov        d1, d1
  55E99C55: 1C                    db_op_1C   0x1C
  55E99C56: 18                    db_op_18   0x18
  55E99C57: F2 54                 ext_f2_54  
  55E99C59: CD 5B 08 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99C5E: FC 80 28 F4 08 54     mov        d0, (0x5408F428)
  55E99C64: B0                    db_op_B0   0xB0
  55E99C65: 00                    db_op_00   0x00
  55E99C66: C9 09                 bne        loc_55E99C6F
  55E99C68: 80 83                 mov        0x83, d0
  55E99C6A: CD F1 E1 00 00        call       sub_55E97E5B, [], 0
loc_55E99C6F:
  55E99C6F: FC AC B6 B3 E9 55     movhu      (0x55E9B3B6), d0
  55E99C75: 08                    db_op_08   0x08
  55E99C76: 18                    db_op_18   0x18
  55E99C77: A8                    db_op_A8   0xA8
  55E99C78: C3 19                 ble        loc_55E99C91
  55E99C7A: 89                    mov        d2, d1
  55E99C7B: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99C7C: FC A0 28 F4 08 54     mov        (0x5408F428), d0
  55E99C82: 00                    db_op_00   0x00
  55E99C83: F4 C4                 ext_f4_C4  
  55E99C85: FC AC B6 B3 E9 55     movhu      (0x55E9B3B6), d0
  55E99C8B: 48                    db_op_48   0x48
  55E99C8C: 29 1C                 cmp        0x1C, d1
  55E99C8E: 18                    db_op_18   0x18
  55E99C8F: A2                    db_op_A2   0xA2
  55E99C90: D0                    lblt       
loc_55E99C91:
  55E99C91: FC AC BA B3 E9 55     movhu      (0x55E9B3BA), d0
  55E99C97: 18                    db_op_18   0x18
  55E99C98: A0                    db_op_A0   0xA0
  55E99C99: 00                    db_op_00   0x00
  55E99C9A: C3 48                 ble        loc_55E99CE2
  55E99C9C: FC AC BA B3 E9 55     movhu      (0x55E9B3BA), d0
  55E99CA2: 85                    mov        d1, d1
  55E99CA3: 1C                    db_op_1C   0x1C
  55E99CA4: 18                    db_op_18   0x18
  55E99CA5: F2 54                 ext_f2_54  
  55E99CA7: CD 0D 08 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99CAC: FC 80 2C F4 08 54     mov        d0, (0x5408F42C)
  55E99CB2: B0                    db_op_B0   0xB0
  55E99CB3: 00                    db_op_00   0x00
  55E99CB4: C9 09                 bne        loc_55E99CBD
  55E99CB6: 80 83                 mov        0x83, d0
  55E99CB8: CD A3 E1 00 00        call       sub_55E97E5B, [], 0
loc_55E99CBD:
  55E99CBD: FC AC BA B3 E9 55     movhu      (0x55E9B3BA), d0
  55E99CC3: 08                    db_op_08   0x08
  55E99CC4: 18                    db_op_18   0x18
  55E99CC5: A8                    db_op_A8   0xA8
  55E99CC6: C3 1C                 ble        loc_55E99CE2
  55E99CC8: 89                    mov        d2, d1
  55E99CC9: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99CCA: FC A0 2C F4 08 54     mov        (0x5408F42C), d0
  55E99CD0: 00                    db_op_00   0x00
  55E99CD1: F1 64                 ext_f1_64  
  55E99CD3: F8 70 08              ext_f8_70  0x08
  55E99CD6: FC AC BA B3 E9 55     movhu      (0x55E9B3BA), d0
  55E99CDC: 48                    db_op_48   0x48
  55E99CDD: 29 1C                 cmp        0x1C, d1
  55E99CDF: 18                    db_op_18   0x18
  55E99CE0: A2                    db_op_A2   0xA2
  55E99CE1: D0                    lblt       
loc_55E99CE2:
  55E99CE2: FC AC BE B3 E9 55     movhu      (0x55E9B3BE), d0
  55E99CE8: 18                    db_op_18   0x18
  55E99CE9: A0                    db_op_A0   0xA0
  55E99CEA: 00                    db_op_00   0x00
  55E99CEB: C3 45                 ble        loc_55E99D30
  55E99CED: FC AC BE B3 E9 55     movhu      (0x55E9B3BE), d0
  55E99CF3: 85                    mov        d1, d1
  55E99CF4: 38                    db_op_38   0x38
  55E99CF5: 18                    db_op_18   0x18
  55E99CF6: F2 54                 ext_f2_54  
  55E99CF8: CD BC 07 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99CFD: FC 80 30 F4 08 54     mov        d0, (0x5408F430)
  55E99D03: B0                    db_op_B0   0xB0
  55E99D04: 00                    db_op_00   0x00
  55E99D05: C9 09                 bne        loc_55E99D0E
  55E99D07: 80 83                 mov        0x83, d0
  55E99D09: CD 52 E1 00 00        call       sub_55E97E5B, [], 0
loc_55E99D0E:
  55E99D0E: FC AC BE B3 E9 55     movhu      (0x55E9B3BE), d0
  55E99D14: 08                    db_op_08   0x08
  55E99D15: 18                    db_op_18   0x18
  55E99D16: A8                    db_op_A8   0xA8
  55E99D17: C3 19                 ble        loc_55E99D30
  55E99D19: 89                    mov        d2, d1
  55E99D1A: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99D1B: FC A0 30 F4 08 54     mov        (0x5408F430), d0
  55E99D21: 00                    db_op_00   0x00
  55E99D22: F4 C4                 ext_f4_C4  
  55E99D24: FC AC BE B3 E9 55     movhu      (0x55E9B3BE), d0
  55E99D2A: 48                    db_op_48   0x48
  55E99D2B: 29 38                 cmp        0x38, d1
  55E99D2D: 18                    db_op_18   0x18
  55E99D2E: A2                    db_op_A2   0xA2
  55E99D2F: D0                    lblt       
loc_55E99D30:
  55E99D30: FC AC C2 B3 E9 55     movhu      (0x55E9B3C2), d0
  55E99D36: 18                    db_op_18   0x18
  55E99D37: A0                    db_op_A0   0xA0
  55E99D38: 00                    db_op_00   0x00
  55E99D39: C3 45                 ble        loc_55E99D7E
  55E99D3B: FC AC C2 B3 E9 55     movhu      (0x55E9B3C2), d0
  55E99D41: 85                    mov        d1, d1
  55E99D42: 24 18 F2              mov        0xF218, a0
  55E99D45: 54                    db_op_54   0x54
  55E99D46: CD 6E 07 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99D4B: FC 80 34 F4 08 54     mov        d0, (0x5408F434)
  55E99D51: B0                    db_op_B0   0xB0
  55E99D52: 00                    db_op_00   0x00
  55E99D53: C9 09                 bne        loc_55E99D5C
  55E99D55: 80 83                 mov        0x83, d0
  55E99D57: CD 04 E1 00 00        call       sub_55E97E5B, [], 0
loc_55E99D5C:
  55E99D5C: FC AC C2 B3 E9 55     movhu      (0x55E9B3C2), d0
  55E99D62: 08                    db_op_08   0x08
  55E99D63: 18                    db_op_18   0x18
  55E99D64: A8                    db_op_A8   0xA8
  55E99D65: C3 19                 ble        loc_55E99D7E
  55E99D67: 89                    mov        d2, d1
  55E99D68: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99D69: FC A0 34 F4 08 54     mov        (0x5408F434), d0
  55E99D6F: 00                    db_op_00   0x00
  55E99D70: F4 C4                 ext_f4_C4  
  55E99D72: FC AC C2 B3 E9 55     movhu      (0x55E9B3C2), d0
  55E99D78: 48                    db_op_48   0x48
  55E99D79: 29 24                 cmp        0x24, d1
  55E99D7B: 18                    db_op_18   0x18
  55E99D7C: A2                    db_op_A2   0xA2
  55E99D7D: D0                    lblt       
loc_55E99D7E:
  55E99D7E: FC AC C6 B3 E9 55     movhu      (0x55E9B3C6), d0
  55E99D84: 18                    db_op_18   0x18
  55E99D85: A0                    db_op_A0   0xA0
  55E99D86: 00                    db_op_00   0x00
  55E99D87: C3 45                 ble        loc_55E99DCC
  55E99D89: FC AC C6 B3 E9 55     movhu      (0x55E9B3C6), d0
  55E99D8F: 85                    mov        d1, d1
  55E99D90: 24 18 F2              mov        0xF218, a0
  55E99D93: 54                    db_op_54   0x54
  55E99D94: CD 20 07 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99D99: FC 80 38 F4 08 54     mov        d0, (0x5408F438)
  55E99D9F: B0                    db_op_B0   0xB0
  55E99DA0: 00                    db_op_00   0x00
  55E99DA1: C9 09                 bne        loc_55E99DAA
  55E99DA3: 80 83                 mov        0x83, d0
  55E99DA5: CD B6 E0 00 00        call       sub_55E97E5B, [], 0
loc_55E99DAA:
  55E99DAA: FC AC C6 B3 E9 55     movhu      (0x55E9B3C6), d0
  55E99DB0: 08                    db_op_08   0x08
  55E99DB1: 18                    db_op_18   0x18
  55E99DB2: A8                    db_op_A8   0xA8
  55E99DB3: C3 19                 ble        loc_55E99DCC
  55E99DB5: 89                    mov        d2, d1
  55E99DB6: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99DB7: FC A0 38 F4 08 54     mov        (0x5408F438), d0
  55E99DBD: 00                    db_op_00   0x00
  55E99DBE: F4 C4                 ext_f4_C4  
  55E99DC0: FC AC C6 B3 E9 55     movhu      (0x55E9B3C6), d0
  55E99DC6: 48                    db_op_48   0x48
  55E99DC7: 29 24                 cmp        0x24, d1
  55E99DC9: 18                    db_op_18   0x18
  55E99DCA: A2                    db_op_A2   0xA2
  55E99DCB: D0                    lblt       
loc_55E99DCC:
  55E99DCC: FC AC CA B3 E9 55     movhu      (0x55E9B3CA), d0
  55E99DD2: 18                    db_op_18   0x18
  55E99DD3: A0                    db_op_A0   0xA0
  55E99DD4: 00                    db_op_00   0x00
  55E99DD5: C3 45                 ble        loc_55E99E1A
  55E99DD7: FC AC CA B3 E9 55     movhu      (0x55E9B3CA), d0
  55E99DDD: 85                    mov        d1, d1
  55E99DDE: 24 18 F2              mov        0xF218, a0
  55E99DE1: 54                    db_op_54   0x54
  55E99DE2: CD D2 06 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99DE7: FC 80 3C F4 08 54     mov        d0, (0x5408F43C)
  55E99DED: B0                    db_op_B0   0xB0
  55E99DEE: 00                    db_op_00   0x00
  55E99DEF: C9 09                 bne        loc_55E99DF8
  55E99DF1: 80 83                 mov        0x83, d0
  55E99DF3: CD 68 E0 00 00        call       sub_55E97E5B, [], 0
loc_55E99DF8:
  55E99DF8: FC AC CA B3 E9 55     movhu      (0x55E9B3CA), d0
  55E99DFE: 08                    db_op_08   0x08
  55E99DFF: 18                    db_op_18   0x18
  55E99E00: A8                    db_op_A8   0xA8
  55E99E01: C3 19                 ble        loc_55E99E1A
  55E99E03: 89                    mov        d2, d1
  55E99E04: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99E05: FC A0 3C F4 08 54     mov        (0x5408F43C), d0
  55E99E0B: 00                    db_op_00   0x00
  55E99E0C: F4 C4                 ext_f4_C4  
  55E99E0E: FC AC CA B3 E9 55     movhu      (0x55E9B3CA), d0
  55E99E14: 48                    db_op_48   0x48
  55E99E15: 29 24                 cmp        0x24, d1
  55E99E17: 18                    db_op_18   0x18
  55E99E18: A2                    db_op_A2   0xA2
  55E99E19: D0                    lblt       
loc_55E99E1A:
  55E99E1A: FC AC CE B3 E9 55     movhu      (0x55E9B3CE), d0
  55E99E20: 18                    db_op_18   0x18
  55E99E21: A0                    db_op_A0   0xA0
  55E99E22: 00                    db_op_00   0x00
  55E99E23: C3 49                 ble        loc_55E99E6C
  55E99E25: FC AC CE B3 E9 55     movhu      (0x55E9B3CE), d0
  55E99E2B: 85                    mov        d1, d1
  55E99E2C: 24 18 F2              mov        0xF218, a0
  55E99E2F: 54                    db_op_54   0x54
  55E99E30: CD 84 06 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99E35: FC 80 40 F4 08 54     mov        d0, (0x5408F440)
  55E99E3B: B0                    db_op_B0   0xB0
  55E99E3C: 00                    db_op_00   0x00
  55E99E3D: C9 09                 bne        loc_55E99E46
  55E99E3F: 80 83                 mov        0x83, d0
  55E99E41: CD 1A E0 00 00        call       sub_55E97E5B, [], 0
loc_55E99E46:
  55E99E46: FC AC CE B3 E9 55     movhu      (0x55E9B3CE), d0
  55E99E4C: 08                    db_op_08   0x08
  55E99E4D: 18                    db_op_18   0x18
  55E99E4E: A8                    db_op_A8   0xA8
  55E99E4F: C3 1D                 ble        loc_55E99E6C
  55E99E51: 89                    mov        d2, d1
  55E99E52: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99E53: FC A4 40 F4 08 54     movbu      (0x5408F440), d0
  55E99E59: 0C                    db_op_0C   0x0C
  55E99E5A: E4                    add        d1, d0
  55E99E5B: F1 E0                 ext_f1_E0  
  55E99E5D: F8 7C 08              ext_f8_7C  0x08
  55E99E60: FC AC CE B3 E9 55     movhu      (0x55E9B3CE), d0
  55E99E66: 48                    db_op_48   0x48
  55E99E67: 29 24                 cmp        0x24, d1
  55E99E69: 18                    db_op_18   0x18
  55E99E6A: A2                    db_op_A2   0xA2
  55E99E6B: D0                    lblt       
loc_55E99E6C:
  55E99E6C: FC AC D2 B3 E9 55     movhu      (0x55E9B3D2), d0
  55E99E72: 18                    db_op_18   0x18
  55E99E73: A0                    db_op_A0   0xA0
  55E99E74: 00                    db_op_00   0x00
  55E99E75: C3 49                 ble        loc_55E99EBE
  55E99E77: FC AC D2 B3 E9 55     movhu      (0x55E9B3D2), d0
  55E99E7D: 85                    mov        d1, d1
  55E99E7E: 1C                    db_op_1C   0x1C
  55E99E7F: 18                    db_op_18   0x18
  55E99E80: F2 54                 ext_f2_54  
  55E99E82: CD 32 06 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99E87: FC 80 44 F4 08 54     mov        d0, (0x5408F444)
  55E99E8D: B0                    db_op_B0   0xB0
  55E99E8E: 00                    db_op_00   0x00
  55E99E8F: C9 09                 bne        loc_55E99E98
  55E99E91: 80 83                 mov        0x83, d0
  55E99E93: CD C8 DF 00 00        call       sub_55E97E5B, [], 0
loc_55E99E98:
  55E99E98: FC AC D2 B3 E9 55     movhu      (0x55E9B3D2), d0
  55E99E9E: 08                    db_op_08   0x08
  55E99E9F: 18                    db_op_18   0x18
  55E99EA0: A8                    db_op_A8   0xA8
  55E99EA1: C3 1D                 ble        loc_55E99EBE
  55E99EA3: 89                    mov        d2, d1
  55E99EA4: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99EA5: FC A4 44 F4 08 54     movbu      (0x5408F444), d0
  55E99EAB: 0C                    db_op_0C   0x0C
  55E99EAC: E4                    add        d1, d0
  55E99EAD: F1 E0                 ext_f1_E0  
  55E99EAF: F8 7C 08              ext_f8_7C  0x08
  55E99EB2: FC AC D2 B3 E9 55     movhu      (0x55E9B3D2), d0
  55E99EB8: 48                    db_op_48   0x48
  55E99EB9: 29 1C                 cmp        0x1C, d1
  55E99EBB: 18                    db_op_18   0x18
  55E99EBC: A2                    db_op_A2   0xA2
  55E99EBD: D0                    lblt       
loc_55E99EBE:
  55E99EBE: FC AC D6 B3 E9 55     movhu      (0x55E9B3D6), d0
  55E99EC4: 18                    db_op_18   0x18
  55E99EC5: A0                    db_op_A0   0xA0
  55E99EC6: 00                    db_op_00   0x00
  55E99EC7: C3 48                 ble        loc_55E99F0F
  55E99EC9: FC AC D6 B3 E9 55     movhu      (0x55E9B3D6), d0
  55E99ECF: 18                    db_op_18   0x18
  55E99ED0: F8 C0 05              ext_f8_C0  0x05
  55E99ED3: CD E1 05 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99ED8: FC 80 48 F4 08 54     mov        d0, (0x5408F448)
  55E99EDE: B0                    db_op_B0   0xB0
  55E99EDF: 00                    db_op_00   0x00
  55E99EE0: C9 09                 bne        loc_55E99EE9
  55E99EE2: 80 83                 mov        0x83, d0
  55E99EE4: CD 77 DF 00 00        call       sub_55E97E5B, [], 0
loc_55E99EE9:
  55E99EE9: FC AC D6 B3 E9 55     movhu      (0x55E9B3D6), d0
  55E99EEF: 08                    db_op_08   0x08
  55E99EF0: 18                    db_op_18   0x18
  55E99EF1: A8                    db_op_A8   0xA8
  55E99EF2: C3 1D                 ble        loc_55E99F0F
  55E99EF4: 89                    mov        d2, d1
  55E99EF5: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99EF6: FC A4 48 F4 08 54     movbu      (0x5408F448), d0
  55E99EFC: 0C                    db_op_0C   0x0C
  55E99EFD: E4                    add        d1, d0
  55E99EFE: F1 E0                 ext_f1_E0  
  55E99F00: F8 7C 08              ext_f8_7C  0x08
  55E99F03: FC AC D6 B3 E9 55     movhu      (0x55E9B3D6), d0
  55E99F09: 48                    db_op_48   0x48
  55E99F0A: 29 20                 cmp        0x20, d1
  55E99F0C: 18                    db_op_18   0x18
  55E99F0D: A2                    db_op_A2   0xA2
  55E99F0E: D0                    lblt       
loc_55E99F0F:
  55E99F0F: FC AC DA B3 E9 55     movhu      (0x55E9B3DA), d0
  55E99F15: 18                    db_op_18   0x18
  55E99F16: A0                    db_op_A0   0xA0
  55E99F17: 00                    db_op_00   0x00
  55E99F18: C3 44                 ble        loc_55E99F5C
  55E99F1A: FC AC DA B3 E9 55     movhu      (0x55E9B3DA), d0
  55E99F20: 18                    db_op_18   0x18
  55E99F21: F8 C0 04              ext_f8_C0  0x04
  55E99F24: CD 90 05 F0 10        call       sub_55E9A4B4, [d2,d3,a2,a3], 16
  55E99F29: FC 80 4C F4 08 54     mov        d0, (0x5408F44C)
  55E99F2F: B0                    db_op_B0   0xB0
  55E99F30: 00                    db_op_00   0x00
  55E99F31: C9 09                 bne        loc_55E99F3A
  55E99F33: 80 83                 mov        0x83, d0
  55E99F35: CD 26 DF 00 00        call       sub_55E97E5B, [], 0
loc_55E99F3A:
  55E99F3A: FC AC DA B3 E9 55     movhu      (0x55E9B3DA), d0
  55E99F40: 08                    db_op_08   0x08
  55E99F41: 18                    db_op_18   0x18
  55E99F42: A8                    db_op_A8   0xA8
  55E99F43: C3 19                 ble        loc_55E99F5C
  55E99F45: 89                    mov        d2, d1
  55E99F46: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E99F47: FC A0 4C F4 08 54     mov        (0x5408F44C), d0
  55E99F4D: 00                    db_op_00   0x00
  55E99F4E: F4 C4                 ext_f4_C4  
  55E99F50: FC AC DA B3 E9 55     movhu      (0x55E9B3DA), d0
  55E99F56: 48                    db_op_48   0x48
  55E99F57: 29 10                 cmp        0x10, d1
  55E99F59: 18                    db_op_18   0x18
  55E99F5A: A2                    db_op_A2   0xA2
  55E99F5B: D0                    lblt       
loc_55E99F5C:
  55E99F5C: DF C0 0C              ret        [d2,d3], 12

; --- Function sub_55E99F5F (callers: 4) ---
sub_55E99F5F:
  55E99F5F: 82 1A                 mov        0x1A, d2
  55E99F61: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E99F67: 85                    mov        d1, d1
  55E99F68: 01                    db_op_01   0x01
  55E99F69: A0                    db_op_A0   0xA0
  55E99F6A: 00                    db_op_00   0x00
  55E99F6B: C9 03                 bne        loc_55E99F6E
  55E99F6D: 04                    db_op_04   0x04
loc_55E99F6E:
  55E99F6E: A5                    db_op_A5   0xA5
  55E99F6F: 01                    db_op_01   0x01
  55E99F70: C8 0C                 beq        loc_55E99F7C
  55E99F72: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E99F78: A5                    db_op_A5   0xA5
  55E99F79: 01                    db_op_01   0x01
  55E99F7A: C9 07                 bne        loc_55E99F81
loc_55E99F7C:
  55E99F7C: 80 E7                 mov        0xE7, d0
  55E99F7E: DF 80 08              ret        [d2], 8
loc_55E99F81:
  55E99F81: AA                    db_op_AA   0xAA
  55E99F82: 01                    db_op_01   0x01
  55E99F83: C0 0C                 blt        loc_55E99F8F
  55E99F85: FC AD A6 B3 E9 55     movhu      (0x55E9B3A6), d1
  55E99F8B: 19                    db_op_19   0x19
  55E99F8C: A6                    db_op_A6   0xA6
  55E99F8D: C3 07                 ble        loc_55E99F94
loc_55E99F8F:
  55E99F8F: 80 EE                 mov        0xEE, d0
  55E99F91: DF 80 08              ret        [d2], 8
loc_55E99F94:
  55E99F94: CD 09 DF 00 00        call       sub_55E97E9D, [], 0
  55E99F99: FC A4 18 F4 08 54     movbu      (0x5408F418), d0
  55E99F9F: 85                    mov        d1, d1
  55E99FA0: 70                    mov        d0, (a0)
  55E99FA1: F2 46                 ext_f2_46  
  55E99FA3: E8                    add        d2, d0
  55E99FA4: FC DC 90 FF FF FF     mov        0xFFFFFF90, a0
  55E99FAA: F1 60                 ext_f1_60  
  55E99FAC: F8 60 10              ext_f8_60  0x10
  55E99FAF: A0                    db_op_A0   0xA0
  55E99FB0: 00                    db_op_00   0x00
  55E99FB1: C9 04                 bne        loc_55E99FB5
  55E99FB3: 90 00                 mov        0x00, a0
loc_55E99FB5:
  55E99FB5: B0                    db_op_B0   0xB0
  55E99FB6: 00                    db_op_00   0x00
  55E99FB7: C9 0B                 bne        loc_55E99FC2
  55E99FB9: CD FD DE 00 00        call       sub_55E97EB6, [], 0
  55E99FBE: 80 D6                 mov        0xD6, d0
  55E99FC0: CA 30                 bra        loc_55E99FF0
loc_55E99FC2:
  55E99FC2: F8 60 0C              ext_f8_60  0x0C
  55E99FC5: F8 EC 08              ext_f8_EC  0x08
  55E99FC8: C8 19                 beq        loc_55E99FE1
  55E99FCA: 95                    mov        a1, a1
  55E99FCB: 16                    db_op_16   0x16
  55E99FCC: F1 71                 ext_f1_71  
  55E99FCE: F0 41                 ext_f0_41  
  55E99FD0: 28 FF                 cmp        0xFF, d0
  55E99FD2: F0 51                 ext_f0_51  
  55E99FD4: F0 41                 ext_f0_41  
  55E99FD6: A0                    db_op_A0   0xA0
  55E99FD7: 00                    db_op_00   0x00
  55E99FD8: C9 12                 bne        loc_55E99FEA
  55E99FDA: CD 57 EF 00 04        call       sub_55E98F31, [], 4
  55E99FDF: CA 0B                 bra        loc_55E99FEA
loc_55E99FE1:
  55E99FE1: CD D5 DE 00 00        call       sub_55E97EB6, [], 0
  55E99FE6: 80 D7                 mov        0xD7, d0
  55E99FE8: CA 08                 bra        loc_55E99FF0
loc_55E99FEA:
  55E99FEA: CD CC DE 00 00        call       sub_55E97EB6, [], 0
  55E99FEF: 00                    db_op_00   0x00
loc_55E99FF0:
  55E99FF0: DF 80 08              ret        [d2], 8

; --- Function sub_55E99FF3 (callers: 11) ---
sub_55E99FF3:
  55E99FF3: FC A8 09 F4 08 54     ext_fc_A8  0x5408F409
  55E99FF9: A0                    db_op_A0   0xA0
  55E99FFA: 00                    db_op_00   0x00
  55E99FFB: C8 09                 beq        loc_55E9A004
  55E99FFD: 80 80                 mov        0x80, d0
  55E99FFF: CD 5C DE 00 00        call       sub_55E97E5B, [], 0
loc_55E9A004:
  55E9A004: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E9A00A: A0                    db_op_A0   0xA0
  55E9A00B: 00                    db_op_00   0x00
  55E9A00C: C8 05                 beq        loc_55E9A011
  55E9A00E: DF A0 0C              ret        [d2,a2], 12
loc_55E9A011:
  55E9A011: FC A0 F4 F3 08 54     mov        (0x5408F3F4), d0
  55E9A017: FC A6 F8 F3 08 54     movbu      (0x5408F3F8), d2
  55E9A01D: 70                    mov        d0, (a0)
  55E9A01E: A2                    db_op_A2   0xA2
  55E9A01F: C8 60                 beq        loc_55E9A07F
  55E9A021: F1 90                 ext_f1_90  
  55E9A023: C9 09                 bne        loc_55E9A02C
  55E9A025: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9A026: 20 08                 add        8, d0
  55E9A028: 70                    mov        d0, (a0)
  55E9A029: F1 90                 ext_f1_90  
  55E9A02B: D8                    lbeq       
loc_55E9A02C:
  55E9A02C: FC 80 F4 F3 08 54     mov        d0, (0x5408F3F4)
  55E9A032: F0 08                 ext_f0_08  
  55E9A034: 90 0C                 mov        0x0C, a0
  55E9A036: FC 88 F8 F3 08 54     movhu      d0, (0x5408F3F8)
  55E9A03C: F1 68                 ext_f1_68  
  55E9A03E: F0 60                 ext_f0_60  
  55E9A040: A0                    db_op_A0   0xA0
  55E9A041: 01                    db_op_01   0x01
  55E9A042: C9 06                 bne        loc_55E9A048
  55E9A044: 80 02                 mov        0x02, d0
  55E9A046: F0 70                 ext_f0_70  
loc_55E9A048:
  55E9A048: 80 01                 mov        0x01, d0
  55E9A04A: F8 72 0C              ext_f8_72  0x0C
  55E9A04D: FC A4 28 F3 08 54     movbu      (0x5408F328), d0
  55E9A053: A0                    db_op_A0   0xA0
  55E9A054: 00                    db_op_00   0x00
  55E9A055: C8 1E                 beq        loc_55E9A073
  55E9A057: F1 E8                 ext_f1_E8  
  55E9A059: F8 60 10              ext_f8_60  0x10
  55E9A05C: FC A5 2C F3 08 54     movbu      (0x5408F32C), d1
  55E9A062: 18                    db_op_18   0x18
  55E9A063: F2 14                 ext_f2_14  
  55E9A065: DD B7 2C E0 FF 00 00  call       sub_55C9CD1C, [], 0
  55E9A06C: 00                    db_op_00   0x00
  55E9A06D: FC 81 2C F3 08 54     mov        d1, (0x5408F32C)
loc_55E9A073:
  55E9A073: 22 18                 add        24, d2
  55E9A075: 95                    mov        a1, a1
  55E9A076: 18                    db_op_18   0x18
  55E9A077: F1 69                 ext_f1_69  
  55E9A079: 98                    mov        a2, a0
  55E9A07A: CD E2 DD F0 10        call       sub_55E97E5C, [d2,d3,a2,a3], 16
loc_55E9A07F:
  55E9A07F: FC A0 F8 F3 08 54     mov        (0x5408F3F8), d0
  55E9A085: FC D8 6C F3 08 54     ext_fc_D8  0x5408F36C
  55E9A08B: C9 21                 bne        loc_55E9A0AC
  55E9A08D: 80 00                 mov        0x00, d0
  55E9A08F: A0                    db_op_A0   0xA0
  55E9A090: 01                    db_op_01   0x01
  55E9A091: C9 1B                 bne        loc_55E9A0AC
  55E9A093: 95                    mov        a1, a1
  55E9A094: 44                    db_op_44   0x44
  55E9A095: F1 71                 ext_f1_71  
  55E9A097: F8 05 14              ext_f8_05  0x14
  55E9A09A: F8 01 10              ext_f8_01  0x10
  55E9A09D: F8 21 08              ext_f8_21  0x08
  55E9A0A0: E1                    add        d0, d1
  55E9A0A1: 80 04                 mov        0x04, d0
  55E9A0A3: F1 01                 ext_f1_01  
  55E9A0A5: F1 E5                 ext_f1_E5  
  55E9A0A7: CD D7 DD 00 00        call       sub_55E97E7E, [], 0
loc_55E9A0AC:
  55E9A0AC: DF A0 0C              ret        [d2,a2], 12

; --- Function sub_55E9A0AF (callers: 3) ---
sub_55E9A0AF:
  55E9A0AF: 46                    db_op_46   0x46
  55E9A0B0: 04                    db_op_04   0x04
  55E9A0B1: 18                    db_op_18   0x18
  55E9A0B2: 83 FC                 mov        0xFC, d3
  55E9A0B4: AA                    db_op_AA   0xAA
  55E9A0B5: 08                    db_op_08   0x08
  55E9A0B6: F4 08                 ext_f4_08  
  55E9A0B8: 54                    db_op_54   0x54
  55E9A0B9: 85                    mov        d1, d1
  55E9A0BA: 01                    db_op_01   0x01
  55E9A0BB: AA                    db_op_AA   0xAA
  55E9A0BC: 00                    db_op_00   0x00
  55E9A0BD: C9 03                 bne        loc_55E9A0C0
  55E9A0BF: 04                    db_op_04   0x04
loc_55E9A0C0:
  55E9A0C0: A5                    db_op_A5   0xA5
  55E9A0C1: 01                    db_op_01   0x01
  55E9A0C2: C8 0C                 beq        loc_55E9A0CE
  55E9A0C4: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9A0CA: A5                    db_op_A5   0xA5
  55E9A0CB: 01                    db_op_01   0x01
  55E9A0CC: C9 07                 bne        loc_55E9A0D3
loc_55E9A0CE:
  55E9A0CE: 80 E7                 mov        0xE7, d0
  55E9A0D0: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E9A0D3:
  55E9A0D3: 1B                    db_op_1B   0x1B
  55E9A0D4: AF                    db_op_AF   0xAF
  55E9A0D5: 01                    db_op_01   0x01
  55E9A0D6: C0 0C                 blt        loc_55E9A0E2
  55E9A0D8: FC AD AE B3 E9 55     movhu      (0x55E9B3AE), d1
  55E9A0DE: 19                    db_op_19   0x19
  55E9A0DF: A7                    db_op_A7   0xA7
  55E9A0E0: C3 07                 ble        loc_55E9A0E7
loc_55E9A0E2:
  55E9A0E2: 80 EE                 mov        0xEE, d0
  55E9A0E4: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E9A0E7:
  55E9A0E7: 58 04                 mov        (4, sp), d0
  55E9A0E9: A0                    db_op_A0   0xA0
  55E9A0EA: 00                    db_op_00   0x00
  55E9A0EB: C9 05                 bne        loc_55E9A0F0
  55E9A0ED: CC 85 00              jmp        loc_55E9A172
loc_55E9A0F0:
  55E9A0F0: CD AD DD 00 00        call       sub_55E97E9D, [], 0
  55E9A0F5: FC A5 20 F4 08 54     movbu      (0x5408F420), d1
  55E9A0FB: 80 18                 mov        0x18, d0
  55E9A0FD: F2 43                 ext_f2_43  
  55E9A0FF: ED                    add        d3, d1
  55E9A100: FC DE E8 FF FF FF     mov        0xFFFFFFE8, a2
  55E9A106: F1 66                 ext_f1_66  
  55E9A108: F0 62                 ext_f0_62  
  55E9A10A: F1 DB                 ext_f1_DB  
  55E9A10C: A0                    db_op_A0   0xA0
  55E9A10D: 00                    db_op_00   0x00
  55E9A10E: C9 03                 bne        loc_55E9A111
  55E9A110: 0C                    db_op_0C   0x0C
loc_55E9A111:
  55E9A111: AF                    db_op_AF   0xAF
  55E9A112: 00                    db_op_00   0x00
  55E9A113: C9 0C                 bne        loc_55E9A11F
  55E9A115: CD A1 DD 00 00        call       sub_55E97EB6, [], 0
  55E9A11A: 80 D6                 mov        0xD6, d0
  55E9A11C: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E9A11F:
  55E9A11F: 59 04                 mov        (4, sp), d1
  55E9A121: 9F                    mov        a3, a3
  55E9A122: 14                    db_op_14   0x14
  55E9A123: F1 6F                 ext_f1_6F  
  55E9A125: 73                    mov        d0, (a3)
  55E9A126: 8A                    mov        d2, d2
  55E9A127: 04                    db_op_04   0x04
  55E9A128: F2 14                 ext_f2_14  
  55E9A12A: 63                    mov        (a3), d0
  55E9A12B: EE                    add        d3, d2
  55E9A12C: F1 E8                 ext_f1_E8  
  55E9A12E: F0 00                 nop2       
  55E9A130: F1 A8                 ext_f1_A8  
  55E9A132: C8 36                 beq        loc_55E9A168
  55E9A134: 2B 0C                 cmp        0x0C, d3
loc_55E9A136:
  55E9A136: 77                    mov        d1, (a3)
  55E9A137: 95                    mov        a1, a1
  55E9A138: 60                    mov        (a0), d0
  55E9A139: F1 71                 ext_f1_71  
  55E9A13B: 71                    mov        d0, (a1)
  55E9A13C: F0 08                 ext_f0_08  
  55E9A13E: F2 01                 ext_f2_01  
  55E9A140: F8 41 04              ext_f8_41  0x04
  55E9A143: C8 20                 beq        loc_55E9A163
  55E9A145: F8 EC 01              ext_f8_EC  0x01
  55E9A148: C9 06                 bne        loc_55E9A14E
  55E9A14A: 71                    mov        d0, (a1)
  55E9A14B: A1                    db_op_A1   0xA1
  55E9A14C: C9 17                 bne        loc_55E9A163
loc_55E9A14E:
  55E9A14E: 73                    mov        d0, (a3)
  55E9A14F: 61                    mov        (a1), d0
  55E9A150: 00                    db_op_00   0x00
  55E9A151: CD 69 ED 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E9A156: F1 EC                 ext_f1_EC  
  55E9A158: F0 40                 ext_f0_40  
  55E9A15A: F8 EC 04              ext_f8_EC  0x04
  55E9A15D: C8 06                 beq        loc_55E9A163
  55E9A15F: 00                    db_op_00   0x00
  55E9A160: 63                    mov        (a3), d0
  55E9A161: CA 07                 bra        loc_55E9A168
loc_55E9A163:
  55E9A163: 98                    mov        a2, a0
  55E9A164: F1 A8                 ext_f1_A8  
  55E9A166: C9 D0                 bne        loc_55E9A136
loc_55E9A168:
  55E9A168: CD 8B FE A0 0C        call       sub_55E99FF3, [d2,a2], 12
  55E9A16D: CD 49 DD 00 00        call       sub_55E97EB6, [], 0
loc_55E9A172:
  55E9A172: 00                    db_op_00   0x00
  55E9A173: DF F0 18              ret        [d2,d3,a2,a3], 24

; --- Function sub_55E9A176 (callers: 77) ---
sub_55E9A176:
  55E9A176: 82 1A                 mov        0x1A, d2
  55E9A178: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E9A17E: 85                    mov        d1, d1
  55E9A17F: 01                    db_op_01   0x01
  55E9A180: A0                    db_op_A0   0xA0
  55E9A181: 00                    db_op_00   0x00
  55E9A182: C9 03                 bne        loc_55E9A185
  55E9A184: 04                    db_op_04   0x04
loc_55E9A185:
  55E9A185: A5                    db_op_A5   0xA5
  55E9A186: 01                    db_op_01   0x01
  55E9A187: C8 0C                 beq        loc_55E9A193
  55E9A189: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9A18F: A5                    db_op_A5   0xA5
  55E9A190: 01                    db_op_01   0x01
  55E9A191: C9 07                 bne        loc_55E9A198
loc_55E9A193:
  55E9A193: 80 E7                 mov        0xE7, d0
  55E9A195: DF 80 08              ret        [d2], 8
loc_55E9A198:
  55E9A198: AA                    db_op_AA   0xAA
  55E9A199: 01                    db_op_01   0x01
  55E9A19A: C0 0C                 blt        loc_55E9A1A6
  55E9A19C: FC AD AA B3 E9 55     movhu      (0x55E9B3AA), d1
  55E9A1A2: 19                    db_op_19   0x19
  55E9A1A3: A6                    db_op_A6   0xA6
  55E9A1A4: C3 07                 ble        loc_55E9A1AB
loc_55E9A1A6:
  55E9A1A6: 80 EE                 mov        0xEE, d0
  55E9A1A8: DF 80 08              ret        [d2], 8
loc_55E9A1AB:
  55E9A1AB: CD F2 DC 00 00        call       sub_55E97E9D, [], 0
  55E9A1B0: FC A4 1C F4 08 54     movbu      (0x5408F41C), d0
  55E9A1B6: 85                    mov        d1, d1
  55E9A1B7: 1C                    db_op_1C   0x1C
  55E9A1B8: F2 46                 ext_f2_46  
  55E9A1BA: E8                    add        d2, d0
  55E9A1BB: FC DC E4 FF FF FF     mov        0xFFFFFFE4, a0
  55E9A1C1: F1 60                 ext_f1_60  
  55E9A1C3: F0 60                 ext_f0_60  
  55E9A1C5: A0                    db_op_A0   0xA0
  55E9A1C6: 00                    db_op_00   0x00
  55E9A1C7: C9 04                 bne        loc_55E9A1CB
  55E9A1C9: 90 00                 mov        0x00, a0
loc_55E9A1CB:
  55E9A1CB: B0                    db_op_B0   0xB0
  55E9A1CC: 00                    db_op_00   0x00
  55E9A1CD: C9 0B                 bne        loc_55E9A1D8
  55E9A1CF: CD E7 DC 00 00        call       sub_55E97EB6, [], 0
  55E9A1D4: 80 D6                 mov        0xD6, d0
  55E9A1D6: CA 30                 bra        loc_55E9A206
loc_55E9A1D8:
  55E9A1D8: 91 51                 mov        0x51, a1
  55E9A1DA: 71                    mov        d0, (a1)
  55E9A1DB: F1 94                 ext_f1_94  
  55E9A1DD: C9 1B                 bne        loc_55E9A1F8
  55E9A1DF: F8 00 14              ext_f8_00  0x14
  55E9A1E2: 95                    mov        a1, a1
  55E9A1E3: 18                    db_op_18   0x18
  55E9A1E4: F1 71                 ext_f1_71  
  55E9A1E6: 75                    mov        d1, (a1)
  55E9A1E7: A1                    db_op_A1   0xA1
  55E9A1E8: C4 0B                 bcs        loc_55E9A1F3
  55E9A1EA: CD CC DC 00 00        call       sub_55E97EB6, [], 0
  55E9A1EF: 80 D5                 mov        0xD5, d0
  55E9A1F1: CA 15                 bra        loc_55E9A206
loc_55E9A1F3:
  55E9A1F3: 71                    mov        d0, (a1)
  55E9A1F4: 40 61                 mov        a0, (97, sp)
  55E9A1F6: CA 0A                 bra        loc_55E9A200
loc_55E9A1F8:
  55E9A1F8: F1 E0                 ext_f1_E0  
  55E9A1FA: 00                    db_op_00   0x00
  55E9A1FB: CD 73 EC 30 0C        call       sub_55E98E6E, [a2,a3], 12
loc_55E9A200:
  55E9A200: CD B6 DC 00 00        call       sub_55E97EB6, [], 0
  55E9A205: 00                    db_op_00   0x00
loc_55E9A206:
  55E9A206: DF 80 08              ret        [d2], 8

; --- Function sub_55E9A209 (callers: 20) ---
sub_55E9A209:
  55E9A209: 87                    mov        d1, d3
  55E9A20A: 82 1A                 mov        0x1A, d2
  55E9A20C: 00                    db_op_00   0x00
  55E9A20D: 42 04                 mov        a2, (4, sp)
  55E9A20F: 85                    mov        d1, d1
  55E9A210: 01                    db_op_01   0x01
  55E9A211: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E9A217: A0                    db_op_A0   0xA0
  55E9A218: 00                    db_op_00   0x00
  55E9A219: C9 03                 bne        loc_55E9A21C
  55E9A21B: 04                    db_op_04   0x04
loc_55E9A21C:
  55E9A21C: A5                    db_op_A5   0xA5
  55E9A21D: 01                    db_op_01   0x01
  55E9A21E: C9 07                 bne        loc_55E9A225
  55E9A220: 80 E7                 mov        0xE7, d0
  55E9A222: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E9A225:
  55E9A225: AA                    db_op_AA   0xAA
  55E9A226: 01                    db_op_01   0x01
  55E9A227: C0 0C                 blt        loc_55E9A233
  55E9A229: FC AD B2 B3 E9 55     movhu      (0x55E9B3B2), d1
  55E9A22F: 19                    db_op_19   0x19
  55E9A230: A6                    db_op_A6   0xA6
  55E9A231: C3 07                 ble        loc_55E9A238
loc_55E9A233:
  55E9A233: 80 EE                 mov        0xEE, d0
  55E9A235: DF F0 18              ret        [d2,d3,a2,a3], 24
loc_55E9A238:
  55E9A238: CD 65 DC 00 00        call       sub_55E97E9D, [], 0
  55E9A23D: FC A5 24 F4 08 54     movbu      (0x5408F424), d1
  55E9A243: 80 30                 mov        0x30, d0
  55E9A245: F2 42                 ext_f2_42  
  55E9A247: E9                    add        d2, d1
  55E9A248: 29 D0                 cmp        0xD0, d1
  55E9A24A: F1 E4                 ext_f1_E4  
  55E9A24C: F0 68                 ext_f0_68  
  55E9A24E: 93 AA                 mov        0xAA, a3
  55E9A250: 00                    db_op_00   0x00
  55E9A251: C9 04                 bne        loc_55E9A255
  55E9A253: 9F                    mov        a3, a3
  55E9A254: 00                    db_op_00   0x00
loc_55E9A255:
  55E9A255: BF                    db_op_BF   0xBF
  55E9A256: 00                    db_op_00   0x00
  55E9A257: C9 06                 bne        loc_55E9A25D
  55E9A259: 80 D6                 mov        0xD6, d0
  55E9A25B: CA 68                 bra        loc_55E9A2C3
loc_55E9A25D:
  55E9A25D: 95                    mov        a1, a1
  55E9A25E: 0C                    db_op_0C   0x0C
  55E9A25F: F1 7D                 ext_f1_7D  
  55E9A261: 71                    mov        d0, (a1)
  55E9A262: FC A6 F8 F3 08 54     movbu      (0x5408F3F8), d2
  55E9A268: F1 94                 ext_f1_94  
  55E9A26A: C8 12                 beq        loc_55E9A27C
  55E9A26C: F0 01                 ext_f0_01  
  55E9A26E: 00                    db_op_00   0x00
  55E9A26F: F8 1C 60              ext_f8_1C  0x60
  55E9A272: 75                    mov        d1, (a1)
  55E9A273: F1 E4                 ext_f1_E4  
  55E9A275: CD F9 EB 30 0C        call       sub_55E98E6E, [a2,a3], 12
  55E9A27A: CA 4B                 bra        loc_55E9A2C5
loc_55E9A27C:
  55E9A27C: 9A                    mov        a2, a2
  55E9A27D: 2C F1 7E              mov        0x7EF1, d0
  55E9A280: 72                    mov        d0, (a2)
  55E9A281: A0                    db_op_A0   0xA0
  55E9A282: 00                    db_op_00   0x00
  55E9A283: C7 21                 bls        loc_55E9A2A4
  55E9A285: 95                    mov        a1, a1
  55E9A286: 20 F1                 add        -15, d0
  55E9A288: 7D                    mov        d3, (a1)
  55E9A289: F0 01                 ext_f0_01  
  55E9A28B: 6C                    mov        (a0), d3
  55E9A28C: 71                    mov        d0, (a1)
  55E9A28D: F8 23 28              ext_f8_23  0x28
  55E9A290: F1 90                 ext_f1_90  
  55E9A292: C9 07                 bne        loc_55E9A299
  55E9A294: F8 03 1C              ext_f8_03  0x1C
  55E9A297: CA 04                 bra        loc_55E9A29B
loc_55E9A299:
  55E9A299: 28 04                 cmp        0x04, d0
loc_55E9A29B:
  55E9A29B: 61                    mov        (a1), d0
  55E9A29C: 72                    mov        d0, (a2)
  55E9A29D: 85                    mov        d1, d1
  55E9A29E: 01                    db_op_01   0x01
  55E9A29F: F1 04                 ext_f1_04  
  55E9A2A1: 62                    mov        (a2), d0
  55E9A2A2: CA 23                 bra        loc_55E9A2C5
loc_55E9A2A4:
  55E9A2A4: 9D                    mov        a3, a1
  55E9A2A5: F1 E8                 ext_f1_E8  
  55E9A2A7: 80 10                 mov        0x10, d0
  55E9A2A9: F8 73 02              ext_f8_73  0x02
  55E9A2AC: F8 1C 60              ext_f8_1C  0x60
  55E9A2AF: F8 43 14              ext_f8_43  0x14
  55E9A2B2: 53                    db_op_53   0x53
  55E9A2B3: F1 DD                 ext_f1_DD  
  55E9A2B5: CD 32 EB B0 14        call       sub_55E98DE7, [d2,a2,a3], 20
  55E9A2BA: 9A                    mov        a2, a2
  55E9A2BB: 40 F1                 mov        a0, (241, sp)
  55E9A2BD: 6A                    mov        (a2), d2
  55E9A2BE: 72                    mov        d0, (a2)
  55E9A2BF: A0                    db_op_A0   0xA0
  55E9A2C0: 00                    db_op_00   0x00
  55E9A2C1: C8 04                 beq        loc_55E9A2C5
loc_55E9A2C3:
  55E9A2C3: 42 04                 mov        a2, (4, sp)
loc_55E9A2C5:
  55E9A2C5: CD F1 DB 00 00        call       sub_55E97EB6, [], 0
  55E9A2CA: 58 04                 mov        (4, sp), d0
  55E9A2CC: DF F0 18              ret        [d2,d3,a2,a3], 24

; --- Function sub_55E9A2CF (callers: 1) ---
sub_55E9A2CF:
  55E9A2CF: 18                    db_op_18   0x18
  55E9A2D0: 83 FC                 mov        0xFC, d3
  55E9A2D2: AA                    db_op_AA   0xAA
  55E9A2D3: 08                    db_op_08   0x08
  55E9A2D4: F4 08                 ext_f4_08  
  55E9A2D6: 54                    db_op_54   0x54
  55E9A2D7: 85                    mov        d1, d1
  55E9A2D8: 01                    db_op_01   0x01
  55E9A2D9: AA                    db_op_AA   0xAA
  55E9A2DA: 00                    db_op_00   0x00
  55E9A2DB: C9 03                 bne        loc_55E9A2DE
  55E9A2DD: 04                    db_op_04   0x04
loc_55E9A2DE:
  55E9A2DE: A5                    db_op_A5   0xA5
  55E9A2DF: 01                    db_op_01   0x01
  55E9A2E0: C8 0C                 beq        loc_55E9A2EC
  55E9A2E2: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9A2E8: A5                    db_op_A5   0xA5
  55E9A2E9: 01                    db_op_01   0x01
  55E9A2EA: C9 06                 bne        loc_55E9A2F0
loc_55E9A2EC:
  55E9A2EC: 8A                    mov        d2, d2
  55E9A2ED: E7                    add        d1, d3
  55E9A2EE: CA 78                 bra        loc_55E9A366
loc_55E9A2F0:
  55E9A2F0: 1B                    db_op_1B   0x1B
  55E9A2F1: AF                    db_op_AF   0xAF
  55E9A2F2: 01                    db_op_01   0x01
  55E9A2F3: C0 0C                 blt        loc_55E9A2FF
  55E9A2F5: FC AD CE B3 E9 55     movhu      (0x55E9B3CE), d1
  55E9A2FB: 19                    db_op_19   0x19
  55E9A2FC: A7                    db_op_A7   0xA7
  55E9A2FD: C3 06                 ble        loc_55E9A303
loc_55E9A2FF:
  55E9A2FF: 8A                    mov        d2, d2
  55E9A300: EE                    add        d3, d2
  55E9A301: CA 65                 bra        loc_55E9A366
loc_55E9A303:
  55E9A303: CD 9A DB 00 00        call       sub_55E97E9D, [], 0
  55E9A308: FC A5 40 F4 08 54     movbu      (0x5408F440), d1
  55E9A30E: 80 24                 mov        0x24, d0
  55E9A310: F2 43                 ext_f2_43  
  55E9A312: ED                    add        d3, d1
  55E9A313: FC DD DC FF FF FF     mov        0xFFFFFFDC, a1
  55E9A319: F1 65                 ext_f1_65  
  55E9A31B: F8 61 08              ext_f8_61  0x08
  55E9A31E: A0                    db_op_A0   0xA0
  55E9A31F: 00                    db_op_00   0x00
  55E9A320: C9 04                 bne        loc_55E9A324
  55E9A322: 95                    mov        a1, a1
  55E9A323: 00                    db_op_00   0x00
loc_55E9A324:
  55E9A324: 8A                    mov        d2, d2
  55E9A325: D6                    lbcc       
  55E9A326: B5                    db_op_B5   0xB5
  55E9A327: 00                    db_op_00   0x00
  55E9A328: C8 39                 beq        loc_55E9A361
  55E9A32A: 9A                    mov        a2, a2
  55E9A32B: 10                    db_op_10   0x10
  55E9A32C: F1 76                 ext_f1_76  
  55E9A32E: F0 42                 ext_f0_42  
  55E9A330: F8 EC 04              ext_f8_EC  0x04
  55E9A333: C9 28                 bne        loc_55E9A35B
  55E9A335: F8 61 0A              ext_f8_61  0x0A
  55E9A338: A0                    db_op_A0   0xA0
  55E9A339: 00                    db_op_00   0x00
  55E9A33A: C9 1A                 bne        loc_55E9A354
  55E9A33C: FC CC E4 F3 08 54     mov        0x5408F3E4, d0
  55E9A342: 61                    mov        (a1), d0
  55E9A343: FC A0 E8 F3 08 54     mov        (0x5408F3E8), d0
  55E9A349: F8 31 04              ext_f8_31  0x04
  55E9A34C: F0 14                 ext_f0_14  
  55E9A34E: FC 84 E8 F3 08 54     movb       d0, (0x5408F3E8)
loc_55E9A354:
  55E9A354: F8 02 0C              ext_f8_02  0x0C
  55E9A357: 40 F8                 mov        a0, (248, sp)
  55E9A359: 11                    db_op_11   0x11
  55E9A35A: 0C                    db_op_0C   0x0C
loc_55E9A35B:
  55E9A35B: 80 01                 mov        0x01, d0
  55E9A35D: F8 71 0A              ext_f8_71  0x0A
  55E9A360: 08                    db_op_08   0x08
loc_55E9A361:
  55E9A361: CD 55 DB 00 00        call       sub_55E97EB6, [], 0
loc_55E9A366:
  55E9A366: 88                    mov        d2, d0
  55E9A367: DF E0 10              ret        [d2,d3,a2], 16

; --- Function sub_55E9A36A (callers: 1) ---
sub_55E9A36A:
  55E9A36A: 18                    db_op_18   0x18
  55E9A36B: 83 FC                 mov        0xFC, d3
  55E9A36D: AA                    db_op_AA   0xAA
  55E9A36E: 08                    db_op_08   0x08
  55E9A36F: F4 08                 ext_f4_08  
  55E9A371: 54                    db_op_54   0x54
  55E9A372: 85                    mov        d1, d1
  55E9A373: 01                    db_op_01   0x01
  55E9A374: AA                    db_op_AA   0xAA
  55E9A375: 00                    db_op_00   0x00
  55E9A376: C9 03                 bne        loc_55E9A379
  55E9A378: 04                    db_op_04   0x04
loc_55E9A379:
  55E9A379: A5                    db_op_A5   0xA5
  55E9A37A: 01                    db_op_01   0x01
  55E9A37B: C8 0C                 beq        loc_55E9A387
  55E9A37D: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9A383: A5                    db_op_A5   0xA5
  55E9A384: 01                    db_op_01   0x01
  55E9A385: C9 06                 bne        loc_55E9A38B
loc_55E9A387:
  55E9A387: 8A                    mov        d2, d2
  55E9A388: E7                    add        d1, d3
  55E9A389: CA 61                 bra        loc_55E9A3EA
loc_55E9A38B:
  55E9A38B: 1B                    db_op_1B   0x1B
  55E9A38C: AF                    db_op_AF   0xAF
  55E9A38D: 01                    db_op_01   0x01
  55E9A38E: C0 0C                 blt        loc_55E9A39A
  55E9A390: FC AD CE B3 E9 55     movhu      (0x55E9B3CE), d1
  55E9A396: 19                    db_op_19   0x19
  55E9A397: A7                    db_op_A7   0xA7
  55E9A398: C3 06                 ble        loc_55E9A39E
loc_55E9A39A:
  55E9A39A: 8A                    mov        d2, d2
  55E9A39B: EE                    add        d3, d2
  55E9A39C: CA 4E                 bra        loc_55E9A3EA
loc_55E9A39E:
  55E9A39E: CD FF DA 00 00        call       sub_55E97E9D, [], 0
  55E9A3A3: FC A5 40 F4 08 54     movbu      (0x5408F440), d1
  55E9A3A9: 80 24                 mov        0x24, d0
  55E9A3AB: F2 43                 ext_f2_43  
  55E9A3AD: ED                    add        d3, d1
  55E9A3AE: FC DC DC FF FF FF     mov        0xFFFFFFDC, a0
  55E9A3B4: F1 64                 ext_f1_64  
  55E9A3B6: F8 60 08              ext_f8_60  0x08
  55E9A3B9: A0                    db_op_A0   0xA0
  55E9A3BA: 00                    db_op_00   0x00
  55E9A3BB: C9 04                 bne        loc_55E9A3BF
  55E9A3BD: 90 00                 mov        0x00, a0
loc_55E9A3BF:
  55E9A3BF: 8A                    mov        d2, d2
  55E9A3C0: D6                    lbcc       
  55E9A3C1: B0                    db_op_B0   0xB0
  55E9A3C2: 00                    db_op_00   0x00
  55E9A3C3: C8 22                 beq        loc_55E9A3E5
  55E9A3C5: 9A                    mov        a2, a2
  55E9A3C6: 0A                    db_op_0A   0x0A
  55E9A3C7: F1 72                 ext_f1_72  
  55E9A3C9: F0 62                 ext_f0_62  
  55E9A3CB: A0                    db_op_A0   0xA0
  55E9A3CC: 01                    db_op_01   0x01
  55E9A3CD: C9 14                 bne        loc_55E9A3E1
  55E9A3CF: F8 40 10              ext_f8_40  0x10
  55E9A3D2: F8 EC 04              ext_f8_EC  0x04
  55E9A3D5: C9 0C                 bne        loc_55E9A3E1
  55E9A3D7: F0 04                 ext_f0_04  
  55E9A3D9: F8 20 04              ext_f8_20  0x04
  55E9A3DC: F8 31 04              ext_f8_31  0x04
  55E9A3DF: F0 14                 ext_f0_14  
loc_55E9A3E1:
  55E9A3E1: 00                    db_op_00   0x00
  55E9A3E2: F0 72                 ext_f0_72  
  55E9A3E4: 08                    db_op_08   0x08
loc_55E9A3E5:
  55E9A3E5: CD D1 DA 00 00        call       sub_55E97EB6, [], 0
loc_55E9A3EA:
  55E9A3EA: 88                    mov        d2, d0
  55E9A3EB: DF E0 10              ret        [d2,d3,a2], 16

; --- Function sub_55E9A3EE (callers: 4) ---
sub_55E9A3EE:
  55E9A3EE: 82 1A                 mov        0x1A, d2
  55E9A3F0: FC A8 08 F4 08 54     ext_fc_A8  0x5408F408
  55E9A3F6: 85                    mov        d1, d1
  55E9A3F7: 01                    db_op_01   0x01
  55E9A3F8: A0                    db_op_A0   0xA0
  55E9A3F9: 00                    db_op_00   0x00
  55E9A3FA: C9 03                 bne        loc_55E9A3FD
  55E9A3FC: 04                    db_op_04   0x04
loc_55E9A3FD:
  55E9A3FD: A5                    db_op_A5   0xA5
  55E9A3FE: 01                    db_op_01   0x01
  55E9A3FF: C8 0C                 beq        loc_55E9A40B
  55E9A401: FC A9 09 F4 08 54     ext_fc_A9  0x5408F409
  55E9A407: A5                    db_op_A5   0xA5
  55E9A408: 01                    db_op_01   0x01
  55E9A409: C9 04                 bne        loc_55E9A40D
loc_55E9A40B:
  55E9A40B: CA 7F                 bra        loc_55E9A48A
loc_55E9A40D:
  55E9A40D: AA                    db_op_AA   0xAA
  55E9A40E: 01                    db_op_01   0x01
  55E9A40F: C0 0C                 blt        loc_55E9A41B
  55E9A411: FC AD A6 B3 E9 55     movhu      (0x55E9B3A6), d1
  55E9A417: 19                    db_op_19   0x19
  55E9A418: A6                    db_op_A6   0xA6
  55E9A419: C3 0B                 ble        loc_55E9A424
loc_55E9A41B:
  55E9A41B: AA                    db_op_AA   0xAA
  55E9A41C: 00                    db_op_00   0x00
  55E9A41D: C8 07                 beq        loc_55E9A424
  55E9A41F: 80 EE                 mov        0xEE, d0
  55E9A421: DF 80 08              ret        [d2], 8
loc_55E9A424:
  55E9A424: CD 79 DA 00 00        call       sub_55E97E9D, [], 0
  55E9A429: FC A0 F8 F3 08 54     mov        (0x5408F3F8), d0
  55E9A42F: AA                    db_op_AA   0xAA
  55E9A430: 00                    db_op_00   0x00
  55E9A431: C8 39                 beq        loc_55E9A46A
  55E9A433: FC A4 18 F4 08 54     movbu      (0x5408F418), d0
  55E9A439: 85                    mov        d1, d1
  55E9A43A: 70                    mov        d0, (a0)
  55E9A43B: F2 46                 ext_f2_46  
  55E9A43D: E8                    add        d2, d0
  55E9A43E: 28 90                 cmp        0x90, d0
  55E9A440: F1 E0                 ext_f1_E0  
  55E9A442: F8 68 10              ext_f8_68  0x10
  55E9A445: AA                    db_op_AA   0xAA
  55E9A446: 00                    db_op_00   0x00
  55E9A447: C9 03                 bne        loc_55E9A44A
  55E9A449: 00                    db_op_00   0x00
loc_55E9A44A:
  55E9A44A: F1 E0                 ext_f1_E0  
  55E9A44C: B0                    db_op_B0   0xB0
  55E9A44D: 00                    db_op_00   0x00
  55E9A44E: C9 0C                 bne        loc_55E9A45A
  55E9A450: CD 66 DA 00 00        call       sub_55E97EB6, [], 0
  55E9A455: 80 D6                 mov        0xD6, d0
  55E9A457: DF 80 08              ret        [d2], 8
loc_55E9A45A:
  55E9A45A: F8 60 0C              ext_f8_60  0x0C
  55E9A45D: A0                    db_op_A0   0xA0
  55E9A45E: 10                    db_op_10   0x10
  55E9A45F: C9 0B                 bne        loc_55E9A46A
  55E9A461: CD 55 DA 00 00        call       sub_55E97EB6, [], 0
  55E9A466: 80 D7                 mov        0xD7, d0
  55E9A468: CA 49                 bra        loc_55E9A4B1
loc_55E9A46A:
  55E9A46A: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E9A470: 85                    mov        d1, d1
  55E9A471: 01                    db_op_01   0x01
  55E9A472: A0                    db_op_A0   0xA0
  55E9A473: 00                    db_op_00   0x00
  55E9A474: C9 03                 bne        loc_55E9A477
  55E9A476: 04                    db_op_04   0x04
loc_55E9A477:
  55E9A477: A5                    db_op_A5   0xA5
  55E9A478: 01                    db_op_01   0x01
  55E9A479: C9 15                 bne        loc_55E9A48E
  55E9A47B: FC A4 F8 F3 08 54     movbu      (0x5408F3F8), d0
  55E9A481: F1 A0                 ext_f1_A0  
  55E9A483: C9 0B                 bne        loc_55E9A48E
  55E9A485: CD 31 DA 00 00        call       sub_55E97EB6, [], 0
loc_55E9A48A:
  55E9A48A: 80 E7                 mov        0xE7, d0
  55E9A48C: CA 25                 bra        loc_55E9A4B1
loc_55E9A48E:
  55E9A48E: 95                    mov        a1, a1
  55E9A48F: 16                    db_op_16   0x16
  55E9A490: F1 71                 ext_f1_71  
  55E9A492: F0 41                 ext_f0_41  
  55E9A494: FA C8 FF 00           bxx16      loc_55E9A593
  55E9A498: C0 0B                 blt        loc_55E9A4A3
  55E9A49A: CD 1C DA 00 00        call       sub_55E97EB6, [], 0
  55E9A49F: 80 D5                 mov        0xD5, d0
  55E9A4A1: CA 10                 bra        loc_55E9A4B1
loc_55E9A4A3:
  55E9A4A3: 40 F0                 mov        a0, (240, sp)
  55E9A4A5: 51                    db_op_51   0x51
  55E9A4A6: CD 5B EA 30 0C        call       sub_55E98F01, [a2,a3], 12
  55E9A4AB: CD 0B DA 00 00        call       sub_55E97EB6, [], 0
  55E9A4B0: 00                    db_op_00   0x00
loc_55E9A4B1:
  55E9A4B1: DF 80 08              ret        [d2], 8

; --- Function sub_55E9A4B4 (callers: 15) ---
sub_55E9A4B4:
  55E9A4B4: FC A5 5C F3 08 54     movbu      (0x5408F35C), d1
  55E9A4BA: FC DC 54 F3 08 54     mov        0x5408F354, a0
  55E9A4C0: F1 91                 ext_f1_91  
  55E9A4C2: C8 06                 beq        loc_55E9A4C8
  55E9A4C4: A0                    db_op_A0   0xA0
  55E9A4C5: EC                    add        d3, d0
  55E9A4C6: C4 07                 bcs        loc_55E9A4CD
loc_55E9A4C8:
  55E9A4C8: 90 00                 mov        0x00, a0
  55E9A4CA: DE F0 10              retf       [d2,d3,a2,a3], 16
loc_55E9A4CD:
  55E9A4CD: 28 18                 cmp        0x18, d0
  55E9A4CF: 85                    mov        d1, d1
  55E9A4D0: 01                    db_op_01   0x01
  55E9A4D1: F1 04                 ext_f1_04  
  55E9A4D3: FC E0 FC FF FF FF     ext_fc_E0  0xFFFFFFFC
  55E9A4D9: FA C8 00 01           bxx16      loc_55E9A5D9
  55E9A4DD: C6 76                 bcc        loc_55E9A553
  55E9A4DF: FC A7 5C F3 08 54     movbu      (0x5408F35C), d3
loc_55E9A4E5:
  55E9A4E5: F1 93                 ext_f1_93  
  55E9A4E7: C9 06                 bne        loc_55E9A4ED
  55E9A4E9: 90 00                 mov        0x00, a0
  55E9A4EB: CA 66                 bra        loc_55E9A551
loc_55E9A4ED:
  55E9A4ED: 95                    mov        a1, a1
  55E9A4EE: 10                    db_op_10   0x10
  55E9A4EF: F1 6D                 ext_f1_6D  
  55E9A4F1: 75                    mov        d1, (a1)
  55E9A4F2: F1 01                 ext_f1_01  
  55E9A4F4: A5                    db_op_A5   0xA5
  55E9A4F5: 00                    db_op_00   0x00
  55E9A4F6: C2 09                 bge        loc_55E9A4FF
  55E9A4F8: F1 ED                 ext_f1_ED  
  55E9A4FA: F8 0D 08              ext_f8_0D  0x08
  55E9A4FD: CA E8                 bra        loc_55E9A4E5
loc_55E9A4FF:
  55E9A4FF: A5                    db_op_A5   0xA5
  55E9A500: 28 C7                 cmp        0xC7, d0
  55E9A502: 36                    db_op_36   0x36
  55E9A503: 8E                    mov        d3, d2
  55E9A504: E2                    add        d0, d2
  55E9A505: F1 E8                 ext_f1_E8  
  55E9A507: F8 14 10              ext_f8_14  0x10
  55E9A50A: 61                    mov        (a1), d0
  55E9A50B: 9F                    mov        a3, a3
  55E9A50C: 0C                    db_op_0C   0x0C
  55E9A50D: F1 6F                 ext_f1_6F  
  55E9A50F: F0 07                 ext_f0_07  
  55E9A511: 9A                    mov        a2, a2
  55E9A512: 08                    db_op_08   0x08
  55E9A513: F8 19 08              ext_f8_19  0x08
  55E9A516: F1 6E                 ext_f1_6E  
  55E9A518: F0 06                 ext_f0_06  
  55E9A51A: F8 19 0C              ext_f8_19  0x0C
  55E9A51D: F1 ED                 ext_f1_ED  
  55E9A51F: 71                    mov        d0, (a1)
  55E9A520: 60                    mov        (a0), d0
  55E9A521: 69                    mov        (a1), d2
  55E9A522: F0 04                 ext_f0_04  
  55E9A524: F8 19 04              ext_f8_19  0x04
  55E9A527: F8 1C 04              ext_f8_1C  0x04
  55E9A52A: 72                    mov        d0, (a2)
  55E9A52B: F8 10 08              ext_f8_10  0x08
  55E9A52E: 73                    mov        d0, (a3)
  55E9A52F: F8 10 0C              ext_f8_10  0x0C
  55E9A532: 00                    db_op_00   0x00
  55E9A533: 62                    mov        (a2), d0
  55E9A534: 63                    mov        (a3), d0
  55E9A535: CA 17                 bra        loc_55E9A54C
  55E9A537: 9F                    mov        a3, a3
  55E9A538: 08                    db_op_08   0x08
  55E9A539: F1 6F                 ext_f1_6F  
  55E9A53B: F0 03                 ext_f0_03  
  55E9A53D: 9A                    mov        a2, a2
  55E9A53E: 0C                    db_op_0C   0x0C
  55E9A53F: F1 6E                 ext_f1_6E  
  55E9A541: F0 06                 ext_f0_06  
  55E9A543: 00                    db_op_00   0x00
  55E9A544: F8 34 0C              ext_f8_34  0x0C
  55E9A547: F8 31 08              ext_f8_31  0x08
  55E9A54A: 63                    mov        (a3), d0
  55E9A54B: 62                    mov        (a2), d0
loc_55E9A54C:
  55E9A54C: 80 14                 mov        0x14, d0
  55E9A54E: EC                    add        d3, d0
  55E9A54F: F1 E0                 ext_f1_E0  
loc_55E9A551:
  55E9A551: CA 62                 bra        loc_55E9A5B3
loc_55E9A553:
  55E9A553: FC A7 60 F3 08 54     movbu      (0x5408F360), d3
loc_55E9A559:
  55E9A559: F1 93                 ext_f1_93  
  55E9A55B: C9 06                 bne        loc_55E9A561
  55E9A55D: 90 00                 mov        0x00, a0
  55E9A55F: CA 54                 bra        loc_55E9A5B3
loc_55E9A561:
  55E9A561: 95                    mov        a1, a1
  55E9A562: 10                    db_op_10   0x10
  55E9A563: F1 6D                 ext_f1_6D  
  55E9A565: 75                    mov        d1, (a1)
  55E9A566: F1 01                 ext_f1_01  
  55E9A568: A5                    db_op_A5   0xA5
  55E9A569: 00                    db_op_00   0x00
  55E9A56A: C2 09                 bge        loc_55E9A573
  55E9A56C: F1 ED                 ext_f1_ED  
  55E9A56E: F8 0D 0C              ext_f8_0D  0x0C
  55E9A571: CA E8                 bra        loc_55E9A559
loc_55E9A573:
  55E9A573: A5                    db_op_A5   0xA5
  55E9A574: 28 C7                 cmp        0xC7, d0
  55E9A576: 25 8E E6              mov        0xE68E, a1
  55E9A579: F1 E8                 ext_f1_E8  
  55E9A57B: 65                    mov        (a1), d1
  55E9A57C: F8 10 10              ext_f8_10  0x10
  55E9A57F: F1 ED                 ext_f1_ED  
  55E9A581: 71                    mov        d0, (a1)
  55E9A582: 60                    mov        (a0), d0
  55E9A583: 69                    mov        (a1), d2
  55E9A584: F0 04                 ext_f0_04  
  55E9A586: 00                    db_op_00   0x00
  55E9A587: F8 19 04              ext_f8_19  0x04
  55E9A58A: F8 1C 04              ext_f8_1C  0x04
  55E9A58D: F8 10 08              ext_f8_10  0x08
  55E9A590: F8 10 0C              ext_f8_10  0x0C
loc_55E9A593:
  55E9A593: 88                    mov        d2, d0
  55E9A594: 28 14                 cmp        0x14, d0
  55E9A596: F1 E0                 ext_f1_E0  
  55E9A598: CA 1B                 bra        loc_55E9A5B3
  55E9A59A: 9F                    mov        a3, a3
  55E9A59B: 08                    db_op_08   0x08
  55E9A59C: F1 6F                 ext_f1_6F  
  55E9A59E: F0 03                 ext_f0_03  
  55E9A5A0: 9A                    mov        a2, a2
  55E9A5A1: 0C                    db_op_0C   0x0C
  55E9A5A2: F1 6E                 ext_f1_6E  
  55E9A5A4: F0 06                 ext_f0_06  
  55E9A5A6: 2B 14                 cmp        0x14, d3
  55E9A5A8: F8 34 0C              ext_f8_34  0x0C
  55E9A5AB: F8 31 08              ext_f8_31  0x08
  55E9A5AE: F1 EC                 ext_f1_EC  
  55E9A5B0: 00                    db_op_00   0x00
  55E9A5B1: 63                    mov        (a3), d0
  55E9A5B2: 62                    mov        (a2), d0
loc_55E9A5B3:
  55E9A5B3: DE F0 10              retf       [d2,d3,a2,a3], 16

; --- Function sub_55E9A5B6 (callers: 1) ---
sub_55E9A5B6:
  55E9A5B6: FC DC 54 F3 08 54     mov        0x5408F354, a0
  55E9A5BC: FC DD 78 8C 07 54     mov        0x54078C78, a1
  55E9A5C2: FC CC B0 66 01 00     mov        0x000166B0, d0
  55E9A5C8: FC 80 78 8C 07 54     mov        d0, (0x54078C78)
  55E9A5CE: FC 80 7C 8C 07 54     mov        d0, (0x54078C7C)
  55E9A5D4: FC 80 80 8C 07 54     mov        d0, (0x54078C80)
  55E9A5DA: FC 80 84 8C 07 54     mov        d0, (0x54078C84)
  55E9A5E0: FC 81 88 8C 07 54     mov        d1, (0x54078C88)
  55E9A5E6: FC 84 54 F3 08 54     movb       d0, (0x5408F354)
  55E9A5EC: FC 84 58 F3 08 54     movb       d0, (0x5408F358)
  55E9A5F2: FC 84 5C F3 08 54     movb       d0, (0x5408F35C)
  55E9A5F8: FC 84 60 F3 08 54     movb       d0, (0x5408F360)
  55E9A5FE: FC 81 64 F3 08 54     mov        d1, (0x5408F364)
  55E9A604: DE 00 00              retf       [], 0

; --- Function sub_55E9A607 (callers: 1) ---
sub_55E9A607:
  55E9A607: FC A6 E4 F3 08 54     movbu      (0x5408F3E4), d2
  55E9A60D: FC DE E4 F3 08 54     mov        0x5408F3E4, a2
  55E9A613: F1 9A                 ext_f1_9A  
  55E9A615: C8 2D                 beq        loc_55E9A642
loc_55E9A617:
  55E9A617: 90 0C                 mov        0x0C, a0
  55E9A619: F1 68                 ext_f1_68  
  55E9A61B: 70                    mov        d0, (a0)
  55E9A61C: A0                    db_op_A0   0xA0
  55E9A61D: 00                    db_op_00   0x00
  55E9A61E: C9 1D                 bne        loc_55E9A63B
  55E9A620: 74                    mov        d1, (a0)
  55E9A621: F1 E9                 ext_f1_E9  
  55E9A623: F8 01 1C              ext_f8_01  0x1C
  55E9A626: E1                    add        d0, d1
  55E9A627: 64                    mov        (a0), d1
  55E9A628: F8 61 0A              ext_f8_61  0x0A
  55E9A62B: A0                    db_op_A0   0xA0
  55E9A62C: 01                    db_op_01   0x01
  55E9A62D: C9 0E                 bne        loc_55E9A63B
  55E9A62F: 90 10                 mov        0x10, a0
  55E9A631: F1 74                 ext_f1_74  
  55E9A633: F8 24 08              ext_f8_24  0x08
  55E9A636: F8 00 04              ext_f8_00  0x04
  55E9A639: F0 F1                 calls      (a1)
loc_55E9A63B:
  55E9A63B: F1 E8                 ext_f1_E8  
  55E9A63D: 78                    mov        d2, (a0)
  55E9A63E: F1 9A                 ext_f1_9A  
  55E9A640: C9 D7                 bne        loc_55E9A617
loc_55E9A642:
  55E9A642: DF A0 0C              ret        [d2,a2], 12

; --- Function sub_55E9A645 (callers: 1) ---
sub_55E9A645:
  55E9A645: 3C F1                 mov        d0, (241, sp)
  55E9A647: D3                    lble       
  55E9A648: 2B 08                 cmp        0x08, d3
  55E9A64A: F1 EC                 ext_f1_EC  
  55E9A64C: CD A6 D8 00 00        call       sub_55E97EF2, [], 0
  55E9A651: FC A4 10 F4 08 54     movbu      (0x5408F410), d0
  55E9A657: 40 FC                 mov        a0, (252, sp)
  55E9A659: 81 10                 mov        0x10, d1
  55E9A65B: F4 08                 ext_f4_08  
  55E9A65D: 54                    db_op_54   0x54
  55E9A65E: A0                    db_op_A0   0xA0
  55E9A65F: 01                    db_op_01   0x01
  55E9A660: C6 0F                 bcc        loc_55E9A66F
  55E9A662: FC AC 14 F4 08 54     movhu      (0x5408F414), d0
  55E9A668: 40 FC                 mov        a0, (252, sp)
  55E9A66A: 83 14                 mov        0x14, d3
  55E9A66C: F4 08                 ext_f4_08  
  55E9A66E: 54                    db_op_54   0x54
loc_55E9A66F:
  55E9A66F: 58 08                 mov        (8, sp), d0
  55E9A671: CD 95 D8 00 00        call       sub_55E97F06, [], 0
  55E9A676: FC A6 E4 F3 08 54     movbu      (0x5408F3E4), d2
  55E9A67C: FC DE E4 F3 08 54     mov        0x5408F3E4, a2
  55E9A682: F1 9A                 ext_f1_9A  
  55E9A684: C8 3A                 beq        loc_55E9A6BE
loc_55E9A686:
  55E9A686: 90 0C                 mov        0x0C, a0
  55E9A688: F1 68                 ext_f1_68  
  55E9A68A: 70                    mov        d0, (a0)
  55E9A68B: A0                    db_op_A0   0xA0
  55E9A68C: 01                    db_op_01   0x01
  55E9A68D: C5 25                 bhi        loc_55E9A6B2
  55E9A68F: 74                    mov        d1, (a0)
  55E9A690: F1 E9                 ext_f1_E9  
  55E9A692: F8 01 1C              ext_f8_01  0x1C
  55E9A695: 95                    mov        a1, a1
  55E9A696: 01                    db_op_01   0x01
  55E9A697: F1 14                 ext_f1_14  
  55E9A699: E1                    add        d0, d1
  55E9A69A: 64                    mov        (a0), d1
  55E9A69B: F1 E8                 ext_f1_E8  
  55E9A69D: F8 60 0A              ext_f8_60  0x0A
  55E9A6A0: A0                    db_op_A0   0xA0
  55E9A6A1: 01                    db_op_01   0x01
  55E9A6A2: C9 15                 bne        loc_55E9A6B7
  55E9A6A4: 90 10                 mov        0x10, a0
  55E9A6A6: F1 68                 ext_f1_68  
  55E9A6A8: F8 24 08              ext_f8_24  0x08
  55E9A6AB: F8 00 04              ext_f8_00  0x04
  55E9A6AE: F0 F1                 calls      (a1)
  55E9A6B0: CA 07                 bra        loc_55E9A6B7
loc_55E9A6B2:
  55E9A6B2: 85                    mov        d1, d1
  55E9A6B3: 01                    db_op_01   0x01
  55E9A6B4: F1 04                 ext_f1_04  
  55E9A6B6: 60                    mov        (a0), d0
loc_55E9A6B7:
  55E9A6B7: F1 E8                 ext_f1_E8  
  55E9A6B9: 78                    mov        d2, (a0)
  55E9A6BA: F1 9A                 ext_f1_9A  
  55E9A6BC: C9 CA                 bne        loc_55E9A686
loc_55E9A6BE:
  55E9A6BE: FC A2 EC F3 08 54     mov        (0x5408F3EC), d2
  55E9A6C4: FC CE EC F3 08 54     mov        0x5408F3EC, d2
  55E9A6CA: F1 AA                 ext_f1_AA  
  55E9A6CC: C8 33                 beq        loc_55E9A6FF
loc_55E9A6CE:
  55E9A6CE: 90 0C                 mov        0x0C, a0
  55E9A6D0: F1 78                 ext_f1_78  
  55E9A6D2: 70                    mov        d0, (a0)
  55E9A6D3: A0                    db_op_A0   0xA0
  55E9A6D4: 01                    db_op_01   0x01
  55E9A6D5: C5 1F                 bhi        loc_55E9A6F4
  55E9A6D7: 00                    db_op_00   0x00
  55E9A6D8: 60                    mov        (a0), d0
  55E9A6D9: F8 72 0A              ext_f8_72  0x0A
  55E9A6DC: F0 06                 ext_f0_06  
  55E9A6DE: F8 22 04              ext_f8_22  0x04
  55E9A6E1: F8 31 04              ext_f8_31  0x04
  55E9A6E4: F0 14                 ext_f0_14  
  55E9A6E6: 90 10                 mov        0x10, a0
  55E9A6E8: F1 78                 ext_f1_78  
  55E9A6EA: F8 24 08              ext_f8_24  0x08
  55E9A6ED: F8 00 04              ext_f8_00  0x04
  55E9A6F0: F0 F1                 calls      (a1)
  55E9A6F2: CA 07                 bra        loc_55E9A6F9
loc_55E9A6F4:
  55E9A6F4: 85                    mov        d1, d1
  55E9A6F5: 01                    db_op_01   0x01
  55E9A6F6: F1 04                 ext_f1_04  
  55E9A6F8: 60                    mov        (a0), d0
loc_55E9A6F9:
  55E9A6F9: F0 0A                 ext_f0_0A  
  55E9A6FB: F1 AA                 ext_f1_AA  
  55E9A6FD: C9 D1                 bne        loc_55E9A6CE
loc_55E9A6FF:
  55E9A6FF: FC A0 04 F4 08 54     mov        (0x5408F404), d0
  55E9A705: FC A1 F8 F3 08 54     mov        (0x5408F3F8), d1
  55E9A70B: B0                    db_op_B0   0xB0
  55E9A70C: 00                    db_op_00   0x00
  55E9A70D: C8 27                 beq        loc_55E9A734
  55E9A70F: 90 3C                 mov        0x3C, a0
  55E9A711: F1 74                 ext_f1_74  
  55E9A713: 70                    mov        d0, (a0)
  55E9A714: A0                    db_op_A0   0xA0
  55E9A715: 00                    db_op_00   0x00
  55E9A716: C8 1E                 beq        loc_55E9A734
  55E9A718: A0                    db_op_A0   0xA0
  55E9A719: 01                    db_op_01   0x01
  55E9A71A: C5 15                 bhi        loc_55E9A72F
  55E9A71C: 00                    db_op_00   0x00
  55E9A71D: 60                    mov        (a0), d0
  55E9A71E: F8 61 10              ext_f8_61  0x10
  55E9A721: F8 05 48              ext_f8_05  0x48
  55E9A724: FC A1 04 F4 08 54     mov        (0x5408F404), d1
  55E9A72A: 18                    db_op_18   0x18
  55E9A72B: F0 F1                 calls      (a1)
  55E9A72D: CA 07                 bra        loc_55E9A734
loc_55E9A72F:
  55E9A72F: 85                    mov        d1, d1
  55E9A730: 01                    db_op_01   0x01
  55E9A731: F1 04                 ext_f1_04  
  55E9A733: 60                    mov        (a0), d0
loc_55E9A734:
  55E9A734: F1 EC                 ext_f1_EC  
  55E9A736: CD BC D7 00 00        call       sub_55E97EF2, [], 0
  55E9A73B: FC A4 DC F3 08 54     movbu      (0x5408F3DC), d0
  55E9A741: 42 04                 mov        a2, (4, sp)
  55E9A743: FC C8 DC F3 08 54     ext_fc_C8  0x5408F3DC
  55E9A749: C9 05                 bne        loc_55E9A74E
  55E9A74B: CC E2 00              jmp        loc_55E9A82D
loc_55E9A74E:
  55E9A74E: 8F                    mov        d3, d3
  55E9A74F: 1C                    db_op_1C   0x1C
  55E9A750: F1 0C                 ext_f1_0C  
  55E9A752: 83 95                 mov        0x95, d3
  55E9A754: 24 F1 6D              mov        0x6DF1, a0
  55E9A757: 71                    mov        d0, (a1)
  55E9A758: A0                    db_op_A0   0xA0
  55E9A759: 01                    db_op_01   0x01
  55E9A75A: C3 05                 ble        loc_55E9A75F
  55E9A75C: CC BE 00              jmp        loc_55E9A81A
loc_55E9A75F:
  55E9A75F: 95                    mov        a1, a1
  55E9A760: 0E                    db_op_0E   0x0E
  55E9A761: F1 6D                 ext_f1_6D  
  55E9A763: F0 61                 ext_f0_61  
  55E9A765: FA C8 00 01           bxx16      loc_55E9A865
  55E9A769: C8 14                 beq        loc_55E9A77D
  55E9A76B: FA C8 00 40           bxx16      loc_55E9E76B
  55E9A76F: C8 0E                 beq        loc_55E9A77D
  55E9A771: F1 EC                 ext_f1_EC  
  55E9A773: 80 CE                 mov        0xCE, d0
  55E9A775: CD 45 E7 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E9A77A: CC A3 00              jmp        loc_55E9A81D
loc_55E9A77D:
  55E9A77D: F0 61                 ext_f0_61  
  55E9A77F: FA C8 00 01           bxx16      loc_55E9A87F
  55E9A783: C9 49                 bne        loc_55E9A7CC
  55E9A785: 95                    mov        a1, a1
  55E9A786: 12                    db_op_12   0x12
  55E9A787: F1 6D                 ext_f1_6D  
  55E9A789: F0 61                 ext_f0_61  
  55E9A78B: FC A5 30 F4 08 54     movbu      (0x5408F430), d1
  55E9A791: 18                    db_op_18   0x18
  55E9A792: 8A                    mov        d2, d2
  55E9A793: 38                    db_op_38   0x38
  55E9A794: F2 42                 ext_f2_42  
  55E9A796: F1 E8                 ext_f1_E8  
  55E9A798: F1 64                 ext_f1_64  
  55E9A79A: F8 60 C8              ext_f8_60  0xC8
  55E9A79D: 08                    db_op_08   0x08
  55E9A79E: A8                    db_op_A8   0xA8
  55E9A79F: C8 0D                 beq        loc_55E9A7AC
  55E9A7A1: F0 61                 ext_f0_61  
  55E9A7A3: 8A                    mov        d2, d2
  55E9A7A4: 38                    db_op_38   0x38
  55E9A7A5: 18                    db_op_18   0x18
  55E9A7A6: F2 48                 ext_f2_48  
  55E9A7A8: 82 E6                 mov        0xE6, d2
  55E9A7AA: 2A C8                 cmp        0xC8, d2
loc_55E9A7AC:
  55E9A7AC: F1 EA                 ext_f1_EA  
  55E9A7AE: 52                    db_op_52   0x52
  55E9A7AF: F0 0E                 ext_f0_0E  
  55E9A7B1: F1 EC                 ext_f1_EC  
  55E9A7B3: 80 CE                 mov        0xCE, d0
  55E9A7B5: CD 05 E7 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E9A7BA: F1 9F                 ext_f1_9F  
  55E9A7BC: C9 61                 bne        loc_55E9A81D
  55E9A7BE: 72                    mov        d0, (a2)
  55E9A7BF: F1 98                 ext_f1_98  
  55E9A7C1: C8 5C                 beq        loc_55E9A81D
  55E9A7C3: F1 E8                 ext_f1_E8  
  55E9A7C5: CD 5E EB 30 0C        call       sub_55E99323, [a2,a3], 12
  55E9A7CA: CA 53                 bra        loc_55E9A81D
loc_55E9A7CC:
  55E9A7CC: FA C8 00 40           bxx16      loc_55E9E7CC
  55E9A7D0: C9 4D                 bne        loc_55E9A81D
  55E9A7D2: 90 12                 mov        0x12, a0
  55E9A7D4: F1 6C                 ext_f1_6C  
  55E9A7D6: F0 60                 ext_f0_60  
  55E9A7D8: FC A1 3C F4 08 54     mov        (0x5408F43C), d1
  55E9A7DE: 18                    db_op_18   0x18
  55E9A7DF: 85                    mov        d1, d1
  55E9A7E0: 24 F2 44              mov        0x44F2, a0
  55E9A7E3: F1 54                 ext_f1_54  
  55E9A7E5: F1 E2                 ext_f1_E2  
  55E9A7E7: F8 66 DC              ext_f8_66  0xDC
  55E9A7EA: 08                    db_op_08   0x08
  55E9A7EB: A9                    db_op_A9   0xA9
  55E9A7EC: C8 0E                 beq        loc_55E9A7FA
  55E9A7EE: F0 60                 ext_f0_60  
  55E9A7F0: F1 D6                 ext_f1_D6  
  55E9A7F2: 18                    db_op_18   0x18
  55E9A7F3: 85                    mov        d1, d1
  55E9A7F4: 24 F2 44              mov        0x44F2, a0
  55E9A7F7: E2                    add        d0, d2
  55E9A7F8: 2A DC                 cmp        0xDC, d2
loc_55E9A7FA:
  55E9A7FA: F1 EA                 ext_f1_EA  
  55E9A7FC: 52                    db_op_52   0x52
  55E9A7FD: F0 0E                 ext_f0_0E  
  55E9A7FF: F1 EC                 ext_f1_EC  
  55E9A801: 80 CE                 mov        0xCE, d0
  55E9A803: CD B7 E6 30 0C        call       sub_55E98EBA, [a2,a3], 12
  55E9A808: F1 9F                 ext_f1_9F  
  55E9A80A: C9 13                 bne        loc_55E9A81D
  55E9A80C: 72                    mov        d0, (a2)
  55E9A80D: F1 98                 ext_f1_98  
  55E9A80F: C8 0E                 beq        loc_55E9A81D
  55E9A811: F1 E8                 ext_f1_E8  
  55E9A813: CD 69 EB F0 14        call       sub_55E9937C, [d2,d3,a2,a3], 20
  55E9A818: CA 05                 bra        loc_55E9A81D
loc_55E9A81A:
  55E9A81A: 28 FF                 cmp        0xFF, d0
  55E9A81C: 61                    mov        (a1), d0
loc_55E9A81D:
  55E9A81D: 5C 04                 mov        (4, sp), a0
  55E9A81F: 70                    mov        d0, (a0)
  55E9A820: 42 04                 mov        a2, (4, sp)
  55E9A822: FC C8 DC F3 08 54     ext_fc_C8  0x5408F3DC
  55E9A828: C8 05                 beq        loc_55E9A82D
  55E9A82A: CC 24 FF              jmp        loc_55E9A74E
loc_55E9A82D:
  55E9A82D: 58 08                 mov        (8, sp), d0
  55E9A82F: CD D7 D6 00 00        call       sub_55E97F06, [], 0
  55E9A834: DF F0 1C              ret        [d2,d3,a2,a3], 28

; --- Function sub_55E9A837 (callers: 1) ---
sub_55E9A837:
  55E9A837: CA 00                 bra        sub_55E9A837
  55E9A839: F8 FE FC              add        -4, sp

; --- Function sub_55E9A83C (callers: 1) ---
sub_55E9A83C:
  55E9A83C: DD C4 0F E0 FF 00 00  call       sub_55C9B800, [], 0
loc_55E9A843:
  55E9A843: CA 00                 bra        loc_55E9A843

; --- Function sub_55E9A845 (callers: 4) ---
sub_55E9A845:
  55E9A845: 81 8A                 mov        0x8A, d1
  55E9A847: 01                    db_op_01   0x01
  55E9A848: F1 08                 ext_f1_08  
  55E9A84A: A5                    db_op_A5   0xA5
  55E9A84B: 00                    db_op_00   0x00
  55E9A84C: C8 0F                 beq        loc_55E9A85B
  55E9A84E: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9A84F: F0 45                 ext_f0_45  
  55E9A851: 45                    db_op_45   0x45
  55E9A852: F0 54                 ext_f0_54  
  55E9A854: 41 81                 mov        a1, (129, sp)
  55E9A856: F1 08                 ext_f1_08  
  55E9A858: A5                    db_op_A5   0xA5
  55E9A859: 00                    db_op_00   0x00
  55E9A85A: D9                    lbne       
loc_55E9A85B:
  55E9A85B: DE 80 04              retf       [d2], 4

; --- Function sub_55E9A85E (callers: 9) ---
sub_55E9A85E:
  55E9A85E: 82 43                 mov        0x43, d2
  55E9A860: 10                    db_op_10   0x10
  55E9A861: 00                    db_op_00   0x00
  55E9A862: 42 0C                 mov        a2, (12, sp)
  55E9A864: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E9A86A: 46                    db_op_46   0x46
  55E9A86B: 08                    db_op_08   0x08
  55E9A86C: A0                    db_op_A0   0xA0
  55E9A86D: 00                    db_op_00   0x00
  55E9A86E: 1A                    db_op_1A   0x1A
  55E9A86F: 85                    mov        d1, d1
  55E9A870: 01                    db_op_01   0x01
  55E9A871: C9 03                 bne        loc_55E9A874
  55E9A873: 04                    db_op_04   0x04
loc_55E9A874:
  55E9A874: A5                    db_op_A5   0xA5
  55E9A875: 01                    db_op_01   0x01
  55E9A876: C9 07                 bne        loc_55E9A87D
  55E9A878: 80 E7                 mov        0xE7, d0
  55E9A87A: DF F0 24              ret        [d2,d3,a2,a3], 36
loc_55E9A87D:
  55E9A87D: AA                    db_op_AA   0xAA
  55E9A87E: 01                    db_op_01   0x01
loc_55E9A87F:
  55E9A87F: C0 0C                 blt        loc_55E9A88B
  55E9A881: FC AD B2 B3 E9 55     movhu      (0x55E9B3B2), d1
  55E9A887: 19                    db_op_19   0x19
  55E9A888: A6                    db_op_A6   0xA6
  55E9A889: C3 07                 ble        loc_55E9A890
loc_55E9A88B:
  55E9A88B: 80 EE                 mov        0xEE, d0
  55E9A88D: DF F0 24              ret        [d2,d3,a2,a3], 36
loc_55E9A890:
  55E9A890: 5B 08                 mov        (8, sp), d3
  55E9A892: 4C                    db_op_4C   0x4C
  55E9A893: AF                    db_op_AF   0xAF
  55E9A894: 00                    db_op_00   0x00
  55E9A895: C2 07                 bge        loc_55E9A89C
  55E9A897: 80 EF                 mov        0xEF, d0
  55E9A899: DF F0 24              ret        [d2,d3,a2,a3], 36
loc_55E9A89C:
  55E9A89C: CD 01 D6 00 00        call       sub_55E97E9D, [], 0
  55E9A8A1: FC A4 24 F4 08 54     movbu      (0x5408F424), d0
  55E9A8A7: 85                    mov        d1, d1
  55E9A8A8: 30                    db_op_30   0x30
  55E9A8A9: F2 46                 ext_f2_46  
  55E9A8AB: E8                    add        d2, d0
  55E9A8AC: FC DD D0 FF FF FF     mov        0xFFFFFFD0, a1
  55E9A8B2: F1 61                 ext_f1_61  
  55E9A8B4: F0 61                 ext_f0_61  
  55E9A8B6: F1 D6                 ext_f1_D6  
  55E9A8B8: A0                    db_op_A0   0xA0
  55E9A8B9: 00                    db_op_00   0x00
  55E9A8BA: C9 03                 bne        loc_55E9A8BD
  55E9A8BC: 08                    db_op_08   0x08
loc_55E9A8BD:
  55E9A8BD: AA                    db_op_AA   0xAA
  55E9A8BE: 00                    db_op_00   0x00
  55E9A8BF: C9 07                 bne        loc_55E9A8C6
  55E9A8C1: 80 D6                 mov        0xD6, d0
  55E9A8C3: CC D2 00              jmp        loc_55E9A995
loc_55E9A8C6:
  55E9A8C6: 9F                    mov        a3, a3
  55E9A8C7: 2C F1 6B              mov        0x6BF1, d0
  55E9A8CA: 77                    mov        d1, (a3)
  55E9A8CB: 90 14                 mov        0x14, a0
  55E9A8CD: F1 68                 ext_f1_68  
  55E9A8CF: 43 04                 mov        a3, (4, sp)
  55E9A8D1: F8 00 04              ext_f8_00  0x04
  55E9A8D4: FC A2 F8 F3 08 54     mov        (0x5408F3F8), d2
  55E9A8DA: A1                    db_op_A1   0xA1
  55E9A8DB: C8 56                 beq        loc_55E9A931
  55E9A8DD: 9A                    mov        a2, a2
  55E9A8DE: 24 F1 6A              mov        0x6AF1, a0
  55E9A8E1: F0 02                 ext_f0_02  
  55E9A8E3: 8F                    mov        d3, d3
  55E9A8E4: 28 70                 cmp        0x70, d0
  55E9A8E6: 5C 10                 mov        (16, sp), a0
  55E9A8E8: EB                    add        d2, d3
  55E9A8E9: 60                    mov        (a0), d0
  55E9A8EA: 76                    mov        d1, (a2)
  55E9A8EB: F1 EC                 ext_f1_EC  
  55E9A8ED: 70                    mov        d0, (a0)
  55E9A8EE: A1                    db_op_A1   0xA1
  55E9A8EF: C9 09                 bne        loc_55E9A8F8
  55E9A8F1: 5C 04                 mov        (4, sp), a0
  55E9A8F3: F8 00 08              ext_f8_00  0x08
  55E9A8F6: CA 05                 bra        loc_55E9A8FB
loc_55E9A8F8:
  55E9A8F8: 72                    mov        d0, (a2)
  55E9A8F9: 28 04                 cmp        0x04, d0
loc_55E9A8FB:
  55E9A8FB: 62                    mov        (a2), d0
  55E9A8FC: 73                    mov        d0, (a3)
  55E9A8FD: F1 EA                 ext_f1_EA  
  55E9A8FF: 40 63                 mov        a0, (99, sp)
  55E9A901: 52                    db_op_52   0x52
  55E9A902: 72                    mov        d0, (a2)
  55E9A903: F1 98                 ext_f1_98  
  55E9A905: C9 05                 bne        loc_55E9A90A
  55E9A907: CC 98 00              jmp        loc_55E9A99F
loc_55E9A90A:
  55E9A90A: F0 02                 ext_f0_02  
  55E9A90C: 95                    mov        a1, a1
  55E9A90D: 20 F8                 add        -8, d0
  55E9A90F: 00                    db_op_00   0x00
  55E9A910: 60                    mov        (a0), d0
  55E9A911: F1 69                 ext_f1_69  
  55E9A913: F0 01                 ext_f0_01  
  55E9A915: 60                    mov        (a0), d0
  55E9A916: 75                    mov        d1, (a1)
  55E9A917: F1 EC                 ext_f1_EC  
  55E9A919: 70                    mov        d0, (a0)
  55E9A91A: A1                    db_op_A1   0xA1
  55E9A91B: C9 09                 bne        loc_55E9A924
  55E9A91D: 5C 04                 mov        (4, sp), a0
  55E9A91F: F8 00 08              ext_f8_00  0x08
  55E9A922: CA 05                 bra        loc_55E9A927
loc_55E9A924:
  55E9A924: 71                    mov        d0, (a1)
  55E9A925: 28 04                 cmp        0x04, d0
loc_55E9A927:
  55E9A927: 61                    mov        (a1), d0
  55E9A928: 73                    mov        d0, (a3)
  55E9A929: 85                    mov        d1, d1
  55E9A92A: 01                    db_op_01   0x01
  55E9A92B: F1 04                 ext_f1_04  
  55E9A92D: 63                    mov        (a3), d0
  55E9A92E: 76                    mov        d1, (a2)
  55E9A92F: CA 13                 bra        loc_55E9A942
loc_55E9A931:
  55E9A931: F1 EB                 ext_f1_EB  
  55E9A933: 53                    db_op_53   0x53
  55E9A934: 73                    mov        d0, (a3)
  55E9A935: F1 9C                 ext_f1_9C  
  55E9A937: C8 15                 beq        loc_55E9A94C
  55E9A939: F0 03                 ext_f0_03  
  55E9A93B: F8 00 60              ext_f8_00  0x60
  55E9A93E: 5C 10                 mov        (16, sp), a0
  55E9A940: 60                    mov        (a0), d0
  55E9A941: 77                    mov        d1, (a3)
loc_55E9A942:
  55E9A942: F1 E4                 ext_f1_E4  
  55E9A944: 00                    db_op_00   0x00
  55E9A945: CD 29 E5 30 0C        call       sub_55E98E6E, [a2,a3], 12
  55E9A94A: CA 55                 bra        loc_55E9A99F
loc_55E9A94C:
  55E9A94C: 58 08                 mov        (8, sp), d0
  55E9A94E: A0                    db_op_A0   0xA0
  55E9A94F: 00                    db_op_00   0x00
  55E9A950: C9 06                 bne        loc_55E9A956
  55E9A952: 80 CE                 mov        0xCE, d0
  55E9A954: CA 41                 bra        loc_55E9A995
loc_55E9A956:
  55E9A956: A0                    db_op_A0   0xA0
  55E9A957: FF                    db_op_FF   0xFF
  55E9A958: C8 21                 beq        loc_55E9A979
  55E9A95A: F8 1E 24              ext_f8_1E  0x24
  55E9A95D: 9F                    mov        a3, a3
  55E9A95E: 1C                    db_op_1C   0x1C
  55E9A95F: F1 7B                 ext_f1_7B  
  55E9A961: FC CC DC F3 08 54     mov        0x5408F3DC, d0
  55E9A967: 63                    mov        (a3), d0
  55E9A968: FC A0 E0 F3 08 54     mov        (0x5408F3E0), d0
  55E9A96E: F8 33 04              ext_f8_33  0x04
  55E9A971: F0 1C                 ext_f0_1C  
  55E9A973: FC 8C E0 F3 08 54     ext_fc_8C  0x5408F3E0
loc_55E9A979:
  55E9A979: F1 E8                 ext_f1_E8  
  55E9A97B: F1 E9                 ext_f1_E9  
  55E9A97D: 2A 0C                 cmp        0x0C, d2
  55E9A97F: 89                    mov        d2, d1
  55E9A980: 80 20                 mov        0x20, d0
  55E9A982: F8 70 02              ext_f8_70  0x02
  55E9A985: 98                    mov        a2, a0
  55E9A986: 00                    db_op_00   0x00
  55E9A987: CD 60 E4 B0 14        call       sub_55E98DE7, [d2,a2,a3], 20
  55E9A98C: 90 40                 mov        0x40, a0
  55E9A98E: F1 78                 ext_f1_78  
  55E9A990: 70                    mov        d0, (a0)
  55E9A991: A0                    db_op_A0   0xA0
  55E9A992: 00                    db_op_00   0x00
  55E9A993: C8 06                 beq        loc_55E9A999
loc_55E9A995:
  55E9A995: 42 0C                 mov        a2, (12, sp)
  55E9A997: CA 08                 bra        loc_55E9A99F
loc_55E9A999:
  55E9A999: 5C 10                 mov        (16, sp), a0
  55E9A99B: F8 06 60              ext_f8_06  0x60
  55E9A99E: 64                    mov        (a0), d1
loc_55E9A99F:
  55E9A99F: CD 17 D5 00 00        call       sub_55E97EB6, [], 0
  55E9A9A4: 58 0C                 mov        (12, sp), d0
  55E9A9A6: DF F0 24              ret        [d2,d3,a2,a3], 36

; --- Function sub_55E9A9A9 (callers: 3) ---
sub_55E9A9A9:
  55E9A9A9: F1 E3                 ext_f1_E3  
  55E9A9AB: FC A8 0C F4 08 54     ext_fc_A8  0x5408F40C
  55E9A9B1: 85                    mov        d1, d1
  55E9A9B2: 01                    db_op_01   0x01
  55E9A9B3: A0                    db_op_A0   0xA0
  55E9A9B4: 00                    db_op_00   0x00
  55E9A9B5: C9 03                 bne        loc_55E9A9B8
  55E9A9B7: 04                    db_op_04   0x04
loc_55E9A9B8:
  55E9A9B8: A5                    db_op_A5   0xA5
  55E9A9B9: 01                    db_op_01   0x01
  55E9A9BA: C9 06                 bne        loc_55E9A9C0
  55E9A9BC: 8A                    mov        d2, d2
  55E9A9BD: E7                    add        d1, d3
  55E9A9BE: CA 66                 bra        loc_55E9AA24
loc_55E9A9C0:
  55E9A9C0: F1 DF                 ext_f1_DF  
  55E9A9C2: 4C                    db_op_4C   0x4C
  55E9A9C3: AF                    db_op_AF   0xAF
  55E9A9C4: 00                    db_op_00   0x00
  55E9A9C5: C2 06                 bge        loc_55E9A9CB
  55E9A9C7: 8A                    mov        d2, d2
  55E9A9C8: EF                    add        d3, d3
  55E9A9C9: CA 5B                 bra        loc_55E9AA24
loc_55E9A9CB:
  55E9A9CB: CD D2 D4 00 00        call       sub_55E97E9D, [], 0
  55E9A9D0: FC A2 F8 F3 08 54     mov        (0x5408F3F8), d2
  55E9A9D6: 90 15                 mov        0x15, a0
  55E9A9D8: F1 78                 ext_f1_78  
  55E9A9DA: F0 40                 ext_f0_40  
  55E9A9DC: A0                    db_op_A0   0xA0
  55E9A9DD: 00                    db_op_00   0x00
  55E9A9DE: C8 09                 beq        loc_55E9A9E7
  55E9A9E0: 28 FF                 cmp        0xFF, d0
  55E9A9E2: F0 50                 ext_f0_50  
  55E9A9E4: 08                    db_op_08   0x08
  55E9A9E5: CA 3A                 bra        loc_55E9AA1F
loc_55E9A9E7:
  55E9A9E7: 8A                    mov        d2, d2
  55E9A9E8: CE BF                 movm       (sp), [d2,a2,a3,other,exreg0,exreg1,exother]
  55E9A9EA: 00                    db_op_00   0x00
  55E9A9EB: C8 34                 beq        loc_55E9AA1F
  55E9A9ED: FC DB FF FF FF FF     ext_fc_DB  0xFFFFFFFF
  55E9A9F3: C8 21                 beq        loc_55E9AA14
  55E9A9F5: F8 1E 24              ext_f8_1E  0x24
  55E9A9F8: 95                    mov        a1, a1
  55E9A9F9: 1C                    db_op_1C   0x1C
  55E9A9FA: F1 79                 ext_f1_79  
  55E9A9FC: FC CC DC F3 08 54     mov        0x5408F3DC, d0
  55E9AA02: 61                    mov        (a1), d0
  55E9AA03: FC A0 E0 F3 08 54     mov        (0x5408F3E0), d0
  55E9AA09: F8 31 04              ext_f8_31  0x04
  55E9AA0C: F0 14                 ext_f0_14  
  55E9AA0E: FC 84 E0 F3 08 54     movb       d0, (0x5408F3E0)
loc_55E9AA14:
  55E9AA14: 98                    mov        a2, a0
  55E9AA15: 80 01                 mov        0x01, d0
  55E9AA17: CD 25 E4 30 0C        call       sub_55E98E3C, [a2,a3], 12
  55E9AA1C: F8 0A 40              ext_f8_0A  0x40
loc_55E9AA1F:
  55E9AA1F: CD 97 D4 00 00        call       sub_55E97EB6, [], 0
loc_55E9AA24:
  55E9AA24: 88                    mov        d2, d0
  55E9AA25: DF F0 14              ret        [d2,d3,a2,a3], 20

; --- Function sub_55E9AA28 (callers: 3) ---
sub_55E9AA28:
  55E9AA28: 18                    db_op_18   0x18
  55E9AA29: 43 08                 mov        a3, (8, sp)
  55E9AA2B: 46                    db_op_46   0x46
  55E9AA2C: 04                    db_op_04   0x04
  55E9AA2D: FC A9 0C F4 08 54     ext_fc_A9  0x5408F40C
  55E9AA33: F1 D6                 ext_f1_D6  
  55E9AA35: F8 9A 0C              movbu      d2, (12, a2)
  55E9AA38: A5                    db_op_A5   0xA5
  55E9AA39: 00                    db_op_00   0x00
  55E9AA3A: 8F                    mov        d3, d3
  55E9AA3B: 01                    db_op_01   0x01
  55E9AA3C: C9 03                 bne        loc_55E9AA3F
  55E9AA3E: 0C                    db_op_0C   0x0C
loc_55E9AA3F:
  55E9AA3F: AF                    db_op_AF   0xAF
  55E9AA40: 01                    db_op_01   0x01
  55E9AA41: C9 07                 bne        loc_55E9AA48
  55E9AA43: 80 E7                 mov        0xE7, d0
  55E9AA45: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9AA48:
  55E9AA48: 83 1B                 mov        0x1B, d3
  55E9AA4A: AF                    db_op_AF   0xAF
  55E9AA4B: 01                    db_op_01   0x01
  55E9AA4C: C0 0C                 blt        loc_55E9AA58
  55E9AA4E: FC AD AE B3 E9 55     movhu      (0x55E9B3AE), d1
  55E9AA54: 19                    db_op_19   0x19
  55E9AA55: A7                    db_op_A7   0xA7
  55E9AA56: C3 07                 ble        loc_55E9AA5D
loc_55E9AA58:
  55E9AA58: 80 EE                 mov        0xEE, d0
  55E9AA5A: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9AA5D:
  55E9AA5D: 58 04                 mov        (4, sp), d0
  55E9AA5F: A0                    db_op_A0   0xA0
  55E9AA60: 00                    db_op_00   0x00
  55E9AA61: C8 10                 beq        loc_55E9AA71
  55E9AA63: F8 BA 0C              ext_f8_BA  0x0C
  55E9AA66: AA                    db_op_AA   0xAA
  55E9AA67: 01                    db_op_01   0x01
  55E9AA68: C1 09                 bgt        loc_55E9AA71
  55E9AA6A: 5F 24                 mov        (36, sp), a3
  55E9AA6C: 4D                    db_op_4D   0x4D
  55E9AA6D: BF                    db_op_BF   0xBF
  55E9AA6E: 00                    db_op_00   0x00
  55E9AA6F: C2 07                 bge        loc_55E9AA76
loc_55E9AA71:
  55E9AA71: 80 EF                 mov        0xEF, d0
  55E9AA73: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9AA76:
  55E9AA76: CD 27 D4 00 00        call       sub_55E97E9D, [], 0
  55E9AA7B: FC A5 20 F4 08 54     movbu      (0x5408F420), d1
  55E9AA81: 80 18                 mov        0x18, d0
  55E9AA83: F2 43                 ext_f2_43  
  55E9AA85: ED                    add        d3, d1
  55E9AA86: FC DD E8 FF FF FF     mov        0xFFFFFFE8, a1
  55E9AA8C: F1 65                 ext_f1_65  
  55E9AA8E: F0 61                 ext_f0_61  
  55E9AA90: F1 D5                 ext_f1_D5  
  55E9AA92: A0                    db_op_A0   0xA0
  55E9AA93: 00                    db_op_00   0x00
  55E9AA94: C9 03                 bne        loc_55E9AA97
  55E9AA96: 04                    db_op_04   0x04
loc_55E9AA97:
  55E9AA97: A5                    db_op_A5   0xA5
  55E9AA98: 00                    db_op_00   0x00
  55E9AA99: C9 0C                 bne        loc_55E9AAA5
  55E9AA9B: CD 1B D4 00 00        call       sub_55E97EB6, [], 0
  55E9AAA0: 80 D6                 mov        0xD6, d0
  55E9AAA2: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9AAA5:
  55E9AAA5: 95                    mov        a1, a1
  55E9AAA6: 0C                    db_op_0C   0x0C
  55E9AAA7: F1 65                 ext_f1_65  
  55E9AAA9: F0 41                 ext_f0_41  
  55E9AAAB: F8 EC 02              ext_f8_EC  0x02
  55E9AAAE: C9 14                 bne        loc_55E9AAC2
  55E9AAB0: F1 E6                 ext_f1_E6  
  55E9AAB2: 52                    db_op_52   0x52
  55E9AAB3: 72                    mov        d0, (a2)
  55E9AAB4: F1 98                 ext_f1_98  
  55E9AAB6: C8 0C                 beq        loc_55E9AAC2
  55E9AAB8: CD FE D3 00 00        call       sub_55E97EB6, [], 0
  55E9AABD: 80 E4                 mov        0xE4, d0
  55E9AABF: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9AAC2:
  55E9AAC2: 5B 04                 mov        (4, sp), d3
  55E9AAC4: 90 14                 mov        0x14, a0
  55E9AAC6: F1 64                 ext_f1_64  
  55E9AAC8: 70                    mov        d0, (a0)
  55E9AAC9: F2 0C                 ext_f2_0C  
  55E9AACB: C8 18                 beq        loc_55E9AAE3
  55E9AACD: F8 EE 01              ext_f8_EE  0x01
  55E9AAD0: C9 05                 bne        loc_55E9AAD5
  55E9AAD2: AC                    db_op_AC   0xAC
  55E9AAD3: C9 10                 bne        loc_55E9AAE3
loc_55E9AAD5:
  55E9AAD5: 70                    mov        d0, (a0)
  55E9AAD6: 5E 08                 mov        (8, sp), a2
  55E9AAD8: 62                    mov        (a2), d0
  55E9AAD9: F0 41                 ext_f0_41  
  55E9AADB: F8 EC 04              ext_f8_EC  0x04
  55E9AADE: C8 70                 beq        loc_55E9AB4E
  55E9AAE0: 00                    db_op_00   0x00
  55E9AAE1: CA 6C                 bra        loc_55E9AB4D
loc_55E9AAE3:
  55E9AAE3: 58 24                 mov        (36, sp), d0
  55E9AAE5: FC A2 F8 F3 08 54     mov        (0x5408F3F8), d2
  55E9AAEB: A0                    db_op_A0   0xA0
  55E9AAEC: 00                    db_op_00   0x00
  55E9AAED: C9 0B                 bne        loc_55E9AAF8
  55E9AAEF: CD C7 D3 00 00        call       sub_55E97EB6, [], 0
  55E9AAF4: 80 CE                 mov        0xCE, d0
  55E9AAF6: CA 5E                 bra        loc_55E9AB54
loc_55E9AAF8:
  55E9AAF8: A0                    db_op_A0   0xA0
  55E9AAF9: FF                    db_op_FF   0xFF
  55E9AAFA: C8 21                 beq        loc_55E9AB1B
  55E9AAFC: F8 3E 24              ext_f8_3E  0x24
  55E9AAFF: 9F                    mov        a3, a3
  55E9AB00: 1C                    db_op_1C   0x1C
  55E9AB01: F1 7B                 ext_f1_7B  
  55E9AB03: FC CC DC F3 08 54     mov        0x5408F3DC, d0
  55E9AB09: 63                    mov        (a3), d0
  55E9AB0A: FC A0 E0 F3 08 54     mov        (0x5408F3E0), d0
  55E9AB10: F8 33 04              ext_f8_33  0x04
  55E9AB13: F0 1C                 ext_f0_1C  
  55E9AB15: FC 8C E0 F3 08 54     ext_fc_8C  0x5408F3E0
loc_55E9AB1B:
  55E9AB1B: F8 B8 0C              ext_f8_B8  0x0C
  55E9AB1E: 9F                    mov        a3, a3
  55E9AB1F: 60                    mov        (a0), d0
  55E9AB20: F1 7B                 ext_f1_7B  
  55E9AB22: F8 53 04              ext_f8_53  0x04
  55E9AB25: 58 04                 mov        (4, sp), d0
  55E9AB27: F1 E4                 ext_f1_E4  
  55E9AB29: 63                    mov        (a3), d0
  55E9AB2A: 80 08                 mov        0x08, d0
  55E9AB2C: F8 70 02              ext_f8_70  0x02
  55E9AB2F: F0 41                 ext_f0_41  
  55E9AB31: 98                    mov        a2, a0
  55E9AB32: F1 E5                 ext_f1_E5  
  55E9AB34: 29 04                 cmp        0x04, d1
  55E9AB36: CD B1 E2 B0 14        call       sub_55E98DE7, [d2,a2,a3], 20
  55E9AB3B: 22 40                 add        64, d2
  55E9AB3D: 72                    mov        d0, (a2)
  55E9AB3E: A0                    db_op_A0   0xA0
  55E9AB3F: 00                    db_op_00   0x00
  55E9AB40: C8 0A                 beq        loc_55E9AB4A
  55E9AB42: CD 74 D3 00 00        call       sub_55E97EB6, [], 0
  55E9AB47: 72                    mov        d0, (a2)
  55E9AB48: CA 0C                 bra        loc_55E9AB54
loc_55E9AB4A:
  55E9AB4A: 73                    mov        d0, (a3)
  55E9AB4B: 5C 08                 mov        (8, sp), a0
loc_55E9AB4D:
  55E9AB4D: 60                    mov        (a0), d0
loc_55E9AB4E:
  55E9AB4E: CD 68 D3 00 00        call       sub_55E97EB6, [], 0
  55E9AB53: 00                    db_op_00   0x00
loc_55E9AB54:
  55E9AB54: DF F0 20              ret        [d2,d3,a2,a3], 32

; --- Function sub_55E9AB57 (callers: 3) ---
sub_55E9AB57:
  55E9AB57: FC A9 08 F4 08 54     ext_fc_A9  0x5408F408
  55E9AB5D: 80 01                 mov        0x01, d0
  55E9AB5F: A5                    db_op_A5   0xA5
  55E9AB60: 00                    db_op_00   0x00
  55E9AB61: C9 03                 bne        loc_55E9AB64
  55E9AB63: 00                    db_op_00   0x00
loc_55E9AB64:
  55E9AB64: A0                    db_op_A0   0xA0
  55E9AB65: 01                    db_op_01   0x01
  55E9AB66: C9 06                 bne        loc_55E9AB6C
  55E9AB68: 80 E7                 mov        0xE7, d0
  55E9AB6A: CA 26                 bra        loc_55E9AB90
loc_55E9AB6C:
  55E9AB6C: FC A8 09 F4 08 54     ext_fc_A8  0x5408F409
  55E9AB72: A0                    db_op_A0   0xA0
  55E9AB73: 01                    db_op_01   0x01
  55E9AB74: C9 1B                 bne        loc_55E9AB8F
  55E9AB76: 00                    db_op_00   0x00
  55E9AB77: FC 82 09 F4 08 54     mov        d2, (0x5408F409)
  55E9AB7D: FE 01 0C F4 08 54 02  ext_fe_01  0x5408F40C, 0x02
  55E9AB84: FC A4 00 F4 08 54     movbu      (0x5408F400), d0
  55E9AB8A: CD 7C D3 00 00        call       sub_55E97F06, [], 0
loc_55E9AB8F:
  55E9AB8F: 00                    db_op_00   0x00
loc_55E9AB90:
  55E9AB90: DF 00 04              ret        [], 4

; --- Function sub_55E9AB93 (callers: 1) ---
sub_55E9AB93:
  55E9AB93: 82 FC                 mov        0xFC, d2
  55E9AB95: A8                    db_op_A8   0xA8
  55E9AB96: 0C                    db_op_0C   0x0C
  55E9AB97: F4 08                 ext_f4_08  
  55E9AB99: 54                    db_op_54   0x54
  55E9AB9A: 43 04                 mov        a3, (4, sp)
  55E9AB9C: F1 E7                 ext_f1_E7  
  55E9AB9E: F1 D7                 ext_f1_D7  
  55E9ABA0: 1A                    db_op_1A   0x1A
  55E9ABA1: F8 9E 08              movbu      d3, (8, a2)
  55E9ABA4: A0                    db_op_A0   0xA0
  55E9ABA5: 00                    db_op_00   0x00
  55E9ABA6: 85                    mov        d1, d1
  55E9ABA7: 01                    db_op_01   0x01
  55E9ABA8: C9 03                 bne        loc_55E9ABAB
  55E9ABAA: 04                    db_op_04   0x04
loc_55E9ABAB:
  55E9ABAB: A5                    db_op_A5   0xA5
  55E9ABAC: 01                    db_op_01   0x01
  55E9ABAD: C9 07                 bne        loc_55E9ABB4
  55E9ABAF: 80 E7                 mov        0xE7, d0
  55E9ABB1: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9ABB4:
  55E9ABB4: AA                    db_op_AA   0xAA
  55E9ABB5: 01                    db_op_01   0x01
  55E9ABB6: C0 0C                 blt        loc_55E9ABC2
  55E9ABB8: FC AD AE B3 E9 55     movhu      (0x55E9B3AE), d1
  55E9ABBE: 19                    db_op_19   0x19
  55E9ABBF: A6                    db_op_A6   0xA6
  55E9ABC0: C3 07                 ble        loc_55E9ABC7
loc_55E9ABC2:
  55E9ABC2: 80 EE                 mov        0xEE, d0
  55E9ABC4: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9ABC7:
  55E9ABC7: BF                    db_op_BF   0xBF
  55E9ABC8: 00                    db_op_00   0x00
  55E9ABC9: C8 09                 beq        loc_55E9ABD2
  55E9ABCB: F8 BB 08              ext_f8_BB  0x08
  55E9ABCE: AF                    db_op_AF   0xAF
  55E9ABCF: 01                    db_op_01   0x01
  55E9ABD0: C3 07                 ble        loc_55E9ABD7
loc_55E9ABD2:
  55E9ABD2: 80 EF                 mov        0xEF, d0
  55E9ABD4: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9ABD7:
  55E9ABD7: CD C6 D2 00 00        call       sub_55E97E9D, [], 0
  55E9ABDC: FC A4 20 F4 08 54     movbu      (0x5408F420), d0
  55E9ABE2: 85                    mov        d1, d1
  55E9ABE3: 18                    db_op_18   0x18
  55E9ABE4: F2 46                 ext_f2_46  
  55E9ABE6: E8                    add        d2, d0
  55E9ABE7: FC DC E8 FF FF FF     mov        0xFFFFFFE8, a0
  55E9ABED: F1 60                 ext_f1_60  
  55E9ABEF: F0 60                 ext_f0_60  
  55E9ABF1: A0                    db_op_A0   0xA0
  55E9ABF2: 00                    db_op_00   0x00
  55E9ABF3: C9 04                 bne        loc_55E9ABF7
  55E9ABF5: 90 00                 mov        0x00, a0
loc_55E9ABF7:
  55E9ABF7: B0                    db_op_B0   0xB0
  55E9ABF8: 00                    db_op_00   0x00
  55E9ABF9: C9 0C                 bne        loc_55E9AC05
  55E9ABFB: CD BB D2 00 00        call       sub_55E97EB6, [], 0
  55E9AC00: 80 D6                 mov        0xD6, d0
  55E9AC02: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9AC05:
  55E9AC05: 95                    mov        a1, a1
  55E9AC06: 0C                    db_op_0C   0x0C
  55E9AC07: F1 71                 ext_f1_71  
  55E9AC09: F0 41                 ext_f0_41  
  55E9AC0B: F8 EC 02              ext_f8_EC  0x02
  55E9AC0E: C9 13                 bne        loc_55E9AC21
  55E9AC10: 92 52                 mov        0x52, a2
  55E9AC12: 72                    mov        d0, (a2)
  55E9AC13: F1 98                 ext_f1_98  
  55E9AC15: C8 0C                 beq        loc_55E9AC21
  55E9AC17: CD 9F D2 00 00        call       sub_55E97EB6, [], 0
  55E9AC1C: 80 E4                 mov        0xE4, d0
  55E9AC1E: DF F0 20              ret        [d2,d3,a2,a3], 32
loc_55E9AC21:
  55E9AC21: 9A                    mov        a2, a2
  55E9AC22: 14                    db_op_14   0x14
  55E9AC23: F1 72                 ext_f1_72  
  55E9AC25: 72                    mov        d0, (a2)
  55E9AC26: F1 DD                 ext_f1_DD  
  55E9AC28: F2 04                 ext_f2_04  
  55E9AC2A: C8 19                 beq        loc_55E9AC43
  55E9AC2C: F8 EF 01              ext_f8_EF  0x01
  55E9AC2F: C9 05                 bne        loc_55E9AC34
  55E9AC31: A4                    db_op_A4   0xA4
  55E9AC32: C9 11                 bne        loc_55E9AC43
loc_55E9AC34:
  55E9AC34: 72                    mov        d0, (a2)
  55E9AC35: 5C 04                 mov        (4, sp), a0
  55E9AC37: 60                    mov        (a0), d0
  55E9AC38: F0 41                 ext_f0_41  
  55E9AC3A: F8 EC 04              ext_f8_EC  0x04
  55E9AC3D: C8 43                 beq        loc_55E9AC80
  55E9AC3F: 00                    db_op_00   0x00
  55E9AC40: 62                    mov        (a2), d0
  55E9AC41: CA 3F                 bra        loc_55E9AC80
loc_55E9AC43:
  55E9AC43: FC A2 F8 F3 08 54     mov        (0x5408F3F8), d2
  55E9AC49: F8 B8 08              ext_f8_B8  0x08
  55E9AC4C: 4B                    db_op_4B   0x4B
  55E9AC4D: 0C                    db_op_0C   0x0C
  55E9AC4E: 8A                    mov        d2, d2
  55E9AC4F: 60                    mov        (a0), d0
  55E9AC50: F1 5A                 ext_f1_5A  
  55E9AC52: F1 EA                 ext_f1_EA  
  55E9AC54: F8 52 04              ext_f8_52  0x04
  55E9AC57: 66                    mov        (a2), d1
  55E9AC58: 5E 0C                 mov        (12, sp), a2
  55E9AC5A: 80 08                 mov        0x08, d0
  55E9AC5C: F8 70 02              ext_f8_70  0x02
  55E9AC5F: F0 41                 ext_f0_41  
  55E9AC61: 91 50                 mov        0x50, a1
  55E9AC63: F1 D1                 ext_f1_D1  
  55E9AC65: 98                    mov        a2, a0
  55E9AC66: CD 81 E1 B0 14        call       sub_55E98DE7, [d2,a2,a3], 20
  55E9AC6B: 22 40                 add        64, d2
  55E9AC6D: 72                    mov        d0, (a2)
  55E9AC6E: A0                    db_op_A0   0xA0
  55E9AC6F: 00                    db_op_00   0x00
  55E9AC70: C8 0A                 beq        loc_55E9AC7A
  55E9AC72: CD 44 D2 00 00        call       sub_55E97EB6, [], 0
  55E9AC77: 72                    mov        d0, (a2)
  55E9AC78: CA 0E                 bra        loc_55E9AC86
loc_55E9AC7A:
  55E9AC7A: F1 E8                 ext_f1_E8  
  55E9AC7C: 70                    mov        d0, (a0)
  55E9AC7D: 5C 04                 mov        (4, sp), a0
  55E9AC7F: 60                    mov        (a0), d0
loc_55E9AC80:
  55E9AC80: CD 36 D2 00 00        call       sub_55E97EB6, [], 0
  55E9AC85: 00                    db_op_00   0x00
loc_55E9AC86:
  55E9AC86: DF F0 20              ret        [d2,d3,a2,a3], 32

; --- Function sub_55E9AC89 (callers: 73) ---
sub_55E9AC89:
  55E9AC89: FC A9 0C F4 08 54     ext_fc_A9  0x5408F40C
  55E9AC8F: 18                    db_op_18   0x18
  55E9AC90: 83 A5                 mov        0xA5, d3
  55E9AC92: 00                    db_op_00   0x00
  55E9AC93: 8A                    mov        d2, d2
  55E9AC94: 01                    db_op_01   0x01
  55E9AC95: C9 03                 bne        loc_55E9AC98
  55E9AC97: 08                    db_op_08   0x08
loc_55E9AC98:
  55E9AC98: AA                    db_op_AA   0xAA
  55E9AC99: 01                    db_op_01   0x01
  55E9AC9A: C9 07                 bne        loc_55E9ACA1
  55E9AC9C: 80 E7                 mov        0xE7, d0
  55E9AC9E: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E9ACA1:
  55E9ACA1: 1B                    db_op_1B   0x1B
  55E9ACA2: AF                    db_op_AF   0xAF
  55E9ACA3: 01                    db_op_01   0x01
  55E9ACA4: C0 0C                 blt        loc_55E9ACB0
  55E9ACA6: FC AD AA B3 E9 55     movhu      (0x55E9B3AA), d1
  55E9ACAC: 19                    db_op_19   0x19
  55E9ACAD: A7                    db_op_A7   0xA7
  55E9ACAE: C3 07                 ble        loc_55E9ACB5
loc_55E9ACB0:
  55E9ACB0: 80 EE                 mov        0xEE, d0
  55E9ACB2: DF F0 14              ret        [d2,d3,a2,a3], 20
loc_55E9ACB5:
  55E9ACB5: CD E8 D1 00 00        call       sub_55E97E9D, [], 0
  55E9ACBA: FC A5 1C F4 08 54     movbu      (0x5408F41C), d1
  55E9ACC0: 80 1C                 mov        0x1C, d0
  55E9ACC2: F2 43                 ext_f2_43  
  55E9ACC4: ED                    add        d3, d1
  55E9ACC5: FC DC E4 FF FF FF     mov        0xFFFFFFE4, a0
  55E9ACCB: F1 64                 ext_f1_64  
  55E9ACCD: F0 60                 ext_f0_60  
  55E9ACCF: A0                    db_op_A0   0xA0
  55E9ACD0: 00                    db_op_00   0x00
  55E9ACD1: C9 04                 bne        loc_55E9ACD5
  55E9ACD3: 90 00                 mov        0x00, a0
loc_55E9ACD5:
  55E9ACD5: B0                    db_op_B0   0xB0
  55E9ACD6: 00                    db_op_00   0x00
  55E9ACD7: C9 0B                 bne        loc_55E9ACE2
  55E9ACD9: CD DD D1 00 00        call       sub_55E97EB6, [], 0
  55E9ACDE: 80 D6                 mov        0xD6, d0
  55E9ACE0: CA 3F                 bra        loc_55E9AD1F
loc_55E9ACE2:
  55E9ACE2: 95                    mov        a1, a1
  55E9ACE3: 18                    db_op_18   0x18
  55E9ACE4: F1 71                 ext_f1_71  
  55E9ACE6: 71                    mov        d0, (a1)
  55E9ACE7: A0                    db_op_A0   0xA0
  55E9ACE8: 01                    db_op_01   0x01
  55E9ACE9: C4 09                 bcs        loc_55E9ACF2
  55E9ACEB: 85                    mov        d1, d1
  55E9ACEC: 01                    db_op_01   0x01
  55E9ACED: F1 04                 ext_f1_04  
  55E9ACEF: 61                    mov        (a1), d0
  55E9ACF0: CA 29                 bra        loc_55E9AD19
loc_55E9ACF2:
  55E9ACF2: FC A2 F8 F3 08 54     mov        (0x5408F3F8), d2
  55E9ACF8: 91 80                 mov        0x80, a1
  55E9ACFA: 04                    db_op_04   0x04
  55E9ACFB: F8 70 02              ext_f8_70  0x02
  55E9ACFE: F8 40 0C              ext_f8_40  0x0C
  55E9AD01: 50                    db_op_50   0x50
  55E9AD02: F1 D1                 ext_f1_D1  
  55E9AD04: 98                    mov        a2, a0
  55E9AD05: CD E2 E0 B0 14        call       sub_55E98DE7, [d2,a2,a3], 20
  55E9AD0A: 22 40                 add        64, d2
  55E9AD0C: 72                    mov        d0, (a2)
  55E9AD0D: A0                    db_op_A0   0xA0
  55E9AD0E: 00                    db_op_00   0x00
  55E9AD0F: C8 0A                 beq        loc_55E9AD19
  55E9AD11: CD A5 D1 00 00        call       sub_55E97EB6, [], 0
  55E9AD16: 72                    mov        d0, (a2)
  55E9AD17: CA 08                 bra        loc_55E9AD1F
loc_55E9AD19:
  55E9AD19: CD 9D D1 00 00        call       sub_55E97EB6, [], 0
  55E9AD1E: 00                    db_op_00   0x00
loc_55E9AD1F:
  55E9AD1F: DF F0 14              ret        [d2,d3,a2,a3], 20
  55E9AD22: CB                    nop        
  55E9AD23: FF                    db_op_FF   0xFF
  55E9AD24: 13                    db_op_13   0x13
  55E9AD25: 00                    db_op_00   0x00
  55E9AD26: 11                    db_op_11   0x11
  55E9AD27: 00                    db_op_00   0x00
  55E9AD28: 15                    db_op_15   0x15
  55E9AD29: 00                    db_op_00   0x00
  55E9AD2A: 14                    db_op_14   0x14
  55E9AD2B: 00                    db_op_00   0x00
  55E9AD2C: 16                    db_op_16   0x16
  55E9AD2D: 00                    db_op_00   0x00
  55E9AD2E: 12                    db_op_12   0x12
  55E9AD2F: 00                    db_op_00   0x00
  55E9AD30: 19                    db_op_19   0x19
  55E9AD31: 00                    db_op_00   0x00
  55E9AD32: 18                    db_op_18   0x18
  55E9AD33: 00                    db_op_00   0x00
  55E9AD34: 17                    db_op_17   0x17
  55E9AD35: 00                    db_op_00   0x00
  55E9AD36: 11                    db_op_11   0x11
  55E9AD37: 00                    db_op_00   0x00
  55E9AD38: 15                    db_op_15   0x15
  55E9AD39: 00                    db_op_00   0x00
  55E9AD3A: 13                    db_op_13   0x13
  55E9AD3B: 00                    db_op_00   0x00
  55E9AD3C: 12                    db_op_12   0x12
  55E9AD3D: 00                    db_op_00   0x00
  55E9AD3E: 14                    db_op_14   0x14
  55E9AD3F: 00                    db_op_00   0x00
  55E9AD40: 01                    db_op_01   0x01
  55E9AD41: 00                    db_op_00   0x00
  55E9AD42: 00                    db_op_00   0x00
  55E9AD43: 00                    db_op_00   0x00
  55E9AD44: 02                    db_op_02   0x02
  55E9AD45: 00                    db_op_00   0x00
  55E9AD46: 00                    db_op_00   0x00
  55E9AD47: 00                    db_op_00   0x00
  55E9AD48: 00                    db_op_00   0x00
  55E9AD49: 00                    db_op_00   0x00
  55E9AD4A: 00                    db_op_00   0x00
  55E9AD4B: 00                    db_op_00   0x00
  55E9AD4C: 4E                    db_op_4E   0x4E
  55E9AD4D: BD                    db_op_BD   0xBD
  55E9AD4E: C9 55                 bne        loc_55E9ADA3
  55E9AD50: 01                    db_op_01   0x01
  55E9AD51: 00                    db_op_00   0x00
  55E9AD52: 00                    db_op_00   0x00
  55E9AD53: 00                    db_op_00   0x00
  55E9AD54: 00                    db_op_00   0x00
  55E9AD55: 0C                    db_op_0C   0x0C
  55E9AD56: 00                    db_op_00   0x00
  55E9AD57: 00                    db_op_00   0x00
  55E9AD58: 00                    db_op_00   0x00
  55E9AD59: 00                    db_op_00   0x00
  55E9AD5A: 00                    db_op_00   0x00
  55E9AD5B: 00                    db_op_00   0x00
  55E9AD5C: 05                    db_op_05   0x05
  55E9AD5D: 00                    db_op_00   0x00
  55E9AD5E: 00                    db_op_00   0x00
  55E9AD5F: 00                    db_op_00   0x00
  55E9AD60: 02                    db_op_02   0x02
  55E9AD61: 00                    db_op_00   0x00
  55E9AD62: 00                    db_op_00   0x00
  55E9AD63: 00                    db_op_00   0x00
  55E9AD64: 00                    db_op_00   0x00
  55E9AD65: 00                    db_op_00   0x00
  55E9AD66: 00                    db_op_00   0x00
  55E9AD67: 00                    db_op_00   0x00
  55E9AD68: 9B                    mov        a2, a3
  55E9AD69: 04                    db_op_04   0x04
  55E9AD6A: D4                    lbcs       
  55E9AD6B: 55                    db_op_55   0x55
  55E9AD6C: 03                    db_op_03   0x03
  55E9AD6D: 00                    db_op_00   0x00
  55E9AD6E: 00                    db_op_00   0x00
  55E9AD6F: 00                    db_op_00   0x00
  55E9AD70: 00                    db_op_00   0x00
  55E9AD71: 06                    db_op_06   0x06
  55E9AD72: 00                    db_op_00   0x00
  55E9AD73: 00                    db_op_00   0x00
  55E9AD74: 00                    db_op_00   0x00
  55E9AD75: 00                    db_op_00   0x00
  55E9AD76: 00                    db_op_00   0x00
  55E9AD77: 00                    db_op_00   0x00
  55E9AD78: 06                    db_op_06   0x06
  55E9AD79: 00                    db_op_00   0x00
  55E9AD7A: 00                    db_op_00   0x00
  55E9AD7B: 00                    db_op_00   0x00
  55E9AD7C: 02                    db_op_02   0x02
  55E9AD7D: 00                    db_op_00   0x00
  55E9AD7E: 00                    db_op_00   0x00
  55E9AD7F: 00                    db_op_00   0x00
  55E9AD80: 00                    db_op_00   0x00
  55E9AD81: 00                    db_op_00   0x00
  55E9AD82: 00                    db_op_00   0x00
  55E9AD83: 00                    db_op_00   0x00
  55E9AD84: 9E                    mov        a3, a2
  55E9AD85: DE D1 55              retf       [d2,d3,a3,exother], 85
  55E9AD88: 02                    db_op_02   0x02
  55E9AD89: 00                    db_op_00   0x00
  55E9AD8A: 00                    db_op_00   0x00
  55E9AD8B: 00                    db_op_00   0x00
  55E9AD8C: 00                    db_op_00   0x00
  55E9AD8D: 08                    db_op_08   0x08
  55E9AD8E: 00                    db_op_00   0x00
  55E9AD8F: 00                    db_op_00   0x00
  55E9AD90: 00                    db_op_00   0x00
  55E9AD91: 00                    db_op_00   0x00
  55E9AD92: 00                    db_op_00   0x00
  55E9AD93: 00                    db_op_00   0x00
  55E9AD94: 07                    db_op_07   0x07
  55E9AD95: 00                    db_op_00   0x00
  55E9AD96: 00                    db_op_00   0x00
  55E9AD97: 00                    db_op_00   0x00
  55E9AD98: 02                    db_op_02   0x02
  55E9AD99: 00                    db_op_00   0x00
  55E9AD9A: 00                    db_op_00   0x00
  55E9AD9B: 00                    db_op_00   0x00
  55E9AD9C: 00                    db_op_00   0x00
  55E9AD9D: 00                    db_op_00   0x00
  55E9AD9E: 00                    db_op_00   0x00
  55E9AD9F: 00                    db_op_00   0x00
  55E9ADA0: F4 6F                 ext_f4_6F  
  55E9ADA2: D2                    lbge       
loc_55E9ADA3:
  55E9ADA3: 55                    db_op_55   0x55
  55E9ADA4: 02                    db_op_02   0x02
  55E9ADA5: 00                    db_op_00   0x00
  55E9ADA6: 00                    db_op_00   0x00
  55E9ADA7: 00                    db_op_00   0x00
  55E9ADA8: 00                    db_op_00   0x00
  55E9ADA9: 12                    db_op_12   0x12
  55E9ADAA: 00                    db_op_00   0x00
  55E9ADAB: 00                    db_op_00   0x00
  55E9ADAC: 00                    db_op_00   0x00
  55E9ADAD: 00                    db_op_00   0x00
  55E9ADAE: 00                    db_op_00   0x00
  55E9ADAF: 00                    db_op_00   0x00
  55E9ADB0: 18                    db_op_18   0x18
  55E9ADB1: 00                    db_op_00   0x00
  55E9ADB2: 00                    db_op_00   0x00
  55E9ADB3: 00                    db_op_00   0x00
  55E9ADB4: 02                    db_op_02   0x02
  55E9ADB5: 00                    db_op_00   0x00
  55E9ADB6: 00                    db_op_00   0x00
  55E9ADB7: 00                    db_op_00   0x00
  55E9ADB8: 00                    db_op_00   0x00
  55E9ADB9: 00                    db_op_00   0x00
  55E9ADBA: 00                    db_op_00   0x00
  55E9ADBB: 00                    db_op_00   0x00
  55E9ADBC: 65                    mov        (a1), d1
  55E9ADBD: FE E0 55 04 00 00 00  ext_fe_E0  0x00000455, 0x00
  55E9ADC4: 00                    db_op_00   0x00
  55E9ADC5: 08                    db_op_08   0x08
  55E9ADC6: 00                    db_op_00   0x00
  55E9ADC7: 00                    db_op_00   0x00
  55E9ADC8: 00                    db_op_00   0x00
  55E9ADC9: 00                    db_op_00   0x00
  55E9ADCA: 00                    db_op_00   0x00
  55E9ADCB: 00                    db_op_00   0x00
  55E9ADCC: 09                    db_op_09   0x09
  55E9ADCD: 00                    db_op_00   0x00
  55E9ADCE: 00                    db_op_00   0x00
  55E9ADCF: 00                    db_op_00   0x00
  55E9ADD0: 02                    db_op_02   0x02
  55E9ADD1: 00                    db_op_00   0x00
  55E9ADD2: 00                    db_op_00   0x00
  55E9ADD3: 00                    db_op_00   0x00
  55E9ADD4: 00                    db_op_00   0x00
  55E9ADD5: 00                    db_op_00   0x00
  55E9ADD6: 00                    db_op_00   0x00
  55E9ADD7: 00                    db_op_00   0x00
  55E9ADD8: 8B                    mov        d2, d3
  55E9ADD9: 9E                    mov        a3, a2
  55E9ADDA: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9ADDB: 55                    db_op_55   0x55
  55E9ADDC: 05                    db_op_05   0x05
  55E9ADDD: 00                    db_op_00   0x00
  55E9ADDE: 00                    db_op_00   0x00
  55E9ADDF: 00                    db_op_00   0x00
  55E9ADE0: 00                    db_op_00   0x00
  55E9ADE1: 06                    db_op_06   0x06
  55E9ADE2: 00                    db_op_00   0x00
  55E9ADE3: 00                    db_op_00   0x00
  55E9ADE4: 00                    db_op_00   0x00
  55E9ADE5: 00                    db_op_00   0x00
  55E9ADE6: 00                    db_op_00   0x00
  55E9ADE7: 00                    db_op_00   0x00
  55E9ADE8: 08                    db_op_08   0x08
  55E9ADE9: 00                    db_op_00   0x00
  55E9ADEA: 00                    db_op_00   0x00
  55E9ADEB: 00                    db_op_00   0x00
  55E9ADEC: 02                    db_op_02   0x02
  55E9ADED: 00                    db_op_00   0x00
  55E9ADEE: 00                    db_op_00   0x00
  55E9ADEF: 00                    db_op_00   0x00
  55E9ADF0: 00                    db_op_00   0x00
  55E9ADF1: 00                    db_op_00   0x00
  55E9ADF2: 00                    db_op_00   0x00
  55E9ADF3: 00                    db_op_00   0x00
  55E9ADF4: F2 9C                 ext_f2_9C  
  55E9ADF6: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9ADF7: 55                    db_op_55   0x55
  55E9ADF8: 05                    db_op_05   0x05
  55E9ADF9: 00                    db_op_00   0x00
  55E9ADFA: 00                    db_op_00   0x00
  55E9ADFB: 00                    db_op_00   0x00
  55E9ADFC: 00                    db_op_00   0x00
  55E9ADFD: 06                    db_op_06   0x06
  55E9ADFE: 00                    db_op_00   0x00
  55E9ADFF: 00                    db_op_00   0x00
  55E9AE00: 00                    db_op_00   0x00
  55E9AE01: 00                    db_op_00   0x00
  55E9AE02: 00                    db_op_00   0x00
  55E9AE03: 00                    db_op_00   0x00
  55E9AE04: 19                    db_op_19   0x19
  55E9AE05: 00                    db_op_00   0x00
  55E9AE06: 00                    db_op_00   0x00
loc_55E9AE07:
  55E9AE07: 00                    db_op_00   0x00
  55E9AE08: 02                    db_op_02   0x02
  55E9AE09: 00                    db_op_00   0x00
  55E9AE0A: 00                    db_op_00   0x00
  55E9AE0B: 00                    db_op_00   0x00
  55E9AE0C: 00                    db_op_00   0x00
  55E9AE0D: 00                    db_op_00   0x00
  55E9AE0E: 00                    db_op_00   0x00
  55E9AE0F: 00                    db_op_00   0x00
  55E9AE10: C5 F7                 bhi        loc_55E9AE07
  55E9AE12: E0                    add        d0, d0
  55E9AE13: 55                    db_op_55   0x55
  55E9AE14: 06                    db_op_06   0x06
  55E9AE15: 00                    db_op_00   0x00
  55E9AE16: 00                    db_op_00   0x00
  55E9AE17: 00                    db_op_00   0x00
  55E9AE18: 00                    db_op_00   0x00
  55E9AE19: 04                    db_op_04   0x04
  55E9AE1A: 00                    db_op_00   0x00
  55E9AE1B: 00                    db_op_00   0x00
  55E9AE1C: 00                    db_op_00   0x00
  55E9AE1D: 00                    db_op_00   0x00
  55E9AE1E: 00                    db_op_00   0x00
  55E9AE1F: 00                    db_op_00   0x00
  55E9AE20: 1A                    db_op_1A   0x1A
  55E9AE21: 00                    db_op_00   0x00
  55E9AE22: 00                    db_op_00   0x00
  55E9AE23: 00                    db_op_00   0x00
  55E9AE24: 02                    db_op_02   0x02
  55E9AE25: 00                    db_op_00   0x00
  55E9AE26: 00                    db_op_00   0x00
  55E9AE27: 00                    db_op_00   0x00
  55E9AE28: 00                    db_op_00   0x00
  55E9AE29: 00                    db_op_00   0x00
  55E9AE2A: 00                    db_op_00   0x00
  55E9AE2B: 00                    db_op_00   0x00
  55E9AE2C: F5 FE                 ext_f5_FE  
  55E9AE2E: E0                    add        d0, d0
  55E9AE2F: 55                    db_op_55   0x55
  55E9AE30: 06                    db_op_06   0x06
  55E9AE31: 00                    db_op_00   0x00
  55E9AE32: 00                    db_op_00   0x00
  55E9AE33: 00                    db_op_00   0x00
  55E9AE34: 00                    db_op_00   0x00
  55E9AE35: 04                    db_op_04   0x04
  55E9AE36: 00                    db_op_00   0x00
  55E9AE37: 00                    db_op_00   0x00
  55E9AE38: 00                    db_op_00   0x00
  55E9AE39: 00                    db_op_00   0x00
  55E9AE3A: 00                    db_op_00   0x00
  55E9AE3B: 00                    db_op_00   0x00
  55E9AE3C: 10                    db_op_10   0x10
  55E9AE3D: 00                    db_op_00   0x00
  55E9AE3E: 00                    db_op_00   0x00
  55E9AE3F: 00                    db_op_00   0x00
  55E9AE40: 02                    db_op_02   0x02
  55E9AE41: 00                    db_op_00   0x00
  55E9AE42: 00                    db_op_00   0x00
  55E9AE43: 00                    db_op_00   0x00
  55E9AE44: 00                    db_op_00   0x00
  55E9AE45: 00                    db_op_00   0x00
  55E9AE46: 00                    db_op_00   0x00
  55E9AE47: 00                    db_op_00   0x00
  55E9AE48: 96                    mov        a1, a2
  55E9AE49: 7F                    mov        d3, (a3)
  55E9AE4A: D8                    lbeq       
  55E9AE4B: 55                    db_op_55   0x55
  55E9AE4C: 02                    db_op_02   0x02
  55E9AE4D: 00                    db_op_00   0x00
  55E9AE4E: 00                    db_op_00   0x00
  55E9AE4F: 00                    db_op_00   0x00
  55E9AE50: 00                    db_op_00   0x00
  55E9AE51: 06                    db_op_06   0x06
  55E9AE52: 00                    db_op_00   0x00
  55E9AE53: 00                    db_op_00   0x00
  55E9AE54: 00                    db_op_00   0x00
  55E9AE55: 00                    db_op_00   0x00
  55E9AE56: 00                    db_op_00   0x00
  55E9AE57: 00                    db_op_00   0x00
  55E9AE58: 0A                    db_op_0A   0x0A
  55E9AE59: 00                    db_op_00   0x00
  55E9AE5A: 00                    db_op_00   0x00
  55E9AE5B: 00                    db_op_00   0x00
  55E9AE5C: 02                    db_op_02   0x02
  55E9AE5D: 00                    db_op_00   0x00
  55E9AE5E: 00                    db_op_00   0x00
  55E9AE5F: 00                    db_op_00   0x00
  55E9AE60: 00                    db_op_00   0x00
  55E9AE61: 00                    db_op_00   0x00
  55E9AE62: 00                    db_op_00   0x00
  55E9AE63: 00                    db_op_00   0x00
  55E9AE64: 4E                    db_op_4E   0x4E
  55E9AE65: A3                    db_op_A3   0xA3
  55E9AE66: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9AE67: 55                    db_op_55   0x55
  55E9AE68: 07                    db_op_07   0x07
  55E9AE69: 00                    db_op_00   0x00
  55E9AE6A: 00                    db_op_00   0x00
  55E9AE6B: 00                    db_op_00   0x00
  55E9AE6C: 00                    db_op_00   0x00
  55E9AE6D: 04                    db_op_04   0x04
  55E9AE6E: 00                    db_op_00   0x00
  55E9AE6F: 00                    db_op_00   0x00
  55E9AE70: 00                    db_op_00   0x00
  55E9AE71: 00                    db_op_00   0x00
  55E9AE72: 00                    db_op_00   0x00
  55E9AE73: 00                    db_op_00   0x00
  55E9AE74: 0C                    db_op_0C   0x0C
  55E9AE75: 00                    db_op_00   0x00
  55E9AE76: 00                    db_op_00   0x00
  55E9AE77: 00                    db_op_00   0x00
  55E9AE78: 02                    db_op_02   0x02
  55E9AE79: 00                    db_op_00   0x00
  55E9AE7A: 00                    db_op_00   0x00
  55E9AE7B: 00                    db_op_00   0x00
  55E9AE7C: 00                    db_op_00   0x00
  55E9AE7D: 00                    db_op_00   0x00
  55E9AE7E: 00                    db_op_00   0x00
  55E9AE7F: 00                    db_op_00   0x00
  55E9AE80: 19                    db_op_19   0x19
  55E9AE81: F4 CC                 ext_f4_CC  
  55E9AE83: 55                    db_op_55   0x55
  55E9AE84: 08                    db_op_08   0x08
  55E9AE85: 00                    db_op_00   0x00
  55E9AE86: 00                    db_op_00   0x00
  55E9AE87: 00                    db_op_00   0x00
  55E9AE88: 00                    db_op_00   0x00
  55E9AE89: 0A                    db_op_0A   0x0A
  55E9AE8A: 00                    db_op_00   0x00
  55E9AE8B: 00                    db_op_00   0x00
  55E9AE8C: 00                    db_op_00   0x00
  55E9AE8D: 00                    db_op_00   0x00
  55E9AE8E: 00                    db_op_00   0x00
  55E9AE8F: 00                    db_op_00   0x00
  55E9AE90: 03                    db_op_03   0x03
  55E9AE91: 00                    db_op_00   0x00
  55E9AE92: 00                    db_op_00   0x00
  55E9AE93: 00                    db_op_00   0x00
  55E9AE94: 02                    db_op_02   0x02
  55E9AE95: 00                    db_op_00   0x00
  55E9AE96: 00                    db_op_00   0x00
  55E9AE97: 00                    db_op_00   0x00
  55E9AE98: 00                    db_op_00   0x00
  55E9AE99: 00                    db_op_00   0x00
  55E9AE9A: 00                    db_op_00   0x00
  55E9AE9B: 00                    db_op_00   0x00
  55E9AE9C: E2                    add        d0, d2
  55E9AE9D: 0D                    db_op_0D   0x0D
  55E9AE9E: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55E9AE9F: 55                    db_op_55   0x55
  55E9AEA0: 0A                    db_op_0A   0x0A
  55E9AEA1: 00                    db_op_00   0x00
  55E9AEA2: 00                    db_op_00   0x00
  55E9AEA3: 00                    db_op_00   0x00
  55E9AEA4: 00                    db_op_00   0x00
loc_55E9AEA5:
  55E9AEA5: 10                    db_op_10   0x10
  55E9AEA6: 00                    db_op_00   0x00
  55E9AEA7: 00                    db_op_00   0x00
  55E9AEA8: 00                    db_op_00   0x00
  55E9AEA9: 00                    db_op_00   0x00
  55E9AEAA: 00                    db_op_00   0x00
  55E9AEAB: 00                    db_op_00   0x00
  55E9AEAC: 02                    db_op_02   0x02
  55E9AEAD: 00                    db_op_00   0x00
  55E9AEAE: 00                    db_op_00   0x00
  55E9AEAF: 00                    db_op_00   0x00
  55E9AEB0: 02                    db_op_02   0x02
  55E9AEB1: 00                    db_op_00   0x00
  55E9AEB2: 00                    db_op_00   0x00
  55E9AEB3: 00                    db_op_00   0x00
  55E9AEB4: 00                    db_op_00   0x00
  55E9AEB5: 00                    db_op_00   0x00
  55E9AEB6: 00                    db_op_00   0x00
  55E9AEB7: 00                    db_op_00   0x00
  55E9AEB8: DD 6B CD 55 0B 00 00  call       0x613F7C23, [], 0
  55E9AEBF: 00                    db_op_00   0x00
  55E9AEC0: 00                    db_op_00   0x00
  55E9AEC1: 10                    db_op_10   0x10
  55E9AEC2: 00                    db_op_00   0x00
  55E9AEC3: 00                    db_op_00   0x00
  55E9AEC4: 00                    db_op_00   0x00
  55E9AEC5: 00                    db_op_00   0x00
  55E9AEC6: 00                    db_op_00   0x00
  55E9AEC7: 00                    db_op_00   0x00
  55E9AEC8: 04                    db_op_04   0x04
  55E9AEC9: 00                    db_op_00   0x00
  55E9AECA: 00                    db_op_00   0x00
  55E9AECB: 00                    db_op_00   0x00
  55E9AECC: 02                    db_op_02   0x02
  55E9AECD: 00                    db_op_00   0x00
  55E9AECE: 00                    db_op_00   0x00
  55E9AECF: 00                    db_op_00   0x00
  55E9AED0: 00                    db_op_00   0x00
  55E9AED1: 00                    db_op_00   0x00
  55E9AED2: 00                    db_op_00   0x00
  55E9AED3: 00                    db_op_00   0x00
  55E9AED4: 51                    db_op_51   0x51
  55E9AED5: C6 D0                 bcc        loc_55E9AEA5
  55E9AED7: 55                    db_op_55   0x55
  55E9AED8: 0E                    db_op_0E   0x0E
  55E9AED9: 00                    db_op_00   0x00
  55E9AEDA: 00                    db_op_00   0x00
  55E9AEDB: 00                    db_op_00   0x00
  55E9AEDC: 00                    db_op_00   0x00
  55E9AEDD: 10                    db_op_10   0x10
  55E9AEDE: 00                    db_op_00   0x00
  55E9AEDF: 00                    db_op_00   0x00
  55E9AEE0: 00                    db_op_00   0x00
  55E9AEE1: 00                    db_op_00   0x00
  55E9AEE2: 00                    db_op_00   0x00
  55E9AEE3: 00                    db_op_00   0x00
  55E9AEE4: 0E                    db_op_0E   0x0E
  55E9AEE5: 00                    db_op_00   0x00
  55E9AEE6: 00                    db_op_00   0x00
  55E9AEE7: 00                    db_op_00   0x00
  55E9AEE8: 02                    db_op_02   0x02
  55E9AEE9: 00                    db_op_00   0x00
  55E9AEEA: 00                    db_op_00   0x00
  55E9AEEB: 00                    db_op_00   0x00
  55E9AEEC: 00                    db_op_00   0x00
  55E9AEED: 00                    db_op_00   0x00
  55E9AEEE: 00                    db_op_00   0x00
  55E9AEEF: 00                    db_op_00   0x00
  55E9AEF0: 94                    mov        a1, a0
  55E9AEF1: 91 D8                 mov        0xD8, a1
  55E9AEF3: 55                    db_op_55   0x55
  55E9AEF4: 09                    db_op_09   0x09
  55E9AEF5: 00                    db_op_00   0x00
  55E9AEF6: 00                    db_op_00   0x00
  55E9AEF7: 00                    db_op_00   0x00
  55E9AEF8: 00                    db_op_00   0x00
  55E9AEF9: 02                    db_op_02   0x02
  55E9AEFA: 00                    db_op_00   0x00
  55E9AEFB: 00                    db_op_00   0x00
  55E9AEFC: 00                    db_op_00   0x00
  55E9AEFD: 00                    db_op_00   0x00
  55E9AEFE: 00                    db_op_00   0x00
  55E9AEFF: 00                    db_op_00   0x00
  55E9AF00: 0D                    db_op_0D   0x0D
  55E9AF01: 00                    db_op_00   0x00
  55E9AF02: 00                    db_op_00   0x00
  55E9AF03: 00                    db_op_00   0x00
  55E9AF04: 02                    db_op_02   0x02
  55E9AF05: 00                    db_op_00   0x00
  55E9AF06: 00                    db_op_00   0x00
  55E9AF07: 00                    db_op_00   0x00
  55E9AF08: 00                    db_op_00   0x00
  55E9AF09: 00                    db_op_00   0x00
  55E9AF0A: 00                    db_op_00   0x00
  55E9AF0B: 00                    db_op_00   0x00
  55E9AF0C: 40 9E                 mov        a0, (158, sp)
  55E9AF0E: D8                    lbeq       
  55E9AF0F: 55                    db_op_55   0x55
  55E9AF10: 0E                    db_op_0E   0x0E
  55E9AF11: 00                    db_op_00   0x00
  55E9AF12: 00                    db_op_00   0x00
  55E9AF13: 00                    db_op_00   0x00
  55E9AF14: 00                    db_op_00   0x00
  55E9AF15: 12                    db_op_12   0x12
  55E9AF16: 00                    db_op_00   0x00
  55E9AF17: 00                    db_op_00   0x00
  55E9AF18: 00                    db_op_00   0x00
  55E9AF19: 00                    db_op_00   0x00
  55E9AF1A: 00                    db_op_00   0x00
  55E9AF1B: 00                    db_op_00   0x00
  55E9AF1C: 17                    db_op_17   0x17
  55E9AF1D: 00                    db_op_00   0x00
  55E9AF1E: 00                    db_op_00   0x00
  55E9AF1F: 00                    db_op_00   0x00
  55E9AF20: 02                    db_op_02   0x02
  55E9AF21: 00                    db_op_00   0x00
  55E9AF22: 00                    db_op_00   0x00
  55E9AF23: 00                    db_op_00   0x00
  55E9AF24: 00                    db_op_00   0x00
  55E9AF25: 00                    db_op_00   0x00
  55E9AF26: 00                    db_op_00   0x00
  55E9AF27: 00                    db_op_00   0x00
  55E9AF28: 7F                    mov        d3, (a3)
  55E9AF29: B0                    db_op_B0   0xB0
  55E9AF2A: D8                    lbeq       
  55E9AF2B: 55                    db_op_55   0x55
  55E9AF2C: 10                    db_op_10   0x10
  55E9AF2D: 00                    db_op_00   0x00
  55E9AF2E: 00                    db_op_00   0x00
  55E9AF2F: 00                    db_op_00   0x00
  55E9AF30: 00                    db_op_00   0x00
  55E9AF31: 20 00                 add        0, d0
  55E9AF33: 00                    db_op_00   0x00
  55E9AF34: 00                    db_op_00   0x00
  55E9AF35: 00                    db_op_00   0x00
  55E9AF36: 00                    db_op_00   0x00
  55E9AF37: 00                    db_op_00   0x00
  55E9AF38: 0B                    db_op_0B   0x0B
  55E9AF39: 00                    db_op_00   0x00
  55E9AF3A: 00                    db_op_00   0x00
  55E9AF3B: 00                    db_op_00   0x00
  55E9AF3C: 02                    db_op_02   0x02
  55E9AF3D: 00                    db_op_00   0x00
  55E9AF3E: 00                    db_op_00   0x00
  55E9AF3F: 00                    db_op_00   0x00
  55E9AF40: 00                    db_op_00   0x00
  55E9AF41: 00                    db_op_00   0x00
  55E9AF42: 00                    db_op_00   0x00
  55E9AF43: 00                    db_op_00   0x00
  55E9AF44: 28 23                 cmp        0x23, d0
  55E9AF46: D4                    lbcs       
  55E9AF47: 55                    db_op_55   0x55
  55E9AF48: 0F                    db_op_0F   0x0F
  55E9AF49: 00                    db_op_00   0x00
  55E9AF4A: 00                    db_op_00   0x00
  55E9AF4B: 00                    db_op_00   0x00
  55E9AF4C: 00                    db_op_00   0x00
  55E9AF4D: 04                    db_op_04   0x04
  55E9AF4E: 00                    db_op_00   0x00
  55E9AF4F: 00                    db_op_00   0x00
  55E9AF50: 00                    db_op_00   0x00
  55E9AF51: 00                    db_op_00   0x00
  55E9AF52: 00                    db_op_00   0x00
  55E9AF53: 00                    db_op_00   0x00
  55E9AF54: 0F                    db_op_0F   0x0F
  55E9AF55: 00                    db_op_00   0x00
  55E9AF56: 00                    db_op_00   0x00
  55E9AF57: 00                    db_op_00   0x00
  55E9AF58: 02                    db_op_02   0x02
  55E9AF59: 00                    db_op_00   0x00
  55E9AF5A: 00                    db_op_00   0x00
  55E9AF5B: 00                    db_op_00   0x00
  55E9AF5C: 00                    db_op_00   0x00
  55E9AF5D: 00                    db_op_00   0x00
  55E9AF5E: 00                    db_op_00   0x00
  55E9AF5F: 00                    db_op_00   0x00
  55E9AF60: F1 BB                 ext_f1_BB  
  55E9AF62: D4                    lbcs       
  55E9AF63: 55                    db_op_55   0x55
  55E9AF64: 0C                    db_op_0C   0x0C
  55E9AF65: 00                    db_op_00   0x00
  55E9AF66: 00                    db_op_00   0x00
  55E9AF67: 00                    db_op_00   0x00
  55E9AF68: 00                    db_op_00   0x00
  55E9AF69: 06                    db_op_06   0x06
  55E9AF6A: 00                    db_op_00   0x00
  55E9AF6B: 00                    db_op_00   0x00
  55E9AF6C: 00                    db_op_00   0x00
  55E9AF6D: 00                    db_op_00   0x00
  55E9AF6E: 00                    db_op_00   0x00
  55E9AF6F: 00                    db_op_00   0x00
  55E9AF70: 1B                    db_op_1B   0x1B
  55E9AF71: 00                    db_op_00   0x00
  55E9AF72: 00                    db_op_00   0x00
  55E9AF73: 00                    db_op_00   0x00
  55E9AF74: 02                    db_op_02   0x02
  55E9AF75: 00                    db_op_00   0x00
  55E9AF76: 00                    db_op_00   0x00
  55E9AF77: 00                    db_op_00   0x00
  55E9AF78: 00                    db_op_00   0x00
  55E9AF79: 00                    db_op_00   0x00
  55E9AF7A: 00                    db_op_00   0x00
  55E9AF7B: 00                    db_op_00   0x00
  55E9AF7C: 91 FB                 mov        0xFB, a1
  55E9AF7E: E3                    add        d0, d3
  55E9AF7F: 55                    db_op_55   0x55
  55E9AF80: 03                    db_op_03   0x03
  55E9AF81: 00                    db_op_00   0x00
  55E9AF82: 00                    db_op_00   0x00
  55E9AF83: 00                    db_op_00   0x00
  55E9AF84: 00                    db_op_00   0x00
  55E9AF85: 06                    db_op_06   0x06
  55E9AF86: 00                    db_op_00   0x00
  55E9AF87: 00                    db_op_00   0x00
  55E9AF88: 00                    db_op_00   0x00
  55E9AF89: 00                    db_op_00   0x00
  55E9AF8A: 00                    db_op_00   0x00
  55E9AF8B: 00                    db_op_00   0x00
  55E9AF8C: 1F                    db_op_1F   0x1F
  55E9AF8D: 00                    db_op_00   0x00
  55E9AF8E: 00                    db_op_00   0x00
  55E9AF8F: 00                    db_op_00   0x00
  55E9AF90: 02                    db_op_02   0x02
  55E9AF91: 00                    db_op_00   0x00
  55E9AF92: 00                    db_op_00   0x00
  55E9AF93: 00                    db_op_00   0x00
  55E9AF94: 00                    db_op_00   0x00
  55E9AF95: 00                    db_op_00   0x00
  55E9AF96: 00                    db_op_00   0x00
  55E9AF97: 00                    db_op_00   0x00
  55E9AF98: 3F BD                 mov        d3, (189, sp)
  55E9AF9A: C9 55                 bne        loc_55E9AFEF
  55E9AF9C: 12                    db_op_12   0x12
  55E9AF9D: 00                    db_op_00   0x00
  55E9AF9E: 00                    db_op_00   0x00
  55E9AF9F: 00                    db_op_00   0x00
  55E9AFA0: 80 00                 mov        0x00, d0
  55E9AFA2: 00                    db_op_00   0x00
  55E9AFA3: 00                    db_op_00   0x00
  55E9AFA4: 00                    db_op_00   0x00
  55E9AFA5: 00                    db_op_00   0x00
  55E9AFA6: 00                    db_op_00   0x00
  55E9AFA7: 00                    db_op_00   0x00
  55E9AFA8: 00                    db_op_00   0x00
  55E9AFA9: 00                    db_op_00   0x00
  55E9AFAA: 00                    db_op_00   0x00
  55E9AFAB: 00                    db_op_00   0x00
  55E9AFAC: 00                    db_op_00   0x00
  55E9AFAD: 00                    db_op_00   0x00
  55E9AFAE: 00                    db_op_00   0x00
  55E9AFAF: 00                    db_op_00   0x00
  55E9AFB0: 00                    db_op_00   0x00
  55E9AFB1: 00                    db_op_00   0x00
  55E9AFB2: 00                    db_op_00   0x00
  55E9AFB3: 00                    db_op_00   0x00
  55E9AFB4: 00                    db_op_00   0x00
  55E9AFB5: 00                    db_op_00   0x00
  55E9AFB6: 00                    db_op_00   0x00
  55E9AFB7: 00                    db_op_00   0x00
  55E9AFB8: 00                    db_op_00   0x00
  55E9AFB9: 00                    db_op_00   0x00
  55E9AFBA: 00                    db_op_00   0x00
  55E9AFBB: 00                    db_op_00   0x00
  55E9AFBC: 00                    db_op_00   0x00
  55E9AFBD: 00                    db_op_00   0x00
  55E9AFBE: 00                    db_op_00   0x00
  55E9AFBF: 00                    db_op_00   0x00
  55E9AFC0: 00                    db_op_00   0x00
  55E9AFC1: 00                    db_op_00   0x00
  55E9AFC2: 00                    db_op_00   0x00
  55E9AFC3: 00                    db_op_00   0x00
  55E9AFC4: 00                    db_op_00   0x00
  55E9AFC5: 00                    db_op_00   0x00
  55E9AFC6: 00                    db_op_00   0x00
  55E9AFC7: 00                    db_op_00   0x00
  55E9AFC8: 00                    db_op_00   0x00
  55E9AFC9: 00                    db_op_00   0x00
  55E9AFCA: 00                    db_op_00   0x00
  55E9AFCB: 00                    db_op_00   0x00
  55E9AFCC: 00                    db_op_00   0x00
  55E9AFCD: 00                    db_op_00   0x00
  55E9AFCE: 00                    db_op_00   0x00
  55E9AFCF: 00                    db_op_00   0x00
  55E9AFD0: 11                    db_op_11   0x11
  55E9AFD1: 00                    db_op_00   0x00
  55E9AFD2: 00                    db_op_00   0x00
  55E9AFD3: 00                    db_op_00   0x00
  55E9AFD4: 00                    db_op_00   0x00
  55E9AFD5: 00                    db_op_00   0x00
  55E9AFD6: 00                    db_op_00   0x00
  55E9AFD7: 00                    db_op_00   0x00
  55E9AFD8: 01                    db_op_01   0x01
  55E9AFD9: 00                    db_op_00   0x00
  55E9AFDA: 00                    db_op_00   0x00
  55E9AFDB: 00                    db_op_00   0x00
  55E9AFDC: 01                    db_op_01   0x01
  55E9AFDD: 00                    db_op_00   0x00
  55E9AFDE: 00                    db_op_00   0x00
  55E9AFDF: 00                    db_op_00   0x00
  55E9AFE0: 12                    db_op_12   0x12
  55E9AFE1: 00                    db_op_00   0x00
  55E9AFE2: 00                    db_op_00   0x00
  55E9AFE3: 00                    db_op_00   0x00
  55E9AFE4: 00                    db_op_00   0x00
  55E9AFE5: 00                    db_op_00   0x00
  55E9AFE6: 00                    db_op_00   0x00
  55E9AFE7: 00                    db_op_00   0x00
  55E9AFE8: 01                    db_op_01   0x01
  55E9AFE9: 00                    db_op_00   0x00
  55E9AFEA: 00                    db_op_00   0x00
  55E9AFEB: 00                    db_op_00   0x00
  55E9AFEC: 01                    db_op_01   0x01
  55E9AFED: 00                    db_op_00   0x00
  55E9AFEE: 00                    db_op_00   0x00
loc_55E9AFEF:
  55E9AFEF: 00                    db_op_00   0x00
  55E9AFF0: 13                    db_op_13   0x13
  55E9AFF1: 00                    db_op_00   0x00
  55E9AFF2: 00                    db_op_00   0x00
  55E9AFF3: 00                    db_op_00   0x00
  55E9AFF4: 00                    db_op_00   0x00
  55E9AFF5: 00                    db_op_00   0x00
  55E9AFF6: 00                    db_op_00   0x00
  55E9AFF7: 00                    db_op_00   0x00
  55E9AFF8: 01                    db_op_01   0x01
  55E9AFF9: 00                    db_op_00   0x00
  55E9AFFA: 00                    db_op_00   0x00
  55E9AFFB: 00                    db_op_00   0x00
  55E9AFFC: 01                    db_op_01   0x01
  55E9AFFD: 00                    db_op_00   0x00
  55E9AFFE: 00                    db_op_00   0x00
  55E9AFFF: 00                    db_op_00   0x00
  55E9B000: 14                    db_op_14   0x14
  55E9B001: 00                    db_op_00   0x00
  55E9B002: 00                    db_op_00   0x00
  55E9B003: 00                    db_op_00   0x00
  55E9B004: 00                    db_op_00   0x00
  55E9B005: 00                    db_op_00   0x00
  55E9B006: 00                    db_op_00   0x00
  55E9B007: 00                    db_op_00   0x00
  55E9B008: 01                    db_op_01   0x01
  55E9B009: 00                    db_op_00   0x00
  55E9B00A: 00                    db_op_00   0x00
  55E9B00B: 00                    db_op_00   0x00
  55E9B00C: 01                    db_op_01   0x01
  55E9B00D: 00                    db_op_00   0x00
  55E9B00E: 00                    db_op_00   0x00
  55E9B00F: 00                    db_op_00   0x00
  55E9B010: 15                    db_op_15   0x15
  55E9B011: 00                    db_op_00   0x00
  55E9B012: 00                    db_op_00   0x00
  55E9B013: 00                    db_op_00   0x00
  55E9B014: 00                    db_op_00   0x00
  55E9B015: 00                    db_op_00   0x00
  55E9B016: 00                    db_op_00   0x00
  55E9B017: 00                    db_op_00   0x00
  55E9B018: 01                    db_op_01   0x01
  55E9B019: 00                    db_op_00   0x00
  55E9B01A: 00                    db_op_00   0x00
  55E9B01B: 00                    db_op_00   0x00
  55E9B01C: 01                    db_op_01   0x01
  55E9B01D: 00                    db_op_00   0x00
  55E9B01E: 00                    db_op_00   0x00
  55E9B01F: 00                    db_op_00   0x00
  55E9B020: 16                    db_op_16   0x16
  55E9B021: 00                    db_op_00   0x00
  55E9B022: 00                    db_op_00   0x00
  55E9B023: 00                    db_op_00   0x00
  55E9B024: 00                    db_op_00   0x00
  55E9B025: 00                    db_op_00   0x00
  55E9B026: 00                    db_op_00   0x00
  55E9B027: 00                    db_op_00   0x00
  55E9B028: 01                    db_op_01   0x01
  55E9B029: 00                    db_op_00   0x00
  55E9B02A: 00                    db_op_00   0x00
  55E9B02B: 00                    db_op_00   0x00
  55E9B02C: 01                    db_op_01   0x01
  55E9B02D: 00                    db_op_00   0x00
  55E9B02E: 00                    db_op_00   0x00
  55E9B02F: 00                    db_op_00   0x00
  55E9B030: 17                    db_op_17   0x17
  55E9B031: 00                    db_op_00   0x00
  55E9B032: 00                    db_op_00   0x00
  55E9B033: 00                    db_op_00   0x00
  55E9B034: 00                    db_op_00   0x00
  55E9B035: 00                    db_op_00   0x00
  55E9B036: 00                    db_op_00   0x00
  55E9B037: 00                    db_op_00   0x00
  55E9B038: 01                    db_op_01   0x01
  55E9B039: 00                    db_op_00   0x00
  55E9B03A: 00                    db_op_00   0x00
  55E9B03B: 00                    db_op_00   0x00
  55E9B03C: 01                    db_op_01   0x01
  55E9B03D: 00                    db_op_00   0x00
  55E9B03E: 00                    db_op_00   0x00
  55E9B03F: 00                    db_op_00   0x00
  55E9B040: 18                    db_op_18   0x18
  55E9B041: 00                    db_op_00   0x00
  55E9B042: 00                    db_op_00   0x00
  55E9B043: 00                    db_op_00   0x00
  55E9B044: 00                    db_op_00   0x00
  55E9B045: 00                    db_op_00   0x00
  55E9B046: 00                    db_op_00   0x00
  55E9B047: 00                    db_op_00   0x00
  55E9B048: 01                    db_op_01   0x01
  55E9B049: 00                    db_op_00   0x00
  55E9B04A: 00                    db_op_00   0x00
  55E9B04B: 00                    db_op_00   0x00
  55E9B04C: 01                    db_op_01   0x01
  55E9B04D: 00                    db_op_00   0x00
  55E9B04E: 00                    db_op_00   0x00
  55E9B04F: 00                    db_op_00   0x00
  55E9B050: 19                    db_op_19   0x19
  55E9B051: 00                    db_op_00   0x00
  55E9B052: 00                    db_op_00   0x00
  55E9B053: 00                    db_op_00   0x00
  55E9B054: 00                    db_op_00   0x00
  55E9B055: 00                    db_op_00   0x00
  55E9B056: 00                    db_op_00   0x00
  55E9B057: 00                    db_op_00   0x00
  55E9B058: 01                    db_op_01   0x01
  55E9B059: 00                    db_op_00   0x00
  55E9B05A: 00                    db_op_00   0x00
  55E9B05B: 00                    db_op_00   0x00
  55E9B05C: 01                    db_op_01   0x01
  55E9B05D: 00                    db_op_00   0x00
  55E9B05E: 00                    db_op_00   0x00
  55E9B05F: 00                    db_op_00   0x00
  55E9B060: 00                    db_op_00   0x00
  55E9B061: 00                    db_op_00   0x00
  55E9B062: 00                    db_op_00   0x00
  55E9B063: 00                    db_op_00   0x00
  55E9B064: 00                    db_op_00   0x00
  55E9B065: 00                    db_op_00   0x00
  55E9B066: 00                    db_op_00   0x00
  55E9B067: 00                    db_op_00   0x00
  55E9B068: 00                    db_op_00   0x00
  55E9B069: 00                    db_op_00   0x00
  55E9B06A: 00                    db_op_00   0x00
  55E9B06B: 00                    db_op_00   0x00
  55E9B06C: 00                    db_op_00   0x00
  55E9B06D: 00                    db_op_00   0x00
  55E9B06E: 00                    db_op_00   0x00
  55E9B06F: 00                    db_op_00   0x00
  55E9B070: 11                    db_op_11   0x11
  55E9B071: 00                    db_op_00   0x00
  55E9B072: 00                    db_op_00   0x00
  55E9B073: 00                    db_op_00   0x00
  55E9B074: 02                    db_op_02   0x02
  55E9B075: 00                    db_op_00   0x00
  55E9B076: 00                    db_op_00   0x00
  55E9B077: 00                    db_op_00   0x00
  55E9B078: 00                    db_op_00   0x00
  55E9B079: 00                    db_op_00   0x00
  55E9B07A: 00                    db_op_00   0x00
  55E9B07B: 00                    db_op_00   0x00
  55E9B07C: 12                    db_op_12   0x12
  55E9B07D: 00                    db_op_00   0x00
  55E9B07E: 00                    db_op_00   0x00
  55E9B07F: 00                    db_op_00   0x00
  55E9B080: 02                    db_op_02   0x02
  55E9B081: 00                    db_op_00   0x00
  55E9B082: 00                    db_op_00   0x00
  55E9B083: 00                    db_op_00   0x00
  55E9B084: 00                    db_op_00   0x00
  55E9B085: 00                    db_op_00   0x00
  55E9B086: 00                    db_op_00   0x00
  55E9B087: 00                    db_op_00   0x00
  55E9B088: 13                    db_op_13   0x13
  55E9B089: 00                    db_op_00   0x00
  55E9B08A: 00                    db_op_00   0x00
  55E9B08B: 00                    db_op_00   0x00
  55E9B08C: 02                    db_op_02   0x02
  55E9B08D: 00                    db_op_00   0x00
  55E9B08E: 00                    db_op_00   0x00
  55E9B08F: 00                    db_op_00   0x00
  55E9B090: 00                    db_op_00   0x00
  55E9B091: 00                    db_op_00   0x00
  55E9B092: 00                    db_op_00   0x00
  55E9B093: 00                    db_op_00   0x00
  55E9B094: 14                    db_op_14   0x14
  55E9B095: 00                    db_op_00   0x00
  55E9B096: 00                    db_op_00   0x00
  55E9B097: 00                    db_op_00   0x00
  55E9B098: 02                    db_op_02   0x02
  55E9B099: 00                    db_op_00   0x00
  55E9B09A: 00                    db_op_00   0x00
  55E9B09B: 00                    db_op_00   0x00
  55E9B09C: 00                    db_op_00   0x00
  55E9B09D: 00                    db_op_00   0x00
  55E9B09E: 00                    db_op_00   0x00
  55E9B09F: 00                    db_op_00   0x00
  55E9B0A0: 15                    db_op_15   0x15
  55E9B0A1: 00                    db_op_00   0x00
  55E9B0A2: 00                    db_op_00   0x00
  55E9B0A3: 00                    db_op_00   0x00
  55E9B0A4: 02                    db_op_02   0x02
  55E9B0A5: 00                    db_op_00   0x00
  55E9B0A6: 00                    db_op_00   0x00
  55E9B0A7: 00                    db_op_00   0x00
  55E9B0A8: 00                    db_op_00   0x00
  55E9B0A9: 00                    db_op_00   0x00
  55E9B0AA: 00                    db_op_00   0x00
  55E9B0AB: 00                    db_op_00   0x00
  55E9B0AC: 00                    db_op_00   0x00
  55E9B0AD: 00                    db_op_00   0x00
  55E9B0AE: 00                    db_op_00   0x00
  55E9B0AF: 00                    db_op_00   0x00
  55E9B0B0: 00                    db_op_00   0x00
  55E9B0B1: 00                    db_op_00   0x00
  55E9B0B2: 00                    db_op_00   0x00
  55E9B0B3: 00                    db_op_00   0x00
  55E9B0B4: 00                    db_op_00   0x00
  55E9B0B5: 00                    db_op_00   0x00
  55E9B0B6: 00                    db_op_00   0x00
  55E9B0B7: 00                    db_op_00   0x00
  55E9B0B8: 01                    db_op_01   0x01
  55E9B0B9: 00                    db_op_00   0x00
  55E9B0BA: 00                    db_op_00   0x00
  55E9B0BB: 00                    db_op_00   0x00
  55E9B0BC: 00                    db_op_00   0x00
  55E9B0BD: 00                    db_op_00   0x00
  55E9B0BE: 00                    db_op_00   0x00
  55E9B0BF: 00                    db_op_00   0x00
  55E9B0C0: 20 00                 add        0, d0
  55E9B0C2: 00                    db_op_00   0x00
  55E9B0C3: 00                    db_op_00   0x00
  55E9B0C4: 00                    db_op_00   0x00
  55E9B0C5: 00                    db_op_00   0x00
  55E9B0C6: 00                    db_op_00   0x00
  55E9B0C7: 00                    db_op_00   0x00
  55E9B0C8: 03                    db_op_03   0x03
  55E9B0C9: 00                    db_op_00   0x00
  55E9B0CA: 00                    db_op_00   0x00
  55E9B0CB: 00                    db_op_00   0x00
  55E9B0CC: 00                    db_op_00   0x00
  55E9B0CD: 00                    db_op_00   0x00
  55E9B0CE: 00                    db_op_00   0x00
  55E9B0CF: 00                    db_op_00   0x00
  55E9B0D0: 08                    db_op_08   0x08
  55E9B0D1: 00                    db_op_00   0x00
  55E9B0D2: 00                    db_op_00   0x00
  55E9B0D3: 00                    db_op_00   0x00
  55E9B0D4: 00                    db_op_00   0x00
  55E9B0D5: 00                    db_op_00   0x00
  55E9B0D6: 00                    db_op_00   0x00
  55E9B0D7: 00                    db_op_00   0x00
  55E9B0D8: 04                    db_op_04   0x04
  55E9B0D9: 00                    db_op_00   0x00
  55E9B0DA: 00                    db_op_00   0x00
  55E9B0DB: 00                    db_op_00   0x00
  55E9B0DC: 00                    db_op_00   0x00
  55E9B0DD: 00                    db_op_00   0x00
  55E9B0DE: 00                    db_op_00   0x00
  55E9B0DF: 00                    db_op_00   0x00
  55E9B0E0: 10                    db_op_10   0x10
  55E9B0E1: 00                    db_op_00   0x00
  55E9B0E2: 00                    db_op_00   0x00
  55E9B0E3: 00                    db_op_00   0x00
  55E9B0E4: 00                    db_op_00   0x00
  55E9B0E5: 00                    db_op_00   0x00
  55E9B0E6: 00                    db_op_00   0x00
  55E9B0E7: 00                    db_op_00   0x00
  55E9B0E8: 02                    db_op_02   0x02
  55E9B0E9: 00                    db_op_00   0x00
  55E9B0EA: 00                    db_op_00   0x00
  55E9B0EB: 00                    db_op_00   0x00
  55E9B0EC: 00                    db_op_00   0x00
  55E9B0ED: 00                    db_op_00   0x00
  55E9B0EE: 00                    db_op_00   0x00
  55E9B0EF: 00                    db_op_00   0x00
  55E9B0F0: 10                    db_op_10   0x10
  55E9B0F1: 00                    db_op_00   0x00
  55E9B0F2: 00                    db_op_00   0x00
  55E9B0F3: 00                    db_op_00   0x00
  55E9B0F4: 00                    db_op_00   0x00
  55E9B0F5: 00                    db_op_00   0x00
  55E9B0F6: 00                    db_op_00   0x00
  55E9B0F7: 00                    db_op_00   0x00
  55E9B0F8: 0E                    db_op_0E   0x0E
  55E9B0F9: 00                    db_op_00   0x00
  55E9B0FA: 00                    db_op_00   0x00
  55E9B0FB: 00                    db_op_00   0x00
  55E9B0FC: 00                    db_op_00   0x00
  55E9B0FD: 00                    db_op_00   0x00
  55E9B0FE: 00                    db_op_00   0x00
  55E9B0FF: 00                    db_op_00   0x00
  55E9B100: 04                    db_op_04   0x04
  55E9B101: 00                    db_op_00   0x00
  55E9B102: 00                    db_op_00   0x00
  55E9B103: 00                    db_op_00   0x00
  55E9B104: 00                    db_op_00   0x00
  55E9B105: 00                    db_op_00   0x00
  55E9B106: 00                    db_op_00   0x00
  55E9B107: 00                    db_op_00   0x00
  55E9B108: 10                    db_op_10   0x10
  55E9B109: 00                    db_op_00   0x00
  55E9B10A: 00                    db_op_00   0x00
  55E9B10B: 00                    db_op_00   0x00
  55E9B10C: 00                    db_op_00   0x00
  55E9B10D: 00                    db_op_00   0x00
  55E9B10E: 00                    db_op_00   0x00
  55E9B10F: 00                    db_op_00   0x00
  55E9B110: 10                    db_op_10   0x10
  55E9B111: 00                    db_op_00   0x00
  55E9B112: 00                    db_op_00   0x00
  55E9B113: 00                    db_op_00   0x00
  55E9B114: 00                    db_op_00   0x00
  55E9B115: 00                    db_op_00   0x00
  55E9B116: 00                    db_op_00   0x00
  55E9B117: 00                    db_op_00   0x00
  55E9B118: 0F                    db_op_0F   0x0F
  55E9B119: 00                    db_op_00   0x00
  55E9B11A: 00                    db_op_00   0x00
  55E9B11B: 00                    db_op_00   0x00
  55E9B11C: 00                    db_op_00   0x00
  55E9B11D: 00                    db_op_00   0x00
  55E9B11E: 00                    db_op_00   0x00
  55E9B11F: 00                    db_op_00   0x00
  55E9B120: 10                    db_op_10   0x10
  55E9B121: 00                    db_op_00   0x00
  55E9B122: 00                    db_op_00   0x00
  55E9B123: 00                    db_op_00   0x00
  55E9B124: 00                    db_op_00   0x00
  55E9B125: 00                    db_op_00   0x00
  55E9B126: 00                    db_op_00   0x00
  55E9B127: 00                    db_op_00   0x00
  55E9B128: 14                    db_op_14   0x14
  55E9B129: 00                    db_op_00   0x00
  55E9B12A: 00                    db_op_00   0x00
  55E9B12B: 00                    db_op_00   0x00
  55E9B12C: 00                    db_op_00   0x00
  55E9B12D: 00                    db_op_00   0x00
  55E9B12E: 00                    db_op_00   0x00
  55E9B12F: 00                    db_op_00   0x00
  55E9B130: 10                    db_op_10   0x10
  55E9B131: 00                    db_op_00   0x00
  55E9B132: 00                    db_op_00   0x00
  55E9B133: 00                    db_op_00   0x00
  55E9B134: 00                    db_op_00   0x00
  55E9B135: 00                    db_op_00   0x00
  55E9B136: 00                    db_op_00   0x00
  55E9B137: 00                    db_op_00   0x00
  55E9B138: 0D                    db_op_0D   0x0D
  55E9B139: 00                    db_op_00   0x00
  55E9B13A: 00                    db_op_00   0x00
  55E9B13B: 00                    db_op_00   0x00
  55E9B13C: 00                    db_op_00   0x00
  55E9B13D: 00                    db_op_00   0x00
  55E9B13E: 00                    db_op_00   0x00
  55E9B13F: 00                    db_op_00   0x00
  55E9B140: 10                    db_op_10   0x10
  55E9B141: 00                    db_op_00   0x00
  55E9B142: 00                    db_op_00   0x00
  55E9B143: 00                    db_op_00   0x00
  55E9B144: 00                    db_op_00   0x00
  55E9B145: 00                    db_op_00   0x00
  55E9B146: 00                    db_op_00   0x00
  55E9B147: 00                    db_op_00   0x00
  55E9B148: 16                    db_op_16   0x16
  55E9B149: 00                    db_op_00   0x00
  55E9B14A: 00                    db_op_00   0x00
  55E9B14B: 00                    db_op_00   0x00
  55E9B14C: 00                    db_op_00   0x00
  55E9B14D: 00                    db_op_00   0x00
  55E9B14E: 00                    db_op_00   0x00
  55E9B14F: 00                    db_op_00   0x00
  55E9B150: 08                    db_op_08   0x08
  55E9B151: 00                    db_op_00   0x00
  55E9B152: 00                    db_op_00   0x00
  55E9B153: 00                    db_op_00   0x00
  55E9B154: 00                    db_op_00   0x00
  55E9B155: 00                    db_op_00   0x00
  55E9B156: 00                    db_op_00   0x00
  55E9B157: 00                    db_op_00   0x00
  55E9B158: 18                    db_op_18   0x18
  55E9B159: 00                    db_op_00   0x00
  55E9B15A: 00                    db_op_00   0x00
  55E9B15B: 00                    db_op_00   0x00
  55E9B15C: 00                    db_op_00   0x00
  55E9B15D: 00                    db_op_00   0x00
  55E9B15E: 00                    db_op_00   0x00
  55E9B15F: 00                    db_op_00   0x00
  55E9B160: 01                    db_op_01   0x01
  55E9B161: 00                    db_op_00   0x00
  55E9B162: 00                    db_op_00   0x00
  55E9B163: 00                    db_op_00   0x00
  55E9B164: 00                    db_op_00   0x00
  55E9B165: 00                    db_op_00   0x00
  55E9B166: 00                    db_op_00   0x00
  55E9B167: 00                    db_op_00   0x00
  55E9B168: 05                    db_op_05   0x05
  55E9B169: 00                    db_op_00   0x00
  55E9B16A: 00                    db_op_00   0x00
  55E9B16B: 00                    db_op_00   0x00
  55E9B16C: 00                    db_op_00   0x00
  55E9B16D: 00                    db_op_00   0x00
  55E9B16E: 00                    db_op_00   0x00
  55E9B16F: 00                    db_op_00   0x00
  55E9B170: 10                    db_op_10   0x10
  55E9B171: 00                    db_op_00   0x00
  55E9B172: 00                    db_op_00   0x00
  55E9B173: 00                    db_op_00   0x00
  55E9B174: 00                    db_op_00   0x00
  55E9B175: 00                    db_op_00   0x00
  55E9B176: 00                    db_op_00   0x00
  55E9B177: 00                    db_op_00   0x00
  55E9B178: 13                    db_op_13   0x13
  55E9B179: 00                    db_op_00   0x00
  55E9B17A: 00                    db_op_00   0x00
  55E9B17B: 00                    db_op_00   0x00
  55E9B17C: 00                    db_op_00   0x00
  55E9B17D: 00                    db_op_00   0x00
  55E9B17E: 00                    db_op_00   0x00
  55E9B17F: 00                    db_op_00   0x00
  55E9B180: 04                    db_op_04   0x04
  55E9B181: 00                    db_op_00   0x00
  55E9B182: 00                    db_op_00   0x00
  55E9B183: 00                    db_op_00   0x00
  55E9B184: 00                    db_op_00   0x00
  55E9B185: 00                    db_op_00   0x00
  55E9B186: 00                    db_op_00   0x00
  55E9B187: 00                    db_op_00   0x00
  55E9B188: 12                    db_op_12   0x12
  55E9B189: 00                    db_op_00   0x00
  55E9B18A: 00                    db_op_00   0x00
  55E9B18B: 00                    db_op_00   0x00
  55E9B18C: 00                    db_op_00   0x00
  55E9B18D: 00                    db_op_00   0x00
  55E9B18E: 00                    db_op_00   0x00
  55E9B18F: 00                    db_op_00   0x00
  55E9B190: 10                    db_op_10   0x10
  55E9B191: 00                    db_op_00   0x00
  55E9B192: 00                    db_op_00   0x00
  55E9B193: 00                    db_op_00   0x00
  55E9B194: 00                    db_op_00   0x00
  55E9B195: 00                    db_op_00   0x00
  55E9B196: 00                    db_op_00   0x00
  55E9B197: 00                    db_op_00   0x00
  55E9B198: 06                    db_op_06   0x06
  55E9B199: 00                    db_op_00   0x00
  55E9B19A: 00                    db_op_00   0x00
  55E9B19B: 00                    db_op_00   0x00
  55E9B19C: 00                    db_op_00   0x00
  55E9B19D: 00                    db_op_00   0x00
  55E9B19E: 00                    db_op_00   0x00
  55E9B19F: 00                    db_op_00   0x00
  55E9B1A0: 04                    db_op_04   0x04
  55E9B1A1: 00                    db_op_00   0x00
  55E9B1A2: 00                    db_op_00   0x00
  55E9B1A3: 00                    db_op_00   0x00
  55E9B1A4: 00                    db_op_00   0x00
  55E9B1A5: 00                    db_op_00   0x00
  55E9B1A6: 00                    db_op_00   0x00
  55E9B1A7: 00                    db_op_00   0x00
  55E9B1A8: 07                    db_op_07   0x07
  55E9B1A9: 00                    db_op_00   0x00
  55E9B1AA: 00                    db_op_00   0x00
  55E9B1AB: 00                    db_op_00   0x00
  55E9B1AC: 00                    db_op_00   0x00
  55E9B1AD: 00                    db_op_00   0x00
  55E9B1AE: 00                    db_op_00   0x00
  55E9B1AF: 00                    db_op_00   0x00
  55E9B1B0: 10                    db_op_10   0x10
  55E9B1B1: 00                    db_op_00   0x00
  55E9B1B2: 00                    db_op_00   0x00
  55E9B1B3: 00                    db_op_00   0x00
  55E9B1B4: 00                    db_op_00   0x00
  55E9B1B5: 00                    db_op_00   0x00
  55E9B1B6: 00                    db_op_00   0x00
  55E9B1B7: 00                    db_op_00   0x00
  55E9B1B8: 08                    db_op_08   0x08
  55E9B1B9: 00                    db_op_00   0x00
  55E9B1BA: 00                    db_op_00   0x00
  55E9B1BB: 00                    db_op_00   0x00
  55E9B1BC: 00                    db_op_00   0x00
  55E9B1BD: 00                    db_op_00   0x00
  55E9B1BE: 00                    db_op_00   0x00
  55E9B1BF: 00                    db_op_00   0x00
  55E9B1C0: 10                    db_op_10   0x10
  55E9B1C1: 00                    db_op_00   0x00
  55E9B1C2: 00                    db_op_00   0x00
  55E9B1C3: 00                    db_op_00   0x00
  55E9B1C4: 00                    db_op_00   0x00
  55E9B1C5: 00                    db_op_00   0x00
  55E9B1C6: 00                    db_op_00   0x00
  55E9B1C7: 00                    db_op_00   0x00
  55E9B1C8: 09                    db_op_09   0x09
  55E9B1C9: 00                    db_op_00   0x00
  55E9B1CA: 00                    db_op_00   0x00
  55E9B1CB: 00                    db_op_00   0x00
  55E9B1CC: 00                    db_op_00   0x00
  55E9B1CD: 00                    db_op_00   0x00
  55E9B1CE: 00                    db_op_00   0x00
  55E9B1CF: 00                    db_op_00   0x00
  55E9B1D0: 08                    db_op_08   0x08
  55E9B1D1: 00                    db_op_00   0x00
  55E9B1D2: 00                    db_op_00   0x00
  55E9B1D3: 00                    db_op_00   0x00
  55E9B1D4: 00                    db_op_00   0x00
  55E9B1D5: 00                    db_op_00   0x00
  55E9B1D6: 00                    db_op_00   0x00
  55E9B1D7: 00                    db_op_00   0x00
  55E9B1D8: 0A                    db_op_0A   0x0A
  55E9B1D9: 00                    db_op_00   0x00
  55E9B1DA: 00                    db_op_00   0x00
  55E9B1DB: 00                    db_op_00   0x00
  55E9B1DC: 00                    db_op_00   0x00
  55E9B1DD: 00                    db_op_00   0x00
  55E9B1DE: 00                    db_op_00   0x00
  55E9B1DF: 00                    db_op_00   0x00
  55E9B1E0: 08                    db_op_08   0x08
  55E9B1E1: 00                    db_op_00   0x00
  55E9B1E2: 00                    db_op_00   0x00
  55E9B1E3: 00                    db_op_00   0x00
  55E9B1E4: 00                    db_op_00   0x00
  55E9B1E5: 00                    db_op_00   0x00
  55E9B1E6: 00                    db_op_00   0x00
  55E9B1E7: 00                    db_op_00   0x00
  55E9B1E8: 0B                    db_op_0B   0x0B
  55E9B1E9: 00                    db_op_00   0x00
  55E9B1EA: 00                    db_op_00   0x00
  55E9B1EB: 00                    db_op_00   0x00
  55E9B1EC: 00                    db_op_00   0x00
  55E9B1ED: 00                    db_op_00   0x00
  55E9B1EE: 00                    db_op_00   0x00
  55E9B1EF: 00                    db_op_00   0x00
  55E9B1F0: 01                    db_op_01   0x01
  55E9B1F1: 00                    db_op_00   0x00
  55E9B1F2: 00                    db_op_00   0x00
  55E9B1F3: 00                    db_op_00   0x00
  55E9B1F4: 00                    db_op_00   0x00
  55E9B1F5: 00                    db_op_00   0x00
  55E9B1F6: 00                    db_op_00   0x00
  55E9B1F7: 00                    db_op_00   0x00
  55E9B1F8: 0C                    db_op_0C   0x0C
  55E9B1F9: 00                    db_op_00   0x00
  55E9B1FA: 00                    db_op_00   0x00
  55E9B1FB: 00                    db_op_00   0x00
  55E9B1FC: 00                    db_op_00   0x00
  55E9B1FD: 00                    db_op_00   0x00
  55E9B1FE: 00                    db_op_00   0x00
  55E9B1FF: 00                    db_op_00   0x00
  55E9B200: 01                    db_op_01   0x01
  55E9B201: 00                    db_op_00   0x00
  55E9B202: 00                    db_op_00   0x00
  55E9B203: 00                    db_op_00   0x00
  55E9B204: 00                    db_op_00   0x00
  55E9B205: 00                    db_op_00   0x00
  55E9B206: 00                    db_op_00   0x00
  55E9B207: 00                    db_op_00   0x00
  55E9B208: 11                    db_op_11   0x11
  55E9B209: 00                    db_op_00   0x00
  55E9B20A: 00                    db_op_00   0x00
  55E9B20B: 00                    db_op_00   0x00
  55E9B20C: 00                    db_op_00   0x00
  55E9B20D: 00                    db_op_00   0x00
  55E9B20E: 00                    db_op_00   0x00
  55E9B20F: 00                    db_op_00   0x00
  55E9B210: 12                    db_op_12   0x12
  55E9B211: 00                    db_op_00   0x00
  55E9B212: 00                    db_op_00   0x00
  55E9B213: 00                    db_op_00   0x00
  55E9B214: 00                    db_op_00   0x00
  55E9B215: 00                    db_op_00   0x00
  55E9B216: 00                    db_op_00   0x00
  55E9B217: 00                    db_op_00   0x00
  55E9B218: 15                    db_op_15   0x15
  55E9B219: 00                    db_op_00   0x00
  55E9B21A: 00                    db_op_00   0x00
  55E9B21B: 00                    db_op_00   0x00
  55E9B21C: 00                    db_op_00   0x00
  55E9B21D: 00                    db_op_00   0x00
  55E9B21E: 00                    db_op_00   0x00
  55E9B21F: 00                    db_op_00   0x00
  55E9B220: 08                    db_op_08   0x08
  55E9B221: 00                    db_op_00   0x00
  55E9B222: 00                    db_op_00   0x00
  55E9B223: 00                    db_op_00   0x00
  55E9B224: 00                    db_op_00   0x00
  55E9B225: 00                    db_op_00   0x00
  55E9B226: 00                    db_op_00   0x00
  55E9B227: 00                    db_op_00   0x00
  55E9B228: 17                    db_op_17   0x17
  55E9B229: 00                    db_op_00   0x00
  55E9B22A: 00                    db_op_00   0x00
  55E9B22B: 00                    db_op_00   0x00
  55E9B22C: 00                    db_op_00   0x00
  55E9B22D: 00                    db_op_00   0x00
  55E9B22E: 00                    db_op_00   0x00
  55E9B22F: 00                    db_op_00   0x00
  55E9B230: 01                    db_op_01   0x01
  55E9B231: 00                    db_op_00   0x00
  55E9B232: 00                    db_op_00   0x00
  55E9B233: 00                    db_op_00   0x00
  55E9B234: 00                    db_op_00   0x00
  55E9B235: 00                    db_op_00   0x00
  55E9B236: 00                    db_op_00   0x00
  55E9B237: 00                    db_op_00   0x00
  55E9B238: 19                    db_op_19   0x19
  55E9B239: 00                    db_op_00   0x00
  55E9B23A: 00                    db_op_00   0x00
  55E9B23B: 00                    db_op_00   0x00
  55E9B23C: 00                    db_op_00   0x00
  55E9B23D: 00                    db_op_00   0x00
  55E9B23E: 00                    db_op_00   0x00
  55E9B23F: 00                    db_op_00   0x00
  55E9B240: 04                    db_op_04   0x04
  55E9B241: 00                    db_op_00   0x00
  55E9B242: 00                    db_op_00   0x00
  55E9B243: 00                    db_op_00   0x00
  55E9B244: 00                    db_op_00   0x00
  55E9B245: 00                    db_op_00   0x00
  55E9B246: 00                    db_op_00   0x00
  55E9B247: 00                    db_op_00   0x00
  55E9B248: 00                    db_op_00   0x00
  55E9B249: 00                    db_op_00   0x00
  55E9B24A: 00                    db_op_00   0x00
  55E9B24B: 00                    db_op_00   0x00
  55E9B24C: 00                    db_op_00   0x00
  55E9B24D: 00                    db_op_00   0x00
  55E9B24E: 00                    db_op_00   0x00
  55E9B24F: 00                    db_op_00   0x00
  55E9B250: 00                    db_op_00   0x00
  55E9B251: 00                    db_op_00   0x00
  55E9B252: 00                    db_op_00   0x00
  55E9B253: 00                    db_op_00   0x00
  55E9B254: 00                    db_op_00   0x00
  55E9B255: 00                    db_op_00   0x00
  55E9B256: 00                    db_op_00   0x00
  55E9B257: 00                    db_op_00   0x00
  55E9B258: 00                    db_op_00   0x00
  55E9B259: 00                    db_op_00   0x00
  55E9B25A: 00                    db_op_00   0x00
  55E9B25B: 00                    db_op_00   0x00
  55E9B25C: 00                    db_op_00   0x00
  55E9B25D: 00                    db_op_00   0x00
  55E9B25E: 00                    db_op_00   0x00
  55E9B25F: 00                    db_op_00   0x00
  55E9B260: 00                    db_op_00   0x00
  55E9B261: 00                    db_op_00   0x00
  55E9B262: 00                    db_op_00   0x00
  55E9B263: 00                    db_op_00   0x00
  55E9B264: 00                    db_op_00   0x00
  55E9B265: 00                    db_op_00   0x00
  55E9B266: 00                    db_op_00   0x00
  55E9B267: 00                    db_op_00   0x00
  55E9B268: 00                    db_op_00   0x00
  55E9B269: 00                    db_op_00   0x00
  55E9B26A: 00                    db_op_00   0x00
  55E9B26B: 00                    db_op_00   0x00
  55E9B26C: 00                    db_op_00   0x00
  55E9B26D: 00                    db_op_00   0x00
  55E9B26E: 00                    db_op_00   0x00
  55E9B26F: 00                    db_op_00   0x00
  55E9B270: 00                    db_op_00   0x00
  55E9B271: 00                    db_op_00   0x00
  55E9B272: 00                    db_op_00   0x00
  55E9B273: 00                    db_op_00   0x00
  55E9B274: 00                    db_op_00   0x00
  55E9B275: 00                    db_op_00   0x00
  55E9B276: 00                    db_op_00   0x00
  55E9B277: 00                    db_op_00   0x00
  55E9B278: 00                    db_op_00   0x00
  55E9B279: 00                    db_op_00   0x00
  55E9B27A: 00                    db_op_00   0x00
  55E9B27B: 00                    db_op_00   0x00
  55E9B27C: 00                    db_op_00   0x00
  55E9B27D: 00                    db_op_00   0x00
  55E9B27E: 00                    db_op_00   0x00
  55E9B27F: 00                    db_op_00   0x00
  55E9B280: 00                    db_op_00   0x00
  55E9B281: 00                    db_op_00   0x00
  55E9B282: 00                    db_op_00   0x00
  55E9B283: 00                    db_op_00   0x00
  55E9B284: 00                    db_op_00   0x00
  55E9B285: 00                    db_op_00   0x00
  55E9B286: 00                    db_op_00   0x00
  55E9B287: 00                    db_op_00   0x00
  55E9B288: 00                    db_op_00   0x00
  55E9B289: 00                    db_op_00   0x00
  55E9B28A: 00                    db_op_00   0x00
  55E9B28B: 00                    db_op_00   0x00
  55E9B28C: 00                    db_op_00   0x00
  55E9B28D: 00                    db_op_00   0x00
  55E9B28E: 00                    db_op_00   0x00
  55E9B28F: 00                    db_op_00   0x00
  55E9B290: 01                    db_op_01   0x01
  55E9B291: 00                    db_op_00   0x00
  55E9B292: 00                    db_op_00   0x00
  55E9B293: 00                    db_op_00   0x00
  55E9B294: 00                    db_op_00   0x00
  55E9B295: 00                    db_op_00   0x00
  55E9B296: 00                    db_op_00   0x00
  55E9B297: 00                    db_op_00   0x00
  55E9B298: 64                    mov        (a0), d1
  55E9B299: 00                    db_op_00   0x00
  55E9B29A: 00                    db_op_00   0x00
  55E9B29B: 00                    db_op_00   0x00
  55E9B29C: 40 00                 mov        a0, (0, sp)
  55E9B29E: 00                    db_op_00   0x00
  55E9B29F: 00                    db_op_00   0x00
  55E9B2A0: 00                    db_op_00   0x00
  55E9B2A1: 00                    db_op_00   0x00
  55E9B2A2: 00                    db_op_00   0x00
  55E9B2A3: 00                    db_op_00   0x00
  55E9B2A4: 04                    db_op_04   0x04
  55E9B2A5: 00                    db_op_00   0x00
  55E9B2A6: 00                    db_op_00   0x00
  55E9B2A7: 00                    db_op_00   0x00
  55E9B2A8: 00                    db_op_00   0x00
  55E9B2A9: 00                    db_op_00   0x00
  55E9B2AA: 00                    db_op_00   0x00
  55E9B2AB: 00                    db_op_00   0x00
  55E9B2AC: 01                    db_op_01   0x01
  55E9B2AD: 00                    db_op_00   0x00
  55E9B2AE: 00                    db_op_00   0x00
  55E9B2AF: 00                    db_op_00   0x00
  55E9B2B0: 40 00                 mov        a0, (0, sp)
  55E9B2B2: 00                    db_op_00   0x00
  55E9B2B3: 00                    db_op_00   0x00
  55E9B2B4: 00                    db_op_00   0x00
  55E9B2B5: 00                    db_op_00   0x00
  55E9B2B6: 00                    db_op_00   0x00
  55E9B2B7: 00                    db_op_00   0x00
  55E9B2B8: 03                    db_op_03   0x03
  55E9B2B9: 00                    db_op_00   0x00
  55E9B2BA: 00                    db_op_00   0x00
  55E9B2BB: 00                    db_op_00   0x00
  55E9B2BC: 00                    db_op_00   0x00
  55E9B2BD: 00                    db_op_00   0x00
  55E9B2BE: 00                    db_op_00   0x00
  55E9B2BF: 00                    db_op_00   0x00
  55E9B2C0: 09                    db_op_09   0x09
  55E9B2C1: 00                    db_op_00   0x00
  55E9B2C2: 00                    db_op_00   0x00
  55E9B2C3: 00                    db_op_00   0x00
  55E9B2C4: 80 00                 mov        0x00, d0
  55E9B2C6: 00                    db_op_00   0x00
  55E9B2C7: 00                    db_op_00   0x00
  55E9B2C8: 00                    db_op_00   0x00
  55E9B2C9: 00                    db_op_00   0x00
  55E9B2CA: 00                    db_op_00   0x00
  55E9B2CB: 00                    db_op_00   0x00
  55E9B2CC: 00                    db_op_00   0x00
  55E9B2CD: 00                    db_op_00   0x00
  55E9B2CE: 00                    db_op_00   0x00
  55E9B2CF: 00                    db_op_00   0x00
  55E9B2D0: 00                    db_op_00   0x00
  55E9B2D1: 00                    db_op_00   0x00
  55E9B2D2: 00                    db_op_00   0x00
  55E9B2D3: 00                    db_op_00   0x00
  55E9B2D4: 00                    db_op_00   0x00
  55E9B2D5: 00                    db_op_00   0x00
  55E9B2D6: 00                    db_op_00   0x00
  55E9B2D7: 00                    db_op_00   0x00
  55E9B2D8: 00                    db_op_00   0x00
  55E9B2D9: 00                    db_op_00   0x00
  55E9B2DA: 00                    db_op_00   0x00
  55E9B2DB: 00                    db_op_00   0x00
  55E9B2DC: 00                    db_op_00   0x00
  55E9B2DD: 00                    db_op_00   0x00
  55E9B2DE: 00                    db_op_00   0x00
  55E9B2DF: 00                    db_op_00   0x00
  55E9B2E0: 00                    db_op_00   0x00
  55E9B2E1: 00                    db_op_00   0x00
  55E9B2E2: 00                    db_op_00   0x00
  55E9B2E3: 00                    db_op_00   0x00
  55E9B2E4: 00                    db_op_00   0x00
  55E9B2E5: 00                    db_op_00   0x00
  55E9B2E6: 00                    db_op_00   0x00
  55E9B2E7: 00                    db_op_00   0x00
  55E9B2E8: 00                    db_op_00   0x00
  55E9B2E9: 00                    db_op_00   0x00
  55E9B2EA: 00                    db_op_00   0x00
  55E9B2EB: 00                    db_op_00   0x00
  55E9B2EC: 00                    db_op_00   0x00
  55E9B2ED: 00                    db_op_00   0x00
  55E9B2EE: 00                    db_op_00   0x00
  55E9B2EF: 00                    db_op_00   0x00
  55E9B2F0: 00                    db_op_00   0x00
  55E9B2F1: 00                    db_op_00   0x00
  55E9B2F2: 00                    db_op_00   0x00
  55E9B2F3: 00                    db_op_00   0x00
  55E9B2F4: 00                    db_op_00   0x00
  55E9B2F5: 00                    db_op_00   0x00
  55E9B2F6: 00                    db_op_00   0x00
  55E9B2F7: 00                    db_op_00   0x00
  55E9B2F8: 00                    db_op_00   0x00
  55E9B2F9: 00                    db_op_00   0x00
  55E9B2FA: 00                    db_op_00   0x00
  55E9B2FB: 00                    db_op_00   0x00
  55E9B2FC: 00                    db_op_00   0x00
  55E9B2FD: 00                    db_op_00   0x00
  55E9B2FE: 00                    db_op_00   0x00
  55E9B2FF: 00                    db_op_00   0x00
  55E9B300: 00                    db_op_00   0x00
  55E9B301: 00                    db_op_00   0x00
  55E9B302: 00                    db_op_00   0x00
  55E9B303: 00                    db_op_00   0x00
  55E9B304: 00                    db_op_00   0x00
  55E9B305: 00                    db_op_00   0x00
  55E9B306: 00                    db_op_00   0x00
  55E9B307: 00                    db_op_00   0x00
  55E9B308: 00                    db_op_00   0x00
  55E9B309: 00                    db_op_00   0x00
  55E9B30A: 00                    db_op_00   0x00
  55E9B30B: 00                    db_op_00   0x00
  55E9B30C: 00                    db_op_00   0x00
  55E9B30D: 00                    db_op_00   0x00
  55E9B30E: 00                    db_op_00   0x00
  55E9B30F: 00                    db_op_00   0x00
  55E9B310: 00                    db_op_00   0x00
  55E9B311: 00                    db_op_00   0x00
  55E9B312: 00                    db_op_00   0x00
  55E9B313: 00                    db_op_00   0x00
  55E9B314: 00                    db_op_00   0x00
  55E9B315: 00                    db_op_00   0x00
  55E9B316: 00                    db_op_00   0x00
  55E9B317: 00                    db_op_00   0x00
  55E9B318: 00                    db_op_00   0x00
  55E9B319: 00                    db_op_00   0x00
  55E9B31A: 00                    db_op_00   0x00
  55E9B31B: 00                    db_op_00   0x00
  55E9B31C: 00                    db_op_00   0x00
  55E9B31D: 00                    db_op_00   0x00
  55E9B31E: 00                    db_op_00   0x00
  55E9B31F: 00                    db_op_00   0x00
  55E9B320: 02                    db_op_02   0x02
  55E9B321: 00                    db_op_00   0x00
  55E9B322: 00                    db_op_00   0x00
  55E9B323: 00                    db_op_00   0x00
  55E9B324: 00                    db_op_00   0x00
  55E9B325: 00                    db_op_00   0x00
  55E9B326: 00                    db_op_00   0x00
  55E9B327: 00                    db_op_00   0x00
  55E9B328: E4                    add        d1, d0
  55E9B329: B8                    db_op_B8   0xB8
  55E9B32A: C9 55                 bne        loc_55E9B37F
  55E9B32C: 03                    db_op_03   0x03
  55E9B32D: 00                    db_op_00   0x00
  55E9B32E: 00                    db_op_00   0x00
  55E9B32F: 00                    db_op_00   0x00
  55E9B330: 00                    db_op_00   0x00
  55E9B331: 00                    db_op_00   0x00
  55E9B332: 00                    db_op_00   0x00
  55E9B333: 00                    db_op_00   0x00
  55E9B334: E4                    add        d1, d0
  55E9B335: B8                    db_op_B8   0xB8
  55E9B336: C9 55                 bne        loc_55E9B38B
  55E9B338: 04                    db_op_04   0x04
  55E9B339: 00                    db_op_00   0x00
  55E9B33A: 00                    db_op_00   0x00
  55E9B33B: 00                    db_op_00   0x00
  55E9B33C: 00                    db_op_00   0x00
  55E9B33D: 00                    db_op_00   0x00
  55E9B33E: 00                    db_op_00   0x00
  55E9B33F: 00                    db_op_00   0x00
  55E9B340: E4                    add        d1, d0
  55E9B341: B8                    db_op_B8   0xB8
  55E9B342: C9 55                 bne        loc_55E9B397
  55E9B344: 05                    db_op_05   0x05
  55E9B345: 00                    db_op_00   0x00
  55E9B346: 00                    db_op_00   0x00
  55E9B347: 00                    db_op_00   0x00
  55E9B348: 00                    db_op_00   0x00
  55E9B349: 00                    db_op_00   0x00
  55E9B34A: 00                    db_op_00   0x00
  55E9B34B: 00                    db_op_00   0x00
  55E9B34C: E4                    add        d1, d0
  55E9B34D: B8                    db_op_B8   0xB8
  55E9B34E: C9 55                 bne        loc_55E9B3A3
  55E9B350: 06                    db_op_06   0x06
  55E9B351: 00                    db_op_00   0x00
  55E9B352: 00                    db_op_00   0x00
  55E9B353: 00                    db_op_00   0x00
  55E9B354: 00                    db_op_00   0x00
  55E9B355: 00                    db_op_00   0x00
  55E9B356: 00                    db_op_00   0x00
  55E9B357: 00                    db_op_00   0x00
  55E9B358: E4                    add        d1, d0
  55E9B359: B8                    db_op_B8   0xB8
  55E9B35A: C9 55                 bne        loc_55E9B3AF
  55E9B35C: 00                    db_op_00   0x00
  55E9B35D: 00                    db_op_00   0x00
  55E9B35E: 00                    db_op_00   0x00
  55E9B35F: 00                    db_op_00   0x00
  55E9B360: 00                    db_op_00   0x00
  55E9B361: 00                    db_op_00   0x00
  55E9B362: 00                    db_op_00   0x00
  55E9B363: 00                    db_op_00   0x00
  55E9B364: 00                    db_op_00   0x00
  55E9B365: 00                    db_op_00   0x00
  55E9B366: 00                    db_op_00   0x00
  55E9B367: 00                    db_op_00   0x00
  55E9B368: 00                    db_op_00   0x00
  55E9B369: 00                    db_op_00   0x00
  55E9B36A: 00                    db_op_00   0x00
  55E9B36B: 00                    db_op_00   0x00
  55E9B36C: 00                    db_op_00   0x00
  55E9B36D: 00                    db_op_00   0x00
  55E9B36E: 00                    db_op_00   0x00
  55E9B36F: 00                    db_op_00   0x00
  55E9B370: 00                    db_op_00   0x00
  55E9B371: 00                    db_op_00   0x00
  55E9B372: 00                    db_op_00   0x00
  55E9B373: 00                    db_op_00   0x00
  55E9B374: 00                    db_op_00   0x00
  55E9B375: 00                    db_op_00   0x00
  55E9B376: 00                    db_op_00   0x00
  55E9B377: 00                    db_op_00   0x00
  55E9B378: 00                    db_op_00   0x00
  55E9B379: 00                    db_op_00   0x00
  55E9B37A: 00                    db_op_00   0x00
  55E9B37B: 00                    db_op_00   0x00
  55E9B37C: 00                    db_op_00   0x00
  55E9B37D: 00                    db_op_00   0x00
  55E9B37E: 00                    db_op_00   0x00
loc_55E9B37F:
  55E9B37F: 00                    db_op_00   0x00
  55E9B380: 00                    db_op_00   0x00
  55E9B381: 00                    db_op_00   0x00
  55E9B382: 00                    db_op_00   0x00
  55E9B383: 00                    db_op_00   0x00
  55E9B384: 00                    db_op_00   0x00
  55E9B385: 00                    db_op_00   0x00
  55E9B386: 00                    db_op_00   0x00
  55E9B387: 00                    db_op_00   0x00
  55E9B388: 00                    db_op_00   0x00
  55E9B389: 00                    db_op_00   0x00
  55E9B38A: 00                    db_op_00   0x00
loc_55E9B38B:
  55E9B38B: 00                    db_op_00   0x00
  55E9B38C: 00                    db_op_00   0x00
  55E9B38D: 00                    db_op_00   0x00
  55E9B38E: 00                    db_op_00   0x00
  55E9B38F: 00                    db_op_00   0x00
  55E9B390: 00                    db_op_00   0x00
  55E9B391: 00                    db_op_00   0x00
  55E9B392: 00                    db_op_00   0x00
  55E9B393: 00                    db_op_00   0x00
  55E9B394: 00                    db_op_00   0x00
  55E9B395: 00                    db_op_00   0x00
  55E9B396: 00                    db_op_00   0x00
loc_55E9B397:
  55E9B397: 00                    db_op_00   0x00
  55E9B398: 00                    db_op_00   0x00
  55E9B399: 00                    db_op_00   0x00
  55E9B39A: 00                    db_op_00   0x00
  55E9B39B: 00                    db_op_00   0x00
  55E9B39C: 00                    db_op_00   0x00
  55E9B39D: 00                    db_op_00   0x00
  55E9B39E: 00                    db_op_00   0x00
  55E9B39F: 00                    db_op_00   0x00
  55E9B3A0: 00                    db_op_00   0x00
  55E9B3A1: 00                    db_op_00   0x00
  55E9B3A2: 00                    db_op_00   0x00
loc_55E9B3A3:
  55E9B3A3: 00                    db_op_00   0x00
  55E9B3A4: 20 00                 add        0, d0
  55E9B3A6: 40 00                 mov        a0, (0, sp)
  55E9B3A8: 10                    db_op_10   0x10
  55E9B3A9: 00                    db_op_00   0x00
  55E9B3AA: 20 00                 add        0, d0
  55E9B3AC: 10                    db_op_10   0x10
  55E9B3AD: 00                    db_op_00   0x00
  55E9B3AE: 20 00                 add        0, d0
  55E9B3B0: 20 00                 add        0, d0
  55E9B3B2: 40 00                 mov        a0, (0, sp)
  55E9B3B4: 00                    db_op_00   0x00
  55E9B3B5: 00                    db_op_00   0x00
  55E9B3B6: 00                    db_op_00   0x00
  55E9B3B7: 00                    db_op_00   0x00
  55E9B3B8: 00                    db_op_00   0x00
  55E9B3B9: 00                    db_op_00   0x00
  55E9B3BA: 00                    db_op_00   0x00
  55E9B3BB: 00                    db_op_00   0x00
  55E9B3BC: 00                    db_op_00   0x00
  55E9B3BD: 00                    db_op_00   0x00
  55E9B3BE: 00                    db_op_00   0x00
  55E9B3BF: 00                    db_op_00   0x00
  55E9B3C0: 08                    db_op_08   0x08
  55E9B3C1: 00                    db_op_00   0x00
  55E9B3C2: 10                    db_op_10   0x10
  55E9B3C3: 00                    db_op_00   0x00
  55E9B3C4: 08                    db_op_08   0x08
  55E9B3C5: 00                    db_op_00   0x00
  55E9B3C6: 10                    db_op_10   0x10
  55E9B3C7: 00                    db_op_00   0x00
  55E9B3C8: 01                    db_op_01   0x01
  55E9B3C9: 00                    db_op_00   0x00
  55E9B3CA: 01                    db_op_01   0x01
  55E9B3CB: 00                    db_op_00   0x00
  55E9B3CC: 08                    db_op_08   0x08
  55E9B3CD: 00                    db_op_00   0x00
  55E9B3CE: 10                    db_op_10   0x10
  55E9B3CF: 00                    db_op_00   0x00
  55E9B3D0: 08                    db_op_08   0x08
  55E9B3D1: 00                    db_op_00   0x00
  55E9B3D2: 10                    db_op_10   0x10
  55E9B3D3: 00                    db_op_00   0x00
  55E9B3D4: 08                    db_op_08   0x08
  55E9B3D5: 00                    db_op_00   0x00
  55E9B3D6: 10                    db_op_10   0x10
  55E9B3D7: 00                    db_op_00   0x00
  55E9B3D8: 00                    db_op_00   0x00
  55E9B3D9: 00                    db_op_00   0x00
  55E9B3DA: 00                    db_op_00   0x00
  55E9B3DB: 00                    db_op_00   0x00
  55E9B3DC: 80 00                 mov        0x00, d0
  55E9B3DE: 80 00                 mov        0x00, d0
  55E9B3E0: 0B                    db_op_0B   0x0B
  55E9B3E1: 00                    db_op_00   0x00
  55E9B3E2: 02                    db_op_02   0x02
  55E9B3E3: 00                    db_op_00   0x00
  55E9B3E4: 01                    db_op_01   0x01
  55E9B3E5: 54                    db_op_54   0x54
  55E9B3E6: 10                    db_op_10   0x10
  55E9B3E7: 15                    db_op_15   0x15
  55E9B3E8: 21 31                 add        49, d1
  55E9B3EA: 32                    db_op_32   0x32
  55E9B3EB: 00                    db_op_00   0x00
  55E9B3EC: 00                    db_op_00   0x00
  55E9B3ED: 00                    db_op_00   0x00
  55E9B3EE: 00                    db_op_00   0x00
  55E9B3EF: 00                    db_op_00   0x00
  55E9B3F0: 21 00                 add        0, d1
  55E9B3F2: 00                    db_op_00   0x00
  55E9B3F3: 00                    db_op_00   0x00
  55E9B3F4: 1A                    db_op_1A   0x1A
  55E9B3F5: 00                    db_op_00   0x00
  55E9B3F6: 09                    db_op_09   0x09
  55E9B3F7: 00                    db_op_00   0x00
  55E9B3F8: 16                    db_op_16   0x16
  55E9B3F9: 00                    db_op_00   0x00
  55E9B3FA: 05                    db_op_05   0x05
  55E9B3FB: 00                    db_op_00   0x00
  55E9B3FC: 21 00                 add        0, d1
  55E9B3FE: 00                    db_op_00   0x00
  55E9B3FF: 00                    db_op_00   0x00
  55E9B400: 01                    db_op_01   0x01
  55E9B401: 00                    db_op_00   0x00
  55E9B402: 00                    db_op_00   0x00
  55E9B403: 00                    db_op_00   0x00
  55E9B404: 01                    db_op_01   0x01
  55E9B405: 00                    db_op_00   0x00
  55E9B406: 00                    db_op_00   0x00
  55E9B407: 00                    db_op_00   0x00
  55E9B408: 01                    db_op_01   0x01
  55E9B409: 00                    db_op_00   0x00
  55E9B40A: 00                    db_op_00   0x00
  55E9B40B: 00                    db_op_00   0x00
  55E9B40C: 09                    db_op_09   0x09
  55E9B40D: 00                    db_op_00   0x00
  55E9B40E: 00                    db_op_00   0x00
  55E9B40F: 00                    db_op_00   0x00
  55E9B410: 09                    db_op_09   0x09
  55E9B411: 00                    db_op_00   0x00
  55E9B412: 00                    db_op_00   0x00
  55E9B413: 00                    db_op_00   0x00
  55E9B414: 02                    db_op_02   0x02
  55E9B415: 00                    db_op_00   0x00
  55E9B416: 00                    db_op_00   0x00
  55E9B417: 00                    db_op_00   0x00
  55E9B418: 09                    db_op_09   0x09
  55E9B419: 00                    db_op_00   0x00
  55E9B41A: 00                    db_op_00   0x00
  55E9B41B: 00                    db_op_00   0x00
  55E9B41C: 09                    db_op_09   0x09
  55E9B41D: 00                    db_op_00   0x00
  55E9B41E: 00                    db_op_00   0x00
  55E9B41F: 00                    db_op_00   0x00
  55E9B420: 09                    db_op_09   0x09
  55E9B421: 00                    db_op_00   0x00
  55E9B422: 00                    db_op_00   0x00
  55E9B423: 00                    db_op_00   0x00
  55E9B424: 01                    db_op_01   0x01
  55E9B425: 00                    db_op_00   0x00
  55E9B426: 00                    db_op_00   0x00
  55E9B427: 00                    db_op_00   0x00
