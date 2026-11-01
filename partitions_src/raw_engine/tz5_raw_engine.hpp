#pragma once

#include "partition_workspace.hpp"
#include "ui_engine/tz5_ui_engine.hpp"
#include "tz5/assembler.hpp"

#include <cstdint>
#include <string>
#include <vector>

namespace tz5::raw {

// ============================================================================
// Panasonic Lumix DMC-TZ5 (Venus Engine IV) — RAW Image Engine & SD Loader
// ============================================================================
//
// Sensor & Hardware Specifications:
//   - Sensor: 1/2.33" CCD, 10.7 Megapixels (3648 x 2736 active photosites)
//   - Color Filter Array (CFA): RGGB Bayer filter
//   - ADC Resolution: 12-bit uncompressed Bayer dump (~15,360,000 bytes per frame)
//   - Storage Bus: SD / SDHC (Class 2 to Class 10, sustained 2.0 to 6.0 MB/s write)
//   - Write Latency without compression: ~3.5 to 5.0 seconds
//
// RAW Integration Architecture:
//   1. part_02 (.rodata Menu Tables):
//      - QUALITY Sub-Options Table @ VA 0x55E6742C:
//          Option 0 (0x0000): FINE JPEG      (Active, style 0x55E6C2A4)
//          Option 1 (0x0001): STANDARD JPEG  (Active, style 0x55E6C2A4)
//          Option 2 (0x0003): RAW            (Unlocked! style changed from 0x55E6C2AC -> 0x55E6C2A4)
//          Option 3 (0x0005): RAW + JPEG     (Unlocked! style changed from 0x55E6C2AC -> 0x55E6C2A4)
//          Option 4 (0x00FF): Terminator
//      - Setup Menu Item 34 @ VA 0x55E69FD0:
//          Rebinds unused Demo Mode to dedicated "RAW CAPTURE & LOADER" toggle.
//   2. part_03 (OSD Strings & Glyphs):
//      - Allocates new 0x0003-terminated 16-bit OSD strings:
//          * "RAW"
//          * "RAW+JPEG"
//          * "RAW CAPTURE & LOADER"
//   3. part_05 (Resource & 24-Language Table):
//      - Binds new string VAs across all 24 language blocks in master table (magic 0x12345678).
//   4. Visual Recording Loader Routine (MN103S in part_02 CAVE_MAIN_TEXT):
//      - Due to low SD card bandwidth (~3.8 MB/s), saving ~15 MB takes ~4 seconds.
//      - Renders an animated modal dialog on the camera LCD:
//          * Modal Backdrop & Gold Header (kDrawRectOrPanel @ 0x55D6AB3E)
//          * Labels: "RAW CAPTURE IN PROGRESS", "SAVING TO SD CARD...", "SD WRITE: ~3.8 MB/s"
//          * Progress Track & Animated Progress Bar (0% -> 100%)
//          * Layer Refresh (kRefreshScreenLayer @ 0x55D6F036) for smooth on-screen updates.
//   5. Firmware Version:
//      - Updated to v1.3 (Major: 1, Minor: 30) in "Pana" header @ 0x008008.
// ============================================================================

struct RawConfigOptions {
    bool enable_quality_menu_raw = true;     // Unlock Option 2 & 3 in QUALITY menu
    bool enable_setup_menu_toggle = true;    // Rebind Demo Mode item in SETUP menu
    bool enable_visual_sd_loader = true;     // Inject visual progress bar loader routine
    uint16_t version_major = 1;              // Version major = 1
    uint16_t version_minor = 3;              // Version minor = 3 (01 00 03 00 -> v1.3, higher than factory 1.2 which is 01 00 02 00)
    float estimated_sd_speed_mbs = 3.8f;     // Estimated SD write speed in MB/s
    uint32_t sensor_raw_bytes = 15360000u;   // 10.7 MP 12-bit Bayer CCD (3648x2736)
};

struct RawInjectionResult {
    uint32_t quality_sub_opts_va = 0x55E6742Cu;
    size_t unlocked_quality_options = 0;
    uint32_t raw_label_va = 0;
    uint32_t raw_plus_jpeg_label_va = 0;
    uint32_t setup_menu_label_va = 0;
    size_t rebound_language_entries = 0;
    uint32_t loader_function_va = 0;
    uint32_t loader_function_size = 0;
    uint32_t setup_menu_item_va = 0x55E69FD0u;
    std::string firmware_version_str;
    std::vector<std::string> disassembly_preview;
};

class VenusRawEngine {
public:
    explicit VenusRawEngine(partitions::PartitionWorkspace& ws);

    // Apply the complete RAW feature mod:
    //   1. Unlock Option 2 (RAW) and Option 3 (RAW+JPEG) in QUALITY sub-options table
    //   2. Allocate localized OSD strings and rebind 24-language master table in part_05
    //   3. Rebind SETUP menu item to RAW Mode toggle
    //   4. Assemble and inject the Visual SD Loader routine in part_02 CAVE_MAIN_TEXT
    //   5. Update firmware version to v1.3
    bool apply_raw_mod(const RawConfigOptions& opts,
                       RawInjectionResult* out_result,
                       std::string* err = nullptr);

    // Export comprehensive documentation and technical specification
    bool export_raw_docs(const std::string& out_dir,
                         const RawInjectionResult& res,
                         std::string* err = nullptr) const;

private:
    bool unlock_quality_sub_options(RawInjectionResult& res, std::string* err);
    bool inject_visual_sd_loader(const RawConfigOptions& opts, RawInjectionResult& res, std::string* err);
    bool configure_setup_menu_toggle(RawInjectionResult& res, std::string* err);

    partitions::PartitionWorkspace& ws_;
    ui::VenusUiEngine ui_;
};

} // namespace tz5::raw
