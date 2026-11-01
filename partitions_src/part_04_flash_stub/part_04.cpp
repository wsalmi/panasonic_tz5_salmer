#include "part_04_flash_stub/part_04.hpp"
#include "tz5/assembler.hpp"
#include "tz5/symbols.hpp"

#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::partitions {

Part04FlashStub::Part04FlashStub() : bytes_{0xCBu, 0xCBu, 0xCBu, 0xCBu} {
    meta_.index = 4;
    meta_.id = "part_04_flash_stub";
    meta_.filename = "part_04_0x36b800_0x36b804.bin";
    meta_.unpacked_start = kUnpackedStart;
    meta_.unpacked_end = kUnpackedEnd;
    meta_.region_limit = kRegionLimit;
    meta_.va_start = kBaseVa;
    meta_.va_end = kBaseVa + kOriginalSize;
    meta_.original_sha256 = "b420830d2ab6f7f080c7d72bbddc9990b4a535825dbd6a8ddfdd4c633367caa6";
    meta_.rea_evidence_id = "ev_836778a76859ffc891e135718b7208f9dd4cd15fcf0fc421181b9d659620de2c";
    meta_.rea_manifest_id = "agm_10c6b04091cf1849a9ab1c20480ff0e1d854db3e1c6309575a1853ca72b7ad72";
    meta_.role_summary = "4-Byte NOR Flash Sector-Aligned Return/NOP Stub (0xCB 0xCB 0xCB 0xCB @ VA 0x55FE7800)";
}

bool Part04FlashStub::load_from_partition_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open part_04 file: " + path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    if (sz < kOriginalSize || sz > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Invalid part_04 size";
        return false;
    }
    ifs.seekg(0, std::ios::beg);
    bytes_.resize(sz);
    ifs.read(reinterpret_cast<char*>(bytes_.data()), static_cast<std::streamsize>(sz));
    return true;
}

bool Part04FlashStub::load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err) {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "ROM too small to contain part_04";
        return false;
    }
    uint32_t last_active = kUnpackedEnd;
    for (uint32_t off = kRegionLimit - 1; off >= kUnpackedEnd; --off) {
        if (full_rom[off] != 0xFFu) {
            last_active = off + 1u;
            break;
        }
    }
    bytes_.assign(full_rom.begin() + kUnpackedStart, full_rom.begin() + last_active);
    return true;
}

std::vector<uint8_t> Part04FlashStub::emit_partition_bytes() const {
    return bytes_;
}

bool Part04FlashStub::write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err) const {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "Target ROM buffer too small for part_04";
        return false;
    }
    if (bytes_.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "part_04 exceeds 0x374000 region limit";
        return false;
    }
    std::fill(full_rom.begin() + kUnpackedStart, full_rom.begin() + kRegionLimit, 0xFFu);
    std::memcpy(full_rom.data() + kUnpackedStart, bytes_.data(), bytes_.size());
    return true;
}

bool Part04FlashStub::set_custom_stub_routine(const std::string& fn_name,
                                              const std::vector<std::string>& asm_lines,
                                              std::string* err) {
    Mn103Assembler as(kBaseVa);
    std::unordered_map<std::string, uint32_t> syms;
    for (const auto& [va, sname] : get_default_code_symbols()) {
        syms[sname] = va;
    }
    syms[fn_name] = kBaseVa;
    for (const auto& line : asm_lines) {
        if (!as.assemble_line(line, syms, err)) {
            return false;
        }
    }
    if (as.bytes().size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Custom routine exceeds part_04 region limit";
        return false;
    }
    bytes_ = as.bytes();
    return true;
}

std::string Part04FlashStub::generate_source_documentation() const {
    std::ostringstream oss;
    oss << "// ============================================================================\n"
        << "// PARTITION 04 SOURCE MODULE: " << meta_.id << "\n"
        << "// File: " << meta_.filename << " (" << bytes_.size() << " bytes)\n"
        << "// Unpacked Flash Range : 0x36B800 .. 0x36B804 (Expansion -> 0x374000, 34,816 B)\n"
        << "// Virtual Address (VA) : 0x55FE7800 .. 0x55FE7804\n"
        << "// REA Evidence ID      : " << meta_.rea_evidence_id << "\n"
        << "// ============================================================================\n\n"
        << "#include <cstdint>\n\n"
        << "namespace tz5::part04_src {\n\n"
        << "// 4-byte aligned return/nop stub at VA 0x55FE7800 (0xCB = rets/nop in MN103S)\n"
        << "void flash_boundary_stub_0x55FE7800(void) {\n"
        << "    return; // cb cb cb cb\n"
        << "}\n\n"
        << "} // namespace tz5::part04_src\n";
    return oss.str();
}

std::string Part04FlashStub::generate_json_summary() const {
    std::ostringstream oss;
    oss << "{\n"
        << "  \"partition_index\": 4,\n"
        << "  \"id\": \"" << meta_.id << "\",\n"
        << "  \"va_start\": \"0x55FE7800\",\n"
        << "  \"va_end\": \"0x" << std::hex << std::uppercase << (kBaseVa + bytes_.size()) << std::dec << "\",\n"
        << "  \"size\": " << bytes_.size() << ",\n"
        << "  \"free_cave_bytes\": " << (kRegionLimit - kUnpackedStart - bytes_.size()) << ",\n"
        << "  \"sha256\": \"" << FirmwareImage::sha256_hex(bytes_) << "\",\n"
        << "  \"rea_evidence_id\": \"" << meta_.rea_evidence_id << "\"\n"
        << "}\n";
    return oss.str();
}

} // namespace tz5::partitions
