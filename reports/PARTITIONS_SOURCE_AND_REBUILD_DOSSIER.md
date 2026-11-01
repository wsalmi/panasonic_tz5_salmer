# Panasonic Lumix DMC-TZ5 (`TZ5_a.bin`) — Dossiê de Engenharia Reversa, Código-Fonte Modular e Reconstrução das 7 Partições (`part_00` a `part_06`)

## 1. Identidade de Artefatos e Registro REA por Partição

Cada uma das 7 partições extraídas em [`output/partitions/`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions) foi inspecionada e registrada individualmente no ledger do **Reverse Engineer Anything (REA)** ([`reports/evidence_bundle.json`](file:///Users/wesleysalmi/source-me/tz5-rea/reports/evidence_bundle.json), 27 registros de evidência), mapeada ao seu endereço virtual na CPU **Matsushita MN10300 / MN103S (AM33)** ($\text{VA} = \text{UnpackedOffset} + \text{0x55C7C000}$) e implementada como um módulo de código-fonte C++20 editável e recompilável em [`partitions_src/`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src):

| Partição | Arquivo `.bin` | Offset Flash (Unpacked) | Endereço Virtual (VA) | Tamanho Base (Cave Livre) | SHA-256 Original | REA Evidence ID (`inspect_artifact`) | Módulo de Código-Fonte C++20 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`part_00`** | [`part_00_0x000000_0x001305.bin`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions/part_00_0x000000_0x001305.bin) | `0x000000..0x001305` | `0x55C7C000..0x55C7D305` | `4.869 B` (`+11.515 B` até `0x004000`) | `746164f8860bd483...` | `ev_2a77ce06d889473bea4de5ee8738aefd66fba752dc805aac44ab907818a3f3da` | [`part_00.hpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_00_bootloader/part_00.hpp) / [`part_00.cpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_00_bootloader/part_00.cpp) |
| **`part_01`** | [`part_01_0x004000_0x0049f2.bin`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions/part_01_0x004000_0x0049f2.bin) | `0x004000..0x0049F2` | `0x55C80000..0x55C809F2` | `2.546 B` (`+13.838 B` até `0x008000`) | `93de706269e2dd0b...` | `ev_20a0133a9d605ff899bbf5c8f10a9173e701d5f47c5cbeebbc9c722701e0f62b` | [`part_01.hpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_01_vectors_init/part_01.hpp) / [`part_01.cpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_01_vectors_init/part_01.cpp) |
| **`part_02`** | [`part_02_0x008000_0x21f428.bin`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions/part_02_0x008000_0x21f428.bin) | `0x008000..0x21F428` | `0x55C84000..0x55E9B428` | `2.192.424 B` (`+19.416 B` até `0x224000`) | `c0717019149caa0c...` | `ev_1bbdae1883713739fda02e5fce3ed5c88cd001e93530af6a9dd9d1c04eedab68` | [`part_02.hpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_02_main_firmware/part_02.hpp) / [`part_02.cpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_02_main_firmware/part_02.cpp) |
| **`part_03`** | [`part_03_0x224000_0x31f118.bin`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions/part_03_0x224000_0x31f118.bin) | `0x224000..0x31F118` | `0x55EA0000..0x55F9B118` | `1.028.376 B` (`+313.064 B` até `0x36B800`) | `c29d3592b4d8cec9...` | `ev_bfea28937a85208940f8156388aee0b05e10d32ea20643ace8882213e9615172` | [`part_03.hpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_03_osd_ui/part_03.hpp) / [`part_03.cpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_03_osd_ui/part_03.cpp) |
| **`part_04`** | [`part_04_0x36b800_0x36b804.bin`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions/part_04_0x36b800_0x36b804.bin) | `0x36B800..0x36B804` | `0x55FE7800..0x55FE7804` | `4 B` (`+34.812 B` até `0x374000`) | `b420830d2ab6f7f0...` | `ev_836778a76859ffc891e135718b7208f9dd4cd15fcf0fc421181b9d659620de2c` | [`part_04.hpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_04_flash_stub/part_04.hpp) / [`part_04.cpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_04_flash_stub/part_04.cpp) |
| **`part_05`** | [`part_05_0x374000_0x480f08.bin`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions/part_05_0x374000_0x480f08.bin) | `0x374000..0x480F08` | `0x55FF0000..0x560FCF08` | `1.101.576 B` (`+12.536 B` até `0x484000`) | `f5588074d8a4d1f1...` | `ev_c6e9740541df83835fc86bc158e5e961f3c212b783e6641ea74303c66b52bce9` | [`part_05.hpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_05_resource_tables/part_05.hpp) / [`part_05.cpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_05_resource_tables/part_05.cpp) |
| **`part_06`** | [`part_06_0x484000_0x484020.bin`](file:///Users/wesleysalmi/source-me/tz5-rea/output/partitions/part_06_0x484000_0x484020.bin) | `0x484000..0x484020` | `0x56100000..0x56100020` | `32 B` (Linha `147.968` da matriz 2D) | `b7b25a6e3e917f7a...` | `ev_0b97032c09f8891c07077289b35967440a949db77f9f74b22c8dcfb89c5d9b8b` | [`part_06.hpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_06_parity_trailer/part_06.hpp) / [`part_06.cpp`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_06_parity_trailer/part_06.cpp) |

---

## 2. Análise Detalhada e Código-Fonte de Cada Partição

### 2.1 Partição 00 (`part_00_bootloader` — `0x000000..0x001305` | `VA 0x55C7C000..0x55C7D305`)
- **Papel Arquitetural**: Bootloader primário e motor de gravação NOR Flash (`boot_reset_entry` em `0x55C7C000` e `boot_flash_updater_main` em `0x55C7C0E3`).
- **Mapeamento de Memória e Periféricos**:
  - Carrega `0x54080000` em `a0` como ponteiro base de boot/stack inicial.
  - Inicializa controladores de clock/PLL (`0x9C000000`), barramento (`0x9C00C000`) e DMA de Flash (`0x9C012100`).
  - Copia dois blocos críticos de programação de flash da ROM para a **Fast RAM on-chip** (`0x400001E4` e `0x4000071C`) e espelha a imagem de trabalho em `0x54200000` (SDRAM), permitindo apagar/gravar blocos da NOR Flash sem executar a partir da própria Flash.
- **Como alterar / adicionar recursos ([`Part00Bootloader`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_00_bootloader/part_00.hpp))**:
  - `set_initial_boot_target_va(uint32_t new_va)`: Altera o endereço inicial carregado em `0x55C7C000`.
  - `append_early_boot_extension(name, asm_lines, &out_va)`: Compila e anexa novas rotinas MN103S na cave de `11.515` bytes (`0x001305..0x004000`).

### 2.2 Partição 01 (`part_01_vectors_init` — `0x004000..0x0049F2` | `VA 0x55C80000..0x55C809F2`)
- **Papel Arquitetural**: Tabela de Vetores de Reset e Interrupção de Hardware da CPU MN103S e inicialização de RAM do Kernel RTOS.
- **Tabela de Vetores de 8 Bytes (`0x55C80000..0x55C8004F`)**:
  - **Slot 0 (`0x55C80000` — `vec_hardware_reset`)**: `fc dd 50 00 c8 55 f0 f5` (`mov 0x55C80050, a1; jmp (a1)` $\to$ `kernel_reset_handler`).
  - **Slot 1 (`0x55C80008` — `vec_nmi_entry`)**: `cc ff 00` (`jmp 0x55C80107` $\to$ `nmi_watchdog_handler`).
  - **Slot 2 (`0x55C80010` — `vec_trap_rti`)**: `f0 fd` (`rti`).
  - **Slots 3..9 (`0x55C80018..0x55C80048` — `vec_irq_group0..6`)**: `dc <disp32>` (`jmp 0x55E97FC7` $\to$ saltam para `venus_master_irq_dispatcher` na Partição 02e).
- **Inicialização de Memória do Kernel (`kernel_early_ram_init` @ `0x55C800D1`)**:
  - Zera o `.bss` do kernel em SDRAM (`0x5400042C..0x540127E4`, `74.680` bytes).
  - Copia os `44` bytes da imagem `.data` do kernel em `0x55C80638..0x55C80664` (`0x004638..0x004664`) para `0x54000400..0x5400042C`.
- **Como alterar / adicionar recursos ([`Part01VectorsInit`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_01_vectors_init/part_01.hpp))**:
  - `redirect_irq_vector_slot(slot_index, new_handler_va)`: Redireciona qualquer grupo de interrupção (`Slots 3..9`) para um novo ISR.
  - `set_kernel_data_word(word_index, value)`: Modifica palavras de 32 bits na imagem inicial `.data` do kernel (`0x54000400`).
  - `append_custom_isr(name, asm_lines, &out_va)`: Compila um novo ISR na cave de `13.838` bytes (`0x0049F2..0x008000`).

### 2.3 Partição 02 (`part_02_main_firmware` — `0x008000..0x21F428` | `VA 0x55C84000..0x55E9B428`)
- **Papel Arquitetural**: Contém 5 sub-segmentos fundamentais do executável principal `\TZ5.AHX`:
  1. **`02a` (`0x008000..0x013FFF` | `VA 0x55C84000..0x55C8FFFF`)**: Cabeçalho `"Pana"` (`00 00 50 61 6E 61 00 00`, versão `1.02` em `0x008008`), tabelas de descritores e Bloco de Identidade do Modelo em `0x013F00` (`Panasonic`, `DMC-TZ5`, `_PANA`, `TZ5__`, `LUMIX`).
  2. **`02b` (`0x014000..0x01F02C` | `VA 0x55C90000..0x55C9B02C` $\to$ `SDRAM 0x54012840..0x5401D86C`)**: Segmento `.data` inicializado (`45.100` bytes), contendo `1.119` ponteiros para ROM (`0x55xxxxxx`) e `341` ponteiros para SDRAM (`0x54xxxxxx`).
  3. **`02c` (`0x01F02C..0x1D8DC0` | `VA 0x55C9B02C..0x55E54DC0`)**: `CRT0` (`0x55C9B02C`), `CAVE_CRT0` (`0x55C9B080..0x55C9C000`, `3.968` B livres) e segmento `.text` principal (`8.683` funções descobertas: RTOS, ISP Venus Engine IV, OIS/AF/Zoom, FAT/DCF, FotoNation, QuickTime `.MOV`, PictBridge, Service Mode).
  4. **`02d` (`0x1D8DC0..0x21BFC0` | `VA 0x55E54DC0..0x55E97FC0`)**: Pool `.rodata` (strings ASCII, átomos QuickTime, códigos de erro de fábrica, jump tables).
  5. **`02e` (`0x21BFC0..0x21F428` | `VA 0x55E97FC0..0x55E9B428`)**: `.text` superior e `venus_master_irq_dispatcher` (`0x55E97FC7`), seguido por `CAVE_MAIN_TEXT` (`0x21F428..0x224000`, `19.416` B livres).
- **Como alterar / adicionar recursos ([`Part02MainFirmware`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_02_main_firmware/part_02.hpp))**:
  - `set_firmware_version(major, minor)` e `set_camera_model_identity(model, brand)`
  - `patch_data_segment_u32(sdram_va, new_val)` e `patch_rodata_ascii(target_va, new_text)`
  - `add_cave_ascii_string(text, &out_va)`, `add_cave_function(fn_name, asm_lines, &out_va)` e `hook_call_instruction(call_insn_va, new_target_va)`

### 2.4 Partição 03 (`part_03_osd_ui` — `0x224000..0x31F118` | `VA 0x55EA0000..0x55F9B118`)
- **Papel Arquitetural**: Banco de dados multi-idioma de textos de interface (OSD) e glifos de fontes bitmap.
- **Estrutura Descoberta**:
  - Contém **`4.812` strings OSD de 16 bits terminadas por `0x0003`** (formato proprietário Panasonic Venus Engine IV) e **`304` strings UTF-16LE terminadas por `0x0000`**, seguidas por mapas de glifos de caracteres.
  - Possui **`313.064` bytes (`305,7 KB`) livres** em `CAVE_UPPER_ROM` (`0x31F118..0x36B800`).
- **Como alterar / adicionar recursos ([`Part03OsdUi`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_03_osd_ui/part_03.hpp))**:
  - `patch_osd_string_at_va(va, new_text)`: Edita uma string de menu existente in-place.
  - `add_new_osd_string(text, &out_new_va)`: Aloca uma nova string 16-bit terminada em `0x0003` na área de expansão de `part_03` e retorna seu novo `VA` (`0x55F9B118+`) para vinculação na tabela mestre da Partição 05.

### 2.5 Partição 04 (`part_04_flash_stub` — `0x36B800..0x36B804` | `VA 0x55FE7800..0x55FE7804`)
- **Papel Arquitetural**: Stub de retorno/alinhamento de 4 bytes (`CB CB CB CB` = quatro instruções `rets`/`nop` de 1 byte na arquitetura MN103S) posicionado exatamente na fronteira de setor flash `0x36B800` (`VA 0x55FE7800`), com `34.812` bytes livres (`0x36B804..0x374000`) antes da Partição 05.
- **Como alterar / adicionar recursos ([`Part04FlashStub`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_04_flash_stub/part_04.hpp))**:
  - `set_custom_stub_routine(fn_name, asm_lines)`: Substitui ou expande o stub de 4 bytes em `0x55FE7800` por uma sub-rotina MN103S completa executável in-place (`XIP`).

### 2.6 Partição 05 (`part_05_resource_tables` — `0x374000..0x480F08` | `VA 0x55FF0000..0x560FCF08`)
- **Papel Arquitetural**: Contém 3 sub-regiões acopladas ao sistema de UI e calibração ISP:
  1. **`05a` (`0x374000..0x383FFF` | `VA 0x55FF0000..0x55FFFFFF`)**: Arena de `64 KB` inicializada com `0x00` (referenciada por 7 instruções em `part_02`).
  2. **`05b` (`0x384000..0x3D4E98` | `VA 0x56000000..0x56050E98`)**: **Tabela Mestre de Ponteiros de Recursos e Idiomas**, iniciada pela palavra mágica **`0x12345678`** em `VA 0x56000000` (referenciada por 30 XREFs em `part_02`). Contém **`82.853` palavras de 32 bits**, das quais:
     - **`60.504` ponteiros** apontam diretamente para strings/recursos na **Partição 03** (`0x55EA0000..0x55F9B118`).
     - **`17.520` ponteiros** apontam diretamente para strings/recursos na sub-região **`05c`** (`0x56050E98..0x560FCF08`).
  3. **`05c` (`0x3D4E98..0x480F08` | `VA 0x56050E98..0x560FCF08`)**: Contém **`3.173` strings OSD adicionais terminadas em `0x0003`**, ícones bitmap e tabelas de calibração ISP, seguidas por `12.536` bytes livres em `CAVE_TAIL_ROM` (`0x480F08..0x484000`).
- **Como alterar / adicionar recursos ([`Part05ResourceTables`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_05_resource_tables/part_05.hpp))**:
  - `set_master_table_pointer(word_index, new_target_va)` e `rebind_master_pointers_by_va(old_va, new_va)`: Atualiza ponteiros na tabela `0x12345678` para apontar para novas strings/recursos alocados em `part_03` ou `part_05`.
  - `append_upper_resource_blob(blob, &out_va)`: Anexa novos recursos binários em `CAVE_TAIL_ROM`.

### 2.7 Partição 06 (`part_06_parity_trailer` — `0x484000..0x484020` | `VA 0x56100000..0x56100020`)
- **Papel Arquitetural**: Trailer de integridade vertical de 32 bytes (`18f8d9406631723fcc110b3b5c3c99af64c17a2d0e9b44d41d5fc6fe35f1e180`), correspondente à **Linha `147.968`** da matriz 2D de soma zero (`147.969 linhas × 17 colunas` de palavras big-endian `uint16_t`).
- **Fórmula Matemática Verificada (`100%`)**:
  $$W_{147968, c} = \left(-\sum_{r=0}^{147967} W_{r, c}\right) \bmod 65536 \quad (0 \le c \le 15), \qquad W_{147968, 16} = \text{0x9E60}$$
- **Como alterar / reconstruir ([`Part06ParityTrailer`](file:///Users/wesleysalmi/source-me/tz5-rea/partitions_src/part_06_parity_trailer/part_06.hpp))**:
  - `recompute_from_rom_payload(rom_payload_484000)`: Recalcula automaticamente as 16 palavras de paridade vertical sempre que qualquer byte de `part_00`..`part_05` é alterado.

---

## 3. Guia Prático: Como Alterar, Adicionar Recursos e Reconstruir Partições

### 3.1Via CLI (`tz5-fw-tool`)
```bash
# 1. Exportar os arquivos de código-fonte C++20 gerados e dossiês JSON das 7 partições:
./build/tz5-fw-tool partitions-export-src output/partitions output/partitions_analysis

# 2. Adicionar uma nova string OSD na Partição 03, revincular a tabela 0x12345678 na Partição 05,
#    atualizar a versão na Partição 02, salvar os novos .bin de cada partição e gerar o firmware final:
./build/tz5-fw-tool partitions-build output/partitions output/TZ5_from_partitions.bin \
    --out-partitions-dir output/partitions_rebuilt \
    --version 2.50 \
    --add-osd 0x55F77D52="LUMIX-TZ5-PRO"

# 3. Executar a suíte de testes de reconstrução bit-exact e modificação das 7 partições:
./build/tz5-fw-tool partitions-test TZ5_a.bin output/partitions
```

### 3.2 Via API C++20 (`tz5::partitions::PartitionWorkspace`)
```cpp
#include "partition_workspace.hpp"

int main() {
    tz5::partitions::PartitionWorkspace ws;
    ws.load_from_partitions_dir("output/partitions");

    // 1. Adicionar rotina no Bootloader (Partição 00)
    uint32_t boot_hook_va = 0;
    ws.part00().append_early_boot_extension("my_boot_hook", {"rets"}, &boot_hook_va);

    // 2. Adicionar ISR e redirecionar vetor de interrupção (Partição 01)
    uint32_t isr_va = 0;
    ws.part01().append_custom_isr("my_irq6_isr", {"jmp @venus_master_irq_dispatcher"}, &isr_va);
    ws.part01().redirect_irq_vector_slot(9, isr_va);

    // 3. Alterar versão e injetar função na Partição 02
    ws.part02().set_firmware_version(2, 50);

    // 4. Adicionar nova string UI na Partição 03 e vincular na tabela 0x12345678 da Partição 05
    uint32_t new_osd_va = 0;
    size_t rebound = 0;
    ws.add_localized_osd_and_rebind_table("CUSTOM MENU", 0x55F77D52u, &new_osd_va, &rebound);

    // 5. Salvar os 7 arquivos .bin atualizados das partições e o container TZ5_a.bin (recalculando Partição 06)
    ws.save_all_partition_binaries("output/partitions_rebuilt");
    std::vector<uint8_t> framed_fw;
    ws.build_framed_firmware(framed_fw);
}
```
