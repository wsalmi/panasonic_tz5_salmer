#pragma once

#include "common/partition_types.hpp"

#include <cstdint>
#include <span>
#include <string>
#include <vector>

namespace tz5::partitions {

struct PanaFirmwareHeader {
    char magic[5]{}; // "Pana"
    uint16_t version_major = 1;
    uint16_t version_minor = 2;
    uint32_t build_flags = 1;
    std::string manufacturer; // @ 0x013F00 ("Panasonic")
    std::string model_name;   // @ 0x013F10 ("DMC-TZ5")
    std::string vendor_tag;   // @ 0x013F20 ("_PANA")
    std::string short_code;   // @ 0x013F30 ("TZ5__")
    std::string brand_family; // @ 0x013F38 ("LUMIX")
};

struct DataSegmentStats {
    uint32_t rom_start_off = 0x014000u;
    uint32_t rom_end_off   = 0x01F02Cu;
    uint32_t sdram_start_va = 0x54012840u;
    uint32_t sdram_end_va   = 0x5401D86Cu;
    size_t rom_pointer_count = 0;
    size_t ram_pointer_count = 0;
};

class Part02MainFirmware final : public IPartitionModule {
public:
    static constexpr uint32_t kUnpackedStart = 0x008000u;
    static constexpr uint32_t kUnpackedEnd   = 0x21F428u;
    static constexpr uint32_t kRegionLimit   = 0x224000u; // 19,416 bytes in CAVE_MAIN_TEXT (0x21F428..0x224000)
    static constexpr uint32_t kBaseVa        = 0x55C84000u;
    static constexpr uint32_t kOriginalSize  = kUnpackedEnd - kUnpackedStart; // 2,192,424 bytes

    // Internal relative offsets within part_02 (where offset 0 == unpacked 0x008000 == VA 0x55C84000)
    static constexpr uint32_t kRelPanaHeader   = 0x000000u; // Unpacked 0x008000 (VA 0x55C84000)
    static constexpr uint32_t kRelModelIdBlock = 0x00BF00u; // Unpacked 0x013F00 (VA 0x55C8FF00)
    static constexpr uint32_t kRelDataStart    = 0x00C000u; // Unpacked 0x014000 (VA 0x55C90000 -> SDRAM 0x54012840)
    static constexpr uint32_t kRelCrt0Entry    = 0x01702Cu; // Unpacked 0x01F02C (VA 0x55C9B02C)
    static constexpr uint32_t kRelCaveCrt0     = 0x017080u; // Unpacked 0x01F080..0x020000 (VA 0x55C9B080, 3,968 B)
    static constexpr uint32_t kRelMainText     = 0x018000u; // Unpacked 0x020000 (VA 0x55C9C000)
    static constexpr uint32_t kRelRodataStart  = 0x1D0DC0u; // Unpacked 0x1D8DC0 (VA 0x55E54DC0)
    static constexpr uint32_t kRelHighIrqStart = 0x213FC0u; // Unpacked 0x21BFC0 (VA 0x55E97FC0)

    Part02MainFirmware();

    const PartitionMetadata& metadata() const override { return meta_; }

    bool load_from_partition_file(const std::string& path, std::string* err = nullptr) override;
    bool load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err = nullptr) override;

    std::vector<uint8_t> emit_partition_bytes() const override;
    bool write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err = nullptr) const override;

    std::string generate_source_documentation() const override;
    std::string generate_json_summary() const override;

    // Structured Accessors
    const std::vector<uint8_t>& raw_bytes() const { return bytes_; }
    const PanaFirmwareHeader& pana_header() const { return header_; }
    const DataSegmentStats& data_stats() const { return data_stats_; }
    const std::vector<SubroutineDoc>& key_subroutines() const { return subroutines_; }

    // Arbitrary byte patching at any VA inside part_02 (0x55C84000..0x55E9B428)
    bool patch_bytes_at_va(uint32_t target_va, std::span<const uint8_t> patch, std::string* err = nullptr);

    // Append arbitrary bytes (e.g. compiled MN103S UI code or new Menu Descriptors) to CAVE_MAIN_TEXT (0x55E9B428+)
    bool append_cave_bytes(std::span<const uint8_t> data, uint32_t* out_va, std::string* err = nullptr);

    // Modification & Feature Addition API for Partition 02
    bool set_firmware_version(uint16_t major, uint16_t minor, std::string* err = nullptr);
    bool set_camera_model_identity(const std::string& model_name,
                                   const std::string& brand_family,
                                   std::string* err = nullptr);

    // Patch a 32-bit global variable in the Initialized .data segment (accepts SDRAM VA 0x54012840..0x5401D86C)
    bool patch_data_segment_u32(uint32_t sdram_va, uint32_t new_val, std::string* err = nullptr);
    uint32_t read_data_segment_u32(uint32_t sdram_va) const;

    // Patch an ASCII string in .rodata or .data by ROM VA (0x55C84000..0x55E9B428)
    bool patch_rodata_ascii(uint32_t target_va, const std::string& new_text, bool null_terminate = false, std::string* err = nullptr);

    // Inject a new ASCII string into CAVE_MAIN_TEXT (0x55E9B430+) and return its VA
    bool add_cave_ascii_string(const std::string& text, uint32_t* out_va, std::string* err = nullptr);

    // Assemble and inject a new MN103S function into CAVE_MAIN_TEXT (0x55E9B430+) and optionally hook a 0xDD call site
    bool add_cave_function(const std::string& fn_name,
                           const std::vector<std::string>& asm_lines,
                           uint32_t* out_va = nullptr,
                           std::string* err = nullptr);

    bool hook_call_instruction(uint32_t call_insn_va, uint32_t new_target_va, std::string* err = nullptr);

private:
    void parse_structures();
    std::string read_cstr(uint32_t rel_off, size_t max_len) const;

    PartitionMetadata meta_;
    std::vector<uint8_t> bytes_;     // Base 2,192,424 bytes (0x008000..0x21F428)
    std::vector<uint8_t> ext_bytes_; // CAVE_MAIN_TEXT expansion bytes (0x21F428..0x224000)
    PanaFirmwareHeader header_;
    DataSegmentStats data_stats_;
    std::vector<SubroutineDoc> subroutines_;
};

} // namespace tz5::partitions
