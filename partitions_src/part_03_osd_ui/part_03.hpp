#pragma once

#include "common/partition_types.hpp"

#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

struct OsdStringRecord {
    uint32_t rel_offset = 0;
    uint32_t va = 0;
    uint16_t terminator = 0x0003u; // 0x0003 (Panasonic OSD) or 0x0000 (standard UTF-16LE)
    std::string ascii_text;
};

class Part03OsdUi final : public IPartitionModule {
public:
    static constexpr uint32_t kUnpackedStart = 0x224000u;
    static constexpr uint32_t kUnpackedEnd   = 0x31F118u;
    static constexpr uint32_t kRegionLimit   = 0x36B800u; // 313,064 bytes of 0xFF expansion in CAVE_UPPER_ROM
    static constexpr uint32_t kBaseVa        = 0x55EA0000u;
    static constexpr uint32_t kOriginalSize  = kUnpackedEnd - kUnpackedStart; // 1,028,376 bytes

    Part03OsdUi();

    const PartitionMetadata& metadata() const override { return meta_; }

    bool load_from_partition_file(const std::string& path, std::string* err = nullptr) override;
    bool load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err = nullptr) override;

    std::vector<uint8_t> emit_partition_bytes() const override;
    bool write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err = nullptr) const override;

    std::string generate_source_documentation() const override;
    std::string generate_json_summary() const override;

    // Accessors
    const std::vector<uint8_t>& raw_bytes() const { return bytes_; }
    const std::vector<uint8_t>& ext_bytes() const { return ext_bytes_; }
    const std::vector<OsdStringRecord>& osd_0003_strings() const { return osd_0003_strings_; }
    const std::vector<OsdStringRecord>& utf16_0000_strings() const { return utf16_0000_strings_; }

    // Modification & Feature Addition API for Partition 03
    // Edit an existing 0x0003-terminated OSD string at its Virtual Address (0x55EA0000..0x55F9B118)
    bool patch_osd_string_at_va(uint32_t va, const std::string& new_text, std::string* err = nullptr);

    // Allocate a new 0x0003-terminated 16-bit OSD string in Partition 03's expansion cave (0x55F9B118+)
    // Returns the new Virtual Address (VA) so it can be linked into Partition 05's 0x12345678 pointer table!
    bool add_new_osd_string(const std::string& text, uint32_t* out_new_va, std::string* err = nullptr);

private:
    void parse_structures();

    PartitionMetadata meta_;
    std::vector<uint8_t> bytes_;     // Base 1,028,376 bytes
    std::vector<uint8_t> ext_bytes_; // Expansion strings/fonts in CAVE_UPPER_ROM (0x31F118..0x36B800)
    std::vector<OsdStringRecord> osd_0003_strings_;
    std::vector<OsdStringRecord> utf16_0000_strings_;
};

} // namespace tz5::partitions
