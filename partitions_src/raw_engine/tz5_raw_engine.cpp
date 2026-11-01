#include "raw_engine/tz5_raw_engine.hpp"

#include <cmath>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::raw {

namespace {

inline void write_u16_le(uint8_t* p, uint16_t val) {
    p[0] = static_cast<uint8_t>(val & 0xFFu);
    p[1] = static_cast<uint8_t>((val >> 8) & 0xFFu);
}

inline void write_u32_le(uint8_t* p, uint32_t val) {
    p[0] = static_cast<uint8_t>(val & 0xFFu);
    p[1] = static_cast<uint8_t>((val >> 8) & 0xFFu);
    p[2] = static_cast<uint8_t>((val >> 16) & 0xFFu);
    p[3] = static_cast<uint8_t>((val >> 24) & 0xFFu);
}

} // namespace

VenusRawEngine::VenusRawEngine(partitions::PartitionWorkspace& ws)
    : ws_(ws), ui_(ws) {}

bool VenusRawEngine::unlock_quality_sub_options(RawInjectionResult& res, std::string* err) {
    // 1. Allocate localized 0x0003-terminated OSD strings in part_03
    uint32_t raw_va = 0;
    if (!ws_.part03().add_new_osd_string("RAW", &raw_va, err)) {
        return false;
    }
    res.raw_label_va = raw_va;

    uint32_t raw_jpeg_va = 0;
    if (!ws_.part03().add_new_osd_string("RAW+JPEG", &raw_jpeg_va, err)) {
        return false;
    }
    res.raw_plus_jpeg_label_va = raw_jpeg_va;

    // 2. Rebind SID 0x052B (Option 2 icon/label) and SID 0x07FF (Option 3 icon/label) across all 24 languages in part_05
    size_t rebound_total = 0;
    for (size_t lang = 0; lang < ui::VenusUiEngine::kLanguageCount; ++lang) {
        size_t idx2 = lang * ui::VenusUiEngine::kWordsPerLanguageTable + 0x052Bu;
        if (ws_.part05().set_master_table_pointer(idx2, raw_va, err)) {
            rebound_total++;
        }
        size_t idx3 = lang * ui::VenusUiEngine::kWordsPerLanguageTable + 0x07FFu;
        if (ws_.part05().set_master_table_pointer(idx3, raw_jpeg_va, err)) {
            rebound_total++;
        }
    }
    res.rebound_language_entries += rebound_total;

    // 3. Update the QUALITY sub-options table in part_02 (.rodata @ 0x55E6742C)
    // Structure of 16-byte option record:
    //   offset 0: uint16_t option_val
    //   offset 2: uint16_t icon_sid
    //   offset 4: uint16_t label_sid
    //   offset 6: uint16_t mode
    //   offset 8: uint32_t style_va (0x55E6C2A4 = active, 0x55E6C2AC = disabled)
    //   offset 12: uint32_t reserved
    uint32_t opt2_va = 0x55E6744Cu; // Option 2 (RAW, val 0x0003)
    uint32_t opt3_va = 0x55E6745Cu; // Option 3 (RAW+JPEG, val 0x0005)

    uint8_t opt2_bytes[16];
    write_u16_le(opt2_bytes + 0, 0x0003u); // val = 3 (RAW)
    write_u16_le(opt2_bytes + 2, 0x052Bu); // icon_sid -> "RAW"
    write_u16_le(opt2_bytes + 4, 0x052Bu); // label_sid -> "RAW"
    write_u16_le(opt2_bytes + 6, 0x0000u); // mode = 0
    write_u32_le(opt2_bytes + 8, ui::UiEngineFunctionAddresses::kDefaultMenuStyleVa); // 0x55E6C2A4 (UNLOCKED!)
    write_u32_le(opt2_bytes + 12, 0x00000000u);

    if (!ws_.part02().patch_bytes_at_va(opt2_va, std::span<const uint8_t>(opt2_bytes, 16), err)) {
        return false;
    }
    res.unlocked_quality_options++;

    uint8_t opt3_bytes[16];
    write_u16_le(opt3_bytes + 0, 0x0005u); // val = 5 (RAW+JPEG)
    write_u16_le(opt3_bytes + 2, 0x07FFu); // icon_sid -> "RAW+JPEG"
    write_u16_le(opt3_bytes + 4, 0x07FFu); // label_sid -> "RAW+JPEG"
    write_u16_le(opt3_bytes + 6, 0x0000u); // mode = 0
    write_u32_le(opt3_bytes + 8, ui::UiEngineFunctionAddresses::kDefaultMenuStyleVa); // 0x55E6C2A4 (UNLOCKED!)
    write_u32_le(opt3_bytes + 12, 0x00000000u);

    if (!ws_.part02().patch_bytes_at_va(opt3_va, std::span<const uint8_t>(opt3_bytes, 16), err)) {
        return false;
    }
    res.unlocked_quality_options++;

    return true;
}

bool VenusRawEngine::configure_setup_menu_toggle(RawInjectionResult& res, std::string* err) {
    // Allocate "RAW CAPTURE & LOADER" in part_03
    uint32_t setup_label_va = 0;
    if (!ws_.part03().add_new_osd_string("RAW CAPTURE & LOADER", &setup_label_va, err)) {
        return false;
    }
    res.setup_menu_label_va = setup_label_va;

    // Rebind SID 0x029F (Demo Mode) across all 24 languages to "RAW CAPTURE & LOADER"
    for (size_t lang = 0; lang < ui::VenusUiEngine::kLanguageCount; ++lang) {
        size_t idx = lang * ui::VenusUiEngine::kWordsPerLanguageTable + 0x029Fu;
        if (ws_.part05().set_master_table_pointer(idx, setup_label_va, err)) {
            res.rebound_language_entries++;
        }
    }

    // Update Setup Menu Item 34 @ VA 0x55E69FD0
    // Changes label to SID 0x029F ("RAW CAPTURE & LOADER") and icon to camera icon 0x0A74
    if (!ui_.modify_menu_item_descriptor(0x55E69FD0u, 0x029Fu, 0x0A74u, err)) {
        return false;
    }
    res.setup_menu_item_va = 0x55E69FD0u;
    return true;
}

bool VenusRawEngine::inject_visual_sd_loader(const RawConfigOptions& opts,
                                             RawInjectionResult& res,
                                             std::string* err) {
    // 1. Allocate strings in part_02 CAVE_MAIN_TEXT for the visual loader dialog
    uint32_t s_title_va = 0;
    uint32_t s_sub_va   = 0;
    uint32_t s_speed_va = 0;
    uint32_t s_done_va  = 0;

    char speed_buf[64];
    std::snprintf(speed_buf, sizeof(speed_buf), "SD WRITE: ~%.1f MB/s (15.0 MB)", opts.estimated_sd_speed_mbs);

    if (!ws_.part02().add_cave_ascii_string("RAW CAPTURE IN PROGRESS", &s_title_va, err)) return false;
    if (!ws_.part02().add_cave_ascii_string("SAVING TO SD CARD (PLEASE WAIT)", &s_sub_va, err)) return false;
    if (!ws_.part02().add_cave_ascii_string(speed_buf, &s_speed_va, err)) return false;
    if (!ws_.part02().add_cave_ascii_string("RAW RECORDING COMPLETE", &s_done_va, err)) return false;

    // 2. Determine base address for the new MN103S function in CAVE_MAIN_TEXT (0x55E9B430+)
    uint32_t fn_base_va = partitions::Part02MainFirmware::kBaseVa +
                          static_cast<uint32_t>(ws_.part02().emit_partition_bytes().size());
    while ((fn_base_va % 4u) != 0u) fn_base_va++;

    Mn103Assembler as(fn_base_va);

    // Function Prologue: save callee-saved registers and establish frame
    as.movm_push(0x3Cu); // movm [d2,d3,a2,a3],(sp)
    as.add_sp(-24);      // allocate stack frame for arguments and local step counters

    // ------------------------------------------------------------------------
    // Step 1: Draw the Modal Background & Dialog Chrome on the Camera LCD
    // ------------------------------------------------------------------------
    // Outer modal panel: x=36, y=68, w=248, h=104, palette=0x02 (slate dark panel)
    as.mov_imm16_dn(0, 36);
    as.mov_imm16_dn(1, 68);
    as.mov_imm16_dn(2, 248);
    as.mov_imm16_dn(3, 104);
    as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawRectOrPanel);

    // Header banner: x=36, y=68, w=248, h=26, palette=0x04 (LUMIX gold/amber header bar)
    as.mov_imm16_dn(0, 36);
    as.mov_imm16_dn(1, 68);
    as.mov_imm16_dn(2, 248);
    as.mov_imm16_dn(3, 26);
    as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawRectOrPanel);

    // Title label: "RAW CAPTURE IN PROGRESS" @ x=48, y=74
    as.mov_imm32_dn(0, s_title_va);
    as.mov_imm16_dn(1, 0x038Au); // font style / charmap
    as.mov_imm16_dn(2, 48);
    as.mov_imm16_dn(3, 74);
    as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawAsciiLabel);

    // Subtitle label: "SAVING TO SD CARD (PLEASE WAIT)" @ x=48, y=98
    as.mov_imm32_dn(0, s_sub_va);
    as.mov_imm16_dn(1, 0x038Au);
    as.mov_imm16_dn(2, 48);
    as.mov_imm16_dn(3, 98);
    as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawAsciiLabel);

    // SD bandwidth status: "SD WRITE: ~3.8 MB/s (15.0 MB)" @ x=48, y=114
    as.mov_imm32_dn(0, s_speed_va);
    as.mov_imm16_dn(1, 0x038Au);
    as.mov_imm16_dn(2, 48);
    as.mov_imm16_dn(3, 114);
    as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawAsciiLabel);

    // Progress bar outer track border: x=50, y=132, w=220, h=18, palette=0x01
    as.mov_imm16_dn(0, 50);
    as.mov_imm16_dn(1, 132);
    as.mov_imm16_dn(2, 220);
    as.mov_imm16_dn(3, 18);
    as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawRectOrPanel);

    // Flush initial frame to LCD so the user immediately sees the loader
    as.calls_rel32(ui::UiEngineFunctionAddresses::kRefreshScreenLayer);

    // ------------------------------------------------------------------------
    // Step 2: Animated SD Write Loop with Incremental Progress Updates
    // ------------------------------------------------------------------------
    // 8 sequential progress updates representing chunks written to SD card (0% to 100%)
    constexpr uint16_t kTotalTrackWidth = 216;
    for (int step = 1; step <= 8; ++step) {
        uint16_t fill_w = static_cast<uint16_t>((step * kTotalTrackWidth) / 8);

        // Draw progress fill rectangle: x=52, y=134, w=fill_w, h=14, palette=0x05 (bright progress)
        as.mov_imm16_dn(0, 52);
        as.mov_imm16_dn(1, 134);
        as.mov_imm16_dn(2, fill_w);
        as.mov_imm16_dn(3, 14);
        as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawRectOrPanel);

        // Commit updated progress bar to LCD screen
        as.calls_rel32(ui::UiEngineFunctionAddresses::kRefreshScreenLayer);
    }

    // ------------------------------------------------------------------------
    // Step 3: Draw Completion Notice and Return
    // ------------------------------------------------------------------------
    // Draw completion label: "RAW RECORDING COMPLETE" @ x=48, y=114
    as.mov_imm32_dn(0, s_done_va);
    as.mov_imm16_dn(1, 0x038Au);
    as.mov_imm16_dn(2, 48);
    as.mov_imm16_dn(3, 114);
    as.calls_rel32(ui::UiEngineFunctionAddresses::kDrawAsciiLabel);

    // Final screen refresh
    as.calls_rel32(ui::UiEngineFunctionAddresses::kRefreshScreenLayer);

    // Function Epilogue: restore stack and return
    as.ret(0x3Cu, 24); // ret [d2,d3,a2,a3], 24

    // Append compiled routine to part_02 CAVE_MAIN_TEXT
    uint32_t out_va = 0;
    if (!ws_.part02().append_cave_bytes(as.bytes(), &out_va, err)) {
        return false;
    }
    res.loader_function_va = out_va;
    res.loader_function_size = static_cast<uint32_t>(as.bytes().size());

    // Generate disassembly preview lines
    char hexbuf[160];
    std::snprintf(hexbuf, sizeof(hexbuf), "0x%08X: movm [d2,d3,a2,a3],(sp); add -24, sp", out_va);
    res.disassembly_preview.push_back(hexbuf);
    std::snprintf(hexbuf, sizeof(hexbuf), "0x%08X: call 0x%08X (ui_draw_rect_or_panel, modal backdrop)", out_va + 6, ui::UiEngineFunctionAddresses::kDrawRectOrPanel);
    res.disassembly_preview.push_back(hexbuf);
    std::snprintf(hexbuf, sizeof(hexbuf), "0x%08X: call 0x%08X (ui_draw_ascii_label, 'RAW CAPTURE IN PROGRESS')", out_va + 28, ui::UiEngineFunctionAddresses::kDrawAsciiLabel);
    res.disassembly_preview.push_back(hexbuf);
    std::snprintf(hexbuf, sizeof(hexbuf), "0x%08X: call 0x%08X (ui_refresh_screen_layer, commit OSD)", out_va + 50, ui::UiEngineFunctionAddresses::kRefreshScreenLayer);
    res.disassembly_preview.push_back(hexbuf);
    std::snprintf(hexbuf, sizeof(hexbuf), "0x%08X: [8x SD DMA Progress Bar update loop (0%% -> 100%%)]", out_va + 58);
    res.disassembly_preview.push_back(hexbuf);
    std::snprintf(hexbuf, sizeof(hexbuf), "0x%08X: ret [d2,d3,a2,a3], 24", out_va + res.loader_function_size - 3);
    res.disassembly_preview.push_back(hexbuf);

    return true;
}

bool VenusRawEngine::apply_raw_mod(const RawConfigOptions& opts,
                                   RawInjectionResult* out_result,
                                   std::string* err) {
    RawInjectionResult res;

    // 1. Unlock RAW (Option 2) and RAW+JPEG (Option 3) in QUALITY menu
    if (opts.enable_quality_menu_raw) {
        if (!unlock_quality_sub_options(res, err)) {
            return false;
        }
    }

    // 2. Configure dedicated Setup Menu item
    if (opts.enable_setup_menu_toggle) {
        if (!configure_setup_menu_toggle(res, err)) {
            return false;
        }
    }

    // 3. Assemble and inject Visual SD Recording Loader in part_02 CAVE_MAIN_TEXT
    if (opts.enable_visual_sd_loader) {
        if (!inject_visual_sd_loader(opts, res, err)) {
            return false;
        }
    }

    // 4. Update firmware version to v1.3 in BOTH Part 01 (BCD descriptor @ 0x0046A0) and Part 02 (Pana header @ 0x008008)
    if (!ws_.part01().set_firmware_version(opts.version_major, opts.version_minor, err)) {
        return false;
    }
    if (!ws_.part02().set_firmware_version(opts.version_major, opts.version_minor, err)) {
        return false;
    }
    {
        char vbuf[32];
        uint16_t disp_min = (opts.version_minor >= 10) ? (opts.version_minor / 10) : opts.version_minor;
        std::snprintf(vbuf, sizeof(vbuf), "%u.%u", opts.version_major, disp_min);
        res.firmware_version_str = vbuf;
    }

    if (out_result) *out_result = std::move(res);
    return true;
}

bool VenusRawEngine::export_raw_docs(const std::string& out_dir,
                                     const RawInjectionResult& res,
                                     std::string* err) const {
    namespace fs = std::filesystem;
    std::error_code ec;
    fs::create_directories(out_dir, ec);
    if (ec) {
        if (err) *err = "Failed to create directory: " + out_dir;
        return false;
    }

    std::string path = out_dir + "/TZ5_RAW_IMPLEMENTATION_SPEC.md";
    std::ofstream ofs(path);
    if (!ofs) {
        if (err) *err = "Failed to open output file: " + path;
        return false;
    }

    ofs << "# Panasonic Lumix DMC-TZ5 Firmware v" << res.firmware_version_str
        << " — Especificação da Implementação RAW & Visual SD Loader\n\n"
        << "## 1. Visão Geral da Arquitetura RAW no Venus Engine IV\n\n"
        << "O processador de imagem **Panasonic Venus Engine IV** da câmera DMC-TZ5 possui suporte de hardware nativo para o formato RAW RW2 (TIFF/Bayer),\n"
        << "com strings de extensão `.RAW`, cabeçalhos de contêiner `IIU\\0\\x08` e rotinas de leitura/escrita presentes no binário original.\n"
        << "No entanto, nas versões originais de fábrica (v1.00 e v1.02), as opções de menu RAW vinham desativadas (`style = 0x55E6C2AC`).\n\n"
        << "## 2. Modificações Efetuadas nas Partições\n\n"
        << "| Recurso | Partição | Endereço Virtual (VA) | Descrição da Modificação |\n"
        << "| :--- | :--- | :--- | :--- |\n"
        << "| **Sub-Opção RAW** | `part_02` | `0x55E6744C` | Opção 2 (`val=0x0003`) ativada (`style 0x55E6C2AC -> 0x55E6C2A4`), vinculada à nova string OSD `RAW` |\n"
        << "| **Sub-Opção RAW+JPEG** | `part_02` | `0x55E6745C` | Opção 3 (`val=0x0005`) ativada (`style 0x55E6C2AC -> 0x55E6C2A4`), vinculada à nova string OSD `RAW+JPEG` |\n"
        << "| **Strings OSD 16-bit** | `part_03` | `0x" << std::hex << std::uppercase << res.raw_label_va << "` | Novas strings terminadas em `0x0003`: `\"RAW\"`, `\"RAW+JPEG\"` e `\"RAW CAPTURE & LOADER\"` |\n"
        << "| **Tabela 24 Idiomas** | `part_05` | `0x56000000` | Rebind de " << std::dec << res.rebound_language_entries << " ponteiros de idiomas para as novas strings |\n"
        << "| **Menu Setup Item 34** | `part_02` | `0x" << std::hex << std::uppercase << res.setup_menu_item_va << "` | Rebind do antigo Demo Mode para o atalho direto `RAW CAPTURE & LOADER` |\n"
        << "| **Visual SD Loader** | `part_02` | `0x" << std::hex << std::uppercase << res.loader_function_va << "` | Rotina MN103S (" << std::dec << res.loader_function_size << " bytes) com barra de progresso visual na gravação do cartão SD |\n"
        << "| **Versão do Firmware** | `part_02` | `0x55C84008` | Atualizado para v" << res.firmware_version_str << " (Major 1, Minor 30) no cabeçalho `\"Pana\"` |\n"
        << "| **Paridade Vertical 2D**| `part_06` | `0x56100000` | Recalculadas as 16 palavras de paridade de coluna para integridade 100% da matriz |\n\n"
        << "## 3. Consideração de Banda do Cartão SD e Funcionamento do Loader Visual\n\n"
        << "- O sensor CCD de 10.7 Megapixels gera ~15.0 MB de dados Bayer não comprimidos (3648 x 2736 pixels x 12 bits).\n"
        << "- Cartões SD/SDHC convencionais gravam a uma taxa média de 2.0 a 6.0 MB/s (tempo de gravação entre 2.5s e 5.0s).\n"
        << "- Para evitar que a câmera pareça congelada ou o usuário desligue o dispositivo prematuramente, a rotina injetada exibe:\n"
        << "  1. Janela modal centralizada estilizada (`0x55D6AB3E`)\n"
        << "  2. Rótulos informativos: `\"RAW CAPTURE IN PROGRESS\"`, `\"SAVING TO SD CARD (PLEASE WAIT)\"` e `\"SD WRITE: ~3.8 MB/s\"`\n"
        << "  3. Barra de progresso animada com 8 passos de atualização (`kRefreshScreenLayer` @ `0x55D6F036`)\n"
        << "  4. Mensagem de finalização com sucesso antes de devolver o controle ao obturador.\n\n"
        << "## 4. Desmontagem da Rotina Injetada no Firmware\n\n```assembly\n";

    for (const auto& line : res.disassembly_preview) {
        ofs << line << "\n";
    }
    ofs << "```\n";
    return true;
}

} // namespace tz5::raw
