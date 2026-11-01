#pragma once

#include "common/partition_types.hpp"

#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

struct MasterTableStats {
    uint32_t magic = 0;               // 0x12345678 @ VA 0x56000000 (ROM 0x384000)
    uint32_t first_upper_res_va = 0;  // 0x56050E98 @ VA 0x56000004 (ROM 0x384004)
    size_t total_word_entries = 0;    // 82,853 words in 0x384004..0x3D4E98
    size_t part03_pointer_count = 0;  // 60,504 pointers -> 0x55EA0000..0x55F9B118
    size_t part05_pointer_count = 0;  // 17,520 pointers -> 0x56000000..0x560FCF08
    size_t upper_osd_0003_count = 0;  // 0x0003-terminated strings inside 0x3D4E98..0x480F08
};

class Part05ResourceTables final : public IPartitionModule {
public:
    static constexpr uint32_t kUnpackedStart = 0x374000u;
    static constexpr uint32_t kUnpackedEnd   = 0x480F08u;
    static constexpr uint32_t kRegionLimit   = 0x484000u; // 12,536 bytes of 0xFF expansion in CAVE_TAIL_ROM
    static constexpr uint32_t kBaseVa        = 0x55FF0000u;
    static constexpr uint32_t kOriginalSize  = kUnpackedEnd - kUnpackedStart; // 1,101,576 bytes

    // Relative offsets inside part_05 (where offset 0 == unpacked 0x374000 == VA 0x55FF0000)
    static constexpr uint32_t kRelZeroArenaStart   = 0x000000u; // 64 KB of 0x00 (0x374000..0x383FFF)
    static constexpr uint32_t kRelMasterTableStart = 0x010000u; // Unpacked 0x384000 (VA 0x56000000, magic 0x12345678)
    static constexpr uint32_t kRelMasterTableEnd   = 0x060E98u; // Unpacked 0x3D4E98 (VA 0x56050E98)
    static constexpr uint32_t kRelUpperResStart    = 0x060E98u; // Unpacked 0x3D4E98..0x480F08

    Part05ResourceTables();

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
    const MasterTableStats& table_stats() const { return stats_; }
    uint32_t read_master_table_word(size_t word_index) const;

    // Modification & Feature Addition API for Partition 05
    // Update a specific 32-bit pointer entry in the 0x12345678 Master Table (word_index 1..82853)
    bool set_master_table_pointer(size_t word_index, uint32_t new_target_va, std::string* err = nullptr);

    // Replace all occurrences of old_target_va in the 0x12345678 Master Table with new_target_va
    // Returns the number of updated pointer slots.
    size_t rebind_master_pointers_by_va(uint32_t old_target_va, uint32_t new_target_va);

    // Append a custom resource blob or 0x0003 OSD string into Partition 05's CAVE_TAIL_ROM (0x560FCF08+)
    bool append_upper_resource_blob(std::span<const uint8_t> blob, uint32_t* out_va, std::string* err = nullptr);

private:
    void parse_structures();

    PartitionMetadata meta_;
    std::vector<uint8_t> bytes_;     // Base 1,101,576 bytes
    std::vector<uint8_t> ext_bytes_; // Expansion in CAVE_TAIL_ROM (0x480F08..0x484000)
    MasterTableStats stats_;
};

} // namespace tz5::partitions
