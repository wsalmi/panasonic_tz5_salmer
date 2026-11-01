#include "partition_workspace.hpp"

#include <filesystem>
#include <fstream>
#include <sstream>

namespace tz5::partitions {

PartitionWorkspace::PartitionWorkspace() = default;

std::vector<const IPartitionModule*> PartitionWorkspace::all_modules() const {
    return {&part00_, &part01_, &part02_, &part03_, &part04_, &part05_, &part06_};
}

bool PartitionWorkspace::load_from_partitions_dir(const std::string& dir_path, std::string* err) {
    namespace fs = std::filesystem;
    fs::path base(dir_path);

    IPartitionModule* mods[7] = {&part00_, &part01_, &part02_, &part03_, &part04_, &part05_, &part06_};
    for (auto* m : mods) {
        std::string fpath = (base / m->metadata().filename).string();
        if (!m->load_from_partition_file(fpath, err)) {
            return false;
        }
    }
    return true;
}

bool PartitionWorkspace::load_from_firmware_file(const std::string& fw_path, std::string* err) {
    std::ifstream ifs(fw_path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open firmware file: " + fw_path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    ifs.seekg(0, std::ios::beg);
    std::vector<uint8_t> raw(sz);
    if (!ifs.read(reinterpret_cast<char*>(raw.data()), static_cast<std::streamsize>(sz))) {
        if (err) *err = "Failed to read firmware file: " + fw_path;
        return false;
    }

    std::vector<uint8_t> unpacked_with_trailer;
    if (raw.size() == FirmwareImage::kFramedFileSize) {
        std::vector<uint8_t> trailer32;
        unpacked_with_trailer = FirmwareImage::unpack_framed_to_rom(raw, &trailer32);
        unpacked_with_trailer.insert(unpacked_with_trailer.end(), trailer32.begin(), trailer32.end());
    } else if (raw.size() == FirmwareImage::kUnpackedWithTrailerSize || raw.size() == FirmwareImage::kRomPayloadSize) {
        unpacked_with_trailer = std::move(raw);
    } else {
        if (err) *err = "Unsupported firmware file size";
        return false;
    }

    IPartitionModule* mods[7] = {&part00_, &part01_, &part02_, &part03_, &part04_, &part05_, &part06_};
    for (auto* m : mods) {
        if (!m->load_from_full_rom(unpacked_with_trailer, err)) {
            return false;
        }
    }
    return true;
}

bool PartitionWorkspace::add_localized_osd_and_rebind_table(const std::string& new_osd_text,
                                                            uint32_t old_osd_va_to_replace,
                                                            uint32_t* out_new_osd_va,
                                                            size_t* out_rebound_pointers,
                                                            std::string* err) {
    uint32_t new_va = 0;
    if (!part03_.add_new_osd_string(new_osd_text, &new_va, err)) {
        return false;
    }
    size_t rebound = part05_.rebind_master_pointers_by_va(old_osd_va_to_replace, new_va);
    if (out_new_osd_va) *out_new_osd_va = new_va;
    if (out_rebound_pointers) *out_rebound_pointers = rebound;
    return true;
}

bool PartitionWorkspace::link_unpacked_rom(std::vector<uint8_t>& out_rom_with_trailer_484020, std::string* err) {
    std::vector<uint8_t> rom(FirmwareImage::kUnpackedWithTrailerSize, 0xFFu);

    const IPartitionModule* payload_mods[6] = {&part00_, &part01_, &part02_, &part03_, &part04_, &part05_};
    for (const auto* m : payload_mods) {
        if (!m->write_into_full_rom(rom, err)) {
            return false;
        }
    }

    // Automatically recompute Partition 06 (the 32-byte vertical column-parity trailer at 0x484000..0x484020)
    part06_.recompute_from_rom_payload(std::span<const uint8_t>(rom.data(), FirmwareImage::kRomPayloadSize));
    if (!part06_.write_into_full_rom(rom, err)) {
        return false;
    }

    out_rom_with_trailer_484020 = std::move(rom);
    return true;
}

bool PartitionWorkspace::build_framed_firmware(std::vector<uint8_t>& out_framed_5030946, std::string* err) {
    std::vector<uint8_t> rom_with_trailer;
    if (!link_unpacked_rom(rom_with_trailer, err)) {
        return false;
    }
    FirmwareImage fw;
    if (!fw.load_from_bytes(rom_with_trailer, err)) {
        return false;
    }
    out_framed_5030946 = fw.build_framed_bytes();
    return true;
}

bool PartitionWorkspace::save_all_partition_binaries(const std::string& out_partitions_dir, std::string* err) {
    namespace fs = std::filesystem;
    std::error_code ec;
    fs::create_directories(out_partitions_dir, ec);
    if (ec) {
        if (err) *err = "Failed to create output partitions directory: " + out_partitions_dir;
        return false;
    }

    // Ensure part06 is up to date before saving
    std::vector<uint8_t> dummy_rom;
    if (!link_unpacked_rom(dummy_rom, err)) {
        return false;
    }

    for (const auto* m : all_modules()) {
        std::string fpath = (fs::path(out_partitions_dir) / m->metadata().filename).string();
        if (!m->save_partition_file(fpath, err)) {
            return false;
        }
    }
    return true;
}

bool PartitionWorkspace::export_all_sources_and_summaries(const std::string& out_analysis_dir, std::string* err) const {
    namespace fs = std::filesystem;
    std::error_code ec;
    fs::create_directories(out_analysis_dir, ec);
    if (ec) {
        if (err) *err = "Failed to create analysis directory: " + out_analysis_dir;
        return false;
    }

    std::ostringstream master_json;
    master_json << "{\n  \"partitions\": [\n";

    auto mods = all_modules();
    for (size_t i = 0; i < mods.size(); ++i) {
        const auto* m = mods[i];
        std::string prefix = "part_0" + std::to_string(m->metadata().index);

        // Write generated C++20 source representation
        std::string src_path = (fs::path(out_analysis_dir) / (prefix + "_generated_source.hpp")).string();
        {
            std::ofstream ofs(src_path, std::ios::binary | std::ios::trunc);
            if (!ofs) {
                if (err) *err = "Failed to write " + src_path;
                return false;
            }
            std::string doc = m->generate_source_documentation();
            ofs.write(doc.data(), static_cast<std::streamsize>(doc.size()));
        }

        // Write individual JSON summary
        std::string json_path = (fs::path(out_analysis_dir) / (prefix + "_analysis.json")).string();
        std::string jsum = m->generate_json_summary();
        {
            std::ofstream jfs(json_path, std::ios::binary | std::ios::trunc);
            if (!jfs) {
                if (err) *err = "Failed to write " + json_path;
                return false;
            }
            jfs.write(jsum.data(), static_cast<std::streamsize>(jsum.size()));
        }

        master_json << jsum;
        if (i + 1 < mods.size()) {
            master_json << ",\n";
        }
    }

    master_json << "  ]\n}\n";
    std::string master_path = (fs::path(out_analysis_dir) / "all_partitions_summary.json").string();
    std::ofstream mfs(master_path, std::ios::binary | std::ios::trunc);
    if (!mfs) {
        if (err) *err = "Failed to write " + master_path;
        return false;
    }
    std::string mstr = master_json.str();
    mfs.write(mstr.data(), static_cast<std::streamsize>(mstr.size()));
    return true;
}

} // namespace tz5::partitions
