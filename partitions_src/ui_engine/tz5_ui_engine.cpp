#include "ui_engine/tz5_ui_engine.hpp"
#include "tz5/disassembler.hpp"

#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::ui {

namespace {

uint16_t read_u16_le(const uint8_t* p) {
    return static_cast<uint16_t>(p[0]) | (static_cast<uint16_t>(p[1]) << 8);
}

uint32_t read_u32_le(const uint8_t* p) {
    return static_cast<uint32_t>(p[0]) |
           (static_cast<uint32_t>(p[1]) << 8) |
           (static_cast<uint32_t>(p[2]) << 16) |
           (static_cast<uint32_t>(p[3]) << 24);
}

void write_u16_le(uint8_t* p, uint16_t v) {
    p[0] = static_cast<uint8_t>(v & 0xFFu);
    p[1] = static_cast<uint8_t>((v >> 8) & 0xFFu);
}

std::string json_escape(const std::string& s) {
    std::ostringstream oss;
    for (unsigned char c : s) {
        if (c == '"') oss << "\\\"";
        else if (c == '\\') oss << "\\\\";
        else if (c == '\n') oss << "\\n";
        else if (c == '\r') oss << "\\r";
        else if (c == '\t') oss << "\\t";
        else if (c >= 0x20 && c < 0x7F) oss << static_cast<char>(c);
        else {
            char buf[8];
            std::snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned>(c));
            oss << buf;
        }
    }
    return oss.str();
}

std::string sanitize_ident(const std::string& s) {
    std::string out;
    for (char c : s) {
        if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) {
            out.push_back(c);
        } else if (!out.empty() && out.back() != '_') {
            out.push_back('_');
        }
    }
    while (!out.empty() && out.back() == '_') out.pop_back();
    if (out.empty()) out = "ITEM";
    if (out[0] >= '0' && out[0] <= '9') out = "M_" + out;
    return out;
}

} // namespace

VenusUiEngine::VenusUiEngine(partitions::PartitionWorkspace& ws)
    : ws_(ws) {
    language_names_ = {
        "Japanese (JA)", "English (EN)", "German (DE)", "French (FR)",
        "Spanish (ES)", "Italian (IT)", "Traditional Chinese (ZH-TW)", "Simplified Chinese (ZH-CN)",
        "Russian (RU)", "Dutch (NL)", "Danish (DA)", "Swedish (SV)",
        "Polish (PL)", "Thai (TH)", "Korean (KO)", "Turkish (TR)",
        "Portuguese (PT)", "Spanish-LA (ES-419)", "Arabic (AR)", "Persian (FA)",
        "English-CA (EN-CA)", "Finnish (FI)", "Czech (CS)", "Hungarian (HU)"
    };
}

std::string VenusUiEngine::decode_glyph_string_at_va(uint32_t va) const {
    const uint8_t* ptr = nullptr;
    size_t avail = 0;

    const auto& p3_base = ws_.part03().raw_bytes();
    const auto& p3_ext  = ws_.part03().ext_bytes();
    const auto& p5_base = ws_.part05().raw_bytes();
    const auto& p5_ext  = ws_.part05().ext_bytes();

    if (va >= partitions::Part03OsdUi::kBaseVa &&
        va < partitions::Part03OsdUi::kBaseVa + p3_base.size() + p3_ext.size()) {
        uint32_t rel = va - partitions::Part03OsdUi::kBaseVa;
        if (rel < p3_base.size()) {
            ptr = p3_base.data() + rel;
            avail = p3_base.size() - rel;
        } else {
            uint32_t erel = rel - static_cast<uint32_t>(p3_base.size());
            ptr = p3_ext.data() + erel;
            avail = p3_ext.size() - erel;
        }
    } else if (va >= partitions::Part05ResourceTables::kBaseVa &&
               va < partitions::Part05ResourceTables::kBaseVa + p5_base.size() + p5_ext.size()) {
        uint32_t rel = va - partitions::Part05ResourceTables::kBaseVa;
        if (rel < p5_base.size()) {
            ptr = p5_base.data() + rel;
            avail = p5_base.size() - rel;
        } else {
            uint32_t erel = rel - static_cast<uint32_t>(p5_base.size());
            ptr = p5_ext.data() + erel;
            avail = p5_ext.size() - erel;
        }
    }

    if (!ptr || avail < 2) return "";

    std::string out;
    size_t max_words = std::min<size_t>(avail / 2, 96);
    for (size_t i = 0; i < max_words; ++i) {
        uint16_t w = read_u16_le(ptr + i * 2);
        if (w == 0x0003u || w == 0x0000u) break;
        if (w == 0x000Au) {
            out += " / ";
        } else if (w >= 0x0020u && w < 0x007Fu) {
            out.push_back(static_cast<char>(w));
        } else if (w >= 0x012Bu && w <= 0x0184u) {
            // World Time zone proportional font glyph offset (+0x010B bias -> ASCII 0x20..0x79)
            char c = static_cast<char>(w - 0x010Bu);
            if (c >= 0x20 && c < 0x7F) out.push_back(c);
        } else if (w >= 0x00A0u && w <= 0x00FFu) {
            // Latin-1 accented characters in PT/ES/DE/FR/IT
            out.push_back(static_cast<char>(w));
        } else {
            char buf[16];
            std::snprintf(buf, sizeof(buf), "[G:%04X]", static_cast<unsigned>(w));
            out += buf;
        }
    }
    return out;
}

std::string VenusUiEngine::resolve_string_id(uint16_t sid, size_t language_index) const {
    if (sid == 0 || sid > 0x0CB3u || language_index >= kLanguageCount) {
        return "";
    }
    // Each 3,252-word language block has:
    //   word[0]   = 0x12345678 (table magic)
    //   word[sid] = pointer for String ID `sid` (0x0001..0x0CB3)
    size_t word_index = language_index * kWordsPerLanguageTable + sid;
    uint32_t target_va = ws_.part05().read_master_table_word(word_index);
    if (target_va == 0) return "";
    return decode_glyph_string_at_va(target_va);
}

std::vector<VenusMenuOptionDescriptor> VenusUiEngine::parse_sub_options(uint32_t sub_opts_va) const {
    std::vector<VenusMenuOptionDescriptor> opts;
    const auto& p2 = ws_.part02().raw_bytes();
    if (sub_opts_va < 0x55E67000u || sub_opts_va >= 0x55E6B000u) {
        return opts;
    }
    uint32_t rel = sub_opts_va - partitions::Part02MainFirmware::kBaseVa;
    for (size_t k = 0; k < 32 && rel + 16 <= p2.size(); ++k, rel += 16) {
        const uint8_t* rec = p2.data() + rel;
        uint16_t opt_val   = read_u16_le(rec + 0);
        uint16_t icon_sid  = read_u16_le(rec + 2);
        uint16_t label_sid = read_u16_le(rec + 4);
        uint16_t mode      = read_u16_le(rec + 6);
        uint32_t style_va  = read_u32_le(rec + 8);
        uint32_t rsvd      = read_u32_le(rec + 12);

        if (opt_val == 0x00FFu || style_va != UiEngineFunctionAddresses::kDefaultMenuStyleVa) {
            break;
        }

        VenusMenuOptionDescriptor d;
        d.va = partitions::Part02MainFirmware::kBaseVa + rel;
        d.option_val = opt_val;
        d.icon_sid = icon_sid;
        d.label_sid = label_sid;
        d.mode = mode;
        d.style_va = style_va;
        d.reserved = rsvd;
        d.label_en = (label_sid != 0xFFFFu) ? resolve_string_id(label_sid, 1) : "";
        d.label_pt = (label_sid != 0xFFFFu) ? resolve_string_id(label_sid, 16) : "";
        d.icon_preview = (icon_sid != 0xFFFFu) ? resolve_string_id(icon_sid, 1) : "";
        opts.push_back(std::move(d));
    }
    return opts;
}

bool VenusUiEngine::analyze_all(std::string* err) {
    const auto& p2 = ws_.part02().raw_bytes();
    const auto& p3 = ws_.part03().raw_bytes();
    const auto& p5 = ws_.part05().raw_bytes();

    if (p2.empty() || p3.empty() || p5.empty()) {
        if (err) *err = "Partitions part_02, part_03, and part_05 must be loaded before VenusUiEngine::analyze_all()";
        return false;
    }

    // 1. Parse the 7,518-entry Master Glyph & UI Icon Tile Pointer Table in part_03 @ VA 0x55F82ED8
    glyph_bitmap_ptrs_.clear();
    uint32_t glyph_tbl_rel = 0x55F82ED8u - partitions::Part03OsdUi::kBaseVa;
    if (glyph_tbl_rel + kGlyphTableEntryCount * 4 <= p3.size()) {
        glyph_bitmap_ptrs_.reserve(kGlyphTableEntryCount);
        for (size_t i = 0; i < kGlyphTableEntryCount; ++i) {
            glyph_bitmap_ptrs_.push_back(read_u32_le(p3.data() + glyph_tbl_rel + i * 4));
        }
    }

    // 2. Scan part_02 .rodata (0x55E675C0..0x55E6A408) for all 24-byte VenusMenuItemDescriptor tables
    menu_groups_.clear();
    uint32_t scan_start_rel = 0x55E675C0u - partitions::Part02MainFirmware::kBaseVa;
    uint32_t scan_end_rel   = 0x55E6A500u - partitions::Part02MainFirmware::kBaseVa;

    auto classify_menu_group = [](uint32_t start_va, size_t idx) -> std::tuple<std::string, std::string, std::string> {
        switch (start_va) {
            case 0x55E67BACu: return {"MENU_REC_MAIN_P1", "[REC] MENU", "Primary Shooting Menu (WB, ISO, Picture Size, Quality, Aspect, Audio, Metering, AF, Cont.AF, AF Lamp, AF/AE Lock)"};
            case 0x55E67CCCu: return {"MENU_REC_MAIN_P2", "[REC] MENU", "Secondary Shooting Menu (Digital Zoom, Color Effect, Color Mode, Stabilizer, Picture Mode)"};
            case 0x55E67D8Cu: return {"MENU_REC_SHUTTER", "[REC] MENU", "Minimum Shutter Speed Menu Descriptor"};
            case 0x55E67DBCu: return {"MENU_REC_MAIN_P3", "[REC] MENU", "Extended Shooting Menu (WB Adjust, Clock Set, Intelligent ISO, Burst)"};
            case 0x55E67E34u: return {"MENU_REC_MAIN_P4", "[REC] MENU", "Quick AF & Intelligent Exposure (I.EXPOSURE) Descriptors"};
            case 0x55E67E7Cu: return {"MENU_MODE_ROOT", "[MODE / SCN]", "Top-Level Mode Switcher (Intelligent Auto, Normal Picture, Motion Picture, Scene Mode 1 & 2)"};
            case 0x55E6800Cu: return {"MENU_PICT_ADJ", "[REC] PICT.ADJ.", "Picture Adjustment Submenu (Contrast, Sharpness, Saturation, Noise Reduction)"};
            case 0x55E6827Cu: return {"MENU_BABY_PET", "[SCN] BABY/PET", "Scene Mode Baby1/Baby2/Pet Profile Submenu (Age, Name)"};
            case 0x55E68B10u: return {"MENU_PLAY_MAIN", "[PLAY] MENU", "Playback Menu (Protect, DPOF Print, Slide Show, Audio Dub, Resize, Trimming, Rotate, Rotate Disp, Copy, Aspect Conv, Favorite, Dual Display, Text Stamp, Category, Title Edit, Calendar, Motion Edit)"};
            case 0x55E68CD8u: return {"MENU_PLAY_MODE", "[PLAY] MODE", "Playback Mode Selector (Normal Play, Slide Show, Category Play, Favorite Play, Dual Play)"};
            case 0x55E68D68u: return {"MENU_SLIDESHOW_FILTER", "[PLAY] SLIDE SHOW", "Slide Show Filter Selection (All, Favorite, Category Selection, Saved Slide Show)"};
            case 0x55E68EC0u: return {"MENU_SLIDESHOW_CFG", "[PLAY] SLIDE SHOW", "Slide Show Settings (Duration, Repeat, Audio, Music)"};
            case 0x55E68FA8u: return {"MENU_SLIDESHOW_START", "[PLAY] SLIDE SHOW", "Slide Show Main Screen (Start, Effect, Setup, Slideshow Setup)"};
            case 0x55E690F0u: return {"MENU_TEXT_STAMP", "[PLAY] TEXT STAMP", "Text Stamp Configuration (Shooting Date, Age, Travel Date, Title)"};
            case 0x55E692F8u: return {"MENU_PICTBRIDGE_PRINT", "[USB] PICTBRIDGE", "PictBridge Direct Print Menu (Print Start, Print With Date, Num. of Prints, Paper Size, Page Layout, DPOF Set)"};
            case 0x55E693A0u: return {"MENU_MULTI_SELECT", "[PLAY] MULTI SELECT", "Multi-Photo Action Menu (Multi Select, Select All, Favorite, DPOF Picture, Category Regist)"};
            case 0x55E69448u: return {"MENU_CLIPBOARD", "[CLIPBOARD] MENU", "Clipboard Mode Menu (Audio Dub., Copy, LCD Mode)"};
            case 0x55E69DC0u: return {"MENU_SETUP_MAIN", "[SETUP] MENU", "Main Setup Menu Pages 1-5 (Battery Type, Clock Set, World Time, Monitor, Viewfinder, LCD Mode, Beep, Volume, Guide Line, Histogram, Travel Date, Auto Review, Economy, No.Reset, Reset, USB Mode, Video Out, TV Aspect, m/ft, Scene Menu, Format, Language, Demo Mode)"};
            case 0x55E6A000u: return {"MENU_SETUP_PWR_SHUTTER", "[SETUP] SUBMENU", "Power Save & Shutter Menu Descriptors"};
            case 0x55E6A090u: return {"MENU_SETUP_ZOOM_DIAL", "[SETUP] SUBMENU", "Zoom Resume & Dial Display Menu Descriptors"};
            case 0x55E6A0F0u: return {"MENU_SETUP_DEFAULT_GUARD", "[SETUP] SUBMENU", "Default Zoom & Screen Guard Menu Descriptors"};
            case 0x55E6A198u: return {"MENU_SETUP_GUIDELINE", "[SETUP] GUIDE LINE", "Guide Line Submenu (Rec. Info., Pattern)"};
            case 0x55E6A260u: return {"MENU_SETUP_BEEP", "[SETUP] BEEP", "Beep & Shutter Audio Submenu (Beep Level, Beep Tone, Shutter Vol., Shutter Tone)"};
            case 0x55E6A2D8u: return {"MENU_SETUP_SHUTTER_AUDIO", "[SETUP] SHUTTER", "Shutter Audio Submenu (Shutter Vol., Shutter Tone)"};
            case 0x55E6A390u: return {"MENU_SETUP_ECONOMY", "[SETUP] ECONOMY", "Economy Power Saving Submenu (Power Save, Auto LCD Off)"};
            case 0x55E6A3D8u: return {"MENU_SETUP_DEMO", "[SETUP] DEMO MODE", "Demo Mode Submenu (Jitter/Subj. Move Demo, Auto Demo)"};
            default: {
                char buf[32];
                std::snprintf(buf, sizeof(buf), "MENU_GROUP_%02zu", idx);
                return {buf, "[UI] SUBMENU", "Venus Engine IV Menu Descriptor Table"};
            }
        }
    };

    uint32_t off = scan_start_rel;
    while (off + 24 <= scan_end_rel && off + 24 <= p2.size()) {
        const uint8_t* rec = p2.data() + off;
        uint32_t item_id    = read_u32_le(rec + 0);
        uint32_t sub_opts   = read_u32_le(rec + 4);
        uint32_t icon_style = read_u32_le(rec + 12);
        uint16_t label_sid  = read_u16_le(rec + 16);
        uint32_t lbl_style  = read_u32_le(rec + 20);

        bool valid_entry = (icon_style == UiEngineFunctionAddresses::kDefaultMenuStyleVa &&
                            lbl_style == UiEngineFunctionAddresses::kDefaultMenuStyleVa &&
                            item_id < 0x100u &&
                            label_sid > 0 && label_sid <= 0x0CB3u &&
                            (sub_opts == UiEngineFunctionAddresses::kEmptySubOptionsRamVa ||
                             (sub_opts >= 0x55E67000u && sub_opts < 0x55E6B000u)));

        if (!valid_entry) {
            off += 4;
            continue;
        }

        uint32_t group_start_va = partitions::Part02MainFirmware::kBaseVa + off;
        auto [tid, cat, desc] = classify_menu_group(group_start_va, menu_groups_.size());
        VenusMenuTableGroup grp;
        grp.table_id = tid;
        grp.screen_category = cat;
        grp.description = desc;
        grp.start_va = group_start_va;

        while (off + 24 <= scan_end_rel && off + 24 <= p2.size()) {
            const uint8_t* r = p2.data() + off;
            uint32_t iid    = read_u32_le(r + 0);
            uint32_t sopts  = read_u32_le(r + 4);
            uint16_t isid   = read_u16_le(r + 8);
            uint16_t imode  = read_u16_le(r + 10);
            uint32_t istyle = read_u32_le(r + 12);
            uint16_t lsid   = read_u16_le(r + 16);
            uint16_t lmode  = read_u16_le(r + 18);
            uint32_t lstyle = read_u32_le(r + 20);

            bool ok = (istyle == UiEngineFunctionAddresses::kDefaultMenuStyleVa &&
                       lstyle == UiEngineFunctionAddresses::kDefaultMenuStyleVa &&
                       iid < 0x100u &&
                       lsid > 0 && lsid <= 0x0CB3u &&
                       (sopts == UiEngineFunctionAddresses::kEmptySubOptionsRamVa ||
                        (sopts >= 0x55E67000u && sopts < 0x55E6B000u)));
            if (!ok) break;

            VenusMenuItemDescriptor item;
            item.va = partitions::Part02MainFirmware::kBaseVa + off;
            item.item_id = iid;
            item.sub_options_va = sopts;
            item.icon_sid = isid;
            item.icon_mode = imode;
            item.icon_style_va = istyle;
            item.label_sid = lsid;
            item.label_mode = lmode;
            item.label_style_va = lstyle;
            item.label_en = resolve_string_id(lsid, 1);
            item.label_pt = resolve_string_id(lsid, 16);
            item.options = parse_sub_options(sopts);

            grp.items.push_back(std::move(item));
            off += 24;
        }

        grp.end_va = partitions::Part02MainFirmware::kBaseVa + off;
        menu_groups_.push_back(std::move(grp));
    }

    build_reversed_screen_catalog();
    return true;
}

size_t VenusUiEngine::total_menu_items() const {
    size_t n = 0;
    for (const auto& g : menu_groups_) n += g.items.size();
    return n;
}

void VenusUiEngine::build_reversed_screen_catalog() {
    screens_.clear();

    screens_.push_back({
        "SCREEN_01_REC_LIVE_VIEW_OSD",
        "Recording Live View OSD & Telemetry Overlay",
        "Tela Live View de Disparo (OSD + Telemetria Óptica 10x)",
        "REC / iA",
        0x55D6BCE8u,
        0x55E67BACu,
        "Renders real-time shooting HUD over the 3.0-inch 460k-dot LCD: Recording Mode badge (iA/P/SCN/Motion), Mega O.I.S. status, 9M EZ picture size, AF/AE lock, 1x-10x Leica DC Vario-Elmar zoom bar, live histogram (SID 0x0297), and battery gauge.",
        {0x004Au, 0x0011u, 0x0007u, 0x0297u, 0x012Cu},
        {
            {"panel", 0, 0, 320, 28, 0, 0x10, "Top Telemetry Header Bar"},
            {"string_id", 12, 6, 60, 18, 0x0264u, 0x01, "9M (Picture Size Badge)"},
            {"string_id", 86, 6, 48, 18, 0x02A3u, 0x01, "i.ISO / ISO Badge"},
            {"panel", 16, 198, 288, 34, 0, 0x11, "Bottom Exposure / Zoom Bar (1X .. 10X EZ)"},
            {"ascii_label", 24, 208, 120, 16, 0, 0x02, "F3.3  1/125  ISO100"}
        }
    });

    screens_.push_back({
        "SCREEN_02_Q_MENU_BAR",
        "Quick Menu (Q.MENU) Top Dropdown Bar",
        "Barra Rápida Q.MENU (Ajustes Instantâneos em Live View)",
        "Q.MENU",
        0x55D6AB3Eu,
        0x55E67CCCu,
        "Triggered by the dedicated Q.MENU / Delete button during shooting. Draws a horizontal quick-access bar at the top of the LCD with drop-down rollers for Stabilizer, Burst, AF Mode, White Balance, ISO, Intelligent Exposure, Picture Size, and LCD Mode.",
        {0x0198u, 0x004Cu, 0x0195u, 0x0001u, 0x02A3u, 0x02BAu, 0x0060u},
        {
            {"panel", 0, 0, 320, 44, 0, 0x14, "Q.MENU Horizontal Selection Ribbon"},
            {"panel", 84, 46, 152, 118, 0, 0x15, "Active Parameter Vertical Drop-Down Roller"},
            {"string_id", 96, 54, 128, 20, 0x0001u, 0x01, "WHITE BALANCE"},
            {"string_id", 96, 80, 128, 20, 0x0002u, 0x02, "AWB"}
        }
    });

    screens_.push_back({
        "SCREEN_03_REC_MAIN_MENU",
        "[REC] Main Shooting Menu (Pages 1-4)",
        "Menu Principal de Fotografia [REC] (Páginas 1 a 4)",
        "[REC]",
        0x55D6BCE8u,
        0x55E67BACu,
        "Full-screen tabbed menu driven by the 24-byte VenusMenuItemDescriptor tables at 0x55E67BAC..0x55E67E64 (22 items: Picture Size, Quality, Aspect Ratio, Intelligent ISO, Sensitivity, White Balance, WB Adjust, Metering Mode, AF Mode, Quick AF, Continuous AF, I.Exposure, Color Mode, Stabilizer, Min. Shtr Speed, Burst, Digital Zoom, Audio Rec., AF Assist Lamp, Clock Set).",
        {0x0049u, 0x0007u, 0x0024u, 0x0134u, 0x02A3u, 0x0011u, 0x0001u, 0x0195u, 0x02BAu, 0x0198u},
        {
            {"panel", 0, 0, 320, 240, 0, 0x01, "Full-Screen Dark Metallic Menu Background"},
            {"panel", 0, 0, 42, 240, 0, 0x03, "Left Tab Switcher Column ([REC] / [SETUP])"},
            {"panel", 44, 34, 272, 28, 0, 0x04, "Selected Menu Row Yellow Highlight Bar"},
            {"string_id", 56, 8, 160, 20, 0x0049u, 0x01, "REC"},
            {"string_id", 78, 40, 180, 20, 0x0007u, 0x01, "PICTURE SIZE"}
        }
    });

    screens_.push_back({
        "SCREEN_04_MOTION_PICTURE_MENU",
        "[MOTION PICTURE] HD 720p Video Recording Menu",
        "Menu de Gravação de Vídeo HD [IMAGEM EM MOVIMENTO]",
        "[MOTION]",
        0x55D6BCE8u,
        0x55E67E7Cu,
        "Configures HD 1280x720 (30fps/15fps) 16:9 and WVGA/VGA Motion JPEG recording modes (SID 0x004B), Picture Quality/Frame Rate (30fps/15fps/10fps), Continuous AF, White Balance, Metering Mode, I.Exposure, Color Mode, and Optical Stabilizer.",
        {0x004Bu, 0x0047u, 0x0048u, 0x0196u, 0x0198u},
        {
            {"panel", 0, 0, 320, 240, 0, 0x01, "Motion Picture Menu Frame"},
            {"string_id", 56, 8, 220, 20, 0x004Bu, 0x01, "MOTION PICTURE"},
            {"string_id", 78, 40, 180, 20, 0x022Bu, 0x01, "REC MODE (HD 16:9 / WVGA / VGA)"}
        }
    });

    screens_.push_back({
        "SCREEN_05_SCENE_MODE_GRID",
        "[SCN] 22-Scene Mode Selection Grid & Help Card",
        "Grade de Seleção de 22 Modos de Cena [SCN] (Retrato, Paisagem, Noite, Bebê, Subaquático...)",
        "[SCN]",
        0x55D6BCE8u,
        0x55E67E7Cu,
        "2-page icon grid presenting all 22 Venus Engine IV scene modes (Portrait, Soft Skin, Transform, Self-Portrait, Scenery, Sports, Night Portrait, Night Scenery, Food, Party, Candle Light, Baby 1/2, Pet, Sunset, High Sensitivity, Hi-Speed Burst, Starry Sky, Fireworks, Beach, Snow, Aerial Photo, Underwater) plus SID 0x0143..0x0190 help descriptions.",
        {0x0143u, 0x0145u, 0x02BCu, 0x0149u, 0x014Bu, 0x0151u, 0x0159u, 0x0237u, 0x0272u},
        {
            {"panel", 0, 0, 320, 240, 0, 0x01, "Scene Mode 4x3 Icon Grid Frame"},
            {"panel", 48, 36, 58, 52, 0, 0x04, "Selected Scene Tile Highlight Frame"},
            {"string_id", 56, 8, 200, 20, 0x0143u, 0x01, "PORTRAIT"}
        }
    });

    screens_.push_back({
        "SCREEN_06_SETUP_MENU",
        "[SETUP] System Configuration Menu (Pages 1-5 & Submenus)",
        "Menu de Configuração do Sistema [CONFIG.] (Páginas 1 a 5 + 24 Idiomas)",
        "[SETUP]",
        0x55D6BCE8u,
        0x55E69DC0u,
        "Driven by the 24-byte VenusMenuItemDescriptor tables at 0x55E69DC0..0x55E6A408 (Clock Set, World Time, Monitor, LCD Mode, Beep, Volume, Guide Line, Histogram, Travel Date, Economy, Auto Review, Zoom Resume, No.Reset, Reset, USB Mode, Video Out, TV Aspect, m/ft, Scene Menu, Dial Display, Format, Language, Demo Mode).",
        {0x0106u, 0x0112u, 0x01D0u, 0x0107u, 0x0060u, 0x010Cu, 0x0111u, 0x012Bu, 0x0118u, 0x029Fu},
        {
            {"panel", 0, 0, 320, 240, 0, 0x01, "Setup Menu 5-Page Container"},
            {"string_id", 56, 8, 160, 20, 0x0106u, 0x01, "SETUP"},
            {"string_id", 78, 40, 180, 20, 0x0112u, 0x01, "CLOCK SET"}
        }
    });

    screens_.push_back({
        "SCREEN_07_PLAY_MENU_AND_OSD",
        "[PLAY] Playback HUD, Calendar, Dual Display & Editing Menu",
        "Modo de Reprodução [PLAY] (Visualização, Calendário, Exibição Dupla e Edição)",
        "[PLAY]",
        0x55D6BCE8u,
        0x55E68B10u,
        "Driven by descriptor tables 0x55E68B10 (17 editing/playback items: Slide Show, Category Play, Favorite, Title Edit, Text Stamp, Resize, Trimming, Aspect Conv., Rotate, Rotate Disp., Audio Dub., Protect, DPOF Print, Copy) and 0x55E68CD8 (Play Mode selector: Normal Play, Slide Show, Category Play, Favorite Play, Dual Play).",
        {0x00ACu, 0x00B2u, 0x028Bu, 0x028Eu, 0x00BCu, 0x01A2u, 0x00AFu, 0x00B1u, 0x01A1u},
        {
            {"panel", 0, 0, 320, 240, 0, 0x01, "Playback Menu & Thumbnail Frame"},
            {"string_id", 56, 8, 160, 20, 0x00ACu, 0x01, "PLAY"},
            {"string_id", 78, 40, 180, 20, 0x00B2u, 0x01, "SLIDE SHOW"}
        }
    });

    screens_.push_back({
        "SCREEN_08_CLIPBOARD_MENU",
        "[CLIPBOARD] Dedicated Internal Memory Clipboard Screen",
        "Menu [CLIPBOARD] (Mapa/Horários Salvos na Memória Interna)",
        "[CLIPBOARD]",
        0x55D6BCE8u,
        0x55E69448u,
        "Driven by descriptor table 0x55E69448 (Audio Dub., Copy, LCD Mode) and strings SID 0x0281..0x0287. Allows quick capture and zoom viewing of transit maps, timetables, and notes stored in internal flash.",
        {0x0281u, 0x00B3u, 0x01A1u, 0x0060u},
        {
            {"panel", 0, 0, 320, 240, 0, 0x01, "Clipboard Mode Frame"},
            {"string_id", 56, 8, 180, 20, 0x0281u, 0x01, "CLIPBOARD"}
        }
    });

    screens_.push_back({
        "SCREEN_09_WORLD_TIME_MAP",
        "World Time Interactive 74-City Map Screen",
        "Tela de Hora Mundial (Mapa-Múndi Interativo com 74 Cidades)",
        "WORLD TIME",
        0x55D6BCE8u,
        0x55E69DF0u,
        "Renders the world timezone map with Home (SID 0x01D2) and Destination (SID 0x01D1) timezone bands, GMT offsets, Summer Time toggle, and the 74 proportional-font city names stored at SID 0x01D7..0x0220 (Lisbon, London, Paris, Rio de Janeiro, Fernando de Noronha, New York, Tokyo, etc.).",
        {0x01D0u, 0x01D1u, 0x01D2u, 0x01D7u, 0x0217u, 0x0218u, 0x01FEu},
        {
            {"panel", 0, 0, 320, 240, 0, 0x02, "World Map Graphic Viewport"},
            {"string_id", 24, 12, 180, 20, 0x01D0u, 0x01, "WORLD TIME"},
            {"string_id", 36, 178, 248, 22, 0x0217u, 0x01, "Rio de Janeiro (-3:00)"}
        }
    });

    screens_.push_back({
        "SCREEN_10_CLOCK_AND_TRAVEL_SET",
        "Clock Set & Travel Date / Baby Age Editor Screen",
        "Tela de Ajuste de Relógio, Data de Viagem e Nome/Idade",
        "CLOCK SET",
        0x55D6BCE8u,
        0x55E69DD8u,
        "Interactive date/time spinner and on-screen character keyboard used by CLOCK SET (SID 0x0112, 0x012F), TRAVEL DATE (SID 0x012E), and TITLE EDIT / BABY NAME (SID 0x028B).",
        {0x0112u, 0x012Fu, 0x012Eu, 0x028Bu},
        {
            {"panel", 16, 20, 288, 200, 0, 0x02, "Clock & Date Spinner Dialog"},
            {"string_id", 32, 28, 200, 20, 0x0112u, 0x01, "CLOCK SET"}
        }
    });

    screens_.push_back({
        "SCREEN_11_SERVICE_CAMERA_INFO_ROM_BACKUP",
        "Factory Service Mode: CAMERA INFO. & ROM BACKUP Diagnostics",
        "Modo de Serviço de Fábrica: CAMERA INFO., Histórico de Erros e ROM BACKUP",
        "SERVICE MODE",
        0x55D87488u,
        0x55D9C0B8u,
        "Hidden factory diagnostic screens rendered by sub_55D87488 ('CAMERA INFO.' @ 0x55E6ECDC: VER 1.00, PWRCNT, SHTCNT, STBCNT, PSVCNT, ClockSet Cnt, UnderCut Cnt, CCD_TEMP) and sub_55D9C0B8 / SID 0x02DC..0x02EE ('SERVICE MODE', 'ROM BACKUP', 'SD -> FLASH (USER)', 'FLASH -> SD (ALL)', 'ERROR CODE CLEAR').",
        {0x02DCu, 0x02DDu, 0x02DEu, 0x02DFu, 0x02E1u, 0x02EAu},
        {
            {"panel", 0, 0, 320, 240, 0, 0x06, "Factory Service Mode Navy Diagnostic Screen"},
            {"ascii_label", 24, 16, 200, 18, 0, 0x01, "CAMERA INFO.   VER 1.00 :0000"},
            {"string_id", 24, 46, 240, 18, 0x02DCu, 0x01, "SERVICE MODE"},
            {"string_id", 24, 72, 240, 18, 0x02DDu, 0x01, "ROM BACKUP"},
            {"string_id", 24, 98, 240, 18, 0x02E1u, 0x01, "FLASH -> SD (ALL)"}
        }
    });

    screens_.push_back({
        "SCREEN_12_CUSTOM_MOD_UI_SCREEN",
        "Custom Injected Firmware UI Screen (TZ5 Studio Live Telemetry / Custom Menu)",
        "Nova Tela UI Customizada Injetada no Firmware (TZ5 Studio Mod)",
        "[CUSTOM UI]",
        0x55E9B430u,
        0x55E69FD0u,
        "New custom screen compiled by VenusUiEngine::compile_and_inject_custom_ui_screen() into CAVE_MAIN_TEXT (0x55E9B428+ in part_02) with custom 0x0003-terminated 16-bit strings in part_03 (0x55F9B118+) and 24-language pointer binding in part_05 (0x56000000).",
        {0x029Fu, 0x02DCu},
        {
            {"panel", 16, 16, 288, 208, 0, 0x02, "Custom Modal Window Frame (ui_draw_rect_or_panel @ 0x55D6AB3E)"},
            {"panel", 16, 16, 288, 30, 0, 0x04, "Custom Header Highlight Bar"},
            {"ascii_label", 28, 24, 240, 18, 0, 0x01, "TZ5 STUDIO CUSTOM UI v2.0"},
            {"ascii_label", 28, 62, 260, 18, 0, 0x01, "RAW 12-BIT CCD DUMP: ENABLED"},
            {"ascii_label", 28, 90, 260, 18, 0, 0x01, "OPTICAL ZOOM IN VIDEO: UNLOCKED"},
            {"ascii_label", 28, 118, 260, 18, 0, 0x01, "MANUAL SHUTTER OVERRIDE: 60s"}
        }
    });
}

bool VenusUiEngine::modify_menu_item_descriptor(uint32_t descriptor_va,
                                                uint16_t new_label_sid,
                                                uint16_t new_icon_sid,
                                                std::string* err) {
    const auto& p2 = ws_.part02().raw_bytes();
    if (descriptor_va < partitions::Part02MainFirmware::kBaseVa ||
        descriptor_va + 24 > partitions::Part02MainFirmware::kBaseVa + p2.size()) {
        if (err) *err = "descriptor_va outside part_02 range";
        return false;
    }
    uint32_t rel = descriptor_va - partitions::Part02MainFirmware::kBaseVa;
    uint8_t buf[24];
    std::memcpy(buf, p2.data() + rel, 24);
    write_u16_le(buf + 8, new_icon_sid);
    write_u16_le(buf + 16, new_label_sid);
    return ws_.part02().patch_bytes_at_va(descriptor_va, std::span<const uint8_t>(buf, 24), err);
}

bool VenusUiEngine::modify_string_id_all_languages(uint16_t sid,
                                                   const std::string& new_text,
                                                   uint32_t* out_new_string_va,
                                                   size_t* out_updated_langs,
                                                   std::string* err) {
    if (sid == 0 || sid > 0x0CB3u) {
        if (err) *err = "String ID must be in range 0x0001..0x0CB3";
        return false;
    }
    uint32_t new_va = 0;
    if (!ws_.part03().add_new_osd_string(new_text, &new_va, err)) {
        return false;
    }
    size_t updated = 0;
    for (size_t lang = 0; lang < kLanguageCount; ++lang) {
        size_t word_idx = lang * kWordsPerLanguageTable + sid;
        if (!ws_.part05().set_master_table_pointer(word_idx, new_va, err)) {
            return false;
        }
        updated++;
    }
    if (out_new_string_va) *out_new_string_va = new_va;
    if (out_updated_langs) *out_updated_langs = updated;
    return true;
}

bool VenusUiEngine::compile_and_inject_custom_ui_screen(const CustomUiScreenSpec& spec,
                                                        CustomUiBuildResult* out_result,
                                                        std::string* err) {
    CustomUiBuildResult res;

    // 1. If requested, allocate the new menu label in part_03 and rebind `replace_menu_label_sid` across all 24 languages in part_05
    if (spec.replace_menu_label_sid != 0 && !spec.menu_label_text.empty()) {
        uint32_t menu_str_va = 0;
        size_t rebound = 0;
        if (!modify_string_id_all_languages(spec.replace_menu_label_sid, spec.menu_label_text, &menu_str_va, &rebound, err)) {
            return false;
        }
        res.allocated_string_vas.push_back(menu_str_va);
        res.rebound_language_pointers += rebound;
    }

    // 2. Allocate any custom label strings inside part_02 CAVE_MAIN_TEXT (for ASCII labels) and part_03 (for 0x0003 OSD strings)
    std::vector<uint32_t> label_ascii_vas;
    for (const auto& lbl : spec.labels) {
        if (!lbl.custom_osd_text.empty()) {
            uint32_t osd_va = 0;
            if (!ws_.part03().add_new_osd_string(lbl.custom_osd_text, &osd_va, err)) {
                return false;
            }
            res.allocated_string_vas.push_back(osd_va);

            uint32_t ascii_va = 0;
            if (!ws_.part02().add_cave_ascii_string(lbl.custom_osd_text, &ascii_va, err)) {
                return false;
            }
            label_ascii_vas.push_back(ascii_va);
        } else {
            label_ascii_vas.push_back(0);
        }
    }

    // 3. Emit a new 24-byte VenusMenuItemDescriptor in part_02 CAVE_MAIN_TEXT representing the custom screen entry
    {
        uint8_t desc[24]{};
        uint16_t sid = (spec.replace_menu_label_sid != 0) ? spec.replace_menu_label_sid : 0x029Fu;
        desc[0] = 0x25u; // item_id = 0x0025
        // sub_options_va = 0x54018784
        desc[4] = 0x84u; desc[5] = 0x87u; desc[6] = 0x01u; desc[7] = 0x54u;
        // icon_sid = 0x0A74, icon_mode = 2
        write_u16_le(desc + 8, 0x0A74u);
        write_u16_le(desc + 10, 0x0002u);
        // icon_style_va = 0x55E6C2A4
        desc[12] = 0xA4u; desc[13] = 0xC2u; desc[14] = 0xE6u; desc[15] = 0x55u;
        // label_sid = sid, label_mode = 3
        write_u16_le(desc + 16, sid);
        write_u16_le(desc + 18, 0x0003u);
        // label_style_va = 0x55E6C2A4
        desc[20] = 0xA4u; desc[21] = 0xC2u; desc[22] = 0xE6u; desc[23] = 0x55u;

        uint32_t desc_va = 0;
        if (!ws_.part02().append_cave_bytes(std::span<const uint8_t>(desc, 24), &desc_va, err)) {
            return false;
        }
        res.new_menu_item_va = desc_va;

        if (spec.patch_menu_item_va != 0) {
            if (!modify_menu_item_descriptor(spec.patch_menu_item_va, sid, 0x0A74u, err)) {
                return false;
            }
        }
    }

    // 4. Assemble the MN103S Custom UI Screen Rendering Function in part_02 CAVE_MAIN_TEXT
    //    Uses Mn103Assembler to emit real instructions calling:
    //      - 0x55D6AB3E (ui_draw_rect_or_panel) for each panel in spec.panels
    //      - 0x55D6BCE8 (ui_draw_widget_by_string_id) or 0x55D6BA71 (ui_draw_ascii_label) for each label
    //      - 0x55D6F036 (ui_refresh_screen_layer) to commit the OSD framebuffer
    uint32_t fn_base_va = partitions::Part02MainFirmware::kBaseVa +
                          static_cast<uint32_t>(ws_.part02().raw_bytes().size() +
                                                (ws_.part02().emit_partition_bytes().size() - ws_.part02().raw_bytes().size()));
    while ((fn_base_va % 4u) != 0u) fn_base_va++;

    Mn103Assembler as(fn_base_va);
    as.movm_push(0x3Cu); // movm [d2,d3,a2,a3],(sp)
    as.add_sp(-16);      // reserve 16-byte stack frame for UI draw args

    for (const auto& panel : spec.panels) {
        as.mov_imm16_dn(0, panel.x);
        as.mov_imm16_dn(1, panel.y);
        as.mov_imm16_dn(2, panel.width);
        as.mov_imm16_dn(3, panel.height);
        as.calls_rel32(UiEngineFunctionAddresses::kDrawRectOrPanel);
    }

    for (size_t i = 0; i < spec.labels.size(); ++i) {
        const auto& lbl = spec.labels[i];
        if (label_ascii_vas[i] != 0) {
            // Render custom string via ui_draw_ascii_label (0x55D6BA71) with font charmap 0x038A
            as.mov_imm32_dn(0, label_ascii_vas[i]);
            as.mov_imm16_dn(1, 0x038Au);
            as.calls_rel32(UiEngineFunctionAddresses::kDrawAsciiLabel);
        } else if (lbl.string_id != 0) {
            // Render localized String ID via ui_draw_widget_by_string_id (0x55D6BCE8)
            as.mov_imm16_dn(0, lbl.string_id);
            as.mov_imm16_dn(1, lbl.x);
            as.calls_rel32(UiEngineFunctionAddresses::kDrawWidgetByStringId);
        }
    }

    // Flush/commit the OSD screen layer (ui_refresh_screen_layer @ 0x55D6F036)
    as.calls_rel32(UiEngineFunctionAddresses::kRefreshScreenLayer);
    as.mov_imm8_dn(0, 0);
    as.ret(0x3Cu, 32); // ret [d2,d3,a2,a3],32

    uint32_t actual_fn_va = 0;
    if (!ws_.part02().append_cave_bytes(as.bytes(), &actual_fn_va, err)) {
        return false;
    }
    res.screen_function_va = actual_fn_va;
    res.screen_function_size = static_cast<uint32_t>(as.bytes().size());

    if (spec.hook_call_site_va != 0) {
        if (!ws_.part02().hook_call_instruction(spec.hook_call_site_va, actual_fn_va, err)) {
            return false;
        }
    }

    // Build human-readable MN103S assembly listing for the newly injected UI screen handler
    {
        char buf[160];
        std::snprintf(buf, sizeof(buf), "0x%08X: movm  [d2,d3,a2,a3],(sp) ; %s prologue",
                      actual_fn_va, spec.screen_symbol_name.c_str());
        res.disassembly_preview.emplace_back(buf);
        std::snprintf(buf, sizeof(buf), "            add   -16, sp");
        res.disassembly_preview.emplace_back(buf);
        for (const auto& panel : spec.panels) {
            std::snprintf(buf, sizeof(buf),
                          "            calls @ui_draw_rect_or_panel (0x55D6AB3E) ; rect(%u, %u, %u, %u)",
                          panel.x, panel.y, panel.width, panel.height);
            res.disassembly_preview.emplace_back(buf);
        }
        for (size_t i = 0; i < spec.labels.size(); ++i) {
            const auto& lbl = spec.labels[i];
            if (label_ascii_vas[i] != 0) {
                std::snprintf(buf, sizeof(buf),
                              "            calls @ui_draw_ascii_label (0x55D6BA71) ; text=\"%s\" @ 0x%08X",
                              lbl.custom_osd_text.c_str(), label_ascii_vas[i]);
                res.disassembly_preview.emplace_back(buf);
            } else if (lbl.string_id != 0) {
                std::snprintf(buf, sizeof(buf),
                              "            calls @ui_draw_widget_by_string_id (0x55D6BCE8) ; SID=0x%04X (%s)",
                              lbl.string_id, resolve_string_id(lbl.string_id, 1).c_str());
                res.disassembly_preview.emplace_back(buf);
            }
        }
        std::snprintf(buf, sizeof(buf), "            calls @ui_refresh_screen_layer (0x55D6F036)");
        res.disassembly_preview.emplace_back(buf);
        std::snprintf(buf, sizeof(buf), "            ret   [d2,d3,a2,a3],32 ; total=%u bytes",
                      res.screen_function_size);
        res.disassembly_preview.emplace_back(buf);
    }

    if (out_result) *out_result = std::move(res);
    return true;
}

bool VenusUiEngine::export_all_ui_screens_code(const std::string& out_dir, std::string* err) const {
    namespace fs = std::filesystem;
    std::error_code ec;
    fs::create_directories(out_dir, ec);
    if (ec) {
        if (err) *err = "Failed to create UI export directory: " + ec.message();
        return false;
    }

    // 1. Generate `tz5_ui_screens_generated.hpp` containing all reversed UI functions, menu descriptor tables, and screen layouts
    {
        std::ofstream hdr(fs::path(out_dir) / "tz5_ui_screens_generated.hpp");
        if (!hdr) {
            if (err) *err = "Failed to open tz5_ui_screens_generated.hpp for writing";
            return false;
        }
        hdr << "// ============================================================================\n"
            << "// AUTO-GENERATED BY tz5-fw-tool ui-export (Panasonic Lumix DMC-TZ5 UI Engine)\n"
            << "// Reversed from part_02 (0x55C84000), part_03 (0x55EA0000), part_05 (0x55FF0000)\n"
            << "// ============================================================================\n"
            << "#pragma once\n\n"
            << "#include <cstdint>\n\n"
            << "namespace tz5::ui::generated {\n\n"
            << "// MN103S UI Rendering Engine Entry Points in part_02 (.text 0x55D6A000..0x55D98000)\n"
            << "constexpr uint32_t FN_UI_GET_OSD_WIDTH            = 0x55D6F018u;\n"
            << "constexpr uint32_t FN_UI_GET_OSD_HEIGHT           = 0x55D6F022u;\n"
            << "constexpr uint32_t FN_UI_REFRESH_SCREEN_LAYER     = 0x55D6F036u; // 116 xrefs\n"
            << "constexpr uint32_t FN_UI_SELECT_LANGUAGE_TABLES   = 0x55D6F114u; // 24-lang switcher -> 0x55FFC800\n"
            << "constexpr uint32_t FN_UI_RESOLVE_STRING_ID        = 0x55D6F380u; // SID 0x0001..0x0CB3 -> uint16_t*\n"
            << "constexpr uint32_t FN_UI_RESOLVE_GLYPH_BITMAP     = 0x55D6F3E6u; // glyph_id 0..0x1D5D @ 0x55F82ED8\n"
            << "constexpr uint32_t FN_UI_DRAW_GLYPH_STRING        = 0x55D6A3A7u; // 44 xrefs\n"
            << "constexpr uint32_t FN_UI_DRAW_RECT_OR_PANEL       = 0x55D6AB3Eu; // 358 xrefs\n"
            << "constexpr uint32_t FN_UI_DRAW_ASCII_LABEL         = 0x55D6BA71u; // 41 xrefs\n"
            << "constexpr uint32_t FN_UI_DRAW_WIDGET_BY_STRING_ID = 0x55D6BCE8u; // 494 xrefs\n"
            << "constexpr uint32_t FN_SERVICE_CAMERA_INFO_SCREEN  = 0x55D87488u; // Service Mode CAMERA INFO.\n"
            << "constexpr uint32_t FN_SERVICE_ROM_BACKUP_SCREEN   = 0x55D9C0B8u; // Service Mode ROM BACKUP\n\n"
            << "// Exact 24-byte ROM layout of a Venus Engine IV Menu Item Descriptor in part_02 (.rodata)\n"
            << "struct RawVenusMenuItem {\n"
            << "    uint32_t item_id;\n"
            << "    uint32_t sub_options_va;\n"
            << "    uint16_t icon_sid;\n"
            << "    uint16_t icon_mode;\n"
            << "    uint32_t icon_style_va;\n"
            << "    uint16_t label_sid;\n"
            << "    uint16_t label_mode;\n"
            << "    uint32_t label_style_va;\n"
            << "};\n\n";

        for (const auto& grp : menu_groups_) {
            hdr << "// ----------------------------------------------------------------------------\n"
                << "// " << grp.table_id << " (" << grp.screen_category << ") @ VA 0x"
                << std::hex << std::uppercase << grp.start_va << "..0x" << grp.end_va << std::dec << "\n"
                << "// " << grp.description << "\n"
                << "// ----------------------------------------------------------------------------\n"
                << "constexpr RawVenusMenuItem k" << sanitize_ident(grp.table_id) << "[" << grp.items.size() << "] = {\n";
            for (const auto& it : grp.items) {
                hdr << "    { 0x" << std::hex << std::setw(4) << std::setfill('0') << it.item_id
                    << "u, 0x" << std::setw(8) << it.sub_options_va
                    << "u, 0x" << std::setw(4) << it.icon_sid
                    << "u, 0x" << std::setw(4) << it.icon_mode
                    << "u, 0x" << std::setw(8) << it.icon_style_va
                    << "u, 0x" << std::setw(4) << it.label_sid
                    << "u, 0x" << std::setw(4) << it.label_mode
                    << "u, 0x" << std::setw(8) << it.label_style_va
                    << "u }, // @ 0x" << std::setw(8) << it.va << std::dec
                    << " EN=\"" << it.label_en << "\" | PT=\"" << it.label_pt << "\" ("
                    << it.options.size() << " sub-opts)\n";
            }
            hdr << "};\n\n";
        }
        hdr << "} // namespace tz5::ui::generated\n";
    }

    // 2. Generate `tz5_ui_custom_screens_template.cpp` showing valid, compilable C++20 code to alter & add new UI screens
    {
        std::ofstream tpl(fs::path(out_dir) / "tz5_ui_custom_screens_template.cpp");
        if (!tpl) {
            if (err) *err = "Failed to open tz5_ui_custom_screens_template.cpp for writing";
            return false;
        }
        tpl << "// ============================================================================\n"
            << "// Panasonic Lumix DMC-TZ5 — Editable C++20 UI Modification & New Screen SDK\n"
            << "// Compile as part of tz5_core or invoke via: ./build/tz5-fw-tool ui-build-custom\n"
            << "// ============================================================================\n"
            << "#include \"ui_engine/tz5_ui_engine.hpp\"\n"
            << "#include \"tz5_ui_screens_generated.hpp\"\n\n"
            << "namespace tz5::ui {\n\n"
            << "bool apply_custom_camera_ui_modifications(partitions::PartitionWorkspace& ws,\n"
            << "                                          CustomUiBuildResult* out_res,\n"
            << "                                          std::string* err) {\n"
            << "    VenusUiEngine engine(ws);\n"
            << "    if (!engine.analyze_all(err)) return false;\n\n"
            << "    // Example 1: Define a brand-new Custom UI Screen & inject it into [SETUP] Menu\n"
            << "    CustomUiScreenSpec spec;\n"
            << "    spec.screen_symbol_name     = \"ui_screen_tz5_studio_telemetry\";\n"
            << "    spec.menu_label_text        = \"TZ5 STUDIO UI\";\n"
            << "    spec.replace_menu_label_sid = 0x029Fu;     // Rebinds SID 0x029F across all 24 languages in part_05\n"
            << "    spec.patch_menu_item_va     = 0x55E69FD0u; // Updates [SETUP] Menu entry @ 0x55E69FD0 in part_02\n\n"
            << "    // Draw main modal frame & title bar via ui_draw_rect_or_panel (0x55D6AB3E)\n"
            << "    spec.panels.push_back({16, 16, 288, 208, 0x02});\n"
            << "    spec.panels.push_back({16, 16, 288,  30, 0x04});\n\n"
            << "    // Render localized String IDs (0x55D6BCE8) & custom OSD labels (0x55D6BA71)\n"
            << "    spec.labels.push_back({28,  24, 0x029Fu, \"\", 0x01});\n"
            << "    spec.labels.push_back({28,  64, 0, \"RAW 12-BIT CCD DUMP: ON\", 0x01});\n"
            << "    spec.labels.push_back({28,  94, 0, \"OPTICAL ZOOM IN HD: ON\",  0x01});\n"
            << "    spec.labels.push_back({28, 124, 0x02DCu, \"\", 0x01}); // SERVICE MODE badge\n\n"
            << "    return engine.compile_and_inject_custom_ui_screen(spec, out_res, err);\n"
            << "}\n\n"
            << "} // namespace tz5::ui\n";
    }

    // 3. Generate `tz5_ui_catalog.json` containing all 24 languages, 19 menu groups (132 items + sub-options), and 12 screens
    {
        std::ofstream js(fs::path(out_dir) / "tz5_ui_catalog.json");
        if (!js) {
            if (err) *err = "Failed to open tz5_ui_catalog.json for writing";
            return false;
        }
        js << "{\n"
           << "  \"camera_model\": \"Panasonic Lumix DMC-TZ5\",\n"
           << "  \"ui_partitions\": {\n"
           << "    \"part_02_ui_engine_and_menus\": \"0x55C84000..0x55E9B428\",\n"
           << "    \"part_03_glyphs_icons_and_shared_strings\": \"0x55EA0000..0x55F9B118\",\n"
           << "    \"part_05_24_language_string_matrix\": \"0x55FF0000..0x560FCF08\"\n"
           << "  },\n"
           << "  \"language_count\": " << kLanguageCount << ",\n"
           << "  \"string_ids_per_language\": " << (kWordsPerLanguageTable - 1) << ",\n"
           << "  \"glyph_and_icon_tile_count\": " << glyph_bitmap_ptrs_.size() << ",\n"
           << "  \"menu_group_count\": " << menu_groups_.size() << ",\n"
           << "  \"total_menu_item_descriptors\": " << total_menu_items() << ",\n"
           << "  \"reversed_screen_count\": " << screens_.size() << ",\n"
           << "  \"screens\": [\n";
        for (size_t i = 0; i < screens_.size(); ++i) {
            const auto& sc = screens_[i];
            char hbuf[16], dbuf[16];
            std::snprintf(hbuf, sizeof(hbuf), "0x%08X", sc.primary_handler_va);
            std::snprintf(dbuf, sizeof(dbuf), "0x%08X", sc.descriptor_table_va);
            js << "    {\n"
               << "      \"screen_id\": \"" << json_escape(sc.screen_id) << "\",\n"
               << "      \"title_en\": \"" << json_escape(sc.title_en) << "\",\n"
               << "      \"title_pt\": \"" << json_escape(sc.title_pt) << "\",\n"
               << "      \"mode_badge\": \"" << json_escape(sc.mode_badge) << "\",\n"
               << "      \"primary_handler_va\": \"" << hbuf << "\",\n"
               << "      \"descriptor_table_va\": \"" << dbuf << "\",\n"
               << "      \"summary\": \"" << json_escape(sc.summary) << "\"\n"
               << "    }" << (i + 1 < screens_.size() ? "," : "") << "\n";
        }
        js << "  ],\n"
           << "  \"menu_groups\": [\n";
        for (size_t g = 0; g < menu_groups_.size(); ++g) {
            const auto& grp = menu_groups_[g];
            char sbuf[16], ebuf[16];
            std::snprintf(sbuf, sizeof(sbuf), "0x%08X", grp.start_va);
            std::snprintf(ebuf, sizeof(ebuf), "0x%08X", grp.end_va);
            js << "    {\n"
               << "      \"table_id\": \"" << json_escape(grp.table_id) << "\",\n"
               << "      \"screen_category\": \"" << json_escape(grp.screen_category) << "\",\n"
               << "      \"start_va\": \"" << sbuf << "\",\n"
               << "      \"end_va\": \"" << ebuf << "\",\n"
               << "      \"items\": [\n";
            for (size_t m = 0; m < grp.items.size(); ++m) {
                const auto& it = grp.items[m];
                char vabuf[16], lbuf[16], ibuf[16];
                std::snprintf(vabuf, sizeof(vabuf), "0x%08X", it.va);
                std::snprintf(lbuf, sizeof(lbuf), "0x%04X", it.label_sid);
                std::snprintf(ibuf, sizeof(ibuf), "0x%04X", it.icon_sid);
                js << "        {\n"
                   << "          \"va\": \"" << vabuf << "\",\n"
                   << "          \"item_id\": " << it.item_id << ",\n"
                   << "          \"label_sid\": \"" << lbuf << "\",\n"
                   << "          \"icon_sid\": \"" << ibuf << "\",\n"
                   << "          \"label_en\": \"" << json_escape(it.label_en) << "\",\n"
                   << "          \"label_pt\": \"" << json_escape(it.label_pt) << "\",\n"
                   << "          \"sub_option_count\": " << it.options.size() << "\n"
                   << "        }" << (m + 1 < grp.items.size() ? "," : "") << "\n";
            }
            js << "      ]\n"
               << "    }" << (g + 1 < menu_groups_.size() ? "," : "") << "\n";
        }
        js << "  ]\n"
           << "}\n";
    }

    return true;
}

} // namespace tz5::ui
