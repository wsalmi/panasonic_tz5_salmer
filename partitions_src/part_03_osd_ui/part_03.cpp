#include "part_03_osd_ui/part_03.hpp"

#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::partitions {

Part03OsdUi::Part03OsdUi() : bytes_(kOriginalSize, 0xFFu) {
    meta_.index = 3;
    meta_.id = "part_03_osd_ui";
    meta_.filename = "part_03_0x224000_0x31f118.bin";
    meta_.unpacked_start = kUnpackedStart;
    meta_.unpacked_end = kUnpackedEnd;
    meta_.region_limit = kRegionLimit;
    meta_.va_start = kBaseVa;
    meta_.va_end = kBaseVa + kOriginalSize;
    meta_.original_sha256 = "c29d3592b4d8cec99506d632ddba741a6dc9a857bf78057fb21cec1d52cbe0a4";
    meta_.rea_evidence_id = "ev_bfea28937a85208940f8156388aee0b05e10d32ea20643ace8882213e9615172";
    meta_.rea_manifest_id = "agm_2389d6b4d3470259ba2ed65676d74224e6cd1019199b3ab8fb95130115b6e05b";
    meta_.role_summary = "Multi-Language OSD UI Strings (0x0003-terminated 16-bit LE & UTF-16LE) and Bitmap Font Glyph Tables";
}

bool Part03OsdUi::load_from_partition_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open part_03 file: " + path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    if (sz < kOriginalSize || sz > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Invalid part_03 size";
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

bool Part03OsdUi::load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err) {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "ROM too small to contain part_03";
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

std::vector<uint8_t> Part03OsdUi::emit_partition_bytes() const {
    std::vector<uint8_t> out = bytes_;
    if (!ext_bytes_.empty()) {
        out.insert(out.end(), ext_bytes_.begin(), ext_bytes_.end());
    }
    return out;
}

bool Part03OsdUi::write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err) const {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "Target ROM buffer too small for part_03";
        return false;
    }
    auto emitted = emit_partition_bytes();
    if (emitted.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "part_03 emitted bytes exceed 0x36B800 region limit";
        return false;
    }
    std::fill(full_rom.begin() + kUnpackedStart, full_rom.begin() + kRegionLimit, 0xFFu);
    std::memcpy(full_rom.data() + kUnpackedStart, emitted.data(), emitted.size());
    return true;
}

bool Part03OsdUi::patch_osd_string_at_va(uint32_t va, const std::string& new_text, std::string* err) {
    if (va < kBaseVa || va >= (kBaseVa + bytes_.size())) {
        if (err) *err = "VA outside part_03 base range";
        return false;
    }
    uint32_t rel = va - kBaseVa;
    size_t byte_len = (new_text.size() + 1u) * 2u;
    if (rel + byte_len > bytes_.size()) {
        if (err) *err = "OSD string patch exceeds part_03 bounds";
        return false;
    }
    for (size_t i = 0; i < new_text.size(); ++i) {
        bytes_[rel + i * 2]     = static_cast<uint8_t>(new_text[i]);
        bytes_[rel + i * 2 + 1] = 0x00u;
    }
    bytes_[rel + new_text.size() * 2]     = 0x03u;
    bytes_[rel + new_text.size() * 2 + 1] = 0x00u;
    return true;
}

bool Part03OsdUi::add_new_osd_string(const std::string& text, uint32_t* out_new_va, std::string* err) {
    size_t cur_total = bytes_.size() + ext_bytes_.size();
    if ((cur_total & 1u) != 0u) {
        ext_bytes_.push_back(0xFFu);
        cur_total++;
    }
    size_t needed = (text.size() + 1u) * 2u;
    if (cur_total + needed > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Insufficient space in part_03 CAVE_UPPER_ROM";
        return false;
    }
    uint32_t new_va = kBaseVa + static_cast<uint32_t>(cur_total);
    for (unsigned char ch : text) {
        ext_bytes_.push_back(ch);
        ext_bytes_.push_back(0x00u);
    }
    ext_bytes_.push_back(0x03u);
    ext_bytes_.push_back(0x00u);
    if (out_new_va) *out_new_va = new_va;
    return true;
}

void Part03OsdUi::parse_structures() {
    osd_0003_strings_.clear();
    utf16_0000_strings_.clear();

    // Scan 16-bit aligned offsets in bytes_ for printable ASCII runs terminated by 0x0003 or 0x0000
    size_t i = 0;
    while (i + 2 <= bytes_.size()) {
        uint16_t w = static_cast<uint16_t>(bytes_[i]) | (static_cast<uint16_t>(bytes_[i + 1]) << 8);
        if (w >= 0x0020u && w < 0x007Fu) {
            size_t start = i;
            std::string s;
            while (i + 2 <= bytes_.size()) {
                uint16_t cw = static_cast<uint16_t>(bytes_[i]) | (static_cast<uint16_t>(bytes_[i + 1]) << 8);
                if (cw >= 0x0020u && cw < 0x007Fu) {
                    s.push_back(static_cast<char>(cw));
                    i += 2;
                } else {
                    break;
                }
            }
            if (s.size() >= 3 && i + 2 <= bytes_.size()) {
                uint16_t term = static_cast<uint16_t>(bytes_[i]) | (static_cast<uint16_t>(bytes_[i + 1]) << 8);
                if (term == 0x0003u) {
                    osd_0003_strings_.push_back({
                        static_cast<uint32_t>(start),
                        kBaseVa + static_cast<uint32_t>(start),
                        0x0003u,
                        s
                    });
                    i += 2;
                    continue;
                } else if (term == 0x0000u && s.size() >= 4) {
                    utf16_0000_strings_.push_back({
                        static_cast<uint32_t>(start),
                        kBaseVa + static_cast<uint32_t>(start),
                        0x0000u,
                        s
                    });
                    i += 2;
                    continue;
                }
            }
        } else {
            i += 2;
        }
    }
}

std::string Part03OsdUi::generate_source_documentation() const {
    std::ostringstream oss;
    oss << "// ============================================================================\n"
        << "// PARTITION 03 SOURCE MODULE: " << meta_.id << "\n"
        << "// File: " << meta_.filename << " (" << bytes_.size() << " base bytes + " << ext_bytes_.size() << " ext bytes)\n"
        << "// Unpacked Flash Range : 0x224000 .. 0x31F118 (CAVE_UPPER_ROM -> 0x36B800)\n"
        << "// Virtual Address (VA) : 0x55EA0000 .. 0x55F9B118\n"
        << "// REA Evidence ID      : " << meta_.rea_evidence_id << "\n"
        << "// Discovered 0x0003 OSD Strings : " << osd_0003_strings_.size() << "\n"
        << "// Discovered 0x0000 UTF-16LE    : " << utf16_0000_strings_.size() << "\n"
        << "// ============================================================================\n\n"
        << "#include <cstdint>\n\n"
        << "namespace tz5::part03_src {\n\n"
        << "struct OsdEntry { uint32_t va; const char* text; };\n\n"
        << "constexpr OsdEntry kSampleOsdStrings[] = {\n";

    size_t limit = std::min<size_t>(40, osd_0003_strings_.size());
    for (size_t idx = 0; idx < limit; ++idx) {
        const auto& e = osd_0003_strings_[idx];
        oss << "    { 0x" << std::hex << std::uppercase << std::setw(8) << std::setfill('0') << e.va
            << "u, \"" << e.ascii_text << "\" },\n";
    }
    oss << "};\n\n} // namespace tz5::part03_src\n";
    return oss.str();
}

std::string Part03OsdUi::generate_json_summary() const {
    auto emitted = emit_partition_bytes();
    std::ostringstream oss;
    oss << "{\n"
        << "  \"partition_index\": 3,\n"
        << "  \"id\": \"" << meta_.id << "\",\n"
        << "  \"va_start\": \"0x55EA0000\",\n"
        << "  \"va_end\": \"0x" << std::hex << std::uppercase << (kBaseVa + emitted.size()) << std::dec << "\",\n"
        << "  \"base_size\": " << bytes_.size() << ",\n"
        << "  \"extension_size\": " << ext_bytes_.size() << ",\n"
        << "  \"free_cave_bytes\": " << (kRegionLimit - kUnpackedStart - emitted.size()) << ",\n"
        << "  \"sha256\": \"" << FirmwareImage::sha256_hex(emitted) << "\",\n"
        << "  \"rea_evidence_id\": \"" << meta_.rea_evidence_id << "\",\n"
        << "  \"osd_0003_string_count\": " << osd_0003_strings_.size() << ",\n"
        << "  \"utf16_0000_string_count\": " << utf16_0000_strings_.size() << "\n"
        << "}\n";
    return oss.str();
}

} // namespace tz5::partitions
