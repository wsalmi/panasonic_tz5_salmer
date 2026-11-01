#pragma once

#include "tz5/firmware.hpp"

#include <cstddef>
#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

struct PartitionMetadata {
    int index = 0;
    std::string id;
    std::string filename;
    uint32_t unpacked_start = 0;
    uint32_t unpacked_end = 0;
    uint32_t region_limit = 0; // End of surrounding 0xFF flash sector region before next partition
    uint32_t va_start = 0;
    uint32_t va_end = 0;
    std::string original_sha256;
    std::string rea_evidence_id;
    std::string rea_manifest_id;
    std::string role_summary;
};

struct SubroutineDoc {
    uint32_t va = 0;
    uint32_t rom_offset = 0;
    std::string name;
    std::string signature;
    std::string summary;
    std::string pseudo_c;
};

class IPartitionModule {
public:
    virtual ~IPartitionModule() = default;

    virtual const PartitionMetadata& metadata() const = 0;

    // Load from isolated partition .bin file (e.g. output/partitions/part_XX_...bin)
    virtual bool load_from_partition_file(const std::string& path, std::string* err = nullptr) = 0;

    // Load from full unpacked ROM image (0x484000 or 0x484020 bytes)
    virtual bool load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err = nullptr) = 0;

    // Compile/emit the standalone partition binary (.bin)
    virtual std::vector<uint8_t> emit_partition_bytes() const = 0;

    // Write the compiled partition bytes into the full 0x484000-byte ROM image at unpacked_start
    virtual bool write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err = nullptr) const = 0;

    // Save the standalone compiled partition binary to disk
    bool save_partition_file(const std::string& path, std::string* err = nullptr) const;

    // Generate human-readable decompiled C++20 / assembly / structural source report for this partition
    virtual std::string generate_source_documentation() const = 0;

    // Generate JSON summary of this partition's parsed structures
    virtual std::string generate_json_summary() const = 0;
};

} // namespace tz5::partitions
