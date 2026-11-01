// ============================================================================
// PARTITION 02 SOURCE MODULE: part_02_main_firmware
// File: part_02_0x008000_0x21f428.bin (2192424 base bytes + 0 ext bytes)
// Unpacked Flash Range : 0x008000 .. 0x21F428 (CAVE_MAIN_TEXT -> 0x224000)
// Virtual Address (VA) : 0x55C84000 .. 0x55E9B428
// REA Evidence ID      : ev_1bbdae1883713739fda02e5fce3ed5c88cd001e93530af6a9dd9d1c04eedab68
// ============================================================================

#include <cstdint>

namespace tz5::part02_src {

// [Sub-Segment 02a] 'Pana' Firmware Header (VA 0x55C84000) & Model ID (VA 0x55C8FF00)
constexpr char     kPanaMagic[]      = "Pana";
constexpr uint16_t kFirmwareMajor    = 1;
constexpr uint16_t kFirmwareMinor    = 2;
constexpr char     kManufacturer[]   = "Panasonic";
constexpr char     kCameraModel[]    = "DMC-TZ5";
constexpr char     kCameraBrand[]    = "LUMIX";

// [Sub-Segment 02b] Relocated .data Image (ROM 0x55C90000..0x55C9B02C -> SDRAM 0x54012840..0x5401D86C)
// Embedded ROM Pointers: 357 | Embedded SDRAM Pointers: 412

// Function: crt0_main_firmware_entry @ VA 0x55C9B02C (ROM+0x1F02C)
// C Runtime startup: zeros cached .bss (0x5401D86C..0x54077238), uncached DMA .bss (0x9809A400..0x980C0000), and copies .data (0x55C90000 -> 0x54012840).
void crt0_main_firmware_entry(void) {
    memset((void*)0x5401D86C, 0, 0x54077238 - 0x5401D86C); // 367,052 B
    memset((void*)0x9809A400, 0, 0x980C0000 - 0x9809A400); // 154,624 B
    memcpy((void*)0x54012840, (const void*)0x55C90000, 0x0000B02C); // 45,100 B
    rtos_system_startup();
}

// Function: eeprom_data_info_dumper @ VA 0x55CE8445 (ROM+0x6C445)
// Formats and dumps factory EEPROM calibration blocks ('###### EEPROM DATA INFORMATION ######') to SDRAM 0x98149800 / SD card.
int eeprom_data_info_dumper(int dev_id) {
    str_copy_format_helper((char*)0x98149800, "###### EEPROM DATA INFORMATION ######\r\n");
    return dump_calibration_tables(0x98149800);
}

// Function: tz5_ahx_executable_loader @ VA 0x55CE93F4 (ROM+0x6D3F4)
// Checks for '\TZ5.AHX' (0x55E5FC34) and '\TZ5E.AHX' (0x55E5FC3D) firmware update images on SD card.
int tz5_ahx_executable_loader(const char* drive) {
    if (fs_open_check(drive, "\\TZ5.AHX", 0x40) == 0)
        return execute_ahx_payload("\\TZ5.AHX");
    return execute_ahx_payload("\\TZ5E.AHX");
}

// Function: service_mode_camera_info_screen @ VA 0x55D87488 (ROM+0x10B488)
// Renders the Service Mode 'CAMERA INFO.' telemetry screen (PWRCNT, SHTCNT, STBCNT, PSVCNT, ClockSet Cnt, UnderCut Cnt, CCD_TEMP).
void service_mode_camera_info_screen(void) {
    ui_draw_ascii_label("CAMERA INFO.", 0x010D, 0x038A);
    ui_refresh_screen_layer();
}

// Function: romdata_and_firmware_bin_handler @ VA 0x55D9C0B8 (ROM+0x1200B8)
// Selects between SD card (B:\) and internal flash (A:\) for ROMDATA.BIN backup dumps and FIRMWARE.BIN updates.
int romdata_and_firmware_bin_handler(int mode, int drive_sel) {
    const char* path = (mode == 0)
        ? (drive_sel ? "B:\\ROMDATA.BIN" : "A:\\ROMDATA.BIN")
        : (drive_sel ? "B:\\FIRMWARE.BIN" : "A:\\FIRMWARE.BIN");
    return flash_stream_transfer(path);
}

// Function: venus_master_irq_dispatcher @ VA 0x55E97FC7 (ROM+0x21BFC7)
// High-ROM central interrupt controller dispatcher targeted by hardware vector slots 3..9 (0x55C80018..0x55C80048).
void venus_master_irq_dispatcher(void) {
    uint16_t pending = VENUS_INTC_STATUS & VENUS_INTC_ENABLE;
    dispatch_registered_isr_table(pending);
}

} // namespace tz5::part02_src
