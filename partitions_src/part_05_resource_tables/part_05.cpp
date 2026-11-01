#include "part_05_resource_tables/part_05.hpp"

#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::partitions {

Part05ResourceTables::Part05ResourceTables() : bytes_(kOriginalSize, 0xFFu) {
    meta_.index = 5;
    meta_.id = "part_05_resource_tables";
    meta_.filename = "part_05_0x374000_0x480f08.bin";
    meta_.unpacked_start = kUnpackedStart;
    meta_.unpacked_end = kUnpackedEnd;
    meta_.region_limit = kRegionLimit;
    meta_.va_start = kBaseVa;
    meta_.va_end = kBaseVa + kOriginalSize;
    meta_.original_sha256 = "f5588074d8a4d1f1f847714e21b4882dd4e50f8e9cff925be9699772d5106223";
    meta_.rea_evidence_id = "ev_c6e9740541df83835fc86bc158e5e961f3c212b783e6641ea74303c66b52bce9";
    meta_.rea_manifest_id = "agm_863f9475550309075d2d575fec987af55f9e2aef9c1dd0c3c3742950271b2094";
    meta_.role_summary = "64 KB Zero Arena (0x55FF0000), 0x12345678 Master OSD/Resource Pointer Table (VA 0x56000000) & Upper ISP/UI Resources";
}

bool Part05ResourceTables::load_from_partition_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open part_05 file: " + path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    if (sz < kOriginalSize || sz > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Invalid part_05 size";
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

bool Part05ResourceTables::load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err) {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "ROM too small to contain part_05";
        return false;
    }
    bytes_.assign(full_rom.begin() + kUnpackedStart, full_rom.begin() + kUnpackedEnd);
    ext_bytes_.clear();
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

std::vector<uint8_t> Part05ResourceTables::emit_partition_bytes() const {
    std::vector<uint8_t> out = bytes_;
    if (!ext_bytes_.empty()) {
        out.insert(out.end(), ext_bytes_.begin(), ext_bytes_.end());
    }
    return out;
}

bool Part05ResourceTables::write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err) const {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "Target ROM buffer too small for part_05";
        return false;
    }
    auto emitted = emit_partition_bytes();
    if (emitted.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "part_05 emitted bytes exceed 0x484000 region limit";
        return false;
    }
    std::fill(full_rom.begin() + kUnpackedStart, full_rom.begin() + kRegionLimit, 0xFFu);
    std::memcpy(full_rom.data() + kUnpackedStart, emitted.data(), emitted.size());
    return true;
}

uint32_t Part05ResourceTables::read_master_table_word(size_t word_index) const {
    uint32_t off = kRelMasterTableStart + static_cast<uint32_t>(word_index * 4u);
    if (off + 4 > kRelMasterTableEnd || off + 4 > bytes_.size()) return 0;
    return static_cast<uint32_t>(bytes_[off]) |
           (static_cast<uint32_t>(bytes_[off + 1]) << 8) |
           (static_cast<uint32_t>(bytes_[off + 2]) << 16) |
           (static_cast<uint32_t>(bytes_[off + 3]) << 24);
}

bool Part05ResourceTables::set_master_table_pointer(size_t word_index, uint32_t new_target_va, std::string* err) {
    uint32_t off = kRelMasterTableStart + static_cast<uint32_t>(word_index * 4u);
    if (word_index == 0 || off + 4 > kRelMasterTableEnd) {
        if (err) *err = "word_index outside master pointer table range (1..82853)";
        return false;
    }
    bytes_[off + 0] = static_cast<uint8_t>(new_target_va & 0xFFu);
    bytes_[off + 1] = static_cast<uint8_t>((new_target_va >> 8) & 0xFFu);
    bytes_[off + 2] = static_cast<uint8_t>((new_target_va >> 16) & 0xFFu);
    bytes_[off + 3] = static_cast<uint8_t>((new_target_va >> 24) & 0xFFu);
    return true;
}

size_t Part05ResourceTables::rebind_master_pointers_by_va(uint32_t old_target_va, uint32_t new_target_va) {
    size_t replaced = 0;
    for (uint32_t off = kRelMasterTableStart + 4u; off + 4 <= kRelMasterTableEnd; off += 4) {
        uint32_t w = static_cast<uint32_t>(bytes_[off]) |
                     (static_cast<uint32_t>(bytes_[off + 1]) << 8) |
                     (static_cast<uint32_t>(bytes_[off + 2]) << 16) |
                     (static_cast<uint32_t>(bytes_[off + 3]) << 24);
        if (w == old_target_va) {
            bytes_[off + 0] = static_cast<uint8_t>(new_target_va & 0xFFu);
            bytes_[off + 1] = static_cast<uint8_t>((new_target_va >> 8) & 0xFFu);
            bytes_[off + 2] = static_cast<uint8_t>((new_target_va >> 16) & 0xFFu);
            bytes_[off + 3] = static_cast<uint8_t>((new_target_va >> 24) & 0xFFu);
            replaced++;
        }
    }
    return replaced;
}

bool Part05ResourceTables::append_upper_resource_blob(std::span<const uint8_t> blob, uint32_t* out_va, std::string* err) {
    size_t cur_total = bytes_.size() + ext_bytes_.size();
    while ((cur_total % 4u) != 0u) {
        ext_bytes_.push_back(0xFFu);
        cur_total++;
    }
    if (cur_total + blob.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Insufficient space in part_05 CAVE_TAIL_ROM";
        return false;
    }
    uint32_t new_va = kBaseVa + static_cast<uint32_t>(cur_total);
    ext_bytes_.insert(ext_bytes_.end(), blob.begin(), blob.end());
    if (out_va) *out_va = new_va;
    return true;
}

void Part05ResourceTables::parse_structures() {
    if (bytes_.size() < kOriginalSize) return;

    stats_.magic = read_master_table_word(0);
    stats_.first_upper_res_va = read_master_table_word(1);
    stats_.total_word_entries = (kRelMasterTableEnd - kRelMasterTableStart - 4u) / 4u;
    stats_.part03_pointer_count = 0;
    stats_.part05_pointer_count = 0;

    for (size_t idx = 1; idx <= stats_.total_word_entries; ++idx) {
        uint32_t w = read_master_table_word(idx);
        if (w >= 0x55EA0000u && w < 0x55FA0000u) {
            stats_.part03_pointer_count++;
        } else if (w >= 0x56000000u && w < 0x56100000u) {
            stats_.part05_pointer_count++;
        }
    }

    // Count 0x0003-terminated strings in upper resource block (kRelUpperResStart..bytes_.size())
    stats_.upper_osd_0003_count = 0;
    size_t i = kRelUpperResStart;
    while (i + 2 <= bytes_.size()) {
        uint16_t w = static_cast<uint16_t>(bytes_[i]) | (static_cast<uint16_t>(bytes_[i + 1]) << 8);
        if (w >= 0x0020u && w < 0x007Fu) {
            size_t len = 0;
            while (i + 2 <= bytes_.size()) {
                uint16_t cw = static_cast<uint16_t>(bytes_[i]) | (static_cast<uint16_t>(bytes_[i + 1]) << 8);
                if (cw >= 0x0020u && cw < 0x007Fu) {
                    len++;
                    i += 2;
                } else {
                    break;
                }
            }
            if (len >= 3 && i + 2 <= bytes_.size()) {
                uint16_t term = static_cast<uint16_t>(bytes_[i]) | (static_cast<uint16_t>(bytes_[i + 1]) << 8);
                if (term == 0x0003u) {
                    stats_.upper_osd_0003_count++;
                    i += 2;
                    continue;
                }
            }
        } else {
            i += 2;
        }
    }
}

std::string Part05ResourceTables::generate_source_documentation() const {
    std::ostringstream oss;
    oss << "// ============================================================================\n"
        << "// PARTITION 05 SOURCE MODULE: " << meta_.id << "\n"
        << "// File: " << meta_.filename << " (" << bytes_.size() << " base bytes + " << ext_bytes_.size() << " ext bytes)\n"
        << "// Unpacked Flash Range : 0x374000 .. 0x480F08 (CAVE_TAIL_ROM -> 0x484000)\n"
        << "// Virtual Address (VA) : 0x55FF0000 .. 0x560FCF08\n"
        << "// REA Evidence ID      : " << meta_.rea_evidence_id << "\n"
        << "// ============================================================================\n\n"
        << "#include <cstdint>\n\n"
        << "namespace tz5::part05_src {\n\n"
        << "// [Sub-Segment 05a] 64 KB Zero-Initialized Arena (0x55FF0000..0x55FFFFFF)\n"
        << "constexpr uint32_t kZeroArenaBaseVa = 0x55FF0000u;\n"
        << "constexpr uint32_t kZeroArenaSize   = 0x00010000u;\n\n"
        << "// [Sub-Segment 05b] Master Resource & OSD Pointer Table (0x56000000..0x56050E98)\n"
        << "constexpr uint32_t kMasterTableVa    = 0x56000000u;\n"
        << "constexpr uint32_t kMasterTableMagic = 0x" << std::hex << std::uppercase << stats_.magic << "u;\n"
        << "constexpr uint32_t kFirstUpperResVa  = 0x" << stats_.first_upper_res_va << std::dec << "u;\n"
        << "constexpr size_t   kTotalTableWords  = " << stats_.total_word_entries << ";\n"
        << "constexpr size_t   kPart03Pointers   = " << stats_.part03_pointer_count << ";\n"
        << "constexpr size_t   kPart05Pointers   = " << stats_.part05_pointer_count << ";\n\n"
        << "} // namespace tz5::part05_src\n";
    return oss.str();
}

std::string Part05ResourceTables::generate_json_summary() const {
    auto emitted = emit_partition_bytes();
    std::ostringstream oss;
    oss << "{\n"
        << "  \"partition_index\": 5,\n"
        << "  \"id\": \"" << meta_.id << "\",\n"
        << "  \"va_start\": \"0x55FF0000\",\n"
        << "  \"va_end\": \"0x" << std::hex << std::uppercase << (kBaseVa + emitted.size()) << std::dec << "\",\n"
        << "  \"base_size\": " << bytes_.size() << ",\n"
        << "  \"extension_size\": " << ext_bytes_.size() << ",\n"
        << "  \"free_cave_bytes\": " << (kRegionLimit - kUnpackedStart - emitted.size()) << ",\n"
        << "  \"sha256\": \"" << FirmwareImage::sha256_hex(emitted) << "\",\n"
        << "  \"rea_evidence_id\": \"" << meta_.rea_evidence_id << "\",\n"
        << "  \"master_table\": {\n"
        << "    \"va\": \"0x56000000\",\n"
        << "    \"magic\": \"0x" << std::hex << std::uppercase << stats_.magic << std::dec << "\",\n"
        << "    \"total_word_entries\": " << stats_.total_word_entries << ",\n"
        << "    \"part03_pointers\": " << stats_.part03_pointer_count << ",\n"
        << "    \"part05_pointers\": " << stats_.part05_pointer_count << ",\n"
        << "    \"upper_osd_0003_strings\": " << stats_.upper_osd_0003_count << "\n"
        << "  }\n"
        << "}\n";
    return oss.str();
}

} // namespace tz5::partitions
