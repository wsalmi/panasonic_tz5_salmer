#include "part_00_bootloader/part_00.hpp"
#include "tz5/assembler.hpp"
#include "tz5/disassembler.hpp"
#include "tz5/symbols.hpp"

#include <cstdio>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::partitions {

bool IPartitionModule::save_partition_file(const std::string& path, std::string* err) const {
    auto data = emit_partition_bytes();
    std::ofstream ofs(path, std::ios::binary | std::ios::trunc);
    if (!ofs) {
        if (err) *err = "Failed to open partition output file: " + path;
        return false;
    }
    if (!ofs.write(reinterpret_cast<const char*>(data.data()), static_cast<std::streamsize>(data.size()))) {
        if (err) *err = "Failed to write partition bytes to: " + path;
        return false;
    }
    return true;
}

Part00Bootloader::Part00Bootloader() : bytes_(kOriginalSize, 0xFFu) {
    meta_.index = 0;
    meta_.id = "part_00_bootloader";
    meta_.filename = "part_00_0x000000_0x001305.bin";
    meta_.unpacked_start = kUnpackedStart;
    meta_.unpacked_end = kUnpackedEnd;
    meta_.region_limit = kRegionLimit;
    meta_.va_start = kBaseVa;
    meta_.va_end = kBaseVa + kOriginalSize;
    meta_.original_sha256 = "746164f8860bd48371116385a2884276d49bd88bb95db7c57bda84f8a721427d";
    meta_.rea_evidence_id = "ev_2a77ce06d889473bea4de5ee8738aefd66fba752dc805aac44ab907818a3f3da";
    meta_.rea_manifest_id = "agm_37650b5082668a61f00d3345d30e420b907d61abb2400d2d4e2f94f025010208";
    meta_.role_summary = "Early NOR Flash Bootloader, Venus Engine IV Clock/SDRAM Init & Fast-RAM Flash Updater";
}

bool Part00Bootloader::load_from_partition_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open part_00 file: " + path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    if (sz < kOriginalSize || sz > kRegionLimit) {
        if (err) *err = "Invalid part_00 size";
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

bool Part00Bootloader::load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err) {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "ROM too small to contain part_00";
        return false;
    }
    bytes_.assign(full_rom.begin() + kUnpackedStart, full_rom.begin() + kUnpackedEnd);
    ext_bytes_.clear();
    // Check if any non-0xFF bytes exist in the expansion cave 0x001305..0x004000
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

std::vector<uint8_t> Part00Bootloader::emit_partition_bytes() const {
    std::vector<uint8_t> out = bytes_;
    if (!ext_bytes_.empty()) {
        out.insert(out.end(), ext_bytes_.begin(), ext_bytes_.end());
    }
    return out;
}

bool Part00Bootloader::write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err) const {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "Target ROM buffer too small for part_00";
        return false;
    }
    auto emitted = emit_partition_bytes();
    if (emitted.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "part_00 emitted bytes exceed 0x004000 region limit";
        return false;
    }
    std::fill(full_rom.begin() + kUnpackedStart, full_rom.begin() + kRegionLimit, 0xFFu);
    std::memcpy(full_rom.data() + kUnpackedStart, emitted.data(), emitted.size());
    return true;
}

uint32_t Part00Bootloader::initial_stack_or_jump_va() const {
    if (bytes_.size() >= 6 && bytes_[0] == 0xFCu && bytes_[1] == 0xDCu) {
        return static_cast<uint32_t>(bytes_[2]) |
               (static_cast<uint32_t>(bytes_[3]) << 8) |
               (static_cast<uint32_t>(bytes_[4]) << 16) |
               (static_cast<uint32_t>(bytes_[5]) << 24);
    }
    return 0;
}

bool Part00Bootloader::set_initial_boot_target_va(uint32_t new_va, std::string* err) {
    if (bytes_.size() < 6 || bytes_[0] != 0xFCu || bytes_[1] != 0xDCu) {
        if (err) *err = "Unexpected instruction at 0x55C7C000";
        return false;
    }
    bytes_[2] = static_cast<uint8_t>(new_va & 0xFFu);
    bytes_[3] = static_cast<uint8_t>((new_va >> 8) & 0xFFu);
    bytes_[4] = static_cast<uint8_t>((new_va >> 16) & 0xFFu);
    bytes_[5] = static_cast<uint8_t>((new_va >> 24) & 0xFFu);
    parse_structures();
    return true;
}

bool Part00Bootloader::patch_bootloader_bytes(uint32_t offset_or_va, std::span<const uint8_t> data, std::string* err) {
    uint32_t off = (offset_or_va >= kBaseVa) ? (offset_or_va - kBaseVa) : offset_or_va;
    if (off + data.size() > bytes_.size()) {
        if (err) *err = "Patch exceeds part_00 base bounds";
        return false;
    }
    std::memcpy(bytes_.data() + off, data.data(), data.size());
    parse_structures();
    return true;
}

bool Part00Bootloader::append_early_boot_extension(const std::string& name,
                                                    const std::vector<std::string>& asm_lines,
                                                    uint32_t* out_va,
                                                    std::string* err) {
    // Align extension start to 4-byte boundary relative to 0x001305
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
    syms[name] = fn_va;
    for (const auto& line : asm_lines) {
        if (!as.assemble_line(line, syms, err)) {
            return false;
        }
    }
    if (cur_total + as.bytes().size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Insufficient space in part_00 expansion cave (0x001305..0x004000)";
        return false;
    }
    ext_bytes_.insert(ext_bytes_.end(), as.bytes().begin(), as.bytes().end());
    if (out_va) *out_va = fn_va;
    parse_structures();
    return true;
}

void Part00Bootloader::parse_structures() {
    ram_copies_.clear();
    mmio_writes_.clear();
    subroutines_.clear();

    ram_copies_.push_back({
        "fastram_flash_prog_block_1",
        0x55C7C850u,
        0x400001E4u,
        0x00000538u,
        "On-chip Fast RAM (0x400001E4..0x4000071C) flash erase/program critical routine"
    });
    ram_copies_.push_back({
        "fastram_flash_prog_block_2",
        0x55C7CD88u,
        0x4000071Cu,
        0x0000057Cu,
        "On-chip Fast RAM (0x4000071C..0x40000C98) flash DMA & bus state machine"
    });
    ram_copies_.push_back({
        "sdram_boot_work_buffer",
        0x55C7C000u,
        0x54200000u,
        0x00001305u,
        "Cached SDRAM staging mirror for bootloader & updater descriptors"
    });

    // Scan 6-byte 0xFC instructions in bytes_ for MMIO accesses (0x9Cxxxxxx)
    for (size_t i = 0; i + 6 <= bytes_.size(); ++i) {
        if (bytes_[i] == 0xFCu) {
            uint8_t sub = bytes_[i + 1];
            uint32_t addr = static_cast<uint32_t>(bytes_[i + 2]) |
                            (static_cast<uint32_t>(bytes_[i + 3]) << 8) |
                            (static_cast<uint32_t>(bytes_[i + 4]) << 16) |
                            (static_cast<uint32_t>(bytes_[i + 5]) << 24);
            if ((addr >> 24) == 0x9Cu) {
                std::string periph = resolve_mmio_name(addr);
                if (periph.empty()) periph = "VENUS_MMIO";
                std::string op = (sub >= 0xA0u && sub <= 0xBFu) ? "READ" : "WRITE/IMM";
                mmio_writes_.push_back({kBaseVa + static_cast<uint32_t>(i), addr, periph, op});
            }
        }
    }

    subroutines_.push_back({
        0x55C7C000u,
        0x000000u,
        "boot_reset_entry",
        "void boot_reset_entry(void)",
        "Initializes CPU stack/jump pointer (0x54080000), configures Venus IV bus/PLL registers, and branches to updater/boot dispatcher.",
        "void boot_reset_entry(void) {\n"
        "    uintptr_t* boot_vec = (uintptr_t*)0x54080000;\n"
        "    venus_sysclk_init(0x0400);\n"
        "    boot_flash_updater_main();\n"
        "}"
    });
    subroutines_.push_back({
        0x55C7C0E3u,
        0x0000E3u,
        "boot_flash_updater_main",
        "int boot_flash_updater_main(void)",
        "Relocates flash programming engines to On-Chip Fast RAM (0x400001E4 & 0x4000071C) so NOR flash can be erased/reprogrammed while executing from RAM.",
        "int boot_flash_updater_main(void) {\n"
        "    memcpy((void*)0x400001E4, (const void*)0x55C7C850, 0x538);\n"
        "    memcpy((void*)0x4000071C, (const void*)0x55C7CD88, 0x57C);\n"
        "    VENUS_FLASH_DMA_CTRL = 0x0001;\n"
        "    return ((int(*)(void))0x400001E4)();\n"
        "}"
    });
}

std::string Part00Bootloader::generate_source_documentation() const {
    std::ostringstream oss;
    oss << "// ============================================================================\n"
        << "// PARTITION 00 SOURCE MODULE: " << meta_.id << "\n"
        << "// File: " << meta_.filename << " (" << bytes_.size() << " base bytes + " << ext_bytes_.size() << " ext bytes)\n"
        << "// Unpacked Flash Range : 0x000000 .. 0x001305 (Expansion Cave -> 0x004000)\n"
        << "// Virtual Address (VA) : 0x55C7C000 .. 0x55C7D305\n"
        << "// REA Evidence ID      : " << meta_.rea_evidence_id << "\n"
        << "// ============================================================================\n\n"
        << "#include <cstdint>\n\n"
        << "namespace tz5::part00_src {\n\n"
        << "constexpr uint32_t kBootInitialTargetVa = 0x" << std::hex << std::uppercase
        << std::setw(8) << std::setfill('0') << initial_stack_or_jump_va() << "u;\n\n";

    for (const auto& sub : subroutines_) {
        oss << "// Function: " << sub.name << " @ VA 0x" << std::hex << sub.va
            << " (ROM+0x" << sub.rom_offset << ")\n"
            << "// " << sub.summary << "\n"
            << sub.pseudo_c << "\n\n";
    }
    oss << "} // namespace tz5::part00_src\n";
    return oss.str();
}

std::string Part00Bootloader::generate_json_summary() const {
    auto emitted = emit_partition_bytes();
    std::ostringstream oss;
    oss << "{\n"
        << "  \"partition_index\": 0,\n"
        << "  \"id\": \"" << meta_.id << "\",\n"
        << "  \"va_start\": \"0x55C7C000\",\n"
        << "  \"va_end\": \"0x" << std::hex << std::uppercase << (kBaseVa + emitted.size()) << std::dec << "\",\n"
        << "  \"base_size\": " << bytes_.size() << ",\n"
        << "  \"extension_size\": " << ext_bytes_.size() << ",\n"
        << "  \"free_cave_bytes\": " << (kRegionLimit - emitted.size()) << ",\n"
        << "  \"sha256\": \"" << FirmwareImage::sha256_hex(emitted) << "\",\n"
        << "  \"rea_evidence_id\": \"" << meta_.rea_evidence_id << "\",\n"
        << "  \"initial_boot_target_va\": \"0x" << std::hex << std::uppercase << std::setw(8) << std::setfill('0')
        << initial_stack_or_jump_va() << std::dec << "\",\n"
        << "  \"ram_copy_blocks\": " << ram_copies_.size() << ",\n"
        << "  \"mmio_access_count\": " << mmio_writes_.size() << ",\n"
        << "  \"subroutines\": " << subroutines_.size() << "\n"
        << "}\n";
    return oss.str();
}

} // namespace tz5::partitions
