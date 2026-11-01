#pragma once

#include "common/partition_types.hpp"

#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

struct BootRamCopyDescriptor {
    std::string name;
    uint32_t src_rom_va = 0;
    uint32_t dst_ram_va = 0;
    uint32_t size_bytes = 0;
    std::string purpose;
};

struct BootMmioInitWrite {
    uint32_t insn_va = 0;
    uint32_t mmio_addr = 0;
    std::string peripheral_name;
    std::string operation;
};

class Part00Bootloader final : public IPartitionModule {
public:
    static constexpr uint32_t kUnpackedStart = 0x000000u;
    static constexpr uint32_t kUnpackedEnd   = 0x001305u;
    static constexpr uint32_t kRegionLimit   = 0x004000u; // 11,515 bytes of 0xFF XIP expansion space
    static constexpr uint32_t kBaseVa        = 0x55C7C000u;
    static constexpr uint32_t kOriginalSize  = kUnpackedEnd - kUnpackedStart; // 4,869 bytes

    Part00Bootloader();

    const PartitionMetadata& metadata() const override { return meta_; }

    bool load_from_partition_file(const std::string& path, std::string* err = nullptr) override;
    bool load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err = nullptr) override;

    std::vector<uint8_t> emit_partition_bytes() const override;
    bool write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err = nullptr) const override;

    std::string generate_source_documentation() const override;
    std::string generate_json_summary() const override;

    // Structured inspection accessors
    uint32_t initial_stack_or_jump_va() const;
    const std::vector<BootRamCopyDescriptor>& ram_copy_descriptors() const { return ram_copies_; }
    const std::vector<BootMmioInitWrite>& mmio_writes() const { return mmio_writes_; }
    const std::vector<SubroutineDoc>& subroutines() const { return subroutines_; }

    // Modification & Feature Addition API for Partition 00
    bool set_initial_boot_target_va(uint32_t new_va, std::string* err = nullptr);
    bool patch_bootloader_bytes(uint32_t offset_or_va, std::span<const uint8_t> data, std::string* err = nullptr);

    // Append a new MN103S routine or table into Partition 00's expansion region (0x55C7D308..0x55C7FFFF)
    bool append_early_boot_extension(const std::string& name,
                                     const std::vector<std::string>& asm_lines,
                                     uint32_t* out_va = nullptr,
                                     std::string* err = nullptr);

private:
    void parse_structures();

    PartitionMetadata meta_;
    std::vector<uint8_t> bytes_;       // Base 4,869 bytes (or extended up to 0x004000)
    std::vector<uint8_t> ext_bytes_;   // Optional appended extension bytes in 0x001305..0x004000
    std::vector<BootRamCopyDescriptor> ram_copies_;
    std::vector<BootMmioInitWrite> mmio_writes_;
    std::vector<SubroutineDoc> subroutines_;
};

} // namespace tz5::partitions
