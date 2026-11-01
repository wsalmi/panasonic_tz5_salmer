#pragma once

#include "partition_workspace.hpp"
#include "tz5/assembler.hpp"

#include <cstdint>
#include <string>
#include <vector>

namespace tz5::ui {

// ============================================================================
// Panasonic Lumix DMC-TZ5 (Venus Engine IV) — Reversed UI Engine Architecture
// ============================================================================
// Across the 7 firmware partitions, the Camera LCD UI spans 3 partitions:
//   - part_02 (VA 0x55C84000..0x55E9B428):
//       * MN103S UI Rendering Engine (0x55D6A000..0x55D98000)
//       * .rodata Menu & Screen Descriptor Tables (0x55E675C0..0x55E6A408)
//   - part_03 (VA 0x55EA0000..0x55F9B118):
//       * Master Glyph & Icon Tile Pointer Table (7,518 entries @ 0x55F82ED8)
//       * Glyph Width/Kerning Metrics (0x55F8A452..0x55F995D8)
//       * Font Style Descriptors (436 × 16B @ 0x55F995D8..0x55F9B118)
//       * Language-Independent Strings & Multi-Tile Icon Sprites (SID 0x02DB..0x0CB3)
//   - part_05 (VA 0x55FF0000..0x560FCF08):
//       * Active Language 3,252-word Cache Window (0x55FFC800..0x55FFFFFF)
//       * 24-Language × 3,252-word String ID Matrix (0x56000000..0x5604C380, stride 0x32D0)
//       * 24-Language 0x0003-terminated 16-bit UTF-16/Glyph String Pools (0x56050E98..0x560E88F0)

struct UiEngineFunctionAddresses {
    static constexpr uint32_t kGetOsdLayerWidth          = 0x55D6F018u; // Reads 0x5403B6D0 (576 = 0x0240)
    static constexpr uint32_t kGetOsdLayerHeight         = 0x55D6F022u; // Reads 0x5403B6D4 (480 = 0x01E0)
    static constexpr uint32_t kRefreshScreenLayer        = 0x55D6F036u; // Commits/flushes OSD layer (116 calls)
    static constexpr uint32_t kSelectLanguageLoadTables  = 0x55D6F114u; // Loads 1 of 24 languages into 0x55FFC800
    static constexpr uint32_t kResolveStringIdToGlyphStr = 0x55D6F380u; // Resolves SID (0x0001..0x0CB3) -> uint16_t*
    static constexpr uint32_t kResolveGlyphBitmapMetrics = 0x55D6F3E6u; // Resolves glyph_id (0..0x1D5D) @ 0x55F82ED8
    static constexpr uint32_t kDrawFormattedGlyphString  = 0x55D6A3A7u; // Renders 0x0003-terminated glyph string (44 calls)
    static constexpr uint32_t kDrawRectOrPanel           = 0x55D6AB3Eu; // Draws OSD box/panel/highlight bar (358 calls)
    static constexpr uint32_t kDrawAsciiLabel            = 0x55D6BA71u; // Maps ASCII via SID 0x038A/0x035F & draws (41 calls)
    static constexpr uint32_t kDrawWidgetByStringId      = 0x55D6BCE8u; // Primary UI text/icon widget renderer (494 calls)
    static constexpr uint32_t kDefaultMenuStyleVa        = 0x55E6C2A4u; // Default .rodata widget style struct pointer
    static constexpr uint32_t kEmptySubOptionsRamVa      = 0x54018784u; // Sentinel RAM pointer for items with no sub-options
};

// 16-byte sub-option entry in .rodata (terminated by option_val == 0x00FF)
struct VenusMenuOptionDescriptor {
    uint32_t va = 0;
    uint16_t option_val = 0;
    uint16_t icon_sid = 0xFFFFu;
    uint16_t label_sid = 0xFFFFu;
    uint16_t mode = 0;
    uint32_t style_va = UiEngineFunctionAddresses::kDefaultMenuStyleVa;
    uint32_t reserved = 0;

    std::string label_en;
    std::string label_pt;
    std::string icon_preview;
};

// 24-byte menu item entry in .rodata (0x55E67BAC..0x55E6A408)
struct VenusMenuItemDescriptor {
    uint32_t va = 0;
    uint32_t item_id = 0;
    uint32_t sub_options_va = 0;
    uint16_t icon_sid = 0xFFFFu;
    uint16_t icon_mode = 0xFFu;
    uint32_t icon_style_va = UiEngineFunctionAddresses::kDefaultMenuStyleVa;
    uint16_t label_sid = 0xFFFFu;
    uint16_t label_mode = 0x03u;
    uint32_t label_style_va = UiEngineFunctionAddresses::kDefaultMenuStyleVa;

    std::string label_en;
    std::string label_pt;
    std::vector<VenusMenuOptionDescriptor> options;
};

struct VenusMenuTableGroup {
    std::string table_id;
    std::string screen_category;
    std::string description;
    uint32_t start_va = 0;
    uint32_t end_va = 0;
    std::vector<VenusMenuItemDescriptor> items;
};

struct UiScreenWidgetSpec {
    std::string kind; // "panel", "string_id", "ascii_label", "icon_badge"
    uint16_t x = 0;
    uint16_t y = 0;
    uint16_t w = 0;
    uint16_t h = 0;
    uint16_t string_id = 0;
    uint8_t color_or_style = 1;
    std::string text;
};

struct ReversedCameraScreen {
    std::string screen_id;
    std::string title_en;
    std::string title_pt;
    std::string mode_badge;
    uint32_t primary_handler_va = 0;
    uint32_t descriptor_table_va = 0;
    std::string summary;
    std::vector<uint16_t> key_string_ids;
    std::vector<UiScreenWidgetSpec> layout_widgets;
};

// Specification for compiling & injecting a brand-new Custom UI Screen into the firmware
struct CustomUiRectCmd {
    uint16_t x = 24;
    uint16_t y = 24;
    uint16_t width = 272;
    uint16_t height = 192;
    uint8_t style_palette = 0x02;
};

struct CustomUiLabelCmd {
    uint16_t x = 40;
    uint16_t y = 44;
    uint16_t string_id = 0;       // If non-zero, renders via ui_draw_widget_by_string_id (0x55D6BCE8)
    std::string custom_osd_text;  // If non-empty, allocates a new 0x0003 OSD string in part_03 & renders via 0x55D6A3A7/0x55D6BA71
    uint8_t font_style = 0x01;
};

struct CustomUiScreenSpec {
    std::string screen_symbol_name = "ui_screen_custom_tz5_studio";
    std::string menu_label_text    = "TZ5 STUDIO UI";
    uint16_t replace_menu_label_sid = 0x029Fu; // Optional SID to rebind in all 24 languages (e.g. 0x029F = DEMO MODE)
    uint32_t patch_menu_item_va     = 0x55E69FD0u; // Optional 24B VenusMenuItemDescriptor VA to update
    uint32_t hook_call_site_va      = 0;           // Optional 0xDD call instruction in part_02 to redirect to our screen

    std::vector<CustomUiRectCmd> panels;
    std::vector<CustomUiLabelCmd> labels;
};

struct CustomUiBuildResult {
    uint32_t screen_function_va = 0;
    uint32_t screen_function_size = 0;
    uint32_t new_menu_item_va = 0;
    std::vector<uint32_t> allocated_string_vas;
    size_t rebound_language_pointers = 0;
    std::vector<std::string> disassembly_preview;
};

class VenusUiEngine {
public:
    static constexpr size_t kLanguageCount          = 24;
    static constexpr size_t kWordsPerLanguageTable  = 3252; // word[0]=0x12345678, word[1..3251]=SID 0x0001..0x0CB3
    static constexpr uint32_t kLanguageTableStride  = 0x32D0u; // 13,008 bytes per language
    static constexpr size_t kGlyphTableEntryCount   = 7518;    // 0x0000..0x1D5D @ VA 0x55F82ED8 in part_03
    static constexpr size_t kFontStyleEntryCount    = 436;     // 436 × 16B @ VA 0x55F995D8 in part_03

    explicit VenusUiEngine(partitions::PartitionWorkspace& ws);

    // Parse all UI tables across part_02 (.rodata menus), part_03 (glyphs/icons/shared strings), and part_05 (24 languages)
    bool analyze_all(std::string* err = nullptr);

    // Resolve a 16-bit String ID (0x0001..0x0CB3) for a given language index (0=JP, 1=EN, 2=DE, ..., 16=PT, ..., 23=HU)
    std::string resolve_string_id(uint16_t sid, size_t language_index = 1) const;

    // Accessors for reversed structures
    const std::vector<std::string>& language_names() const { return language_names_; }
    const std::vector<uint32_t>& glyph_bitmap_pointers() const { return glyph_bitmap_ptrs_; }
    const std::vector<VenusMenuTableGroup>& menu_groups() const { return menu_groups_; }
    const std::vector<ReversedCameraScreen>& screens() const { return screens_; }
    size_t total_menu_items() const;

    // Modify an existing 24-byte VenusMenuItemDescriptor in part_02 (.rodata)
    bool modify_menu_item_descriptor(uint32_t descriptor_va,
                                     uint16_t new_label_sid,
                                     uint16_t new_icon_sid,
                                     std::string* err = nullptr);

    // Allocate a new 0x0003-terminated 16-bit string in part_03 and rebind `sid` across all 24 languages in part_05
    bool modify_string_id_all_languages(uint16_t sid,
                                        const std::string& new_text,
                                        uint32_t* out_new_string_va = nullptr,
                                        size_t* out_updated_langs = nullptr,
                                        std::string* err = nullptr);

    // Compile and inject a brand-new Custom UI Screen (MN103S rendering function + OSD strings + menu descriptor)
    bool compile_and_inject_custom_ui_screen(const CustomUiScreenSpec& spec,
                                             CustomUiBuildResult* out_result,
                                             std::string* err = nullptr);

    // Export all reversed UI screens, menu tables, and editable C++20 UI code templates to `out_dir`
    bool export_all_ui_screens_code(const std::string& out_dir, std::string* err = nullptr) const;

private:
    std::string decode_glyph_string_at_va(uint32_t va) const;
    std::vector<VenusMenuOptionDescriptor> parse_sub_options(uint32_t sub_opts_va) const;
    void build_reversed_screen_catalog();

    partitions::PartitionWorkspace& ws_;
    std::vector<std::string> language_names_;
    std::vector<uint32_t> glyph_bitmap_ptrs_;
    std::vector<VenusMenuTableGroup> menu_groups_;
    std::vector<ReversedCameraScreen> screens_;
};

} // namespace tz5::ui
