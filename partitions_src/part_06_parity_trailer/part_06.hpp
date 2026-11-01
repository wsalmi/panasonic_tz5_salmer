#pragma once

#include "common/partition_types.hpp"

#include <array>
#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

class Part06ParityTrailer final : public IPartitionModule {
public:
    static constexpr uint32_t kUnpackedStart = 0x484000u;
    static constexpr uint32_t kUnpackedEnd   = 0x484020u;
    static constexpr uint32_t kRegionLimit   = 0x484020u;
    static constexpr uint32_t kBaseVa        = 0x56100000u;
    static constexpr uint32_t kOriginalSize  = 32u; // 16 x uint16_be vertical column parity words

    Part06ParityTrailer();

    const PartitionMetadata& metadata() const override { return meta_; }

    bool load_from_partition_file(const std::string& path, std::string* err = nullptr) override;
    bool load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err = nullptr) override;

    std::vector<uint8_t> emit_partition_bytes() const override;
    bool write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err = nullptr) const override;

    std::string generate_source_documentation() const override;
    std::string generate_json_summary() const override;

    // Accessors & Parity Recomputation API for Partition 06
    const std::array<uint16_t, 16>& column_parity_words() const { return col_words_; }
    uint16_t corner_checksum_word() const;

    // Recompute the 32-byte vertical column-parity trailer from the 0x484000-byte ROM image (Rows 0..147,967)
    void recompute_from_rom_payload(std::span<const uint8_t> rom_payload_484000);

    // Verify whether the current 32-byte trailer matches the 0x484000-byte ROM payload
    bool verify_against_rom_payload(std::span<const uint8_t> rom_payload_484000) const;

private:
    void sync_words_from_bytes();
    void sync_bytes_from_words();

    PartitionMetadata meta_;
    std::vector<uint8_t> bytes_; // 32 bytes
    std::array<uint16_t, 16> col_words_{};
};

} // namespace tz5::partitions
