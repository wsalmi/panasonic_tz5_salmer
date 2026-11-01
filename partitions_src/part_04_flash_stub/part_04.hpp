#pragma once

#include "common/partition_types.hpp"

#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

class Part04FlashStub final : public IPartitionModule {
public:
    static constexpr uint32_t kUnpackedStart = 0x36B800u;
    static constexpr uint32_t kUnpackedEnd   = 0x36B804u;
    static constexpr uint32_t kRegionLimit   = 0x374000u; // 34,812 bytes of 0xFF expansion space before part_05
    static constexpr uint32_t kBaseVa        = 0x55FE7800u;
    static constexpr uint32_t kOriginalSize  = 4u;        // 0xCB 0xCB 0xCB 0xCB

    Part04FlashStub();

    const PartitionMetadata& metadata() const override { return meta_; }

    bool load_from_partition_file(const std::string& path, std::string* err = nullptr) override;
    bool load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err = nullptr) override;

    std::vector<uint8_t> emit_partition_bytes() const override;
    bool write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err = nullptr) const override;

    std::string generate_source_documentation() const override;
    std::string generate_json_summary() const override;

    // Modification & Feature Addition API for Partition 04
    // Replace or extend the 4-byte 0x55FE7800 stub with a custom MN103S XIP subroutine
    bool set_custom_stub_routine(const std::string& fn_name,
                                 const std::vector<std::string>& asm_lines,
                                 std::string* err = nullptr);

private:
    PartitionMetadata meta_;
    std::vector<uint8_t> bytes_; // Defaults to {0xCB, 0xCB, 0xCB, 0xCB}
};

} // namespace tz5::partitions
