; ==============================================================================
; Section: 00 - Bootloader & Flash Updater (0x55C7C000..0x55C7D305)
; ROM Offset: 0x000000 .. 0x001305
; Virtual Address: 0x55C7C000 .. 0x55C7D305
; Architecture: Matsushita MN10300 / MN103S (AM33) 32-bit RISC
; ==============================================================================


; ------------------------------------------------------------------------------
; FUNCTION: boot_reset_entry (VA 0x55C7C000)
; ------------------------------------------------------------------------------
boot_reset_entry:
  55C7C000: FC DC 00 00 08 54     mov        0x54080000, a0
  55C7C006: F2 F0                 ext_f2_F0  
  55C7C008: 2C 00 04              mov        0x0400, d0
  55C7C00B: 03                    db_op_03   0x03
  55C7C00C: 20 84                 add        -124, d0
  55C7C00E: 2C 00 04              mov        0x0400, d0
  55C7C011: 03                    db_op_03   0x03
  55C7C012: 22 84                 add        -124, d2
  55C7C014: 80 22                 mov        0x22, d0
  55C7C016: 03                    db_op_03   0x03
  55C7C017: 2A 84                 cmp        0x84, d2
  55C7C019: 80 22                 mov        0x22, d0
  55C7C01B: 03                    db_op_03   0x03
  55C7C01C: 2C 84 80              mov        0x8084, d0
  55C7C01F: 02                    db_op_02   0x02
  55C7C020: 03                    db_op_03   0x03
  55C7C021: 2E 84 FC              mov        0xFC84, d2
  55C7C024: CC 00 80              jmp        0x55C74024
  55C7C027: 00                    db_op_00   0x00
  55C7C028: 00                    db_op_00   0x00
  55C7C029: FC 83 64 C0 00 9C     mov        d3, (0x9C00C064)               ; MMIO VENUS_INTC_0x064
  55C7C02F: FC CC 39 8B 00 00     mov        0x00008B39, d0
  55C7C035: FC 83 16 C0 00 9C     mov        d3, (0x9C00C016)               ; MMIO VENUS_INTC_0x016
  55C7C03B: 00                    db_op_00   0x00
  55C7C03C: FC 83 4E 00 00 9C     mov        d3, (0x9C00004E)               ; MMIO VENUS_SYSCLK_PLL_0x04E
  55C7C042: FC 83 50 00 00 9C     mov        d3, (0x9C000050)               ; MMIO VENUS_SYSCLK_PLL_0x050
  55C7C048: FC 83 52 00 00 9C     mov        d3, (0x9C000052)               ; MMIO VENUS_SYSCLK_PLL_0x052
  55C7C04E: FC 83 54 00 00 9C     mov        d3, (0x9C000054)               ; MMIO VENUS_SYSCLK_PLL_0x054
  55C7C054: 80 00                 mov        0x00, d0
  55C7C056: FC 83 44 00 00 9C     mov        d3, (0x9C000044)               ; MMIO VENUS_SYSCLK_PLL_0x044
  55C7C05C: 2D 30 75              mov        0x7530, d1
  55C7C05F: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C060: 29 FF                 cmp        0xFF, d1
  55C7C062: CB                    nop        
  55C7C063: C8 0D                 beq        loc_55C7C070
  55C7C065: FC AC 44 00 00 9C     movhu      (0x9C000044), d0               ; MMIO VENUS_SYSCLK_PLL_0x044
  55C7C06B: FA E0 00 80           ext_fa_E0  0x8000
  55C7C06F: D9                    lbne       
loc_55C7C070:
  55C7C070: 2C 51 22              mov        0x2251, d0
  55C7C073: FC 83 00 F4 00 9C     mov        d3, (0x9C00F400)
  55C7C079: 80 33                 mov        0x33, d0
  55C7C07B: FC 83 02 F4 00 9C     mov        d3, (0x9C00F402)
  55C7C081: 80 20                 mov        0x20, d0
  55C7C083: FC 83 04 F4 00 9C     mov        d3, (0x9C00F404)
  55C7C089: 2C 22 33              mov        0x3322, d0
  55C7C08C: FC 83 14 F4 00 9C     mov        d3, (0x9C00F414)
  55C7C092: 2C 01 11              mov        0x1101, d0
  55C7C095: FC 83 16 F4 00 9C     mov        d3, (0x9C00F416)
  55C7C09B: 2C 0B 22              mov        0x220B, d0
  55C7C09E: FC 83 18 F4 00 9C     mov        d3, (0x9C00F418)
  55C7C0A4: 2C 20 04              mov        0x0420, d0
  55C7C0A7: 85                    mov        d1, d1
  55C7C0A8: 03                    db_op_03   0x03
  55C7C0A9: FC 83 1A F4 00 9C     mov        d3, (0x9C00F41A)
  55C7C0AF: FC 87 1C F4 00 9C     movb       d3, (0x9C00F41C)
  55C7C0B5: 80 0A                 mov        0x0A, d0
  55C7C0B7: FC 83 24 F4 00 9C     mov        d3, (0x9C00F424)
  55C7C0BD: 80 00                 mov        0x00, d0
  55C7C0BF: FC 83 32 F4 00 9C     mov        d3, (0x9C00F432)
  55C7C0C5: 80 07                 mov        0x07, d0
  55C7C0C7: FC 83 34 F4 00 9C     mov        d3, (0x9C00F434)
  55C7C0CD: 2C F0 00              mov        0x00F0, d0
  55C7C0D0: FC 83 3A F4 00 9C     mov        d3, (0x9C00F43A)
  55C7C0D6: 80 01                 mov        0x01, d0
  55C7C0D8: FC 83 0A F4 00 9C     mov        d3, (0x9C00F40A)
  55C7C0DE: 2D 30 75              mov        0x7530, d1
  55C7C0E1: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C0E2: 29 FF                 cmp        0xFF, d1
  55C7C0E4: CB                    nop        
  55C7C0E5: C8 0C                 beq        loc_55C7C0F1
  55C7C0E7: FC AC 0C F4 00 9C     movhu      (0x9C00F40C), d0
  55C7C0ED: F8 E0 01              ext_f8_E0  0x01
  55C7C0F0: D9                    lbne       
loc_55C7C0F1:
  55C7C0F1: 80 00                 mov        0x00, d0
  55C7C0F3: FC 83 F0 10 01 9C     mov        d3, (0x9C0110F0)
  55C7C0F9: 80 01                 mov        0x01, d0
  55C7C0FB: FC 83 F2 10 01 9C     mov        d3, (0x9C0110F2)
  55C7C101: FC 83 F4 10 01 9C     mov        d3, (0x9C0110F4)
  55C7C107: 80 01                 mov        0x01, d0
  55C7C109: FC 83 F8 10 01 9C     mov        d3, (0x9C0110F8)
  55C7C10F: FC 83 FA 10 01 9C     mov        d3, (0x9C0110FA)
  55C7C115: 80 10                 mov        0x10, d0
  55C7C117: FC 83 12 10 01 9C     mov        d3, (0x9C011012)
  55C7C11D: 80 01                 mov        0x01, d0
  55C7C11F: FC 83 02 00 01 9C     mov        d3, (0x9C010002)
  55C7C125: FC 83 06 00 01 9C     mov        d3, (0x9C010006)
  55C7C12B: FC 83 0C 00 01 9C     mov        d3, (0x9C01000C)
  55C7C131: FC 83 12 00 01 9C     mov        d3, (0x9C010012)
  55C7C137: 2C 87 13              mov        0x1387, d0
  55C7C13A: FC 83 4A F2 00 9C     mov        d3, (0x9C00F24A)
  55C7C140: FC CC C9 B5 00 00     mov        0x0000B5C9, d0
  55C7C146: FC 83 4A F2 00 9C     mov        d3, (0x9C00F24A)
  55C7C14C: FC CC 14 81 00 00     mov        0x00008114, d0
  55C7C152: FC 83 42 F2 00 9C     mov        d3, (0x9C00F242)
  55C7C158: 2C 38 12              mov        0x1238, d0
  55C7C15B: FC 83 46 F2 00 9C     mov        d3, (0x9C00F246)
  55C7C161: 2C 91 19              mov        0x1991, d0
  55C7C164: FC 83 40 F2 00 9C     mov        d3, (0x9C00F240)
  55C7C16A: 80 30                 mov        0x30, d0
  55C7C16C: 03                    db_op_03   0x03
  55C7C16D: 70                    mov        d0, (a0)
  55C7C16E: 80 CB                 mov        0xCB, d0
  55C7C170: CB                    nop        
  55C7C171: 80 03                 mov        0x03, d0
  55C7C173: 03                    db_op_03   0x03
  55C7C174: 70                    mov        d0, (a0)
  55C7C175: 80 FC                 mov        0xFC, d0
  55C7C177: DD 1C 07 00 40 FC DC  call       0x95C7C893, [d2,d3,a2,a3,other,exreg0], 220
  55C7C17E: 1C                    db_op_1C   0x1C
  55C7C17F: 07                    db_op_07   0x07
  55C7C180: 00                    db_op_00   0x00
  55C7C181: 40 FC                 mov        a0, (252, sp)
  55C7C183: FF                    db_op_FF   0xFF
  55C7C184: 3E 00                 mov        d2, (0, sp)
  55C7C186: 00                    db_op_00   0x00
  55C7C187: 00                    db_op_00   0x00
  55C7C188: FC DD E4 01 00 40     mov        0x400001E4, a1                 ; On-Chip Fast RAM
  55C7C18E: FC DC E4 01 00 40     mov        0x400001E4, a0                 ; On-Chip Fast RAM
  55C7C194: FC DE 1C 07 00 40     mov        0x4000071C, a2                 ; On-Chip Fast RAM
  55C7C19A: FC FF 37 00 00 00     calls      sub_55C7C1D1
  55C7C1A0: FC DC 00 FF 07 54     mov        0x5407FF00, a0
  55C7C1A6: 00                    db_op_00   0x00
  55C7C1A7: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C1A8: 60                    mov        (a0), d0
  55C7C1A9: 50                    db_op_50   0x50
  55C7C1AA: FC D8 00 00 08 54     ext_fc_D8  0x54080000
  55C7C1B0: D4                    lbcs       
  55C7C1B1: 00                    db_op_00   0x00
  55C7C1B2: F1 E0                 ext_f1_E0  
  55C7C1B4: F1 E1                 ext_f1_E1  
  55C7C1B6: F1 E2                 ext_f1_E2  
  55C7C1B8: F1 E3                 ext_f1_E3  
  55C7C1BA: 81 82                 mov        0x82, d1
  55C7C1BC: 83 CC                 mov        0xCC, d3
  55C7C1BE: E9                    add        d2, d1
  55C7C1BF: 00                    db_op_00   0x00
  55C7C1C0: F1 D0                 ext_f1_D0  
  55C7C1C2: F1 14                 ext_f1_14  
  55C7C1C4: C8 0B                 beq        loc_55C7C1CF
  55C7C1C6: 85                    mov        d1, d1
  55C7C1C7: 04                    db_op_04   0x04
  55C7C1C8: 08                    db_op_08   0x08
loc_55C7C1C9:
  55C7C1C9: 69                    mov        (a1), d2
  55C7C1CA: 51                    db_op_51   0x51
  55C7C1CB: F1 04                 ext_f1_04  
  55C7C1CD: C1 FC                 bgt        loc_55C7C1C9
loc_55C7C1CF:
  55C7C1CF: F0 FC                 rets       

; --- Function sub_55C7C1D1 (callers: 1) ---
sub_55C7C1D1:
  55C7C1D1: F1 D0                 ext_f1_D0  
  55C7C1D3: F1 14                 ext_f1_14  
  55C7C1D5: C8 0C                 beq        loc_55C7C1E1
  55C7C1D7: 85                    mov        d1, d1
  55C7C1D8: 04                    db_op_04   0x04
loc_55C7C1D9:
  55C7C1D9: 79                    mov        d2, (a1)
  55C7C1DA: 51                    db_op_51   0x51
  55C7C1DB: 6A                    mov        (a2), d2
  55C7C1DC: 52                    db_op_52   0x52
  55C7C1DD: F1 04                 ext_f1_04  
  55C7C1DF: C1 FA                 bgt        loc_55C7C1D9
loc_55C7C1E1:
  55C7C1E1: F0 FC                 rets       
  55C7C1E3: FF                    db_op_FF   0xFF

; --- Function sub_55C7C1E4 (callers: 1) ---
sub_55C7C1E4:
  55C7C1E4: 00                    db_op_00   0x00
  55C7C1E5: 08                    db_op_08   0x08
  55C7C1E6: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C1E7: FC AD 1C 21 01 9C     movhu      (0x9C01211C), d1               ; MMIO VENUS_FLASH_DMA_0x1C
  55C7C1ED: 1C                    db_op_1C   0x1C
  55C7C1EE: E0                    add        d0, d0
  55C7C1EF: F4 D0                 ext_f4_D0  
  55C7C1F1: 48                    db_op_48   0x48
  55C7C1F2: 88                    mov        d2, d0
  55C7C1F3: FC AE 1C 21 01 9C     movhu      (0x9C01211C), d2               ; MMIO VENUS_FLASH_DMA_0x1C
  55C7C1F9: 81 1D                 mov        0x1D, d1
  55C7C1FB: E5                    add        d1, d1
  55C7C1FC: F4 E4                 ext_f4_E4  
  55C7C1FE: 40 FC                 mov        a0, (252, sp)
  55C7C200: AE                    db_op_AE   0xAE
  55C7C201: 1C                    db_op_1C   0x1C
  55C7C202: 21 01                 add        1, d1
  55C7C204: 9C                    mov        a3, a0
  55C7C205: 81 1D                 mov        0x1D, d1
  55C7C207: E5                    add        d1, d1
  55C7C208: F4 E4                 ext_f4_E4  
  55C7C20A: 40 FC                 mov        a0, (252, sp)
  55C7C20C: AE                    db_op_AE   0xAE
  55C7C20D: 1C                    db_op_1C   0x1C
  55C7C20E: 21 01                 add        1, d1
  55C7C210: 9C                    mov        a3, a0
  55C7C211: 81 1D                 mov        0x1D, d1
  55C7C213: E5                    add        d1, d1
  55C7C214: F4 E4                 ext_f4_E4  
  55C7C216: 40 FC                 mov        a0, (252, sp)
  55C7C218: AE                    db_op_AE   0xAE
  55C7C219: 1C                    db_op_1C   0x1C
  55C7C21A: 21 01                 add        1, d1
  55C7C21C: 9C                    mov        a3, a0
  55C7C21D: 81 1D                 mov        0x1D, d1
  55C7C21F: E5                    add        d1, d1
  55C7C220: F4 E4                 ext_f4_E4  
  55C7C222: 40 FC                 mov        a0, (252, sp)
  55C7C224: AE                    db_op_AE   0xAE
  55C7C225: 1C                    db_op_1C   0x1C
  55C7C226: 21 01                 add        1, d1
  55C7C228: 9C                    mov        a3, a0
  55C7C229: 81 1D                 mov        0x1D, d1
  55C7C22B: E5                    add        d1, d1
  55C7C22C: F4 E4                 ext_f4_E4  
  55C7C22E: 40 FC                 mov        a0, (252, sp)
  55C7C230: AE                    db_op_AE   0xAE
  55C7C231: 1C                    db_op_1C   0x1C
  55C7C232: 21 01                 add        1, d1
  55C7C234: 9C                    mov        a3, a0
  55C7C235: 81 1D                 mov        0x1D, d1
  55C7C237: E5                    add        d1, d1
  55C7C238: F4 E4                 ext_f4_E4  
  55C7C23A: 40 FC                 mov        a0, (252, sp)
  55C7C23C: AE                    db_op_AE   0xAE
  55C7C23D: 1C                    db_op_1C   0x1C
  55C7C23E: 21 01                 add        1, d1
  55C7C240: 9C                    mov        a3, a0
  55C7C241: 81 1D                 mov        0x1D, d1
  55C7C243: E5                    add        d1, d1
  55C7C244: F4 E4                 ext_f4_E4  
  55C7C246: 40 82                 mov        a0, (130, sp)
  55C7C248: 1E                    db_op_1E   0x1E
  55C7C249: FA CA 00 01           bxx16      loc_55C7C349
  55C7C24D: D0                    lblt       
  55C7C24E: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C254: 2D 00 04              mov        0x0400, d1
  55C7C257: F2 04                 ext_f2_04  
  55C7C259: C8 0C                 beq        loc_55C7C265
  55C7C25B: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C25C: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C262: F2 04                 ext_f2_04  
  55C7C264: D9                    lbne       
loc_55C7C265:
  55C7C265: FC AC 22 21 01 9C     movhu      (0x9C012122), d0               ; MMIO VENUS_FLASH_DMA_0x22
  55C7C26B: A0                    db_op_A0   0xA0
  55C7C26C: 00                    db_op_00   0x00
  55C7C26D: C8 35                 beq        loc_55C7C2A2
  55C7C26F: FC AC 22 21 01 9C     movhu      (0x9C012122), d0               ; MMIO VENUS_FLASH_DMA_0x22
  55C7C275: F8 EC 02              ext_f8_EC  0x02
  55C7C278: C8 07                 beq        loc_55C7C27F
  55C7C27A: 2C FF 00              mov        0x00FF, d0
  55C7C27D: CA 26                 bra        loc_55C7C2A3
loc_55C7C27F:
  55C7C27F: FC AC 22 21 01 9C     movhu      (0x9C012122), d0               ; MMIO VENUS_FLASH_DMA_0x22
  55C7C285: F8 EC 04              ext_f8_EC  0x04
  55C7C288: C8 1A                 beq        loc_55C7C2A2
  55C7C28A: FC AC 2C 21 01 9C     movhu      (0x9C01212C), d0               ; MMIO VENUS_FLASH_DMA_0x2C
  55C7C290: FC AE 28 21 01 9C     movhu      (0x9C012128), d2               ; MMIO VENUS_FLASH_DMA_0x28
  55C7C296: 81 E1                 mov        0xE1, d1
  55C7C298: 1D                    db_op_1D   0x1D
  55C7C299: F1 64                 ext_f1_64  
  55C7C29B: F0 64                 ext_f0_64  
  55C7C29D: 88                    mov        d2, d0
  55C7C29E: F2 24                 ext_f2_24  
  55C7C2A0: F0 70                 ext_f0_70  
loc_55C7C2A2:
  55C7C2A2: 00                    db_op_00   0x00
loc_55C7C2A3:
  55C7C2A3: DE 80 04              retf       [d2], 4

; --- Function sub_55C7C2A6 (callers: 0) ---
sub_55C7C2A6:
  55C7C2A6: CF F0                 movm       [d2,d3,a2,a3], (sp)
  55C7C2A8: F8 FE FC              add        -4, sp
  55C7C2AB: 2C A3 00              mov        0x00A3, d0
  55C7C2AE: FC 83 00 21 01 9C     mov        d3, (0x9C012100)               ; MMIO VENUS_FLASH_DMA_0x00
  55C7C2B4: 80 08                 mov        0x08, d0
  55C7C2B6: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C2BC: FC AC 06 21 01 9C     movhu      (0x9C012106), d0               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C2C2: F8 C8 08              ext_f8_C8  0x08
  55C7C2C5: 14                    db_op_14   0x14
  55C7C2C6: F8 EC 01              ext_f8_EC  0x01
  55C7C2C9: C8 04                 beq        loc_55C7C2CD
  55C7C2CB: CA 11                 bra        loc_55C7C2DC
loc_55C7C2CD:
  55C7C2CD: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C2CE: FC AC 06 21 01 9C     movhu      (0x9C012106), d0               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C2D4: F8 C8 08              ext_f8_C8  0x08
  55C7C2D7: 14                    db_op_14   0x14
  55C7C2D8: F8 EC 01              ext_f8_EC  0x01
  55C7C2DB: D8                    lbeq       
loc_55C7C2DC:
  55C7C2DC: 80 01                 mov        0x01, d0
  55C7C2DE: FC 83 04 21 01 9C     mov        d3, (0x9C012104)               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C2E4: 2C FF 00              mov        0x00FF, d0
  55C7C2E7: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7C2ED: 00                    db_op_00   0x00
  55C7C2EE: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C2F4: 2C 00 01              mov        0x0100, d0
  55C7C2F7: FC 83 04 21 01 9C     mov        d3, (0x9C012104)               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C2FD: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C303: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C307: C9 04                 bne        loc_55C7C30B
  55C7C309: CA 0E                 bra        loc_55C7C317
loc_55C7C30B:
  55C7C30B: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C30C: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C312: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C316: D9                    lbne       
loc_55C7C317:
  55C7C317: 2C 02 01              mov        0x0102, d0
  55C7C31A: FC 83 04 21 01 9C     mov        d3, (0x9C012104)               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C320: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C326: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C32A: C9 04                 bne        loc_55C7C32E
  55C7C32C: CA 0E                 bra        loc_55C7C33A
loc_55C7C32E:
  55C7C32E: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C32F: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C335: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C339: D9                    lbne       
loc_55C7C33A:
  55C7C33A: 00                    db_op_00   0x00
  55C7C33B: FC 83 12 21 01 9C     mov        d3, (0x9C012112)               ; MMIO VENUS_FLASH_DMA_0x12
  55C7C341: FC 83 16 21 01 9C     mov        d3, (0x9C012116)               ; MMIO VENUS_FLASH_DMA_0x16
  55C7C347: 83 2C                 mov        0x2C, d3
loc_55C7C349:
  55C7C349: 00                    db_op_00   0x00
  55C7C34A: 02                    db_op_02   0x02
  55C7C34B: FC 83 02 21 01 9C     mov        d3, (0x9C012102)               ; MMIO VENUS_FLASH_DMA_0x02
  55C7C351: 00                    db_op_00   0x00
  55C7C352: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7C358: FC DE 00 00 20 98     mov        0x98200000, a2                 ; Uncached DMA/Framebuffer SDRAM
  55C7C35E: 8A                    mov        d2, d2
  55C7C35F: 04                    db_op_04   0x04
  55C7C360: 1F                    db_op_1F   0x1F
  55C7C361: F1 EF                 ext_f1_EF  
loc_55C7C363:
  55C7C363: F1 DC                 ext_f1_DC  
  55C7C365: F2 18                 ext_f2_18  
  55C7C367: FC 83 14 21 01 9C     mov        d3, (0x9C012114)               ; MMIO VENUS_FLASH_DMA_0x14
  55C7C36D: 00                    db_op_00   0x00
  55C7C36E: FC 83 20 21 01 9C     mov        d3, (0x9C012120)               ; MMIO VENUS_FLASH_DMA_0x20
  55C7C374: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C37A: 2C 00 01              mov        0x0100, d0
  55C7C37D: FC 83 04 21 01 9C     mov        d3, (0x9C012104)               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C383: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C389: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C38D: C9 04                 bne        loc_55C7C391
  55C7C38F: CA 0E                 bra        loc_55C7C39D
loc_55C7C391:
  55C7C391: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C392: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C398: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C39C: D9                    lbne       
loc_55C7C39D:
  55C7C39D: 2C 76 07              mov        0x0776, d0
  55C7C3A0: FC 83 04 21 01 9C     mov        d3, (0x9C012104)               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C3A6: 98                    mov        a2, a0
  55C7C3A7: CD 3D FE 80 04        call       sub_55C7C1E4, [d2], 4
  55C7C3AC: 14                    db_op_14   0x14
  55C7C3AD: A0                    db_op_A0   0xA0
  55C7C3AE: 00                    db_op_00   0x00
  55C7C3AF: C8 04                 beq        loc_55C7C3B3
  55C7C3B1: CA 23                 bra        loc_55C7C3D4
loc_55C7C3B3:
  55C7C3B3: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C3B9: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C3BD: C9 04                 bne        loc_55C7C3C1
  55C7C3BF: CA 0E                 bra        loc_55C7C3CD
loc_55C7C3C1:
  55C7C3C1: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C3C2: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C3C8: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C3CC: D9                    lbne       
loc_55C7C3CD:
  55C7C3CD: FA D2 00 02           ext_fa_D2  0x0200
  55C7C3D1: CC 1A 01              jmp        loc_55C7C4EB
loc_55C7C3D4:
  55C7C3D4: 1F                    db_op_1F   0x1F
  55C7C3D5: AF                    db_op_AF   0xAF
  55C7C3D6: 00                    db_op_00   0x00
  55C7C3D7: C8 05                 beq        loc_55C7C3DC
  55C7C3D9: CC FF 00              jmp        loc_55C7C4D8
loc_55C7C3DC:
  55C7C3DC: 04                    db_op_04   0x04
  55C7C3DD: 08                    db_op_08   0x08
loc_55C7C3DE:
  55C7C3DE: 00                    db_op_00   0x00
  55C7C3DF: FC 83 20 21 01 9C     mov        d3, (0x9C012120)               ; MMIO VENUS_FLASH_DMA_0x20
  55C7C3E5: FC 87 14 21 01 9C     movb       d3, (0x9C012114)               ; MMIO VENUS_FLASH_DMA_0x14
  55C7C3EB: FC AC 30 21 01 9C     movhu      (0x9C012130), d0               ; MMIO VENUS_FLASH_DMA_0x30
  55C7C3F1: F8 EC 04              ext_f8_EC  0x04
  55C7C3F4: C9 04                 bne        loc_55C7C3F8
  55C7C3F6: CA 0C                 bra        loc_55C7C402
loc_55C7C3F8:
  55C7C3F8: 80 04                 mov        0x04, d0
  55C7C3FA: FC 83 12 21 01 9C     mov        d3, (0x9C012112)               ; MMIO VENUS_FLASH_DMA_0x12
  55C7C400: CA 0A                 bra        loc_55C7C40A
loc_55C7C402:
  55C7C402: 80 02                 mov        0x02, d0
  55C7C404: FC 83 12 21 01 9C     mov        d3, (0x9C012112)               ; MMIO VENUS_FLASH_DMA_0x12
loc_55C7C40A:
  55C7C40A: 80 08                 mov        0x08, d0
  55C7C40C: FC 83 02 21 01 9C     mov        d3, (0x9C012102)               ; MMIO VENUS_FLASH_DMA_0x02
  55C7C412: 80 50                 mov        0x50, d0
  55C7C414: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7C41A: 2C 00 01              mov        0x0100, d0
  55C7C41D: FC 83 04 21 01 9C     mov        d3, (0x9C012104)               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C423: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C429: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C42D: C9 04                 bne        loc_55C7C431
  55C7C42F: CA 0E                 bra        loc_55C7C43D
loc_55C7C431:
  55C7C431: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C432: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C438: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C43C: D9                    lbne       
loc_55C7C43D:
  55C7C43D: 2C 76 07              mov        0x0776, d0
  55C7C440: FC 83 04 21 01 9C     mov        d3, (0x9C012104)               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C446: FC AC 1C 21 01 9C     movhu      (0x9C01211C), d0               ; MMIO VENUS_FLASH_DMA_0x1C
  55C7C44C: F0 72                 ext_f0_72  
  55C7C44E: FC AC 1C 21 01 9C     movhu      (0x9C01211C), d0               ; MMIO VENUS_FLASH_DMA_0x1C
  55C7C454: F8 72 02              ext_f8_72  0x02
  55C7C457: FC AC 1C 21 01 9C     movhu      (0x9C01211C), d0               ; MMIO VENUS_FLASH_DMA_0x1C
  55C7C45D: F8 72 04              ext_f8_72  0x04
  55C7C460: FC AC 1C 21 01 9C     movhu      (0x9C01211C), d0               ; MMIO VENUS_FLASH_DMA_0x1C
  55C7C466: F8 72 06              ext_f8_72  0x06
  55C7C469: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C46F: FA EC 00 04           ext_fa_EC  0x0400
  55C7C473: C9 04                 bne        loc_55C7C477
  55C7C475: CA 0E                 bra        loc_55C7C483
loc_55C7C477:
  55C7C477: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C478: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C47E: FA EC 00 04           ext_fa_EC  0x0400
  55C7C482: D9                    lbne       
loc_55C7C483:
  55C7C483: FC AC 22 21 01 9C     movhu      (0x9C012122), d0               ; MMIO VENUS_FLASH_DMA_0x22
  55C7C489: F8 EC 02              ext_f8_EC  0x02
  55C7C48C: C8 04                 beq        loc_55C7C490
  55C7C48E: CA 3F                 bra        loc_55C7C4CD
loc_55C7C490:
  55C7C490: FC AC 22 21 01 9C     movhu      (0x9C012122), d0               ; MMIO VENUS_FLASH_DMA_0x22
  55C7C496: F8 EC 04              ext_f8_EC  0x04
  55C7C499: C9 04                 bne        loc_55C7C49D
  55C7C49B: CA 1B                 bra        loc_55C7C4B6
loc_55C7C49D:
  55C7C49D: FC AC 2C 21 01 9C     movhu      (0x9C01212C), d0               ; MMIO VENUS_FLASH_DMA_0x2C
  55C7C4A3: FC AE 28 21 01 9C     movhu      (0x9C012128), d2               ; MMIO VENUS_FLASH_DMA_0x28
  55C7C4A9: E0                    add        d0, d0
  55C7C4AA: 1C                    db_op_1C   0x1C
  55C7C4AB: 98                    mov        a2, a0
  55C7C4AC: F1 60                 ext_f1_60  
  55C7C4AE: F0 64                 ext_f0_64  
  55C7C4B0: 1E                    db_op_1E   0x1E
  55C7C4B1: 88                    mov        d2, d0
  55C7C4B2: F2 24                 ext_f2_24  
  55C7C4B4: F0 70                 ext_f0_70  
loc_55C7C4B6:
  55C7C4B6: F8 46 02              ext_f8_46  0x02
  55C7C4B9: F8 42 03              ext_f8_42  0x03
  55C7C4BC: 87                    mov        d1, d3
  55C7C4BD: 1F                    db_op_1F   0x1F
  55C7C4BE: F8 C0 08              ext_f8_C0  0x08
  55C7C4C1: F2 13                 ext_f2_13  
  55C7C4C3: 00                    db_op_00   0x00
  55C7C4C4: FC 83 12 21 01 9C     mov        d3, (0x9C012112)               ; MMIO VENUS_FLASH_DMA_0x12
  55C7C4CA: CC 7E FE              jmp        loc_55C7C348
loc_55C7C4CD:
  55C7C4CD: 48                    db_op_48   0x48
  55C7C4CE: 89                    mov        d2, d1
  55C7C4CF: 86                    mov        d1, d2
  55C7C4D0: 1E                    db_op_1E   0x1E
  55C7C4D1: AA                    db_op_AA   0xAA
  55C7C4D2: 04                    db_op_04   0x04
  55C7C4D3: C2 05                 bge        loc_55C7C4D8
  55C7C4D5: CC 09 FF              jmp        loc_55C7C3DE
loc_55C7C4D8:
  55C7C4D8: 2C A3 00              mov        0x00A3, d0
  55C7C4DB: FC 83 00 21 01 9C     mov        d3, (0x9C012100)               ; MMIO VENUS_FLASH_DMA_0x00
  55C7C4E1: 80 08                 mov        0x08, d0
  55C7C4E3: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
loc_55C7C4E9:
  55C7C4E9: CA 00                 bra        loc_55C7C4E9
loc_55C7C4EB:
  55C7C4EB: 48                    db_op_48   0x48
  55C7C4EC: 1E                    db_op_1E   0x1E
  55C7C4ED: AA                    db_op_AA   0xAA
  55C7C4EE: 20 C2                 add        -62, d0
  55C7C4F0: 05                    db_op_05   0x05
  55C7C4F1: CC 72 FE              jmp        loc_55C7C363
  55C7C4F4: 2C A3 00              mov        0x00A3, d0
  55C7C4F7: FC 83 00 21 01 9C     mov        d3, (0x9C012100)               ; MMIO VENUS_FLASH_DMA_0x00
  55C7C4FD: 80 08                 mov        0x08, d0
  55C7C4FF: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C505: FC DC 00 00 20 54     mov        0x54200000, a0
  55C7C50B: F0 F4                 jmp        (a0)
  55C7C50D: 00                    db_op_00   0x00
  55C7C50E: DF F0 14              ret        [d2,d3,a2,a3], 20
  55C7C511: FF                    db_op_FF   0xFF
  55C7C512: FF                    db_op_FF   0xFF
  55C7C513: FF                    db_op_FF   0xFF
  55C7C514: FF                    db_op_FF   0xFF
  55C7C515: FF                    db_op_FF   0xFF
  55C7C516: FF                    db_op_FF   0xFF
  55C7C517: FF                    db_op_FF   0xFF
  55C7C518: FF                    db_op_FF   0xFF
  55C7C519: FF                    db_op_FF   0xFF
  55C7C51A: FF                    db_op_FF   0xFF
  55C7C51B: FF                    db_op_FF   0xFF
  55C7C51C: FF                    db_op_FF   0xFF
  55C7C51D: FF                    db_op_FF   0xFF
  55C7C51E: FF                    db_op_FF   0xFF
  55C7C51F: FF                    db_op_FF   0xFF
  55C7C520: FF                    db_op_FF   0xFF
  55C7C521: FF                    db_op_FF   0xFF
  55C7C522: FF                    db_op_FF   0xFF
  55C7C523: FF                    db_op_FF   0xFF
  55C7C524: FF                    db_op_FF   0xFF
  55C7C525: FF                    db_op_FF   0xFF
  55C7C526: FF                    db_op_FF   0xFF
  55C7C527: FF                    db_op_FF   0xFF
  55C7C528: FF                    db_op_FF   0xFF
  55C7C529: FF                    db_op_FF   0xFF
  55C7C52A: FF                    db_op_FF   0xFF
  55C7C52B: FF                    db_op_FF   0xFF
  55C7C52C: FF                    db_op_FF   0xFF
  55C7C52D: FF                    db_op_FF   0xFF
  55C7C52E: FF                    db_op_FF   0xFF
  55C7C52F: FF                    db_op_FF   0xFF
  55C7C530: FF                    db_op_FF   0xFF
  55C7C531: FF                    db_op_FF   0xFF
  55C7C532: FF                    db_op_FF   0xFF
  55C7C533: FF                    db_op_FF   0xFF
  55C7C534: FF                    db_op_FF   0xFF
  55C7C535: FF                    db_op_FF   0xFF
  55C7C536: FF                    db_op_FF   0xFF
  55C7C537: FF                    db_op_FF   0xFF
  55C7C538: FF                    db_op_FF   0xFF
  55C7C539: FF                    db_op_FF   0xFF
  55C7C53A: FF                    db_op_FF   0xFF
  55C7C53B: FF                    db_op_FF   0xFF
  55C7C53C: FF                    db_op_FF   0xFF
  55C7C53D: FF                    db_op_FF   0xFF
  55C7C53E: FF                    db_op_FF   0xFF
  55C7C53F: FF                    db_op_FF   0xFF
  55C7C540: FF                    db_op_FF   0xFF
  55C7C541: FF                    db_op_FF   0xFF
  55C7C542: FF                    db_op_FF   0xFF
  55C7C543: FF                    db_op_FF   0xFF
  55C7C544: FF                    db_op_FF   0xFF
  55C7C545: FF                    db_op_FF   0xFF
  55C7C546: FF                    db_op_FF   0xFF
  55C7C547: FF                    db_op_FF   0xFF
  55C7C548: FF                    db_op_FF   0xFF
  55C7C549: FF                    db_op_FF   0xFF
  55C7C54A: FF                    db_op_FF   0xFF
  55C7C54B: FF                    db_op_FF   0xFF
  55C7C54C: FF                    db_op_FF   0xFF
  55C7C54D: FF                    db_op_FF   0xFF
  55C7C54E: FF                    db_op_FF   0xFF
  55C7C54F: FF                    db_op_FF   0xFF
  55C7C550: FF                    db_op_FF   0xFF
  55C7C551: FF                    db_op_FF   0xFF
  55C7C552: FF                    db_op_FF   0xFF
  55C7C553: FF                    db_op_FF   0xFF
  55C7C554: FF                    db_op_FF   0xFF
  55C7C555: FF                    db_op_FF   0xFF
  55C7C556: FF                    db_op_FF   0xFF
  55C7C557: FF                    db_op_FF   0xFF
  55C7C558: FF                    db_op_FF   0xFF
  55C7C559: FF                    db_op_FF   0xFF
  55C7C55A: FF                    db_op_FF   0xFF
  55C7C55B: FF                    db_op_FF   0xFF
  55C7C55C: FF                    db_op_FF   0xFF
  55C7C55D: FF                    db_op_FF   0xFF
  55C7C55E: FF                    db_op_FF   0xFF
  55C7C55F: FF                    db_op_FF   0xFF
  55C7C560: FF                    db_op_FF   0xFF
  55C7C561: FF                    db_op_FF   0xFF
  55C7C562: FF                    db_op_FF   0xFF
  55C7C563: FF                    db_op_FF   0xFF
  55C7C564: FF                    db_op_FF   0xFF
  55C7C565: FF                    db_op_FF   0xFF
  55C7C566: FF                    db_op_FF   0xFF
  55C7C567: FF                    db_op_FF   0xFF
  55C7C568: FF                    db_op_FF   0xFF
  55C7C569: FF                    db_op_FF   0xFF
  55C7C56A: FF                    db_op_FF   0xFF
  55C7C56B: FF                    db_op_FF   0xFF
  55C7C56C: FF                    db_op_FF   0xFF
  55C7C56D: FF                    db_op_FF   0xFF
  55C7C56E: FF                    db_op_FF   0xFF
  55C7C56F: FF                    db_op_FF   0xFF
  55C7C570: FF                    db_op_FF   0xFF
  55C7C571: FF                    db_op_FF   0xFF
  55C7C572: FF                    db_op_FF   0xFF
  55C7C573: FF                    db_op_FF   0xFF
  55C7C574: FF                    db_op_FF   0xFF
  55C7C575: FF                    db_op_FF   0xFF
  55C7C576: FF                    db_op_FF   0xFF
  55C7C577: FF                    db_op_FF   0xFF
  55C7C578: FF                    db_op_FF   0xFF
  55C7C579: FF                    db_op_FF   0xFF
  55C7C57A: FF                    db_op_FF   0xFF
  55C7C57B: FF                    db_op_FF   0xFF
  55C7C57C: FF                    db_op_FF   0xFF
  55C7C57D: FF                    db_op_FF   0xFF
  55C7C57E: FF                    db_op_FF   0xFF
  55C7C57F: FF                    db_op_FF   0xFF
  55C7C580: FF                    db_op_FF   0xFF
  55C7C581: FF                    db_op_FF   0xFF
  55C7C582: FF                    db_op_FF   0xFF
  55C7C583: FF                    db_op_FF   0xFF
  55C7C584: FF                    db_op_FF   0xFF
  55C7C585: FF                    db_op_FF   0xFF
  55C7C586: FF                    db_op_FF   0xFF
  55C7C587: FF                    db_op_FF   0xFF
  55C7C588: FF                    db_op_FF   0xFF
  55C7C589: FF                    db_op_FF   0xFF
  55C7C58A: FF                    db_op_FF   0xFF
  55C7C58B: FF                    db_op_FF   0xFF
  55C7C58C: FF                    db_op_FF   0xFF
  55C7C58D: FF                    db_op_FF   0xFF
  55C7C58E: FF                    db_op_FF   0xFF
  55C7C58F: FF                    db_op_FF   0xFF
  55C7C590: FF                    db_op_FF   0xFF
  55C7C591: FF                    db_op_FF   0xFF
  55C7C592: FF                    db_op_FF   0xFF
  55C7C593: FF                    db_op_FF   0xFF
  55C7C594: FF                    db_op_FF   0xFF
  55C7C595: FF                    db_op_FF   0xFF
  55C7C596: FF                    db_op_FF   0xFF
  55C7C597: FF                    db_op_FF   0xFF
  55C7C598: FF                    db_op_FF   0xFF
  55C7C599: FF                    db_op_FF   0xFF
  55C7C59A: FF                    db_op_FF   0xFF
  55C7C59B: FF                    db_op_FF   0xFF
  55C7C59C: FF                    db_op_FF   0xFF
  55C7C59D: FF                    db_op_FF   0xFF
  55C7C59E: FF                    db_op_FF   0xFF
  55C7C59F: FF                    db_op_FF   0xFF
  55C7C5A0: FF                    db_op_FF   0xFF
  55C7C5A1: FF                    db_op_FF   0xFF
  55C7C5A2: FF                    db_op_FF   0xFF
  55C7C5A3: FF                    db_op_FF   0xFF
  55C7C5A4: FF                    db_op_FF   0xFF
  55C7C5A5: FF                    db_op_FF   0xFF
  55C7C5A6: FF                    db_op_FF   0xFF
  55C7C5A7: FF                    db_op_FF   0xFF
  55C7C5A8: FF                    db_op_FF   0xFF
  55C7C5A9: FF                    db_op_FF   0xFF
  55C7C5AA: FF                    db_op_FF   0xFF
  55C7C5AB: FF                    db_op_FF   0xFF
  55C7C5AC: FF                    db_op_FF   0xFF
  55C7C5AD: FF                    db_op_FF   0xFF
  55C7C5AE: FF                    db_op_FF   0xFF
  55C7C5AF: FF                    db_op_FF   0xFF
  55C7C5B0: FF                    db_op_FF   0xFF
  55C7C5B1: FF                    db_op_FF   0xFF
  55C7C5B2: FF                    db_op_FF   0xFF
  55C7C5B3: FF                    db_op_FF   0xFF
  55C7C5B4: FF                    db_op_FF   0xFF
  55C7C5B5: FF                    db_op_FF   0xFF
  55C7C5B6: FF                    db_op_FF   0xFF
  55C7C5B7: FF                    db_op_FF   0xFF
  55C7C5B8: FF                    db_op_FF   0xFF
  55C7C5B9: FF                    db_op_FF   0xFF
  55C7C5BA: FF                    db_op_FF   0xFF
  55C7C5BB: FF                    db_op_FF   0xFF
  55C7C5BC: FF                    db_op_FF   0xFF
  55C7C5BD: FF                    db_op_FF   0xFF
  55C7C5BE: FF                    db_op_FF   0xFF
  55C7C5BF: FF                    db_op_FF   0xFF
  55C7C5C0: FF                    db_op_FF   0xFF
  55C7C5C1: FF                    db_op_FF   0xFF
  55C7C5C2: FF                    db_op_FF   0xFF
  55C7C5C3: FF                    db_op_FF   0xFF
  55C7C5C4: FF                    db_op_FF   0xFF
  55C7C5C5: FF                    db_op_FF   0xFF
  55C7C5C6: FF                    db_op_FF   0xFF
  55C7C5C7: FF                    db_op_FF   0xFF
  55C7C5C8: FF                    db_op_FF   0xFF
  55C7C5C9: FF                    db_op_FF   0xFF
  55C7C5CA: FF                    db_op_FF   0xFF
  55C7C5CB: FF                    db_op_FF   0xFF
  55C7C5CC: FF                    db_op_FF   0xFF
  55C7C5CD: FF                    db_op_FF   0xFF
  55C7C5CE: FF                    db_op_FF   0xFF
  55C7C5CF: FF                    db_op_FF   0xFF
  55C7C5D0: FF                    db_op_FF   0xFF
  55C7C5D1: FF                    db_op_FF   0xFF
  55C7C5D2: FF                    db_op_FF   0xFF
  55C7C5D3: FF                    db_op_FF   0xFF
  55C7C5D4: FF                    db_op_FF   0xFF
  55C7C5D5: FF                    db_op_FF   0xFF
  55C7C5D6: FF                    db_op_FF   0xFF
  55C7C5D7: FF                    db_op_FF   0xFF
  55C7C5D8: FF                    db_op_FF   0xFF
  55C7C5D9: FF                    db_op_FF   0xFF
  55C7C5DA: FF                    db_op_FF   0xFF
  55C7C5DB: FF                    db_op_FF   0xFF
  55C7C5DC: FF                    db_op_FF   0xFF
  55C7C5DD: FF                    db_op_FF   0xFF
  55C7C5DE: FF                    db_op_FF   0xFF
  55C7C5DF: FF                    db_op_FF   0xFF
  55C7C5E0: FF                    db_op_FF   0xFF
  55C7C5E1: FF                    db_op_FF   0xFF
  55C7C5E2: FF                    db_op_FF   0xFF
  55C7C5E3: FF                    db_op_FF   0xFF
  55C7C5E4: FF                    db_op_FF   0xFF
  55C7C5E5: FF                    db_op_FF   0xFF
  55C7C5E6: FF                    db_op_FF   0xFF
  55C7C5E7: FF                    db_op_FF   0xFF
  55C7C5E8: FF                    db_op_FF   0xFF
  55C7C5E9: FF                    db_op_FF   0xFF
  55C7C5EA: FF                    db_op_FF   0xFF
  55C7C5EB: FF                    db_op_FF   0xFF
  55C7C5EC: FF                    db_op_FF   0xFF
  55C7C5ED: FF                    db_op_FF   0xFF
  55C7C5EE: FF                    db_op_FF   0xFF
  55C7C5EF: FF                    db_op_FF   0xFF
  55C7C5F0: FF                    db_op_FF   0xFF
  55C7C5F1: FF                    db_op_FF   0xFF
  55C7C5F2: FF                    db_op_FF   0xFF
  55C7C5F3: FF                    db_op_FF   0xFF
  55C7C5F4: FF                    db_op_FF   0xFF
  55C7C5F5: FF                    db_op_FF   0xFF
  55C7C5F6: FF                    db_op_FF   0xFF
  55C7C5F7: FF                    db_op_FF   0xFF
  55C7C5F8: FF                    db_op_FF   0xFF
  55C7C5F9: FF                    db_op_FF   0xFF
  55C7C5FA: FF                    db_op_FF   0xFF
  55C7C5FB: FF                    db_op_FF   0xFF
  55C7C5FC: FF                    db_op_FF   0xFF
  55C7C5FD: FF                    db_op_FF   0xFF
  55C7C5FE: FF                    db_op_FF   0xFF
  55C7C5FF: FF                    db_op_FF   0xFF
  55C7C600: 00                    db_op_00   0x00
  55C7C601: F2 E4                 ext_f2_E4  
  55C7C603: F8 C0 10              ext_f8_C0  0x10
  55C7C606: F2 13                 ext_f2_13  
  55C7C608: FA FC FF F7           ext_fa_FC  0xF7FF
  55C7C60C: CB                    nop        
  55C7C60D: CB                    nop        
  55C7C60E: 80 00                 mov        0x00, d0
  55C7C610: 38                    db_op_38   0x38
  55C7C611: 0C                    db_op_0C   0x0C
  55C7C612: 85                    mov        d1, d1
  55C7C613: F2 10                 ext_f2_10  
  55C7C615: C9 29                 bne        loc_55C7C63E
  55C7C617: 80 00                 mov        0x00, d0
  55C7C619: 30                    db_op_30   0x30
  55C7C61A: 00                    db_op_00   0x00
  55C7C61B: 85                    mov        d1, d1
  55C7C61C: FC E0 00 00 01 01     ext_fc_E0  0x01010000
  55C7C622: C9 1C                 bne        loc_55C7C63E
  55C7C624: 38                    db_op_38   0x38
  55C7C625: 70                    mov        d0, (a0)
  55C7C626: 80 FA                 mov        0xFA, d0
  55C7C628: E0                    add        d0, d0
  55C7C629: FD FF 03 70 80        ext_fd_FF  0x7003, 0x80
  55C7C62E: CB                    nop        
  55C7C62F: CB                    nop        
  55C7C630: 90 FF                 mov        0xFF, a0
  55C7C632: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C633: 38                    db_op_38   0x38
  55C7C634: 70                    mov        d0, (a0)
  55C7C635: 80 F8                 mov        0xF8, d0
  55C7C637: EC                    add        d3, d0
  55C7C638: 08                    db_op_08   0x08
  55C7C639: C8 09                 beq        loc_55C7C642
  55C7C63B: 20 FF                 add        -1, d0
  55C7C63D: D9                    lbne       
loc_55C7C63E:
  55C7C63E: 04                    db_op_04   0x04
  55C7C63F: CC 8E 00              jmp        loc_55C7C6CD
loc_55C7C642:
  55C7C642: FC DC 00 00 00 54     mov        0x54000000, a0
  55C7C648: 70                    mov        d0, (a0)
  55C7C649: F8 00 20              ext_f8_00  0x20
  55C7C64C: F8 00 40              ext_f8_00  0x40
  55C7C64F: F8 00 60              ext_f8_00  0x60
  55C7C652: FC DC 00 00 00 98     mov        0x98000000, a0                 ; Uncached DMA/Framebuffer SDRAM
  55C7C658: 70                    mov        d0, (a0)
  55C7C659: F8 00 20              ext_f8_00  0x20
  55C7C65C: F8 00 40              ext_f8_00  0x40
  55C7C65F: F8 00 60              ext_f8_00  0x60
  55C7C662: F8 61 24              ext_f8_61  0x24
  55C7C665: F8 C0 10              ext_f8_C0  0x10
  55C7C668: F8 65 22              ext_f8_65  0x22
  55C7C66B: F2 14                 ext_f2_14  
  55C7C66D: F1 E0                 ext_f1_E0  
  55C7C66F: 80 01                 mov        0x01, d0
  55C7C671: F8 71 22              ext_f8_71  0x22
  55C7C674: 80 0A                 mov        0x0A, d0
  55C7C676: F8 71 24              ext_f8_71  0x24
  55C7C679: 85                    mov        d1, d1
  55C7C67A: 01                    db_op_01   0x01
  55C7C67B: CA 15                 bra        loc_55C7C690
loc_55C7C67D:
  55C7C67D: 04                    db_op_04   0x04
  55C7C67E: FC CC FF FF 7C 00     mov        0x007CFFFF, d0
  55C7C684: CA 0C                 bra        loc_55C7C690
  55C7C686: 00                    db_op_00   0x00
  55C7C687: 00                    db_op_00   0x00
  55C7C688: 00                    db_op_00   0x00
  55C7C689: 00                    db_op_00   0x00
  55C7C68A: 00                    db_op_00   0x00
  55C7C68B: 00                    db_op_00   0x00
  55C7C68C: 00                    db_op_00   0x00
  55C7C68D: 00                    db_op_00   0x00
  55C7C68E: 00                    db_op_00   0x00
  55C7C68F: 00                    db_op_00   0x00
loc_55C7C690:
  55C7C690: E5                    add        d1, d1
  55C7C691: C9 13                 bne        loc_55C7C6A4
  55C7C693: F8 71 36              ext_f8_71  0x36
  55C7C696: F8 C8 10              ext_f8_C8  0x10
  55C7C699: F8 71 38              ext_f8_71  0x38
  55C7C69C: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C69D: F8 61 0E              ext_f8_61  0x0E
  55C7C6A0: F8 E0 02              ext_f8_E0  0x02
  55C7C6A3: D8                    lbeq       
loc_55C7C6A4:
  55C7C6A4: E5                    add        d1, d1
  55C7C6A5: C9 0C                 bne        loc_55C7C6B1
  55C7C6A7: F0 7F                 ext_f0_7F  
  55C7C6A9: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C6AA: F0 63                 ext_f0_63  
  55C7C6AC: FA E0 00 80           ext_fa_E0  0x8000
  55C7C6B0: D9                    lbne       
loc_55C7C6B1:
  55C7C6B1: E5                    add        d1, d1
  55C7C6B2: C9 0B                 bne        loc_55C7C6BD
  55C7C6B4: F8 79 38              ext_f8_79  0x38
  55C7C6B7: F8 CA 10              ext_f8_CA  0x10
  55C7C6BA: F8 79 36              ext_f8_79  0x36
loc_55C7C6BD:
  55C7C6BD: E5                    add        d1, d1
  55C7C6BE: C9 BF                 bne        loc_55C7C67D
  55C7C6C0: F1 D0                 ext_f1_D0  
  55C7C6C2: F8 71 22              ext_f8_71  0x22
  55C7C6C5: F8 C8 10              ext_f8_C8  0x10
  55C7C6C8: F8 71 24              ext_f8_71  0x24
  55C7C6CB: 85                    mov        d1, d1
  55C7C6CC: 01                    db_op_01   0x01
loc_55C7C6CD:
  55C7C6CD: 80 03                 mov        0x03, d0
  55C7C6CF: 03                    db_op_03   0x03
  55C7C6D0: 70                    mov        d0, (a0)
  55C7C6D1: 80 F8                 mov        0xF8, d0
  55C7C6D3: CB                    nop        
  55C7C6D4: 10                    db_op_10   0x10
  55C7C6D5: FA E3 00 08           ext_fa_E3  0x0800
  55C7C6D9: C8 06                 beq        loc_55C7C6DF
  55C7C6DB: FA FD 00 08           ext_fa_FD  0x0800
loc_55C7C6DF:
  55C7C6DF: F0 F6                 jmp        (a2)
  55C7C6E1: 00                    db_op_00   0x00
  55C7C6E2: 00                    db_op_00   0x00
  55C7C6E3: 00                    db_op_00   0x00
  55C7C6E4: 00                    db_op_00   0x00
  55C7C6E5: 00                    db_op_00   0x00
  55C7C6E6: 00                    db_op_00   0x00
  55C7C6E7: 00                    db_op_00   0x00
  55C7C6E8: 83 FC                 mov        0xFC, d3
  55C7C6EA: DF 44 00              ret        [d3,exreg0], 0
  55C7C6ED: 00                    db_op_00   0x00
  55C7C6EE: 9C                    mov        a3, a0
  55C7C6EF: FC DD 00 F4 00 9C     mov        0x9C00F400, a1
  55C7C6F5: F8 69 36              ext_f8_69  0x36
  55C7C6F8: F8 C2 10              ext_f8_C2  0x10
  55C7C6FB: F8 61 38              ext_f8_61  0x38
  55C7C6FE: F2 12                 ext_f2_12  
  55C7C700: FC DE 18 07 00 40     mov        0x40000718, a2                 ; On-Chip Fast RAM
  55C7C706: FC DC 00 06 00 40     mov        0x40000600, a0                 ; On-Chip Fast RAM
  55C7C70C: 85                    mov        d1, d1
  55C7C70D: 01                    db_op_01   0x01
  55C7C70E: F0 40                 ext_f0_40  
  55C7C710: FA C8 FF 00           bxx16      loc_55C7C80F
  55C7C714: C8 04                 beq        loc_55C7C718
  55C7C716: F0 F4                 jmp        (a0)
loc_55C7C718:
  55C7C718: 84                    mov        d1, d0
  55C7C719: DE F0 10              retf       [d2,d3,a2,a3], 16
  55C7C71C: FF                    db_op_FF   0xFF
  55C7C71D: FF                    db_op_FF   0xFF
  55C7C71E: FF                    db_op_FF   0xFF
  55C7C71F: FF                    db_op_FF   0xFF
  55C7C720: FF                    db_op_FF   0xFF
  55C7C721: FF                    db_op_FF   0xFF
  55C7C722: FF                    db_op_FF   0xFF
  55C7C723: FF                    db_op_FF   0xFF
  55C7C724: FF                    db_op_FF   0xFF
  55C7C725: FF                    db_op_FF   0xFF
  55C7C726: FF                    db_op_FF   0xFF
  55C7C727: FF                    db_op_FF   0xFF
  55C7C728: FF                    db_op_FF   0xFF
  55C7C729: FF                    db_op_FF   0xFF
  55C7C72A: FF                    db_op_FF   0xFF
  55C7C72B: FF                    db_op_FF   0xFF
  55C7C72C: FF                    db_op_FF   0xFF
  55C7C72D: FF                    db_op_FF   0xFF
  55C7C72E: FF                    db_op_FF   0xFF
  55C7C72F: FF                    db_op_FF   0xFF
  55C7C730: FF                    db_op_FF   0xFF
  55C7C731: FF                    db_op_FF   0xFF
  55C7C732: FF                    db_op_FF   0xFF
  55C7C733: FF                    db_op_FF   0xFF
  55C7C734: FF                    db_op_FF   0xFF
  55C7C735: FF                    db_op_FF   0xFF
  55C7C736: FF                    db_op_FF   0xFF
  55C7C737: FF                    db_op_FF   0xFF
  55C7C738: FF                    db_op_FF   0xFF
  55C7C739: FF                    db_op_FF   0xFF
  55C7C73A: FF                    db_op_FF   0xFF
  55C7C73B: FF                    db_op_FF   0xFF
  55C7C73C: FF                    db_op_FF   0xFF
  55C7C73D: FF                    db_op_FF   0xFF
  55C7C73E: FF                    db_op_FF   0xFF
  55C7C73F: FF                    db_op_FF   0xFF
  55C7C740: FF                    db_op_FF   0xFF
  55C7C741: FF                    db_op_FF   0xFF
  55C7C742: FF                    db_op_FF   0xFF
  55C7C743: FF                    db_op_FF   0xFF
  55C7C744: FF                    db_op_FF   0xFF
  55C7C745: FF                    db_op_FF   0xFF
  55C7C746: FF                    db_op_FF   0xFF
  55C7C747: FF                    db_op_FF   0xFF
  55C7C748: FF                    db_op_FF   0xFF
  55C7C749: FF                    db_op_FF   0xFF
  55C7C74A: FF                    db_op_FF   0xFF
  55C7C74B: FF                    db_op_FF   0xFF
  55C7C74C: FF                    db_op_FF   0xFF
  55C7C74D: FF                    db_op_FF   0xFF
  55C7C74E: FF                    db_op_FF   0xFF
  55C7C74F: FF                    db_op_FF   0xFF
  55C7C750: FF                    db_op_FF   0xFF
  55C7C751: FF                    db_op_FF   0xFF
  55C7C752: FF                    db_op_FF   0xFF
  55C7C753: FF                    db_op_FF   0xFF
  55C7C754: FF                    db_op_FF   0xFF
  55C7C755: FF                    db_op_FF   0xFF
  55C7C756: FF                    db_op_FF   0xFF
  55C7C757: FF                    db_op_FF   0xFF
  55C7C758: FF                    db_op_FF   0xFF
  55C7C759: FF                    db_op_FF   0xFF
  55C7C75A: FF                    db_op_FF   0xFF
  55C7C75B: FF                    db_op_FF   0xFF
  55C7C75C: FF                    db_op_FF   0xFF
  55C7C75D: FF                    db_op_FF   0xFF
  55C7C75E: FF                    db_op_FF   0xFF
  55C7C75F: FF                    db_op_FF   0xFF
  55C7C760: FF                    db_op_FF   0xFF
  55C7C761: FF                    db_op_FF   0xFF
  55C7C762: FF                    db_op_FF   0xFF
  55C7C763: FF                    db_op_FF   0xFF
  55C7C764: FF                    db_op_FF   0xFF
  55C7C765: FF                    db_op_FF   0xFF
  55C7C766: FF                    db_op_FF   0xFF
  55C7C767: FF                    db_op_FF   0xFF
  55C7C768: FF                    db_op_FF   0xFF
  55C7C769: FF                    db_op_FF   0xFF
  55C7C76A: FF                    db_op_FF   0xFF
  55C7C76B: FF                    db_op_FF   0xFF
  55C7C76C: FF                    db_op_FF   0xFF
  55C7C76D: FF                    db_op_FF   0xFF
  55C7C76E: FF                    db_op_FF   0xFF
  55C7C76F: FF                    db_op_FF   0xFF
  55C7C770: FF                    db_op_FF   0xFF
  55C7C771: FF                    db_op_FF   0xFF
  55C7C772: FF                    db_op_FF   0xFF
  55C7C773: FF                    db_op_FF   0xFF
  55C7C774: FF                    db_op_FF   0xFF
  55C7C775: FF                    db_op_FF   0xFF
  55C7C776: FF                    db_op_FF   0xFF
  55C7C777: FF                    db_op_FF   0xFF
  55C7C778: FF                    db_op_FF   0xFF
  55C7C779: FF                    db_op_FF   0xFF
  55C7C77A: FF                    db_op_FF   0xFF
  55C7C77B: FF                    db_op_FF   0xFF
  55C7C77C: FF                    db_op_FF   0xFF
  55C7C77D: FF                    db_op_FF   0xFF
  55C7C77E: FF                    db_op_FF   0xFF
  55C7C77F: FF                    db_op_FF   0xFF
  55C7C780: FF                    db_op_FF   0xFF
  55C7C781: FF                    db_op_FF   0xFF
  55C7C782: FF                    db_op_FF   0xFF
  55C7C783: FF                    db_op_FF   0xFF
  55C7C784: FF                    db_op_FF   0xFF
  55C7C785: FF                    db_op_FF   0xFF
  55C7C786: FF                    db_op_FF   0xFF
  55C7C787: FF                    db_op_FF   0xFF
  55C7C788: FF                    db_op_FF   0xFF
  55C7C789: FF                    db_op_FF   0xFF
  55C7C78A: FF                    db_op_FF   0xFF
  55C7C78B: FF                    db_op_FF   0xFF
  55C7C78C: FF                    db_op_FF   0xFF
  55C7C78D: FF                    db_op_FF   0xFF
  55C7C78E: FF                    db_op_FF   0xFF
  55C7C78F: FF                    db_op_FF   0xFF
  55C7C790: FF                    db_op_FF   0xFF
  55C7C791: FF                    db_op_FF   0xFF
  55C7C792: FF                    db_op_FF   0xFF
  55C7C793: FF                    db_op_FF   0xFF
  55C7C794: FF                    db_op_FF   0xFF
  55C7C795: FF                    db_op_FF   0xFF
  55C7C796: FF                    db_op_FF   0xFF
  55C7C797: FF                    db_op_FF   0xFF
  55C7C798: FF                    db_op_FF   0xFF
  55C7C799: FF                    db_op_FF   0xFF
  55C7C79A: FF                    db_op_FF   0xFF
  55C7C79B: FF                    db_op_FF   0xFF
  55C7C79C: FF                    db_op_FF   0xFF
  55C7C79D: FF                    db_op_FF   0xFF
  55C7C79E: FF                    db_op_FF   0xFF
  55C7C79F: FF                    db_op_FF   0xFF
  55C7C7A0: FF                    db_op_FF   0xFF
  55C7C7A1: FF                    db_op_FF   0xFF
  55C7C7A2: FF                    db_op_FF   0xFF
  55C7C7A3: FF                    db_op_FF   0xFF
  55C7C7A4: FF                    db_op_FF   0xFF
  55C7C7A5: FF                    db_op_FF   0xFF
  55C7C7A6: FF                    db_op_FF   0xFF
  55C7C7A7: FF                    db_op_FF   0xFF
  55C7C7A8: FF                    db_op_FF   0xFF
  55C7C7A9: FF                    db_op_FF   0xFF
  55C7C7AA: FF                    db_op_FF   0xFF
  55C7C7AB: FF                    db_op_FF   0xFF
  55C7C7AC: FF                    db_op_FF   0xFF
  55C7C7AD: FF                    db_op_FF   0xFF
  55C7C7AE: FF                    db_op_FF   0xFF
  55C7C7AF: FF                    db_op_FF   0xFF
  55C7C7B0: FF                    db_op_FF   0xFF
  55C7C7B1: FF                    db_op_FF   0xFF
  55C7C7B2: FF                    db_op_FF   0xFF
  55C7C7B3: FF                    db_op_FF   0xFF
  55C7C7B4: FF                    db_op_FF   0xFF
  55C7C7B5: FF                    db_op_FF   0xFF
  55C7C7B6: FF                    db_op_FF   0xFF
  55C7C7B7: FF                    db_op_FF   0xFF
  55C7C7B8: FF                    db_op_FF   0xFF
  55C7C7B9: FF                    db_op_FF   0xFF
  55C7C7BA: FF                    db_op_FF   0xFF
  55C7C7BB: FF                    db_op_FF   0xFF
  55C7C7BC: FF                    db_op_FF   0xFF
  55C7C7BD: FF                    db_op_FF   0xFF
  55C7C7BE: FF                    db_op_FF   0xFF
  55C7C7BF: FF                    db_op_FF   0xFF
  55C7C7C0: FF                    db_op_FF   0xFF
  55C7C7C1: FF                    db_op_FF   0xFF
  55C7C7C2: FF                    db_op_FF   0xFF
  55C7C7C3: FF                    db_op_FF   0xFF
  55C7C7C4: FF                    db_op_FF   0xFF
  55C7C7C5: FF                    db_op_FF   0xFF
  55C7C7C6: FF                    db_op_FF   0xFF
  55C7C7C7: FF                    db_op_FF   0xFF
  55C7C7C8: FF                    db_op_FF   0xFF
  55C7C7C9: FF                    db_op_FF   0xFF
  55C7C7CA: FF                    db_op_FF   0xFF
  55C7C7CB: FF                    db_op_FF   0xFF
  55C7C7CC: FF                    db_op_FF   0xFF
  55C7C7CD: FF                    db_op_FF   0xFF
  55C7C7CE: FF                    db_op_FF   0xFF
  55C7C7CF: FF                    db_op_FF   0xFF
  55C7C7D0: FF                    db_op_FF   0xFF
  55C7C7D1: FF                    db_op_FF   0xFF
  55C7C7D2: FF                    db_op_FF   0xFF
  55C7C7D3: FF                    db_op_FF   0xFF
  55C7C7D4: FF                    db_op_FF   0xFF
  55C7C7D5: FF                    db_op_FF   0xFF
  55C7C7D6: FF                    db_op_FF   0xFF
  55C7C7D7: FF                    db_op_FF   0xFF
  55C7C7D8: FF                    db_op_FF   0xFF
  55C7C7D9: FF                    db_op_FF   0xFF
  55C7C7DA: FF                    db_op_FF   0xFF
  55C7C7DB: FF                    db_op_FF   0xFF
loc_55C7C7DC:
  55C7C7DC: FF                    db_op_FF   0xFF
  55C7C7DD: FF                    db_op_FF   0xFF
  55C7C7DE: FF                    db_op_FF   0xFF
  55C7C7DF: FF                    db_op_FF   0xFF
  55C7C7E0: FF                    db_op_FF   0xFF
  55C7C7E1: FF                    db_op_FF   0xFF
  55C7C7E2: FF                    db_op_FF   0xFF
  55C7C7E3: FF                    db_op_FF   0xFF
  55C7C7E4: FF                    db_op_FF   0xFF
  55C7C7E5: FF                    db_op_FF   0xFF
  55C7C7E6: FF                    db_op_FF   0xFF
  55C7C7E7: FF                    db_op_FF   0xFF
  55C7C7E8: FF                    db_op_FF   0xFF
  55C7C7E9: FF                    db_op_FF   0xFF
  55C7C7EA: FF                    db_op_FF   0xFF
  55C7C7EB: FF                    db_op_FF   0xFF
  55C7C7EC: FF                    db_op_FF   0xFF
  55C7C7ED: FF                    db_op_FF   0xFF
  55C7C7EE: FF                    db_op_FF   0xFF
  55C7C7EF: FF                    db_op_FF   0xFF
  55C7C7F0: FF                    db_op_FF   0xFF
  55C7C7F1: FF                    db_op_FF   0xFF
  55C7C7F2: FF                    db_op_FF   0xFF
  55C7C7F3: FF                    db_op_FF   0xFF
  55C7C7F4: FF                    db_op_FF   0xFF
  55C7C7F5: FF                    db_op_FF   0xFF
  55C7C7F6: FF                    db_op_FF   0xFF
  55C7C7F7: FF                    db_op_FF   0xFF
  55C7C7F8: FF                    db_op_FF   0xFF
  55C7C7F9: FF                    db_op_FF   0xFF
  55C7C7FA: FF                    db_op_FF   0xFF
  55C7C7FB: FF                    db_op_FF   0xFF
  55C7C7FC: FF                    db_op_FF   0xFF
  55C7C7FD: FF                    db_op_FF   0xFF
  55C7C7FE: FF                    db_op_FF   0xFF
  55C7C7FF: FF                    db_op_FF   0xFF
  55C7C800: FC CC 4C 0B 20 54     mov        0x54200B4C, d0
  55C7C806: FC 81 28 0B 20 54     mov        d1, (0x54200B28)
  55C7C80C: FC CC 4C 0D 20 54     mov        0x54200D4C, d0
  55C7C812: FC 81 40 0B 20 54     mov        d1, (0x54200B40)
  55C7C818: CD C9 07 F0 18        call       sub_55C7CFE1, [d2,d3,a2,a3], 24
  55C7C81D: 14                    db_op_14   0x14
  55C7C81E: A0                    db_op_A0   0xA0
  55C7C81F: 00                    db_op_00   0x00
  55C7C820: C9 04                 bne        loc_55C7C824
  55C7C822: CA 1F                 bra        loc_55C7C841
loc_55C7C824:
  55C7C824: 2C A3 00              mov        0x00A3, d0
  55C7C827: FC 83 00 21 01 9C     mov        d3, (0x9C012100)               ; MMIO VENUS_FLASH_DMA_0x00
  55C7C82D: 80 08                 mov        0x08, d0
  55C7C82F: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C835: FC DC 00 00 C8 55     mov        0x55C80000, a0                 ; vec_hardware_reset
  55C7C83B: F0 F4                 jmp        (a0)
  55C7C83D: 80 01                 mov        0x01, d0
  55C7C83F: CA 0B                 bra        loc_55C7C84A
loc_55C7C841:
  55C7C841: FC DC 00 00 C8 55     mov        0x55C80000, a0                 ; vec_hardware_reset
  55C7C847: F0 F4                 jmp        (a0)
  55C7C849: 00                    db_op_00   0x00
loc_55C7C84A:
  55C7C84A: DF 00 04              ret        [], 4

; --- Function sub_55C7C84D (callers: 1) ---
sub_55C7C84D:
  55C7C84D: 82 85                 mov        0x85, d2
  55C7C84F: 01                    db_op_01   0x01
  55C7C850: 00                    db_op_00   0x00
  55C7C851: 16                    db_op_16   0x16
  55C7C852: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C853: 15                    db_op_15   0x15
  55C7C854: 87                    mov        d1, d3
  55C7C855: F2 0B                 ext_f2_0B  
  55C7C857: C9 04                 bne        loc_55C7C85B
  55C7C859: 14                    db_op_14   0x14
  55C7C85A: 40 FA                 mov        a0, (250, sp)
  55C7C85C: C9 80                 bne        loc_55C7C7DC
  55C7C85E: 00                    db_op_00   0x00
  55C7C85F: C8 04                 beq        loc_55C7C863
  55C7C861: E5                    add        d1, d1
  55C7C862: DA                    lbra       
loc_55C7C863:
  55C7C863: 14                    db_op_14   0x14
  55C7C864: DE C0 08              retf       [d2,d3], 8

; --- Function sub_55C7C867 (callers: 5) ---
sub_55C7C867:
  55C7C867: FC A8 37 0B 20 54     ext_fc_A8  0x54200B37
  55C7C86D: A0                    db_op_A0   0xA0
  55C7C86E: 60                    mov        (a0), d0
  55C7C86F: C8 2D                 beq        loc_55C7C89C
  55C7C871: FA C8 90 00           bxx16      loc_55C7C901
  55C7C875: C9 10                 bne        loc_55C7C885
  55C7C877: FC A8 21 0B 20 54     ext_fc_A8  0x54200B21
  55C7C87D: FC 83 12 21 01 9C     mov        d3, (0x9C012112)               ; MMIO VENUS_FLASH_DMA_0x12
  55C7C883: CA 4E                 bra        loc_55C7C8D1
loc_55C7C885:
  55C7C885: FC A9 21 0B 20 54     ext_fc_A9  0x54200B21
  55C7C88B: FC A8 22 0B 20 54     ext_fc_A8  0x54200B22
  55C7C891: F8 C0 08              ext_f8_C0  0x08
  55C7C894: F2 11                 ext_f2_11  
  55C7C896: FC 87 12 21 01 9C     movb       d3, (0x9C012112)               ; MMIO VENUS_FLASH_DMA_0x12
loc_55C7C89C:
  55C7C89C: FC A9 23 0B 20 54     ext_fc_A9  0x54200B23
  55C7C8A2: FC A8 24 0B 20 54     ext_fc_A8  0x54200B24
  55C7C8A8: F8 C0 08              ext_f8_C0  0x08
  55C7C8AB: F2 11                 ext_f2_11  
  55C7C8AD: FC 87 14 21 01 9C     movb       d3, (0x9C012114)               ; MMIO VENUS_FLASH_DMA_0x14
  55C7C8B3: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7C8B9: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7C8BF: F4 00                 ext_f4_00  
  55C7C8C1: A0                    db_op_A0   0xA0
  55C7C8C2: 04                    db_op_04   0x04
  55C7C8C3: C0 0E                 blt        loc_55C7C8D1
  55C7C8C5: FC A8 25 0B 20 54     ext_fc_A8  0x54200B25
  55C7C8CB: FC 83 16 21 01 9C     mov        d3, (0x9C012116)               ; MMIO VENUS_FLASH_DMA_0x16
loc_55C7C8D1:
  55C7C8D1: DE 00 00              retf       [], 0

; --- Function sub_55C7C8D4 (callers: 4) ---
sub_55C7C8D4:
  55C7C8D4: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7C8DA: 92 FC                 mov        0xFC, a2
  55C7C8DC: DC 2E 0B 20 54        jmp        0xA9E7D40A
  55C7C8E1: F4 00                 ext_f4_00  
  55C7C8E3: A0                    db_op_A0   0xA0
  55C7C8E4: 00                    db_op_00   0x00
  55C7C8E5: C8 06                 beq        loc_55C7C8EB
  55C7C8E7: 80 04                 mov        0x04, d0
  55C7C8E9: CA 04                 bra        loc_55C7C8ED
loc_55C7C8EB:
  55C7C8EB: 80 02                 mov        0x02, d0
loc_55C7C8ED:
  55C7C8ED: FC 82 21 0B 20 54     mov        d2, (0x54200B21)
  55C7C8F3: 80 50                 mov        0x50, d0
  55C7C8F5: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7C8FB: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
loc_55C7C901:
  55C7C901: CD 66 FF 00 00        call       sub_55C7C867, [], 0
  55C7C906: 00                    db_op_00   0x00
  55C7C907: FC 83 20 21 01 9C     mov        d3, (0x9C012120)               ; MMIO VENUS_FLASH_DMA_0x20
  55C7C90D: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7C913: 80 08                 mov        0x08, d0
  55C7C915: FC 83 02 21 01 9C     mov        d3, (0x9C012102)               ; MMIO VENUS_FLASH_DMA_0x02
  55C7C91B: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7C921: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7C927: F4 00                 ext_f4_00  
  55C7C929: A0                    db_op_A0   0xA0
  55C7C92A: 04                    db_op_04   0x04
  55C7C92B: C0 2C                 blt        loc_55C7C957
  55C7C92D: FC DD 04 21 01 9C     mov        0x9C012104, a1                 ; MMIO VENUS_FLASH_DMA_0x04
  55C7C933: 2C 00 01              mov        0x0100, d0
  55C7C936: F0 71                 ext_f0_71  
  55C7C938: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C93E: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C942: C8 0E                 beq        loc_55C7C950
  55C7C944: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C945: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C94B: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C94F: D9                    lbne       
loc_55C7C950:
  55C7C950: 2C 76 07              mov        0x0776, d0
  55C7C953: F0 71                 ext_f0_71  
  55C7C955: CA 2A                 bra        loc_55C7C97F
loc_55C7C957:
  55C7C957: FC DD 04 21 01 9C     mov        0x9C012104, a1                 ; MMIO VENUS_FLASH_DMA_0x04
  55C7C95D: 2C 00 01              mov        0x0100, d0
  55C7C960: F0 71                 ext_f0_71  
  55C7C962: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C968: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C96C: C8 0E                 beq        loc_55C7C97A
  55C7C96E: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C96F: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C975: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C979: D9                    lbne       
loc_55C7C97A:
  55C7C97A: 2C 36 07              mov        0x0736, d0
  55C7C97D: F0 71                 ext_f0_71  
loc_55C7C97F:
  55C7C97F: 80 08                 mov        0x08, d0
  55C7C981: 85                    mov        d1, d1
  55C7C982: 01                    db_op_01   0x01
  55C7C983: 98                    mov        a2, a0
  55C7C984: CD 20 00 E0 14        call       sub_55C7C9A4, [d2,d3,a2], 20
  55C7C989: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C98F: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C993: C8 0E                 beq        loc_55C7C9A1
  55C7C995: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C996: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C99C: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7C9A0: D9                    lbne       
loc_55C7C9A1:
  55C7C9A1: DF 20 08              ret        [a2], 8

; --- Function sub_55C7C9A4 (callers: 4) ---
sub_55C7C9A4:
  55C7C9A4: F8 96 04              movbu      d1, (4, a2)
  55C7C9A7: 92 1C                 mov        0x1C, a2
  55C7C9A9: FA C8 00 02           bxx16      loc_55C7CBA9
  55C7C9AD: C9 13                 bne        loc_55C7C9C0
  55C7C9AF: FC A9 08 0B 20 54     ext_fc_A9  0x54200B08
  55C7C9B5: A5                    db_op_A5   0xA5
  55C7C9B6: 01                    db_op_01   0x01
  55C7C9B7: C9 09                 bne        loc_55C7C9C0
  55C7C9B9: CD C2 08 00 00        call       sub_55C7D27B, [], 0
  55C7C9BE: CA 17                 bra        loc_55C7C9D5
loc_55C7C9C0:
  55C7C9C0: 04                    db_op_04   0x04
  55C7C9C1: 08                    db_op_08   0x08
  55C7C9C2: A4                    db_op_A4   0xA4
  55C7C9C3: C3 12                 ble        loc_55C7C9D5
  55C7C9C5: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C9C6: FC AF 1C 21 01 9C     movhu      (0x9C01211C), d3               ; MMIO VENUS_FLASH_DMA_0x1C
  55C7C9CC: 1D                    db_op_1D   0x1D
  55C7C9CD: F4 F6                 ext_f4_F6  
  55C7C9CF: 2A 02                 cmp        0x02, d2
  55C7C9D1: 89                    mov        d2, d1
  55C7C9D2: 1E                    db_op_1E   0x1E
  55C7C9D3: A2                    db_op_A2   0xA2
  55C7C9D4: D0                    lblt       
loc_55C7C9D5:
  55C7C9D5: F8 B8 04              ext_f8_B8  0x04
  55C7C9D8: A0                    db_op_A0   0xA0
  55C7C9D9: 01                    db_op_01   0x01
  55C7C9DA: C9 60                 bne        loc_55C7CA3A
  55C7C9DC: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C9E2: 2D 00 04              mov        0x0400, d1
  55C7C9E5: F2 04                 ext_f2_04  
  55C7C9E7: C8 0C                 beq        loc_55C7C9F3
  55C7C9E9: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7C9EA: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7C9F0: F2 04                 ext_f2_04  
  55C7C9F2: D9                    lbne       
loc_55C7C9F3:
  55C7C9F3: FC AD 22 21 01 9C     movhu      (0x9C012122), d1               ; MMIO VENUS_FLASH_DMA_0x22
  55C7C9F9: 84                    mov        d1, d0
  55C7C9FA: 14                    db_op_14   0x14
  55C7C9FB: A0                    db_op_A0   0xA0
  55C7C9FC: 00                    db_op_00   0x00
  55C7C9FD: C8 3D                 beq        loc_55C7CA3A
  55C7C9FF: 15                    db_op_15   0x15
  55C7CA00: F8 ED 02              ext_f8_ED  0x02
  55C7CA03: C8 0F                 beq        loc_55C7CA12
  55C7CA05: 2C 80 00              mov        0x0080, d0
  55C7CA08: FC 82 30 0B 20 54     mov        d2, (0x54200B30)
  55C7CA0E: 80 01                 mov        0x01, d0
  55C7CA10: CA 2B                 bra        loc_55C7CA3B
loc_55C7CA12:
  55C7CA12: FC A8 30 0B 20 54     ext_fc_A8  0x54200B30
  55C7CA18: 40 FC                 mov        a0, (252, sp)
  55C7CA1A: 82 30                 mov        0x30, d2
  55C7CA1C: 0B                    db_op_0B   0x0B
  55C7CA1D: 20 54                 add        84, d0
  55C7CA1F: F8 ED 04              ext_f8_ED  0x04
  55C7CA22: C8 18                 beq        loc_55C7CA3A
  55C7CA24: FC AC 2C 21 01 9C     movhu      (0x9C01212C), d0               ; MMIO VENUS_FLASH_DMA_0x2C
  55C7CA2A: FC AD 28 21 01 9C     movhu      (0x9C012128), d1               ; MMIO VENUS_FLASH_DMA_0x28
  55C7CA30: E0                    add        d0, d0
  55C7CA31: 1C                    db_op_1C   0x1C
  55C7CA32: F1 62                 ext_f1_62  
  55C7CA34: F0 62                 ext_f0_62  
  55C7CA36: F2 21                 ext_f2_21  
  55C7CA38: F0 76                 ext_f0_76  
loc_55C7CA3A:
  55C7CA3A: 00                    db_op_00   0x00
loc_55C7CA3B:
  55C7CA3B: DF E0 14              ret        [d2,d3,a2], 20

; --- Function sub_55C7CA3E (callers: 1) ---
sub_55C7CA3E:
  55C7CA3E: 00                    db_op_00   0x00
  55C7CA3F: FC 82 30 0B 20 54     mov        d2, (0x54200B30)
  55C7CA45: 2C 00 02              mov        0x0200, d0
  55C7CA48: FC 83 02 21 01 9C     mov        d3, (0x9C012102)               ; MMIO VENUS_FLASH_DMA_0x02
  55C7CA4E: 00                    db_op_00   0x00
  55C7CA4F: FC 83 20 21 01 9C     mov        d3, (0x9C012120)               ; MMIO VENUS_FLASH_DMA_0x20
  55C7CA55: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7CA5B: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7CA61: FC DD 2F 0B 20 54     mov        0x54200B2F, a1
  55C7CA67: F4 01                 ext_f4_01  
  55C7CA69: A0                    db_op_A0   0xA0
  55C7CA6A: 04                    db_op_04   0x04
  55C7CA6B: C0 2C                 blt        loc_55C7CA97
  55C7CA6D: FC DD 04 21 01 9C     mov        0x9C012104, a1                 ; MMIO VENUS_FLASH_DMA_0x04
  55C7CA73: 2C 00 01              mov        0x0100, d0
  55C7CA76: F0 71                 ext_f0_71  
  55C7CA78: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CA7E: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CA82: C8 0E                 beq        loc_55C7CA90
  55C7CA84: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7CA85: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CA8B: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CA8F: D9                    lbne       
loc_55C7CA90:
  55C7CA90: 2C 76 07              mov        0x0776, d0
  55C7CA93: F0 71                 ext_f0_71  
  55C7CA95: CA 2A                 bra        loc_55C7CABF
loc_55C7CA97:
  55C7CA97: FC DD 04 21 01 9C     mov        0x9C012104, a1                 ; MMIO VENUS_FLASH_DMA_0x04
  55C7CA9D: 2C 00 01              mov        0x0100, d0
  55C7CAA0: F0 71                 ext_f0_71  
  55C7CAA2: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CAA8: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CAAC: C8 0E                 beq        loc_55C7CABA
  55C7CAAE: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7CAAF: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CAB5: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CAB9: D9                    lbne       
loc_55C7CABA:
  55C7CABA: 2C 36 07              mov        0x0736, d0
  55C7CABD: F0 71                 ext_f0_71  
loc_55C7CABF:
  55C7CABF: 2C 00 02              mov        0x0200, d0
  55C7CAC2: 85                    mov        d1, d1
  55C7CAC3: 01                    db_op_01   0x01
  55C7CAC4: CD E0 FE E0 14        call       sub_55C7C9A4, [d2,d3,a2], 20
  55C7CAC9: 14                    db_op_14   0x14
  55C7CACA: A0                    db_op_A0   0xA0
  55C7CACB: 00                    db_op_00   0x00
  55C7CACC: C9 1D                 bne        loc_55C7CAE9
  55C7CACE: FC AC 26 21 01 9C     movhu      (0x9C012126), d0               ; MMIO VENUS_FLASH_DMA_0x26
  55C7CAD4: F8 C8 08              ext_f8_C8  0x08
  55C7CAD7: 81 15                 mov        0x15, d1
  55C7CAD9: FA C9 FF 00           bxx16      loc_55C7CBD8
  55C7CADD: C8 10                 beq        loc_55C7CAED
  55C7CADF: CD 6E FD C0 08        call       sub_55C7C84D, [d2,d3], 8
  55C7CAE4: 14                    db_op_14   0x14
  55C7CAE5: A0                    db_op_A0   0xA0
  55C7CAE6: 04                    db_op_04   0x04
  55C7CAE7: C0 06                 blt        loc_55C7CAED
loc_55C7CAE9:
  55C7CAE9: 80 01                 mov        0x01, d0
  55C7CAEB: CA 03                 bra        loc_55C7CAEE
loc_55C7CAED:
  55C7CAED: 00                    db_op_00   0x00
loc_55C7CAEE:
  55C7CAEE: FC AD 04 21 01 9C     movhu      (0x9C012104), d1               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CAF4: FA ED FF FF           ext_fa_ED  0xFFFF
  55C7CAF8: C8 0E                 beq        loc_55C7CB06
  55C7CAFA: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7CAFB: FC AD 04 21 01 9C     movhu      (0x9C012104), d1               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CB01: FA ED FF FF           ext_fa_ED  0xFFFF
  55C7CB05: D9                    lbne       
loc_55C7CB06:
  55C7CB06: 14                    db_op_14   0x14
  55C7CB07: DF 00 04              ret        [], 4

; --- Function sub_55C7CB0A (callers: 2) ---
sub_55C7CB0A:
  55C7CB0A: FC AA 30 0B 20 54     ext_fc_AA  0x54200B30
  55C7CB10: 04                    db_op_04   0x04
  55C7CB11: FC 86 30 0B 20 54     movb       d2, (0x54200B30)
  55C7CB17: FC 86 21 0B 20 54     movb       d2, (0x54200B21)
  55C7CB1D: FC 86 22 0B 20 54     movb       d2, (0x54200B22)
  55C7CB23: FC A9 20 0B 20 54     ext_fc_A9  0x54200B20
  55C7CB29: F8 C1 03              ext_f8_C1  0x03
  55C7CB2C: F1 E4                 ext_f1_E4  
  55C7CB2E: FC D0 44 0B 20 54     add        0x54200B44, d0
  55C7CB34: 14                    db_op_14   0x14
  55C7CB35: 54                    db_op_54   0x54
  55C7CB36: F1 60                 ext_f1_60  
  55C7CB38: 70                    mov        d0, (a0)
  55C7CB39: FC 82 23 0B 20 54     mov        d2, (0x54200B23)
  55C7CB3F: 70                    mov        d0, (a0)
  55C7CB40: F8 C4 08              ext_f8_C4  0x08
  55C7CB43: FC 82 24 0B 20 54     mov        d2, (0x54200B24)
  55C7CB49: 70                    mov        d0, (a0)
  55C7CB4A: F8 C4 10              ext_f8_C4  0x10
  55C7CB4D: FC 82 25 0B 20 54     mov        d2, (0x54200B25)
  55C7CB53: 00                    db_op_00   0x00
  55C7CB54: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7CB5A: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7CB60: CD 07 FD 00 00        call       sub_55C7C867, [], 0
  55C7CB65: 80 30                 mov        0x30, d0
  55C7CB67: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7CB6D: FC 83 18 21 01 9C     mov        d3, (0x9C012118)               ; MMIO VENUS_FLASH_DMA_0x18
  55C7CB73: 00                    db_op_00   0x00
  55C7CB74: FC 83 20 21 01 9C     mov        d3, (0x9C012120)               ; MMIO VENUS_FLASH_DMA_0x20
  55C7CB7A: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7CB80: 2C 00 02              mov        0x0200, d0
  55C7CB83: FC 83 02 21 01 9C     mov        d3, (0x9C012102)               ; MMIO VENUS_FLASH_DMA_0x02
  55C7CB89: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7CB8F: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7CB95: F4 00                 ext_f4_00  
  55C7CB97: A0                    db_op_A0   0xA0
  55C7CB98: 04                    db_op_04   0x04
  55C7CB99: C0 2C                 blt        loc_55C7CBC5
  55C7CB9B: FC DC 04 21 01 9C     mov        0x9C012104, a0                 ; MMIO VENUS_FLASH_DMA_0x04
  55C7CBA1: 2C 00 01              mov        0x0100, d0
  55C7CBA4: F0 70                 ext_f0_70  
  55C7CBA6: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CBAC: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CBB0: C8 0E                 beq        loc_55C7CBBE
  55C7CBB2: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7CBB3: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CBB9: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CBBD: D9                    lbne       
loc_55C7CBBE:
  55C7CBBE: 2C 76 07              mov        0x0776, d0
  55C7CBC1: F0 70                 ext_f0_70  
  55C7CBC3: CA 2A                 bra        loc_55C7CBED
loc_55C7CBC5:
  55C7CBC5: FC DC 04 21 01 9C     mov        0x9C012104, a0                 ; MMIO VENUS_FLASH_DMA_0x04
  55C7CBCB: 2C 00 01              mov        0x0100, d0
  55C7CBCE: F0 70                 ext_f0_70  
  55C7CBD0: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CBD6: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CBDA: C8 0E                 beq        loc_55C7CBE8
  55C7CBDC: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7CBDD: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7CBE3: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7CBE7: D9                    lbne       
loc_55C7CBE8:
  55C7CBE8: 2C 36 07              mov        0x0736, d0
  55C7CBEB: F0 70                 ext_f0_70  
loc_55C7CBED:
  55C7CBED: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CBF3: 2C 00 02              mov        0x0200, d0
  55C7CBF6: 85                    mov        d1, d1
  55C7CBF7: 01                    db_op_01   0x01
  55C7CBF8: CD AC FD E0 14        call       sub_55C7C9A4, [d2,d3,a2], 20
  55C7CBFD: FC 8A 30 0B 20 54     movhu      d2, (0x54200B30)
  55C7CC03: 14                    db_op_14   0x14
  55C7CC04: A0                    db_op_A0   0xA0
  55C7CC05: 00                    db_op_00   0x00
  55C7CC06: C8 06                 beq        loc_55C7CC0C
  55C7CC08: 80 01                 mov        0x01, d0
  55C7CC0A: CA 03                 bra        loc_55C7CC0D
loc_55C7CC0C:
  55C7CC0C: 00                    db_op_00   0x00
loc_55C7CC0D:
  55C7CC0D: DF 80 08              ret        [d2], 8

; --- Function sub_55C7CC10 (callers: 1) ---
sub_55C7CC10:
  55C7CC10: 08                    db_op_08   0x08
  55C7CC11: 0C                    db_op_0C   0x0C
  55C7CC12: 1C                    db_op_1C   0x1C
  55C7CC13: FA E0 FF 7F           ext_fa_E0  0x7FFF
  55C7CC17: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7CC18: 1E                    db_op_1E   0x1E
  55C7CC19: EA                    add        d2, d2
  55C7CC1A: 91 F1                 mov        0xF1, a1
  55C7CC1C: 69                    mov        (a1), d2
  55C7CC1D: F0 65                 ext_f0_65  
  55C7CC1F: FC C9 FF FF 00 00     ext_fc_C9  0x0000FFFF
  55C7CC25: C8 15                 beq        loc_55C7CC3A
  55C7CC27: FA E1 FF 7F           ext_fa_E1  0x7FFF
  55C7CC2B: A1                    db_op_A1   0xA1
  55C7CC2C: C9 06                 bne        loc_55C7CC32
  55C7CC2E: 80 01                 mov        0x01, d0
  55C7CC30: CA 0B                 bra        loc_55C7CC3B
loc_55C7CC32:
  55C7CC32: 4C                    db_op_4C   0x4C
  55C7CC33: 8E                    mov        d3, d2
  55C7CC34: 1F                    db_op_1F   0x1F
  55C7CC35: FA CB 00 01           bxx16      loc_55C7CD35
  55C7CC39: D0                    lblt       
loc_55C7CC3A:
  55C7CC3A: 00                    db_op_00   0x00
loc_55C7CC3B:
  55C7CC3B: DE E0 0C              retf       [d2,d3,a2], 12

; --- Function sub_55C7CC3E (callers: 1) ---
sub_55C7CC3E:
  55C7CC3E: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7CC44: 85                    mov        d1, d1
  55C7CC45: FF                    db_op_FF   0xFF
  55C7CC46: F8 C0 03              ext_f8_C0  0x03
  55C7CC49: FC DE 44 0B 20 54     mov        0x54200B44, a2
  55C7CC4F: 98                    mov        a2, a0
  55C7CC50: F1 60                 ext_f1_60  
  55C7CC52: 64                    mov        (a0), d1
  55C7CC53: F8 14 04              ext_f8_14  0x04
  55C7CC56: 00                    db_op_00   0x00
  55C7CC57: FC 82 24 0B 20 54     mov        d2, (0x54200B24)
  55C7CC5D: FC 82 25 0B 20 54     mov        d2, (0x54200B25)
  55C7CC63: 82 0C                 mov        0x0C, d2
loc_55C7CC65:
  55C7CC65: FC 8A 23 0B 20 54     movhu      d2, (0x54200B23)
  55C7CC6B: 00                    db_op_00   0x00
  55C7CC6C: FC 82 30 0B 20 54     mov        d2, (0x54200B30)
  55C7CC72: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CC78: CD 5C FC 20 08        call       sub_55C7C8D4, [a2], 8
  55C7CC7D: FC A8 30 0B 20 54     ext_fc_A8  0x54200B30
  55C7CC83: A0                    db_op_A0   0xA0
  55C7CC84: 02                    db_op_02   0x02
  55C7CC85: C2 10                 bge        loc_55C7CC95
  55C7CC87: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CC8D: F0 40                 ext_f0_40  
  55C7CC8F: FA C8 C9 00           bxx16      loc_55C7CD58
  55C7CC93: C8 09                 beq        loc_55C7CC9C
loc_55C7CC95:
  55C7CC95: 4C                    db_op_4C   0x4C
  55C7CC96: 8E                    mov        d3, d2
  55C7CC97: 17                    db_op_17   0x17
  55C7CC98: AF                    db_op_AF   0xAF
  55C7CC99: 04                    db_op_04   0x04
  55C7CC9A: C0 CB                 blt        loc_55C7CC65
loc_55C7CC9C:
  55C7CC9C: AF                    db_op_AF   0xAF
  55C7CC9D: 04                    db_op_04   0x04
  55C7CC9E: C9 05                 bne        loc_55C7CCA3
  55C7CCA0: CC 33 01              jmp        loc_55C7CDD3
loc_55C7CCA3:
  55C7CCA3: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CCA9: FC AA 31 0B 20 54     ext_fc_AA  0x54200B31
  55C7CCAF: F8 40 06              ext_f8_40  0x06
  55C7CCB2: 8B                    mov        d2, d3
  55C7CCB3: F1 E3                 ext_f1_E3  
  55C7CCB5: F8 40 07              ext_f8_40  0x07
  55C7CCB8: 17                    db_op_17   0x17
  55C7CCB9: F8 93 04              movbu      d0, (4, a3)
  55C7CCBC: AF                    db_op_AF   0xAF
  55C7CCBD: 03                    db_op_03   0x03
  55C7CCBE: C3 3A                 ble        loc_55C7CCF8
loc_55C7CCC0:
  55C7CCC0: FC 8A 23 0B 20 54     movhu      d2, (0x54200B23)
  55C7CCC6: 00                    db_op_00   0x00
  55C7CCC7: FC 82 30 0B 20 54     mov        d2, (0x54200B30)
  55C7CCCD: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CCD3: CD 01 FC 20 08        call       sub_55C7C8D4, [a2], 8
  55C7CCD8: FC A8 30 0B 20 54     ext_fc_A8  0x54200B30
  55C7CCDE: A0                    db_op_A0   0xA0
  55C7CCDF: 02                    db_op_02   0x02
  55C7CCE0: C2 10                 bge        loc_55C7CCF0
  55C7CCE2: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CCE8: F0 40                 ext_f0_40  
  55C7CCEA: FA C8 C9 00           bxx16      loc_55C7CDB3
  55C7CCEE: C8 0A                 beq        loc_55C7CCF8
loc_55C7CCF0:
  55C7CCF0: 2B FF                 cmp        0xFF, d3
  55C7CCF2: 8E                    mov        d3, d2
  55C7CCF3: 17                    db_op_17   0x17
  55C7CCF4: AF                    db_op_AF   0xAF
  55C7CCF5: 03                    db_op_03   0x03
  55C7CCF6: C1 CA                 bgt        loc_55C7CCC0
loc_55C7CCF8:
  55C7CCF8: AF                    db_op_AF   0xAF
  55C7CCF9: 03                    db_op_03   0x03
  55C7CCFA: C9 05                 bne        loc_55C7CCFF
  55C7CCFC: CC D7 00              jmp        loc_55C7CDD3
loc_55C7CCFF:
  55C7CCFF: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CD05: F8 60 02              ext_f8_60  0x02
  55C7CD08: FC 83 3C 0B 20 54     mov        d3, (0x54200B3C)
  55C7CD0E: F1 DD                 ext_f1_DD  
  55C7CD10: 1D                    db_op_1D   0x1D
  55C7CD11: 84                    mov        d1, d0
  55C7CD12: F8 C0 05              ext_f8_C0  0x05
  55C7CD15: FC 82 23 0B 20 54     mov        d2, (0x54200B23)
  55C7CD1B: 84                    mov        d1, d0
  55C7CD1C: F8 C8 03              ext_f8_C8  0x03
  55C7CD1F: FC 82 24 0B 20 54     mov        d2, (0x54200B24)
  55C7CD25: F8 C9 0B              ext_f8_C9  0x0B
  55C7CD28: FC 86 25 0B 20 54     movb       d2, (0x54200B25)
  55C7CD2E: 00                    db_op_00   0x00
  55C7CD2F: FC 82 30 0B 20 54     mov        d2, (0x54200B30)
loc_55C7CD35:
  55C7CD35: CD 9F FB 20 08        call       sub_55C7C8D4, [a2], 8
  55C7CD3A: FC A8 30 0B 20 54     ext_fc_A8  0x54200B30
  55C7CD40: A0                    db_op_A0   0xA0
  55C7CD41: 02                    db_op_02   0x02
  55C7CD42: C2 13                 bge        loc_55C7CD55
  55C7CD44: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CD4A: F0 40                 ext_f0_40  
  55C7CD4C: FA C8 BB 00           bxx16      loc_55C7CE07
  55C7CD50: C9 05                 bne        loc_55C7CD55
  55C7CD52: CC 85 00              jmp        loc_55C7CDD7
loc_55C7CD55:
  55C7CD55: F8 BD 04              ext_f8_BD  0x04
loc_55C7CD58:
  55C7CD58: 84                    mov        d1, d0
  55C7CD59: F8 C0 05              ext_f8_C0  0x05
  55C7CD5C: FC 82 23 0B 20 54     mov        d2, (0x54200B23)
  55C7CD62: 84                    mov        d1, d0
  55C7CD63: F8 C8 03              ext_f8_C8  0x03
  55C7CD66: FC 82 24 0B 20 54     mov        d2, (0x54200B24)
  55C7CD6C: F8 C9 0B              ext_f8_C9  0x0B
  55C7CD6F: FC 86 25 0B 20 54     movb       d2, (0x54200B25)
  55C7CD75: 00                    db_op_00   0x00
  55C7CD76: FC 82 30 0B 20 54     mov        d2, (0x54200B30)
  55C7CD7C: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CD82: CD 52 FB 20 08        call       sub_55C7C8D4, [a2], 8
  55C7CD87: FC A8 30 0B 20 54     ext_fc_A8  0x54200B30
  55C7CD8D: A0                    db_op_A0   0xA0
  55C7CD8E: 02                    db_op_02   0x02
  55C7CD8F: C2 44                 bge        loc_55C7CDD3
  55C7CD91: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CD97: F0 40                 ext_f0_40  
  55C7CD99: FA C8 BB 00           bxx16      loc_55C7CE54
  55C7CD9D: C8 04                 beq        loc_55C7CDA1
  55C7CD9F: CA 34                 bra        loc_55C7CDD3
loc_55C7CDA1:
  55C7CDA1: F8 BF 04              ext_f8_BF  0x04
  55C7CDA4: FC A8 36 0B 20 54     ext_fc_A8  0x54200B36
  55C7CDAA: F2 93                 ext_f2_93  
  55C7CDAC: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7CDB2: F8 C0 03              ext_f8_C0  0x03
  55C7CDB5: F1 62                 ext_f1_62  
  55C7CDB7: F8 1E 04              ext_f8_1E  0x04
  55C7CDBA: 00                    db_op_00   0x00
  55C7CDBB: FC 82 21 0B 20 54     mov        d2, (0x54200B21)
  55C7CDC1: FC 82 22 0B 20 54     mov        d2, (0x54200B22)
  55C7CDC7: 80 01                 mov        0x01, d0
  55C7CDC9: CD 41 FD 80 08        call       sub_55C7CB0A, [d2], 8
  55C7CDCE: 14                    db_op_14   0x14
  55C7CDCF: A0                    db_op_A0   0xA0
  55C7CDD0: 00                    db_op_00   0x00
  55C7CDD1: C8 36                 beq        loc_55C7CE07
loc_55C7CDD3:
  55C7CDD3: 80 01                 mov        0x01, d0
  55C7CDD5: CA 33                 bra        loc_55C7CE08
loc_55C7CDD7:
  55C7CDD7: FC A8 36 0B 20 54     ext_fc_A8  0x54200B36
  55C7CDDD: F1 DF                 ext_f1_DF  
  55C7CDDF: 1F                    db_op_1F   0x1F
  55C7CDE0: F2 93                 ext_f2_93  
  55C7CDE2: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7CDE8: F8 C0 03              ext_f8_C0  0x03
  55C7CDEB: F3 72                 ext_f3_72  
  55C7CDED: 00                    db_op_00   0x00
  55C7CDEE: FC 82 21 0B 20 54     mov        d2, (0x54200B21)
  55C7CDF4: FC 82 22 0B 20 54     mov        d2, (0x54200B22)
  55C7CDFA: CD 10 FD 80 08        call       sub_55C7CB0A, [d2], 8
  55C7CDFF: 14                    db_op_14   0x14
  55C7CE00: A0                    db_op_A0   0xA0
  55C7CE01: 00                    db_op_00   0x00
  55C7CE02: C8 05                 beq        loc_55C7CE07
  55C7CE04: CC 51 FF              jmp        loc_55C7CD55
loc_55C7CE07:
  55C7CE07: 00                    db_op_00   0x00
loc_55C7CE08:
  55C7CE08: DF F0 18              ret        [d2,d3,a2,a3], 24

; --- Function sub_55C7CE0B (callers: 1) ---
sub_55C7CE0B:
  55C7CE0B: FC AA 20 0B 20 54     ext_fc_AA  0x54200B20
  55C7CE11: 80 01                 mov        0x01, d0
  55C7CE13: F1 E9                 ext_f1_E9  
  55C7CE15: FC D1 31 0B 20 54     add        0x54200B31, d1
  55C7CE1B: FC DC 2E 0B 20 54     mov        0x54200B2E, a0
  55C7CE21: F4 48                 ext_f4_48  
  55C7CE23: 88                    mov        d2, d0
  55C7CE24: E0                    add        d0, d0
  55C7CE25: 85                    mov        d1, d1
  55C7CE26: 20 FC                 add        -4, d0
  55C7CE28: DC 54 0D 20 54        jmp        0xA9E7DB7C
  55C7CE2D: F4 D0                 ext_f4_D0  
  55C7CE2F: 85                    mov        d1, d1
  55C7CE30: 05                    db_op_05   0x05
  55C7CE31: FC 86 36 0B 20 54     movb       d2, (0x54200B36)
  55C7CE37: 85                    mov        d1, d1
  55C7CE38: 1F                    db_op_1F   0x1F
  55C7CE39: F0 55                 ext_f0_55  
  55C7CE3B: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7CE41: F8 44 01              ext_f8_44  0x01
  55C7CE44: A5                    db_op_A5   0xA5
  55C7CE45: 73                    mov        d0, (a3)
  55C7CE46: C8 19                 beq        loc_55C7CE5F
  55C7CE48: A5                    db_op_A5   0xA5
  55C7CE49: 33                    db_op_33   0x33
  55C7CE4A: C8 15                 beq        loc_55C7CE5F
  55C7CE4C: A5                    db_op_A5   0xA5
  55C7CE4D: 75                    mov        d1, (a1)
  55C7CE4E: C8 45                 beq        loc_55C7CE93
  55C7CE50: A5                    db_op_A5   0xA5
  55C7CE51: 35                    db_op_35   0x35
  55C7CE52: C8 41                 beq        loc_55C7CE93
loc_55C7CE54:
  55C7CE54: A5                    db_op_A5   0xA5
  55C7CE55: 76                    mov        d1, (a2)
  55C7CE56: C8 72                 beq        loc_55C7CEC8
  55C7CE58: A5                    db_op_A5   0xA5
  55C7CE59: 36                    db_op_36   0x36
  55C7CE5A: C8 6E                 beq        loc_55C7CEC8
  55C7CE5C: CC A9 00              jmp        loc_55C7CF05
loc_55C7CE5F:
  55C7CE5F: 85                    mov        d1, d1
  55C7CE60: 01                    db_op_01   0x01
  55C7CE61: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7CE67: F4 58                 ext_f4_58  
  55C7CE69: 2D 00 04              mov        0x0400, d1
  55C7CE6C: FC DC 2C 0B 20 54     mov        0x54200B2C, a0
  55C7CE72: F4 D0                 ext_f4_D0  
  55C7CE74: 2D E8 03              mov        0x03E8, d1
  55C7CE77: FC DC 3E 0B 20 54     mov        0x54200B3E, a0
  55C7CE7D: F4 D0                 ext_f4_D0  
  55C7CE7F: 85                    mov        d1, d1
  55C7CE80: 40 FC                 mov        a0, (252, sp)
  55C7CE82: DC 3A 0B 20 54        jmp        0xA9E7D9BC
  55C7CE87: F4 D0                 ext_f4_D0  
  55C7CE89: 88                    mov        d2, d0
  55C7CE8A: 54                    db_op_54   0x54
  55C7CE8B: FC CD 00 80 00 00     mov        0x00008000, d1
  55C7CE91: CA 6A                 bra        loc_55C7CEFB
loc_55C7CE93:
  55C7CE93: 85                    mov        d1, d1
  55C7CE94: 02                    db_op_02   0x02
  55C7CE95: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7CE9B: F4 58                 ext_f4_58  
  55C7CE9D: 2D 00 08              mov        0x0800, d1
  55C7CEA0: FC DC 2C 0B 20 54     mov        0x54200B2C, a0
  55C7CEA6: F4 D0                 ext_f4_D0  
  55C7CEA8: 2D D0 07              mov        0x07D0, d1
  55C7CEAB: FC DC 3E 0B 20 54     mov        0x54200B3E, a0
  55C7CEB1: F4 D0                 ext_f4_D0  
  55C7CEB3: 2D 80 00              mov        0x0080, d1
  55C7CEB6: FC DC 3A 0B 20 54     mov        0x54200B3A, a0
  55C7CEBC: F4 D0                 ext_f4_D0  
  55C7CEBE: 88                    mov        d2, d0
  55C7CEBF: 54                    db_op_54   0x54
  55C7CEC0: FC CD 00 00 01 00     mov        0x00010000, d1
  55C7CEC6: CA 35                 bra        loc_55C7CEFB
loc_55C7CEC8:
  55C7CEC8: 85                    mov        d1, d1
  55C7CEC9: 04                    db_op_04   0x04
  55C7CECA: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7CED0: F4 58                 ext_f4_58  
  55C7CED2: 2D 00 10              mov        0x1000, d1
  55C7CED5: FC DC 2C 0B 20 54     mov        0x54200B2C, a0
  55C7CEDB: F4 D0                 ext_f4_D0  
  55C7CEDD: 2D A0 0F              mov        0x0FA0, d1
  55C7CEE0: FC DC 3E 0B 20 54     mov        0x54200B3E, a0
  55C7CEE6: F4 D0                 ext_f4_D0  
  55C7CEE8: 2D 00 01              mov        0x0100, d1
  55C7CEEB: FC DC 3A 0B 20 54     mov        0x54200B3A, a0
  55C7CEF1: F4 D0                 ext_f4_D0  
  55C7CEF3: 88                    mov        d2, d0
  55C7CEF4: 54                    db_op_54   0x54
  55C7CEF5: FC CD 00 00 02 00     mov        0x00020000, d1
loc_55C7CEFB:
  55C7CEFB: FC DC 58 0D 20 54     mov        0x54200D58, a0
  55C7CF01: F3 50                 ext_f3_50  
  55C7CF03: CA 19                 bra        loc_55C7CF1C
loc_55C7CF05:
  55C7CF05: 00                    db_op_00   0x00
  55C7CF06: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7CF0C: F4 48                 ext_f4_48  
  55C7CF0E: 80 11                 mov        0x11, d0
  55C7CF10: FC DC 39 0B 20 54     mov        0x54200B39, a0
  55C7CF16: F4 48                 ext_f4_48  
  55C7CF18: 80 01                 mov        0x01, d0
  55C7CF1A: CA 0E                 bra        loc_55C7CF28
loc_55C7CF1C:
  55C7CF1C: F0 41                 ext_f0_41  
  55C7CF1E: FC DC 38 0B 20 54     mov        0x54200B38, a0
  55C7CF24: 40 F4                 mov        a0, (244, sp)
  55C7CF26: 48                    db_op_48   0x48
  55C7CF27: 00                    db_op_00   0x00
loc_55C7CF28:
  55C7CF28: DE 80 04              retf       [d2], 4

; --- Function sub_55C7CF2B (callers: 1) ---
sub_55C7CF2B:
  55C7CF2B: FC AB 20 0B 20 54     ext_fc_AB  0x54200B20
  55C7CF31: 8C                    mov        d3, d0
  55C7CF32: 54                    db_op_54   0x54
  55C7CF33: F1 E1                 ext_f1_E1  
  55C7CF35: FC D1 40 0B 20 54     add        0x54200B40, d1
  55C7CF3B: F0 01                 ext_f0_01  
  55C7CF3D: F8 44 02              ext_f8_44  0x02
  55C7CF40: F8 40 03              ext_f8_40  0x03
  55C7CF43: F8 C1 08              ext_f8_C1  0x08
  55C7CF46: F2 11                 ext_f2_11  
  55C7CF48: 1D                    db_op_1D   0x1D
  55C7CF49: FC AC 3C 0B 20 54     movhu      (0x54200B3C), d0
  55C7CF4F: 28 FB                 cmp        0xFB, d0
  55C7CF51: A1                    db_op_A1   0xA1
  55C7CF52: C1 69                 bgt        loc_55C7CFBB
  55C7CF54: 00                    db_op_00   0x00
  55C7CF55: FC 82 21 0B 20 54     mov        d2, (0x54200B21)
  55C7CF5B: FC 82 22 0B 20 54     mov        d2, (0x54200B22)
  55C7CF61: 8C                    mov        d3, d0
  55C7CF62: E0                    add        d0, d0
  55C7CF63: FC DC 54 0D 20 54     mov        0x54200D54, a0
  55C7CF69: F4 80                 ext_f4_80  
  55C7CF6B: FC DF 38 0B 20 54     mov        0x54200B38, a3
  55C7CF71: F6 04                 ext_f6_04  
  55C7CF73: F8 C0 09              ext_f8_C0  0x09
  55C7CF76: FC DE 00 00 C8 95     mov        0x95C80000, a2
  55C7CF7C: F1 62                 ext_f1_62  
  55C7CF7E: F4 0F                 ext_f4_0F  
  55C7CF80: 08                    db_op_08   0x08
  55C7CF81: A8                    db_op_A8   0xA8
  55C7CF82: C3 5B                 ble        loc_55C7CFDD
loc_55C7CF84:
  55C7CF84: 00                    db_op_00   0x00
  55C7CF85: FC 83 20 21 01 9C     mov        d3, (0x9C012120)               ; MMIO VENUS_FLASH_DMA_0x20
  55C7CF8B: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7CF91: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7CF97: CD D0 F8 00 00        call       sub_55C7C867, [], 0
  55C7CF9C: 80 30                 mov        0x30, d0
  55C7CF9E: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7CFA4: FC 83 18 21 01 9C     mov        d3, (0x9C012118)               ; MMIO VENUS_FLASH_DMA_0x18
  55C7CFAA: FC A1 40 0B 20 54     mov        (0x54200B40), d1
  55C7CFB0: 98                    mov        a2, a0
  55C7CFB1: CD 8D FA 00 04        call       sub_55C7CA3E, [], 4
  55C7CFB6: 14                    db_op_14   0x14
  55C7CFB7: A0                    db_op_A0   0xA0
  55C7CFB8: 00                    db_op_00   0x00
  55C7CFB9: C8 06                 beq        loc_55C7CFBF
loc_55C7CFBB:
  55C7CFBB: 80 01                 mov        0x01, d0
  55C7CFBD: CA 21                 bra        loc_55C7CFDE
loc_55C7CFBF:
  55C7CFBF: FC A8 23 0B 20 54     ext_fc_A8  0x54200B23
  55C7CFC5: FA D2 00 02           ext_fa_D2  0x0200
  55C7CFC9: 40 FC                 mov        a0, (252, sp)
  55C7CFCB: 82 23                 mov        0x23, d2
  55C7CFCD: 0B                    db_op_0B   0x0B
  55C7CFCE: 20 54                 add        84, d0
  55C7CFD0: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7CFD6: 48                    db_op_48   0x48
  55C7CFD7: F4 03                 ext_f4_03  
  55C7CFD9: 16                    db_op_16   0x16
  55C7CFDA: A2                    db_op_A2   0xA2
  55C7CFDB: C0 A9                 blt        loc_55C7CF84
loc_55C7CFDD:
  55C7CFDD: 00                    db_op_00   0x00
loc_55C7CFDE:
  55C7CFDE: DF F0 14              ret        [d2,d3,a2,a3], 20

; --- Function sub_55C7CFE1 (callers: 1) ---
sub_55C7CFE1:
  55C7CFE1: 00                    db_op_00   0x00
  55C7CFE2: FC 82 08 0B 20 54     mov        d2, (0x54200B08)
  55C7CFE8: FC 82 32 0B 20 54     mov        d2, (0x54200B32)
  55C7CFEE: 2C A3 00              mov        0x00A3, d0
  55C7CFF1: FC 83 00 21 01 9C     mov        d3, (0x9C012100)               ; MMIO VENUS_FLASH_DMA_0x00
  55C7CFF7: 80 08                 mov        0x08, d0
  55C7CFF9: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7CFFF: FC AC 06 21 01 9C     movhu      (0x9C012106), d0               ; MMIO VENUS_FLASH_DMA_0x06
  55C7D005: FC DE 04 21 01 9C     mov        0x9C012104, a2                 ; MMIO VENUS_FLASH_DMA_0x04
  55C7D00B: 85                    mov        d1, d1
  55C7D00C: 01                    db_op_01   0x01
  55C7D00D: F0 76                 ext_f0_76  
  55C7D00F: 04                    db_op_04   0x04
  55C7D010: FC 86 20 0B 20 54     movb       d2, (0x54200B20)
  55C7D016: FC 86 30 0B 20 54     movb       d2, (0x54200B30)
  55C7D01C: FC 86 39 0B 20 54     movb       d2, (0x54200B39)
  55C7D022: F8 C8 08              ext_f8_C8  0x08
  55C7D025: F8 EC 01              ext_f8_EC  0x01
  55C7D028: C9 0D                 bne        loc_55C7D035
  55C7D02A: 80 17                 mov        0x17, d0
  55C7D02C: FC 82 39 0B 20 54     mov        d2, (0x54200B39)
  55C7D032: CC 30 02              jmp        loc_55C7D262
loc_55C7D035:
  55C7D035: FC 86 21 0B 20 54     movb       d2, (0x54200B21)
  55C7D03B: FC 86 22 0B 20 54     movb       d2, (0x54200B22)
  55C7D041: 2C FF 00              mov        0x00FF, d0
  55C7D044: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7D04A: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7D050: 00                    db_op_00   0x00
  55C7D051: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7D057: 2F 00 01              mov        0x0100, d3
  55C7D05A: F0 7E                 ext_f0_7E  
  55C7D05C: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D062: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D066: C8 0E                 beq        loc_55C7D074
  55C7D068: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7D069: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D06F: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D073: D9                    lbne       
loc_55C7D074:
  55C7D074: 2C 02 01              mov        0x0102, d0
  55C7D077: F0 72                 ext_f0_72  
  55C7D079: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D07F: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D083: C8 0E                 beq        loc_55C7D091
  55C7D085: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7D086: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D08C: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D090: D9                    lbne       
loc_55C7D091:
  55C7D091: 2C 90 00              mov        0x0090, d0
  55C7D094: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7D09A: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7D0A0: CD C7 F7 00 00        call       sub_55C7C867, [], 0
  55C7D0A5: 00                    db_op_00   0x00
  55C7D0A6: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7D0AC: 2C A3 00              mov        0x00A3, d0
  55C7D0AF: FC 83 00 21 01 9C     mov        d3, (0x9C012100)               ; MMIO VENUS_FLASH_DMA_0x00
  55C7D0B5: F0 7E                 ext_f0_7E  
  55C7D0B7: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D0BD: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D0C1: C8 0E                 beq        loc_55C7D0CF
  55C7D0C3: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7D0C4: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D0CA: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D0CE: D9                    lbne       
loc_55C7D0CF:
  55C7D0CF: FC CC 06 80 00 00     mov        0x00008006, d0
  55C7D0D5: F0 72                 ext_f0_72  
  55C7D0D7: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D0DD: FA E0 00 80           ext_fa_E0  0x8000
  55C7D0E1: C8 0E                 beq        loc_55C7D0EF
  55C7D0E3: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7D0E4: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D0EA: FA E0 00 80           ext_fa_E0  0x8000
  55C7D0EE: D9                    lbne       
loc_55C7D0EF:
  55C7D0EF: FC AC 08 21 01 9C     movhu      (0x9C012108), d0               ; MMIO VENUS_FLASH_DMA_0x08
  55C7D0F5: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7D0FB: F8 E0 FF              ext_f8_E0  0xFF
  55C7D0FE: F0 50                 ext_f0_50  
  55C7D100: FC AC 08 21 01 9C     movhu      (0x9C012108), d0               ; MMIO VENUS_FLASH_DMA_0x08
  55C7D106: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7D10C: FA E0 00 FF           ext_fa_E0  0xFF00
  55C7D110: F8 C8 08              ext_f8_C8  0x08
  55C7D113: F8 50 01              ext_f8_50  0x01
  55C7D116: CD F5 FC 80 04        call       sub_55C7CE0B, [d2], 4
  55C7D11B: 14                    db_op_14   0x14
  55C7D11C: A0                    db_op_A0   0xA0
  55C7D11D: 00                    db_op_00   0x00
  55C7D11E: C8 05                 beq        loc_55C7D123
  55C7D120: CC 42 01              jmp        loc_55C7D262
loc_55C7D123:
  55C7D123: CD 1B FB F0 18        call       sub_55C7CC3E, [d2,d3,a2,a3], 24
  55C7D128: 14                    db_op_14   0x14
  55C7D129: A0                    db_op_A0   0xA0
  55C7D12A: 00                    db_op_00   0x00
  55C7D12B: C8 05                 beq        loc_55C7D130
  55C7D12D: CC 35 01              jmp        loc_55C7D262
loc_55C7D130:
  55C7D130: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7D136: FC DC 2E 0B 20 54     mov        0x54200B2E, a0
  55C7D13C: F4 00                 ext_f4_00  
  55C7D13E: A0                    db_op_A0   0xA0
  55C7D13F: 00                    db_op_00   0x00
  55C7D140: C8 06                 beq        loc_55C7D146
  55C7D142: 80 04                 mov        0x04, d0
  55C7D144: CA 04                 bra        loc_55C7D148
loc_55C7D146:
  55C7D146: 80 02                 mov        0x02, d0
loc_55C7D148:
  55C7D148: FC 82 21 0B 20 54     mov        d2, (0x54200B21)
  55C7D14E: FC A8 21 0B 20 54     ext_fc_A8  0x54200B21
  55C7D154: 8A                    mov        d2, d2
  55C7D155: 04                    db_op_04   0x04
  55C7D156: F8 92 04              movbu      d0, (4, a2)
  55C7D159: FC AC 3C 0B 20 54     movhu      (0x54200B3C), d0
  55C7D15F: A8                    db_op_A8   0xA8
  55C7D160: C1 05                 bgt        loc_55C7D165
  55C7D162: CC 04 01              jmp        loc_55C7D266
loc_55C7D165:
  55C7D165: FC DF 40 0B 20 54     mov        0x54200B40, a3
loc_55C7D16B:
  55C7D16B: 88                    mov        d2, d0
  55C7D16C: FC A0 28 0B 20 54     mov        (0x54200B28), d0
  55C7D172: CD 9E FA E0 0C        call       sub_55C7CC10, [d2,d3,a2], 12
  55C7D177: 14                    db_op_14   0x14
  55C7D178: A0                    db_op_A0   0xA0
  55C7D179: 00                    db_op_00   0x00
  55C7D17A: C8 05                 beq        loc_55C7D17F
  55C7D17C: CC D8 00              jmp        loc_55C7D254
loc_55C7D17F:
  55C7D17F: 88                    mov        d2, d0
  55C7D180: F8 C0 05              ext_f8_C0  0x05
  55C7D183: FC 82 23 0B 20 54     mov        d2, (0x54200B23)
  55C7D189: 88                    mov        d2, d0
  55C7D18A: F8 C8 03              ext_f8_C8  0x03
  55C7D18D: FC 82 24 0B 20 54     mov        d2, (0x54200B24)
  55C7D193: 88                    mov        d2, d0
  55C7D194: F8 C8 0B              ext_f8_C8  0x0B
  55C7D197: FC 82 25 0B 20 54     mov        d2, (0x54200B25)
  55C7D19D: 80 50                 mov        0x50, d0
  55C7D19F: FC 82 37 0B 20 54     mov        d2, (0x54200B37)
  55C7D1A5: FC 83 10 21 01 9C     mov        d3, (0x9C012110)               ; MMIO VENUS_FLASH_DMA_0x10
  55C7D1AB: CD BC F6 00 00        call       sub_55C7C867, [], 0
  55C7D1B0: 00                    db_op_00   0x00
  55C7D1B1: FC 83 20 21 01 9C     mov        d3, (0x9C012120)               ; MMIO VENUS_FLASH_DMA_0x20
  55C7D1B7: 80 08                 mov        0x08, d0
  55C7D1B9: FC 83 02 21 01 9C     mov        d3, (0x9C012102)               ; MMIO VENUS_FLASH_DMA_0x02
  55C7D1BF: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7D1C5: FC DC 2F 0B 20 54     mov        0x54200B2F, a0
  55C7D1CB: F4 00                 ext_f4_00  
  55C7D1CD: A0                    db_op_A0   0xA0
  55C7D1CE: 04                    db_op_04   0x04
  55C7D1CF: C0 23                 blt        loc_55C7D1F2
  55C7D1D1: F0 7E                 ext_f0_7E  
  55C7D1D3: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D1D9: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D1DD: C8 0E                 beq        loc_55C7D1EB
  55C7D1DF: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7D1E0: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D1E6: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D1EA: D9                    lbne       
loc_55C7D1EB:
  55C7D1EB: 2C 76 07              mov        0x0776, d0
  55C7D1EE: F0 72                 ext_f0_72  
  55C7D1F0: CA 21                 bra        loc_55C7D211
loc_55C7D1F2:
  55C7D1F2: F0 7E                 ext_f0_7E  
  55C7D1F4: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D1FA: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D1FE: C8 0E                 beq        loc_55C7D20C
  55C7D200: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7D201: FC AC 04 21 01 9C     movhu      (0x9C012104), d0               ; MMIO VENUS_FLASH_DMA_0x04
  55C7D207: FA EC FF FF           ext_fa_EC  0xFFFF
  55C7D20B: D9                    lbne       
loc_55C7D20C:
  55C7D20C: 2C 36 07              mov        0x0736, d0
  55C7D20F: F0 72                 ext_f0_72  
loc_55C7D211:
  55C7D211: 00                    db_op_00   0x00
  55C7D212: FC 82 30 0B 20 54     mov        d2, (0x54200B30)
  55C7D218: 80 01                 mov        0x01, d0
  55C7D21A: FC 82 08 0B 20 54     mov        d2, (0x54200B08)
  55C7D220: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7D226: 85                    mov        d1, d1
  55C7D227: 01                    db_op_01   0x01
  55C7D228: 54                    db_op_54   0x54
  55C7D229: F3 83                 ext_f3_83  
  55C7D22B: 80 08                 mov        0x08, d0
  55C7D22D: CD 77 F7 E0 14        call       sub_55C7C9A4, [d2,d3,a2], 20
  55C7D232: FC A8 20 0B 20 54     ext_fc_A8  0x54200B20
  55C7D238: 54                    db_op_54   0x54
  55C7D239: F3 83                 ext_f3_83  
  55C7D23B: F0 40                 ext_f0_40  
  55C7D23D: A0                    db_op_A0   0xA0
  55C7D23E: 59 C9                 mov        (201, sp), d1
  55C7D240: 15                    db_op_15   0x15
  55C7D241: CD EA FC F0 14        call       sub_55C7CF2B, [d2,d3,a2,a3], 20
  55C7D246: 14                    db_op_14   0x14
  55C7D247: A0                    db_op_A0   0xA0
  55C7D248: 00                    db_op_00   0x00
  55C7D249: C9 19                 bne        loc_55C7D262
  55C7D24B: F8 B8 04              ext_f8_B8  0x04
  55C7D24E: FC 82 21 0B 20 54     mov        d2, (0x54200B21)
loc_55C7D254:
  55C7D254: FC AC 3C 0B 20 54     movhu      (0x54200B3C), d0
  55C7D25A: 48                    db_op_48   0x48
  55C7D25B: 1E                    db_op_1E   0x1E
  55C7D25C: A2                    db_op_A2   0xA2
  55C7D25D: C2 09                 bge        loc_55C7D266
  55C7D25F: CC 0C FF              jmp        loc_55C7D16B
loc_55C7D262:
  55C7D262: 80 01                 mov        0x01, d0
  55C7D264: CA 14                 bra        loc_55C7D278
loc_55C7D266:
  55C7D266: 2C A3 00              mov        0x00A3, d0
  55C7D269: FC 83 00 21 01 9C     mov        d3, (0x9C012100)               ; MMIO VENUS_FLASH_DMA_0x00
  55C7D26F: 80 08                 mov        0x08, d0
  55C7D271: FC 83 06 21 01 9C     mov        d3, (0x9C012106)               ; MMIO VENUS_FLASH_DMA_0x06
  55C7D277: 00                    db_op_00   0x00
loc_55C7D278:
  55C7D278: DF F0 18              ret        [d2,d3,a2,a3], 24

; --- Function sub_55C7D27B (callers: 1) ---
sub_55C7D27B:
  55C7D27B: F1 D0                 ext_f1_D0  
  55C7D27D: FC 83 02 10 01 9C     mov        d3, (0x9C011002)
  55C7D283: F8 C4 10              ext_f8_C4  0x10
  55C7D286: FA E0 FF 0F           ext_fa_E0  0x0FFF
  55C7D28A: FC 83 04 10 01 9C     mov        d3, (0x9C011004)
  55C7D290: 00                    db_op_00   0x00
  55C7D291: FC 83 08 10 01 9C     mov        d3, (0x9C011008)
  55C7D297: 2C C0 54              mov        0x54C0, d0
  55C7D29A: FC 83 82 01 00 9C     mov        d3, (0x9C000182)               ; MMIO VENUS_SYSCLK_PLL_0x182
  55C7D2A0: 2C 1C 21              mov        0x211C, d0
  55C7D2A3: FC 83 86 01 00 9C     mov        d3, (0x9C000186)               ; MMIO VENUS_SYSCLK_PLL_0x186
  55C7D2A9: 80 01                 mov        0x01, d0
  55C7D2AB: FC 83 88 01 00 9C     mov        d3, (0x9C000188)               ; MMIO VENUS_SYSCLK_PLL_0x188
  55C7D2B1: 2D 00 12              mov        0x1200, d1
  55C7D2B4: FC 87 8A 01 00 9C     movb       d3, (0x9C00018A)               ; MMIO VENUS_SYSCLK_PLL_0x18A
  55C7D2BA: FC CD 01 9C 00 00     mov        0x00009C01, d1
  55C7D2C0: FC 87 8C 01 00 9C     movb       d3, (0x9C00018C)               ; MMIO VENUS_SYSCLK_PLL_0x18C
  55C7D2C6: 2D 00 02              mov        0x0200, d1
  55C7D2C9: FC 87 8E 01 00 9C     movb       d3, (0x9C00018E)               ; MMIO VENUS_SYSCLK_PLL_0x18E
  55C7D2CF: 04                    db_op_04   0x04
  55C7D2D0: FC 87 90 01 00 9C     movb       d3, (0x9C000190)               ; MMIO VENUS_SYSCLK_PLL_0x190
  55C7D2D6: FC 87 80 01 00 9C     movb       d3, (0x9C000180)               ; MMIO VENUS_SYSCLK_PLL_0x180
  55C7D2DC: FC 83 84 01 00 9C     mov        d3, (0x9C000184)               ; MMIO VENUS_SYSCLK_PLL_0x184
  55C7D2E2: CB                    nop        
  55C7D2E3: CB                    nop        
  55C7D2E4: CB                    nop        
  55C7D2E5: 38                    db_op_38   0x38
  55C7D2E6: 88                    mov        d2, d0
  55C7D2E7: 89                    mov        d2, d1
  55C7D2E8: F8 EC 40              ext_f8_EC  0x40
  55C7D2EB: C9 0A                 bne        loc_55C7D2F5
  55C7D2ED: DB                    setlb                                     ; Load next 4 bytes into LIR hardware loop buffer
  55C7D2EE: 38                    db_op_38   0x38
  55C7D2EF: 88                    mov        d2, d0
  55C7D2F0: 89                    mov        d2, d1
  55C7D2F1: F8 EC 40              ext_f8_EC  0x40
  55C7D2F4: D8                    lbeq       
loc_55C7D2F5:
  55C7D2F5: 38                    db_op_38   0x38
  55C7D2F6: 88                    mov        d2, d0
  55C7D2F7: 89                    mov        d2, d1
  55C7D2F8: FA E0 00 FB           ext_fa_E0  0xFB00
  55C7D2FC: F8 E4 04              ext_f8_E4  0x04
  55C7D2FF: 03                    db_op_03   0x03
  55C7D300: 88                    mov        d2, d0
  55C7D301: 89                    mov        d2, d1
  55C7D302: F0 FC                 rets       
  55C7D304: 00                    db_op_00   0x00
