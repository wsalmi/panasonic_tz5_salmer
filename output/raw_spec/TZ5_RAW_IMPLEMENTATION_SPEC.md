# Panasonic Lumix DMC-TZ5 Firmware v1.4 — Especificação da Implementação RAW & Visual SD Loader

## 1. Visão Geral da Arquitetura RAW no Venus Engine IV

O processador de imagem **Panasonic Venus Engine IV** da câmera DMC-TZ5 possui suporte de hardware nativo para o formato RAW RW2 (TIFF/Bayer),
com strings de extensão `.RAW`, cabeçalhos de contêiner `IIU\0\x08` e rotinas de leitura/escrita presentes no binário original.
No entanto, nas versões originais de fábrica (v1.00 e v1.02), as opções de menu RAW vinham desativadas (`style = 0x55E6C2AC`).

## 2. Modificações Efetuadas nas Partições

| Recurso | Partição | Endereço Virtual (VA) | Descrição da Modificação |
| :--- | :--- | :--- | :--- |
| **Sub-Opção RAW** | `part_02` | `0x55E6744C` | Opção 2 (`val=0x0003`) ativada (`style 0x55E6C2AC -> 0x55E6C2A4`), vinculada à nova string OSD `RAW` |
| **Sub-Opção RAW+JPEG** | `part_02` | `0x55E6745C` | Opção 3 (`val=0x0005`) ativada (`style 0x55E6C2AC -> 0x55E6C2A4`), vinculada à nova string OSD `RAW+JPEG` |
| **Strings OSD 16-bit** | `part_03` | `0x55F9B118` | Novas strings terminadas em `0x0003`: `"RAW"`, `"RAW+JPEG"` e `"RAW CAPTURE & LOADER"` |
| **Tabela 24 Idiomas** | `part_05` | `0x56000000` | Rebind de 72 ponteiros de idiomas para as novas strings |
| **Menu Setup Item 34** | `part_02` | `0x55E69FD0` | Rebind do antigo Demo Mode para o atalho direto `RAW CAPTURE & LOADER` |
| **Visual SD Loader** | `part_02` | `0x55E9B498` | Rotina MN103S (350 bytes) com barra de progresso visual na gravação do cartão SD |
| **Versão do Firmware** | `part_02` | `0x55C84008` | Atualizado para v1.4 (Major 1, Minor 30) no cabeçalho `"Pana"` |
| **Paridade Vertical 2D**| `part_06` | `0x56100000` | Recalculadas as 16 palavras de paridade de coluna para integridade 100% da matriz |

## 3. Consideração de Banda do Cartão SD e Funcionamento do Loader Visual

- O sensor CCD de 10.7 Megapixels gera ~15.0 MB de dados Bayer não comprimidos (3648 x 2736 pixels x 12 bits).
- Cartões SD/SDHC convencionais gravam a uma taxa média de 2.0 a 6.0 MB/s (tempo de gravação entre 2.5s e 5.0s).
- Para evitar que a câmera pareça congelada ou o usuário desligue o dispositivo prematuramente, a rotina injetada exibe:
  1. Janela modal centralizada estilizada (`0x55D6AB3E`)
  2. Rótulos informativos: `"RAW CAPTURE IN PROGRESS"`, `"SAVING TO SD CARD (PLEASE WAIT)"` e `"SD WRITE: ~3.8 MB/s"`
  3. Barra de progresso animada com 8 passos de atualização (`kRefreshScreenLayer` @ `0x55D6F036`)
  4. Mensagem de finalização com sucesso antes de devolver o controle ao obturador.

## 4. Desmontagem da Rotina Injetada no Firmware

```assembly
0x55E9B498: movm [d2,d3,a2,a3],(sp); add -24, sp
0x55E9B49E: call 0x55D6AB3E (ui_draw_rect_or_panel, modal backdrop)
0x55E9B4B4: call 0x55D6BA71 (ui_draw_ascii_label, 'RAW CAPTURE IN PROGRESS')
0x55E9B4CA: call 0x55D6F036 (ui_refresh_screen_layer, commit OSD)
0x55E9B4D2: [8x SD DMA Progress Bar update loop (0% -> 100%)]
0x55E9B5F3: ret [d2,d3,a2,a3], 24
```
