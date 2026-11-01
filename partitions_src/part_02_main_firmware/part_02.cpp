#include "part_02_main_firmware/part_02.hpp"
#include "tz5/assembler.hpp"
#include "tz5/symbols.hpp"

#include <cstdio>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::partitions {

Part02MainFirmware::Part02MainFirmware() : bytes_(kOriginalSize, 0xFFu) {
    meta_.index = 2;
    meta_.id = "part_02_main_firmware";
    meta_.filename = "part_02_0x008000_0x21f428.bin";
    meta_.unpacked_start = kUnpackedStart;
    meta_.unpacked_end = kUnpackedEnd;
    meta_.region_limit = kRegionLimit;
    meta_.va_start = kBaseVa;
    meta_.va_end = kBaseVa + kOriginalSize;
    meta_.original_sha256 = "c0717019149caa0c155e3edb7eb05a88b933cd9c22fbc9352d16308bd0cf42f8";
    meta_.rea_evidence_id = "ev_1bbdae1883713739fda02e5fce3ed5c88cd001e93530af6a9dd9d1c04eedab68";
    meta_.rea_manifest_id = "agm_d6ee5b01c0c789608710329f4bd6852515474cd732525dd678b8adbb7d107c5b";
    meta_.role_summary = "Pana v1.02 Header, DMC-TZ5 Model ID, Relocated .data (45,100 B), CRT0, Main .text (\\TZ5.AHX), .rodata & Master IRQ Dispatcher";
}

bool Part02MainFirmware::load_from_partition_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open part_02 file: " + path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    if (sz < kOriginalSize || sz > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Invalid part_02 size";
        return false;
    }
    ifs.seekg(0, std::ios::beg);
    bytes_.resize(kOriginalSize);
    ifs.read(reinterpret_cast<char*>(bytes_.data()), static_cast<std::streamsize>(kOriginalSize));
    ext_bytes_.clear();
    if (sz > kOriginalSize) {
        ext_bytes_.resize(sz - kOriginalSize);
        ifs.read(reinterpret_cast<char*>(ext_bytes_.data()), static_cast<std::streamsize>(sz - kOriginalSize));
    }
    parse_structures();
    return true;
}

bool Part02MainFirmware::load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err) {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "ROM too small to contain part_02";
        return false;
    }
    bytes_.assign(full_rom.begin() + kUnpackedStart, full_rom.begin() + kUnpackedEnd);
    ext_bytes_.clear();
    uint32_t last_active = kUnpackedEnd;
    for (uint32_t off = kRegionLimit - 1; off >= kUnpackedEnd; --off) {
        if (full_rom[off] != 0xFFu) {
            last_active = off + 1u;
            break;
        }
    }
    if (last_active > kUnpackedEnd) {
        ext_bytes_.assign(full_rom.begin() + kUnpackedEnd, full_rom.begin() + last_active);
    }
    parse_structures();
    return true;
}

std::vector<uint8_t> Part02MainFirmware::emit_partition_bytes() const {
    std::vector<uint8_t> out = bytes_;
    if (!ext_bytes_.empty()) {
        out.insert(out.end(), ext_bytes_.begin(), ext_bytes_.end());
    }
    return out;
}

bool Part02MainFirmware::write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err) const {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "Target ROM buffer too small for part_02";
        return false;
    }
    auto emitted = emit_partition_bytes();
    if (emitted.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "part_02 emitted bytes exceed 0x224000 region limit";
        return false;
    }
    std::fill(full_rom.begin() + kUnpackedStart, full_rom.begin() + kRegionLimit, 0xFFu);
    std::memcpy(full_rom.data() + kUnpackedStart, emitted.data(), emitted.size());
    return true;
}

std::string Part02MainFirmware::read_cstr(uint32_t rel_off, size_t max_len) const {
    std::string s;
    for (size_t i = 0; i < max_len && (rel_off + i) < bytes_.size(); ++i) {
        uint8_t b = bytes_[rel_off + i];
        if (b == 0) break;
        if (b >= 32 && b < 127) s.push_back(static_cast<char>(b));
    }
    return s;
}

bool Part02MainFirmware::set_firmware_version(uint16_t major, uint16_t minor, std::string* err) {
    if (bytes_.size() < 16) {
        if (err) *err = "part_02 buffer uninitialized";
        return false;
    }
    bytes_[8]  = static_cast<uint8_t>(major & 0xFFu);
    bytes_[9]  = static_cast<uint8_t>((major >> 8) & 0xFFu);
    bytes_[10] = static_cast<uint8_t>(minor & 0xFFu);
    bytes_[11] = static_cast<uint8_t>((minor >> 8) & 0xFFu);
    parse_structures();
    return true;
}

bool Part02MainFirmware::set_camera_model_identity(const std::string& model_name,
                                                   const std::string& brand_family,
                                                   std::string* err) {
    if (model_name.size() > 15 || brand_family.size() > 7) {
        if (err) *err = "model_name max 15 chars, brand_family max 7 chars in 0x013F10/0x013F38 blocks";
        return false;
    }
    std::memset(bytes_.data() + kRelModelIdBlock + 0x10u, 0, 16);
    std::memcpy(bytes_.data() + kRelModelIdBlock + 0x10u, model_name.data(), model_name.size());

    std::memset(bytes_.data() + kRelModelIdBlock + 0x38u, 0, 8);
    std::memcpy(bytes_.data() + kRelModelIdBlock + 0x38u, brand_family.data(), brand_family.size());
    parse_structures();
    return true;
}

bool Part02MainFirmware::patch_data_segment_u32(uint32_t sdram_va, uint32_t new_val, std::string* err) {
    if (sdram_va < FirmwareImage::kDataRamVa || sdram_va + 4 > (FirmwareImage::kDataRamVa + FirmwareImage::kDataSize)) {
        if (err) *err = "SDRAM VA outside initialized .data range (0x54012840..0x5401D86C)";
        return false;
    }
    uint32_t rel = kRelDataStart + (sdram_va - FirmwareImage::kDataRamVa);
    bytes_[rel + 0] = static_cast<uint8_t>(new_val & 0xFFu);
    bytes_[rel + 1] = static_cast<uint8_t>((new_val >> 8) & 0xFFu);
    bytes_[rel + 2] = static_cast<uint8_t>((new_val >> 16) & 0xFFu);
    bytes_[rel + 3] = static_cast<uint8_t>((new_val >> 24) & 0xFFu);
    return true;
}

uint32_t Part02MainFirmware::read_data_segment_u32(uint32_t sdram_va) const {
    if (sdram_va < FirmwareImage::kDataRamVa || sdram_va + 4 > (FirmwareImage::kDataRamVa + FirmwareImage::kDataSize)) {
        return 0;
    }
    uint32_t rel = kRelDataStart + (sdram_va - FirmwareImage::kDataRamVa);
    return static_cast<uint32_t>(bytes_[rel]) |
           (static_cast<uint32_t>(bytes_[rel + 1]) << 8) |
           (static_cast<uint32_t>(bytes_[rel + 2]) << 16) |
           (static_cast<uint32_t>(bytes_[rel + 3]) << 24);
}

bool Part02MainFirmware::patch_rodata_ascii(uint32_t target_va, const std::string& new_text, bool null_terminate, std::string* err) {
    if (target_va < kBaseVa || target_va >= (kBaseVa + bytes_.size())) {
        if (err) *err = "target_va outside part_02 address range";
        return false;
    }
    uint32_t rel = target_va - kBaseVa;
    size_t len = new_text.size() + (null_terminate ? 1u : 0u);
    if (rel + len > bytes_.size()) {
        if (err) *err = "String patch exceeds part_02 bounds";
        return false;
    }
    std::memcpy(bytes_.data() + rel, new_text.data(), new_text.size());
    if (null_terminate) {
        bytes_[rel + new_text.size()] = 0x00u;
    }
    return true;
}

bool Part02MainFirmware::add_cave_ascii_string(const std::string& text, uint32_t* out_va, std::string* err) {
    size_t cur_total = bytes_.size() + ext_bytes_.size();
    while ((cur_total % 4u) != 0u) {
        ext_bytes_.push_back(0xFFu);
        cur_total++;
    }
    if (cur_total + text.size() + 1 > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Insufficient space in part_02 CAVE_MAIN_TEXT";
        return false;
    }
    uint32_t str_va = kBaseVa + static_cast<uint32_t>(cur_total);
    ext_bytes_.insert(ext_bytes_.end(), text.begin(), text.end());
    ext_bytes_.push_back(0x00u);
    if (out_va) *out_va = str_va;
    return true;
}

bool Part02MainFirmware::add_cave_function(const std::string& fn_name,
                                           const std::vector<std::string>& asm_lines,
                                           uint32_t* out_va,
                                           std::string* err) {
    size_t cur_total = bytes_.size() + ext_bytes_.size();
    while ((cur_total % 4u) != 0u) {
        ext_bytes_.push_back(0xFFu);
        cur_total++;
    }
    uint32_t fn_va = kBaseVa + static_cast<uint32_t>(cur_total);
    Mn103Assembler as(fn_va);
    std::unordered_map<std::string, uint32_t> syms;
    for (const auto& [va, sname] : get_default_code_symbols()) {
        syms[sname] = va;
    }
    syms[fn_name] = fn_va;
    for (const auto& line : asm_lines) {
        if (!as.assemble_line(line, syms, err)) {
            return false;
        }
    }
    if (cur_total + as.bytes().size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Insufficient space in part_02 CAVE_MAIN_TEXT";
        return false;
    }
    ext_bytes_.insert(ext_bytes_.end(), as.bytes().begin(), as.bytes().end());
    if (out_va) *out_va = fn_va;
    return true;
}

bool Part02MainFirmware::patch_bytes_at_va(uint32_t target_va, std::span<const uint8_t> patch, std::string* err) {
    if (target_va < kBaseVa || target_va + patch.size() > (kBaseVa + bytes_.size())) {
        if (err) *err = "target_va outside part_02 range";
        return false;
    }
    uint32_t rel = target_va - kBaseVa;
    std::memcpy(bytes_.data() + rel, patch.data(), patch.size());
    return true;
}

bool Part02MainFirmware::append_cave_bytes(std::span<const uint8_t> data, uint32_t* out_va, std::string* err) {
    size_t cur_total = bytes_.size() + ext_bytes_.size();
    while ((cur_total % 4u) != 0u) {
        ext_bytes_.push_back(0xFFu);
        cur_total++;
    }
    if (cur_total + data.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Insufficient space in part_02 CAVE_MAIN_TEXT";
        return false;
    }
    uint32_t va = kBaseVa + static_cast<uint32_t>(cur_total);
    ext_bytes_.insert(ext_bytes_.end(), data.begin(), data.end());
    if (out_va) *out_va = va;
    return true;
}

bool Part02MainFirmware::hook_call_instruction(uint32_t call_insn_va, uint32_t new_target_va, std::string* err) {
    if (call_insn_va < kBaseVa || call_insn_va + 7 > (kBaseVa + bytes_.size())) {
        if (err) *err = "call_insn_va outside part_02";
        return false;
    }
    uint32_t rel = call_insn_va - kBaseVa;
    if (bytes_[rel] != 0xDDu) {
        if (err) *err = "Expected 7-byte 0xDD call instruction at call_insn_va";
        return false;
    }
    auto disp32 = static_cast<int32_t>(static_cast<int64_t>(new_target_va) - static_cast<int64_t>(call_insn_va));
    uint32_t udisp = static_cast<uint32_t>(disp32);
    bytes_[rel + 1] = static_cast<uint8_t>(udisp & 0xFFu);
    bytes_[rel + 2] = static_cast<uint8_t>((udisp >> 8) & 0xFFu);
    bytes_[rel + 3] = static_cast<uint8_t>((udisp >> 16) & 0xFFu);
    bytes_[rel + 4] = static_cast<uint8_t>((udisp >> 24) & 0xFFu);
    return true;
}

void Part02MainFirmware::parse_structures() {
    if (bytes_.size() < kOriginalSize) return;

    std::memcpy(header_.magic, bytes_.data() + 2, 4);
    header_.magic[4] = '\0';
    header_.version_major = static_cast<uint16_t>(bytes_[8]) | (static_cast<uint16_t>(bytes_[9]) << 8);
    header_.version_minor = static_cast<uint16_t>(bytes_[10]) | (static_cast<uint16_t>(bytes_[11]) << 8);
    header_.build_flags   = static_cast<uint32_t>(bytes_[12]) | (static_cast<uint32_t>(bytes_[13]) << 8);

    header_.manufacturer = read_cstr(kRelModelIdBlock + 0x00u, 16);
    header_.model_name   = read_cstr(kRelModelIdBlock + 0x10u, 16);
    header_.vendor_tag   = read_cstr(kRelModelIdBlock + 0x20u, 8);
    header_.short_code   = read_cstr(kRelModelIdBlock + 0x30u, 8);
    header_.brand_family = read_cstr(kRelModelIdBlock + 0x38u, 8);

    // Count ROM and RAM pointers inside the 45,100-byte .data segment (kRelDataStart..kRelCrt0Entry)
    data_stats_.rom_pointer_count = 0;
    data_stats_.ram_pointer_count = 0;
    for (uint32_t off = kRelDataStart; off + 4 <= kRelCrt0Entry; off += 4) {
        uint32_t w = static_cast<uint32_t>(bytes_[off]) |
                     (static_cast<uint32_t>(bytes_[off + 1]) << 8) |
                     (static_cast<uint32_t>(bytes_[off + 2]) << 16) |
                     (static_cast<uint32_t>(bytes_[off + 3]) << 24);
        if (w >= 0x55C7C000u && w < 0x56100000u) {
            data_stats_.rom_pointer_count++;
        } else if (w >= 0x54000000u && w < 0x54300000u) {
            data_stats_.ram_pointer_count++;
        }
    }

    subroutines_.clear();
    subroutines_.push_back({
        0x55C9B02Cu, 0x01F02Cu, "crt0_main_firmware_entry", "void crt0_main_firmware_entry(void)",
        "C Runtime startup: zeros cached .bss (0x5401D86C..0x54077238), uncached DMA .bss (0x9809A400..0x980C0000), and copies .data (0x55C90000 -> 0x54012840).",
        "void crt0_main_firmware_entry(void) {\n"
        "    memset((void*)0x5401D86C, 0, 0x54077238 - 0x5401D86C); // 367,052 B\n"
        "    memset((void*)0x9809A400, 0, 0x980C0000 - 0x9809A400); // 154,624 B\n"
        "    memcpy((void*)0x54012840, (const void*)0x55C90000, 0x0000B02C); // 45,100 B\n"
        "    rtos_system_startup();\n"
        "}"
    });
    subroutines_.push_back({
        0x55CE8445u, 0x06C445u, "eeprom_data_info_dumper", "int eeprom_data_info_dumper(int dev_id)",
        "Formats and dumps factory EEPROM calibration blocks ('###### EEPROM DATA INFORMATION ######') to SDRAM 0x98149800 / SD card.",
        "int eeprom_data_info_dumper(int dev_id) {\n"
        "    str_copy_format_helper((char*)0x98149800, \"###### EEPROM DATA INFORMATION ######\\r\\n\");\n"
        "    return dump_calibration_tables(0x98149800);\n"
        "}"
    });
    subroutines_.push_back({
        0x55CE93F4u, 0x06D3F4u, "tz5_ahx_executable_loader", "int tz5_ahx_executable_loader(const char* drive)",
        "Checks for '\\TZ5.AHX' (0x55E5FC34) and '\\TZ5E.AHX' (0x55E5FC3D) firmware update images on SD card.",
        "int tz5_ahx_executable_loader(const char* drive) {\n"
        "    if (fs_open_check(drive, \"\\\\TZ5.AHX\", 0x40) == 0)\n"
        "        return execute_ahx_payload(\"\\\\TZ5.AHX\");\n"
        "    return execute_ahx_payload(\"\\\\TZ5E.AHX\");\n"
        "}"
    });
    subroutines_.push_back({
        0x55D87488u, 0x10B488u, "service_mode_camera_info_screen", "void service_mode_camera_info_screen(void)",
        "Renders the Service Mode 'CAMERA INFO.' telemetry screen (PWRCNT, SHTCNT, STBCNT, PSVCNT, ClockSet Cnt, UnderCut Cnt, CCD_TEMP).",
        "void service_mode_camera_info_screen(void) {\n"
        "    ui_draw_ascii_label(\"CAMERA INFO.\", 0x010D, 0x038A);\n"
        "    ui_refresh_screen_layer();\n"
        "}"
    });
    subroutines_.push_back({
        0x55D9C0B8u, 0x1200B8u, "romdata_and_firmware_bin_handler", "int romdata_and_firmware_bin_handler(int mode, int drive_sel)",
        "Selects between SD card (B:\\) and internal flash (A:\\) for ROMDATA.BIN backup dumps and FIRMWARE.BIN updates.",
        "int romdata_and_firmware_bin_handler(int mode, int drive_sel) {\n"
        "    const char* path = (mode == 0)\n"
        "        ? (drive_sel ? \"B:\\\\ROMDATA.BIN\" : \"A:\\\\ROMDATA.BIN\")\n"
        "        : (drive_sel ? \"B:\\\\FIRMWARE.BIN\" : \"A:\\\\FIRMWARE.BIN\");\n"
        "    return flash_stream_transfer(path);\n"
        "}"
    });
    subroutines_.push_back({
        0x55E97FC7u, 0x21BFC7u, "venus_master_irq_dispatcher", "void venus_master_irq_dispatcher(void)",
        "High-ROM central interrupt controller dispatcher targeted by hardware vector slots 3..9 (0x55C80018..0x55C80048).",
        "void venus_master_irq_dispatcher(void) {\n"
        "    uint16_t pending = VENUS_INTC_STATUS & VENUS_INTC_ENABLE;\n"
        "    dispatch_registered_isr_table(pending);\n"
        "}"
    });
}

std::string Part02MainFirmware::generate_source_documentation() const {
    std::ostringstream oss;
    oss << "// ============================================================================\n"
        << "// PARTITION 02 SOURCE MODULE: " << meta_.id << "\n"
        << "// File: " << meta_.filename << " (" << bytes_.size() << " base bytes + " << ext_bytes_.size() << " ext bytes)\n"
        << "// Unpacked Flash Range : 0x008000 .. 0x21F428 (CAVE_MAIN_TEXT -> 0x224000)\n"
        << "// Virtual Address (VA) : 0x55C84000 .. 0x55E9B428\n"
        << "// REA Evidence ID      : " << meta_.rea_evidence_id << "\n"
        << "// ============================================================================\n\n"
        << "#include <cstdint>\n\n"
        << "namespace tz5::part02_src {\n\n"
        << "// [Sub-Segment 02a] 'Pana' Firmware Header (VA 0x55C84000) & Model ID (VA 0x55C8FF00)\n"
        << "constexpr char     kPanaMagic[]      = \"" << header_.magic << "\";\n"
        << "constexpr uint16_t kFirmwareMajor    = " << header_.version_major << ";\n"
        << "constexpr uint16_t kFirmwareMinor    = " << header_.version_minor << ";\n"
        << "constexpr char     kManufacturer[]   = \"" << header_.manufacturer << "\";\n"
        << "constexpr char     kCameraModel[]    = \"" << header_.model_name << "\";\n"
        << "constexpr char     kCameraBrand[]    = \"" << header_.brand_family << "\";\n\n"
        << "// [Sub-Segment 02b] Relocated .data Image (ROM 0x55C90000..0x55C9B02C -> SDRAM 0x54012840..0x5401D86C)\n"
        << "// Embedded ROM Pointers: " << data_stats_.rom_pointer_count
        << " | Embedded SDRAM Pointers: " << data_stats_.ram_pointer_count << "\n\n";

    for (const auto& sub : subroutines_) {
        oss << "// Function: " << sub.name << " @ VA 0x" << std::hex << std::uppercase << sub.va
            << " (ROM+0x" << sub.rom_offset << std::dec << ")\n"
            << "// " << sub.summary << "\n"
            << sub.pseudo_c << "\n\n";
    }
    oss << "} // namespace tz5::part02_src\n";
    return oss.str();
}

std::string Part02MainFirmware::generate_json_summary() const {
    auto emitted = emit_partition_bytes();
    std::ostringstream oss;
    oss << "{\n"
        << "  \"partition_index\": 2,\n"
        << "  \"id\": \"" << meta_.id << "\",\n"
        << "  \"va_start\": \"0x55C84000\",\n"
        << "  \"va_end\": \"0x" << std::hex << std::uppercase << (kBaseVa + emitted.size()) << std::dec << "\",\n"
        << "  \"base_size\": " << bytes_.size() << ",\n"
        << "  \"extension_size\": " << ext_bytes_.size() << ",\n"
        << "  \"free_cave_bytes\": " << (kRegionLimit - kUnpackedStart - emitted.size()) << ",\n"
        << "  \"sha256\": \"" << FirmwareImage::sha256_hex(emitted) << "\",\n"
        << "  \"rea_evidence_id\": \"" << meta_.rea_evidence_id << "\",\n"
        << "  \"pana_header\": {\n"
        << "    \"magic\": \"" << header_.magic << "\",\n"
        << "    \"version\": \"" << header_.version_major << "." << std::setw(2) << std::setfill('0') << header_.version_minor << "\",\n"
        << "    \"manufacturer\": \"" << header_.manufacturer << "\",\n"
        << "    \"model_name\": \"" << header_.model_name << "\",\n"
        << "    \"brand_family\": \"" << header_.brand_family << "\"\n"
        << "  },\n"
        << "  \"data_segment\": {\n"
        << "    \"rom_va\": \"0x55C90000..0x55C9B02C\",\n"
        << "    \"sdram_va\": \"0x54012840..0x5401D86C\",\n"
        << "    \"size_bytes\": 45100,\n"
        << "    \"rom_pointers\": " << data_stats_.rom_pointer_count << ",\n"
        << "    \"ram_pointers\": " << data_stats_.ram_pointer_count << "\n"
        << "  }\n"
        << "}\n";
    return oss.str();
}

} // namespace tz5::partitions
