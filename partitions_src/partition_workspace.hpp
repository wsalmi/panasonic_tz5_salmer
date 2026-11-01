#pragma once

#include "part_00_bootloader/part_00.hpp"
#include "part_01_vectors_init/part_01.hpp"
#include "part_02_main_firmware/part_02.hpp"
#include "part_03_osd_ui/part_03.hpp"
#include "part_04_flash_stub/part_04.hpp"
#include "part_05_resource_tables/part_05.hpp"
#include "part_06_parity_trailer/part_06.hpp"

#include <string>
#include <vector>

namespace tz5::partitions {

class PartitionWorkspace {
public:
    PartitionWorkspace();

    // Load all 7 partitions from a directory containing part_00_*.bin .. part_06_*.bin
    bool load_from_partitions_dir(const std::string& dir_path, std::string* err = nullptr);

    // Load all 7 partitions directly from a framed TZ5_a.bin or unpacked TZ5_unpacked.bin file
    bool load_from_firmware_file(const std::string& fw_path, std::string* err = nullptr);

    // Direct access to each partition's source/object module for inspection, modification, or extension
    Part00Bootloader&     part00() { return part00_; }
    Part01VectorsInit&    part01() { return part01_; }
    Part02MainFirmware&   part02() { return part02_; }
    Part03OsdUi&          part03() { return part03_; }
    Part04FlashStub&      part04() { return part04_; }
    Part05ResourceTables& part05() { return part05_; }
    Part06ParityTrailer&  part06() { return part06_; }

    const Part00Bootloader&     part00() const { return part00_; }
    const Part01VectorsInit&    part01() const { return part01_; }
    const Part02MainFirmware&   part02() const { return part02_; }
    const Part03OsdUi&          part03() const { return part03_; }
    const Part04FlashStub&      part04() const { return part04_; }
    const Part05ResourceTables& part05() const { return part05_; }
    const Part06ParityTrailer&  part06() const { return part06_; }

    std::vector<const IPartitionModule*> all_modules() const;

    // Cross-partition feature helper:
    // Allocates a new 0x0003-terminated 16-bit OSD string inside Partition 03's expansion cave (0x55F9B118+)
    // AND updates all references to `old_osd_va` (or a specific `master_table_index`) in Partition 05's 0x12345678 table!
    bool add_localized_osd_and_rebind_table(const std::string& new_osd_text,
                                            uint32_t old_osd_va_to_replace,
                                            uint32_t* out_new_osd_va,
                                            size_t* out_rebound_pointers,
                                            std::string* err = nullptr);

    // Assemble the 7 partitions into a contiguous 0x484000-byte ROM image, recomputing Partition 06 (32B parity trailer)
    bool link_unpacked_rom(std::vector<uint8_t>& out_rom_with_trailer_484020, std::string* err = nullptr);

    // Build a complete 5,030,946-byte framed TZ5_a.bin container from the 7 compiled partitions
    bool build_framed_firmware(std::vector<uint8_t>& out_framed_5030946, std::string* err = nullptr);

    // Emit all 7 individual compiled partition .bin files to `out_partitions_dir`
    bool save_all_partition_binaries(const std::string& out_partitions_dir, std::string* err = nullptr);

    // Export generated C++20 source headers and JSON analysis summaries for all 7 partitions to `out_analysis_dir`
    bool export_all_sources_and_summaries(const std::string& out_analysis_dir, std::string* err = nullptr) const;

private:
    Part00Bootloader     part00_;
    Part01VectorsInit    part01_;
    Part02MainFirmware   part02_;
    Part03OsdUi          part03_;
    Part04FlashStub      part04_;
    Part05ResourceTables part05_;
    Part06ParityTrailer  part06_;
};

} // namespace tz5::partitions
