// ============================================================================
// Panasonic Lumix DMC-TZ5 — Editable C++20 UI Modification & New Screen SDK
// Compile as part of tz5_core or invoke via: ./build/tz5-fw-tool ui-build-custom
// ============================================================================
#include "ui_engine/tz5_ui_engine.hpp"
#include "tz5_ui_screens_generated.hpp"

namespace tz5::ui {

bool apply_custom_camera_ui_modifications(partitions::PartitionWorkspace& ws,
                                          CustomUiBuildResult* out_res,
                                          std::string* err) {
    VenusUiEngine engine(ws);
    if (!engine.analyze_all(err)) return false;

    // Example 1: Define a brand-new Custom UI Screen & inject it into [SETUP] Menu
    CustomUiScreenSpec spec;
    spec.screen_symbol_name     = "ui_screen_tz5_studio_telemetry";
    spec.menu_label_text        = "TZ5 STUDIO UI";
    spec.replace_menu_label_sid = 0x029Fu;     // Rebinds SID 0x029F across all 24 languages in part_05
    spec.patch_menu_item_va     = 0x55E69FD0u; // Updates [SETUP] Menu entry @ 0x55E69FD0 in part_02

    // Draw main modal frame & title bar via ui_draw_rect_or_panel (0x55D6AB3E)
    spec.panels.push_back({16, 16, 288, 208, 0x02});
    spec.panels.push_back({16, 16, 288,  30, 0x04});

    // Render localized String IDs (0x55D6BCE8) & custom OSD labels (0x55D6BA71)
    spec.labels.push_back({28,  24, 0x029Fu, "", 0x01});
    spec.labels.push_back({28,  64, 0, "RAW 12-BIT CCD DUMP: ON", 0x01});
    spec.labels.push_back({28,  94, 0, "OPTICAL ZOOM IN HD: ON",  0x01});
    spec.labels.push_back({28, 124, 0x02DCu, "", 0x01}); // SERVICE MODE badge

    return engine.compile_and_inject_custom_ui_screen(spec, out_res, err);
}

} // namespace tz5::ui
