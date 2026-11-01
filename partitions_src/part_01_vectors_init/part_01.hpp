#pragma once

#include "common/partition_types.hpp"

#include <array>
#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

struct HardwareVectorSlot {
    int slot_index = 0;
    std::string name;
    uint32_t slot_va = 0;
    uint32_t target_va = 0;
    std::array<uint8_t, 8> raw_bytes{};
    std::string instruction_desc;
};

class Part01VectorsInit final : public IPartitionModule {
public:
    static constexpr uint32_t kUnpackedStart = 0x004000u;
    static constexpr uint32_t kUnpackedEnd   = 0x0049F2u;
    static constexpr uint32_t kRegionLimit   = 0x008000u; // 13,838 bytes of 0xFF XIP expansion space
    static constexpr uint32_t kBaseVa        = 0x55C80000u;
    static constexpr uint32_t kOriginalSize  = kUnpackedEnd - kUnpackedStart; // 2,546 bytes

    static constexpr uint32_t kKernelDataRelOff = 0x000638u; // 0x004638 in ROM (VA 0x55C80638)
    static constexpr uint32_t kKernelDataRamVa  = 0x54000400u;
    static constexpr uint32_t kKernelDataSize   = 0x00002Cu; // 44 bytes -> 0x5400042C
    static constexpr uint32_t kKernelBssStart   = 0x5400042Cu;
    static constexpr uint32_t kKernelBssEnd     = 0x540127E4u;

    Part01VectorsInit();

    const PartitionMetadata& metadata() const override { return meta_; }

    bool load_from_partition_file(const std::string& path, std::string* err = nullptr) override;
    bool load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err = nullptr) override;

    std::vector<uint8_t> emit_partition_bytes() const override;
    bool write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err = nullptr) const override;

    std::string generate_source_documentation() const override;
    std::string generate_json_summary() const override;

    // Accessors
    const std::vector<HardwareVectorSlot>& vector_slots() const { return vector_slots_; }
    const std::vector<SubroutineDoc>& subroutines() const { return subroutines_; }
    std::span<const uint8_t> kernel_data_init_image() const;

    // Modification & Feature Addition API for Partition 01
    // Update the 16-bit BCD Firmware Version descriptor at 0x0006A0 (VA 0x55C806A0)
    bool set_firmware_version(uint16_t major, uint16_t minor, std::string* err = nullptr);

    // Redirect one of the 7 IRQ group vector slots (slot_index 3..9, corresponding to IRQ groups 0..6) to a new handler VA
    bool redirect_irq_vector_slot(int slot_index, uint32_t new_handler_va, std::string* err = nullptr);

    // Modify a 32-bit word in the 44-byte Kernel .data initial image (copied at boot to 0x54000400..0x5400042C)
    bool set_kernel_data_word(uint32_t word_index, uint32_t value, std::string* err = nullptr);

    // Append a custom ISR handler into Partition 01's expansion cave (0x55C809F4..0x55C83FFF)
    bool append_custom_isr(const std::string& name,
                           const std::vector<std::string>& asm_lines,
                           uint32_t* out_va = nullptr,
                           std::string* err = nullptr);

private:
    void parse_structures();

    PartitionMetadata meta_;
    std::vector<uint8_t> bytes_;
    std::vector<uint8_t> ext_bytes_;
    std::vector<HardwareVectorSlot> vector_slots_;
    std::vector<SubroutineDoc> subroutines_;
};

} // namespace tz5::partitions
