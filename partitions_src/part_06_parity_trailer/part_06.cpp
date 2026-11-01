#include "part_06_parity_trailer/part_06.hpp"

#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::partitions {

Part06ParityTrailer::Part06ParityTrailer() : bytes_(kOriginalSize, 0u) {
    meta_.index = 6;
    meta_.id = "part_06_parity_trailer";
    meta_.filename = "part_06_0x484000_0x484020.bin";
    meta_.unpacked_start = kUnpackedStart;
    meta_.unpacked_end = kUnpackedEnd;
    meta_.region_limit = kRegionLimit;
    meta_.va_start = kBaseVa;
    meta_.va_end = kBaseVa + kOriginalSize;
    meta_.original_sha256 = "b7b25a6e3e917f7a5b37043ca2752c4787064160aed9cc6f7565dfd878116f16";
    meta_.rea_evidence_id = "ev_0b97032c09f8891c07077289b35967440a949db77f9f74b22c8dcfb89c5d9b8b";
    meta_.rea_manifest_id = "agm_b83e7229ad91d5c4ce63290d5486eded47598ccb989aedf0abaf8964b74f47db";
    meta_.role_summary = "32-Byte Vertical Column-Parity Trailer (Row 147,968 of the 147,969 x 17 2D Zero-Sum Matrix)";
}

bool Part06ParityTrailer::load_from_partition_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open part_06 file: " + path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    if (sz != kOriginalSize) {
        if (err) *err = "Invalid part_06 size (expected 32 bytes)";
        return false;
    }
    ifs.seekg(0, std::ios::beg);
    bytes_.resize(kOriginalSize);
    ifs.read(reinterpret_cast<char*>(bytes_.data()), static_cast<std::streamsize>(kOriginalSize));
    sync_words_from_bytes();
    return true;
}

bool Part06ParityTrailer::load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err) {
    if (full_rom.size() >= kUnpackedEnd) {
        bytes_.assign(full_rom.begin() + kUnpackedStart, full_rom.begin() + kUnpackedEnd);
        sync_words_from_bytes();
        return true;
    }
    if (full_rom.size() == kUnpackedStart) {
        recompute_from_rom_payload(full_rom);
        return true;
    }
    if (err) *err = "Invalid ROM size for part_06";
    return false;
}

std::vector<uint8_t> Part06ParityTrailer::emit_partition_bytes() const {
    return bytes_;
}

bool Part06ParityTrailer::write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* /*err*/) const {
    if (full_rom.size() < kUnpackedEnd) {
        full_rom.resize(kUnpackedEnd, 0xFFu);
    }
    std::memcpy(full_rom.data() + kUnpackedStart, bytes_.data(), kOriginalSize);
    return true;
}

void Part06ParityTrailer::sync_words_from_bytes() {
    for (size_t c = 0; c < 16; ++c) {
        col_words_[c] = (static_cast<uint16_t>(bytes_[c * 2]) << 8) |
                        static_cast<uint16_t>(bytes_[c * 2 + 1]);
    }
}

void Part06ParityTrailer::sync_bytes_from_words() {
    bytes_.resize(kOriginalSize);
    for (size_t c = 0; c < 16; ++c) {
        bytes_[c * 2]     = static_cast<uint8_t>((col_words_[c] >> 8) & 0xFFu);
        bytes_[c * 2 + 1] = static_cast<uint8_t>(col_words_[c] & 0xFFu);
    }
}

uint16_t Part06ParityTrailer::corner_checksum_word() const {
    uint32_t sum = 0;
    for (uint16_t w : col_words_) {
        sum += w;
    }
    return static_cast<uint16_t>((-static_cast<int32_t>(sum)) & 0xFFFF);
}

void Part06ParityTrailer::recompute_from_rom_payload(std::span<const uint8_t> rom_payload_484000) {
    std::array<uint32_t, 16> col_accum{};
    col_accum.fill(0u);
    const size_t rows = rom_payload_484000.size() / 32u;
    for (size_t r = 0; r < rows; ++r) {
        const uint8_t* row_ptr = rom_payload_484000.data() + r * 32u;
        for (size_t c = 0; c < 16; ++c) {
            uint16_t w = (static_cast<uint16_t>(row_ptr[c * 2]) << 8) |
                         static_cast<uint16_t>(row_ptr[c * 2 + 1]);
            col_accum[c] += w;
        }
    }
    for (size_t c = 0; c < 16; ++c) {
        col_words_[c] = static_cast<uint16_t>((-static_cast<int32_t>(col_accum[c])) & 0xFFFF);
    }
    sync_bytes_from_words();
}

bool Part06ParityTrailer::verify_against_rom_payload(std::span<const uint8_t> rom_payload_484000) const {
    if (rom_payload_484000.size() < kUnpackedStart) return false;
    Part06ParityTrailer expected;
    expected.recompute_from_rom_payload(rom_payload_484000.subspan(0, kUnpackedStart));
    return expected.bytes_ == bytes_;
}

std::string Part06ParityTrailer::generate_source_documentation() const {
    std::ostringstream oss;
    oss << "// ============================================================================\n"
        << "// PARTITION 06 SOURCE MODULE: " << meta_.id << "\n"
        << "// File: " << meta_.filename << " (32 bytes)\n"
        << "// Unpacked Flash Range : 0x484000 .. 0x484020 (Row 147,968 of 2D Matrix)\n"
        << "// Virtual Address (VA) : 0x56100000 .. 0x56100020\n"
        << "// REA Evidence ID      : " << meta_.rea_evidence_id << "\n"
        << "// ============================================================================\n\n"
        << "#include <array>\n#include <cstdint>\n\n"
        << "namespace tz5::part06_src {\n\n"
        << "// Vertical 16-column big-endian two's-complement parity words:\n"
        << "// W[147968, c] = (-sum_{r=0..147967} W[r, c]) & 0xFFFF\n"
        << "constexpr std::array<uint16_t, 16> kVerticalColumnParityWords = {\n    ";
    for (size_t c = 0; c < 16; ++c) {
        oss << "0x" << std::hex << std::uppercase << std::setw(4) << std::setfill('0') << col_words_[c] << "u";
        if (c + 1 < 16) oss << ((c == 7) ? ",\n    " : ", ");
    }
    oss << "\n};\n"
        << "constexpr uint16_t kCornerChecksumWord = 0x" << std::hex << std::uppercase
        << std::setw(4) << std::setfill('0') << corner_checksum_word() << "u;\n\n"
        << "} // namespace tz5::part06_src\n";
    return oss.str();
}

std::string Part06ParityTrailer::generate_json_summary() const {
    std::ostringstream oss;
    oss << "{\n"
        << "  \"partition_index\": 6,\n"
        << "  \"id\": \"" << meta_.id << "\",\n"
        << "  \"va_start\": \"0x56100000\",\n"
        << "  \"va_end\": \"0x56100020\",\n"
        << "  \"size\": 32,\n"
        << "  \"sha256\": \"" << FirmwareImage::sha256_hex(bytes_) << "\",\n"
        << "  \"rea_evidence_id\": \"" << meta_.rea_evidence_id << "\",\n"
        << "  \"corner_checksum_word\": \"0x" << std::hex << std::uppercase << std::setw(4) << std::setfill('0')
        << corner_checksum_word() << std::dec << "\"\n"
        << "}\n";
    return oss.str();
}

} // namespace tz5::partitions
