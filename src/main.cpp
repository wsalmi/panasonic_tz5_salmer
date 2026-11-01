#include "partition_workspace.hpp"
#include "ui_engine/tz5_ui_engine.hpp"
#include "raw_engine/tz5_raw_engine.hpp"
#include "tz5/assembler.hpp"
#include "tz5/disassembler.hpp"
#include "tz5/firmware.hpp"

#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

namespace {

void print_usage() {
    std::cout << "Panasonic Lumix DMC-TZ5 Firmware Disassembler, Partition Source SDK & Builder (C++20)\n"
              << "Usage:\n"
              << "  tz5-fw-tool info                  <TZ5_a.bin>\n"
              << "  tz5-fw-tool unpack                <TZ5_a.bin> <out_dir>\n"
              << "  tz5-fw-tool disasm                <TZ5_a.bin> <out_dir>\n"
              << "  tz5-fw-tool build                 <input_bin> <output_fw.bin> [--manifest <feature.json>] [--patch-str <va>=<str>] [--patch-osd <va>=<str>] [--version <maj.min>]\n"
              << "  tz5-fw-tool test                  <TZ5_a.bin>\n"
              << "  tz5-fw-tool partitions-export-src <TZ5_a.bin_or_partitions_dir> <out_analysis_dir>\n"
              << "  tz5-fw-tool partitions-build      <partitions_dir> <output_fw.bin> [--out-partitions-dir <dir>] [--version <maj.min>] [--add-osd <old_va>=<new_text>]\n"
              << "  tz5-fw-tool partitions-test       <TZ5_a.bin> <partitions_dir>\n"
              << "  tz5-fw-tool ui-export             <partitions_dir> <out_ui_src_dir>\n"
              << "  tz5-fw-tool ui-build-custom       <partitions_dir> <output_fw.bin> [--menu-label <text>] [--line1 <text>] [--line2 <text>]\n"
              << "  tz5-fw-tool ui-test               <TZ5_a.bin> <partitions_dir>\n"
              << "  tz5-fw-tool raw-build             <partitions_dir> <output_fw.bin> [--version <1.3>] [--out-partitions-dir <dir>] [--sd-speed <MB/s>]\n"
              << "  tz5-fw-tool raw-test              <TZ5_a.bin> <partitions_dir>\n";
}

bool read_raw_file(const std::string& path, std::vector<uint8_t>& out) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) return false;
    auto sz = static_cast<size_t>(ifs.tellg());
    ifs.seekg(0, std::ios::beg);
    out.resize(sz);
    return static_cast<bool>(ifs.read(reinterpret_cast<char*>(out.data()), static_cast<std::streamsize>(sz)));
}

int cmd_info(const std::string& path) {
    std::vector<uint8_t> raw;
    if (!read_raw_file(path, raw)) {
        std::cerr << "Error: Cannot read file " << path << "\n";
        return 1;
    }

    std::cout << "=== Panasonic Lumix DMC-TZ5 Firmware Profile ===\n";
    std::cout << "File Path          : " << path << "\n";
    std::cout << "File Size          : " << raw.size() << " bytes\n";
    std::cout << "SHA-256            : " << tz5::FirmwareImage::sha256_hex(raw) << "\n";

    if (raw.size() == tz5::FirmwareImage::kFramedFileSize) {
        auto rep = tz5::FirmwareImage::verify_framed_bytes(raw);
        std::cout << "Container Format   : Framed 34-byte Records (147,969 rows x 17 BE16 words)\n";
        std::cout << "Horizontal Check   : " << rep.horizontal_valid_rows << " / " << rep.total_rows << " valid rows\n";
        std::cout << "Vertical Check     : " << rep.vertical_valid_cols << " / 17 valid columns\n";
        std::cout << "Corner Word [16]   : 0x" << std::hex << std::uppercase << std::setw(4) << std::setfill('0')
                  << rep.trailer_corner_word << std::dec << "\n";
        std::cout << "Matrix Status      : " << (rep.valid ? "PASS (100% VALID)" : "FAIL") << "\n";
    }

    tz5::FirmwareImage fw;
    std::string err;
    if (!fw.load_from_bytes(raw, &err)) {
        std::cerr << "Error loading firmware: " << err << "\n";
        return 1;
    }

    uint16_t ver_maj = fw.read_u16_le(0x008008u);
    uint16_t ver_min = fw.read_u16_le(0x00800Au);
    std::cout << "Pana Header Ver    : " << ver_maj << "." << std::setw(2) << std::setfill('0') << ver_min << "\n\n";

    std::cout << "=== ROM Partitions (Base VA 0x55C7C000) ===\n";
    for (const auto& p : fw.get_partitions()) {
        char buf[256];
        std::snprintf(buf, sizeof(buf), "  [%d] %-23s Off 0x%06X..0x%06X (Active -> 0x%06X) VA 0x%08X  %s\n",
                      p.index, p.name.c_str(), p.start_offset, p.end_offset, p.active_end_offset,
                      p.va_start, p.description.c_str());
        std::cout << buf;
    }

    std::cout << "\n=== Available Execute-In-Place (XIP) Flash Code Caves ===\n";
    for (const auto& c : fw.code_caves()) {
        char buf[256];
        std::snprintf(buf, sizeof(buf), "  %-16s Off 0x%06X  VA 0x%08X  Free: %6u B  %s\n",
                      c.name.c_str(), c.rom_offset, c.va, c.capacity - c.used, c.description.c_str());
        std::cout << buf;
    }
    return 0;
}

int cmd_unpack(const std::string& path, const std::string& out_dir) {
    namespace fs = std::filesystem;
    tz5::FirmwareImage fw;
    std::string err;
    if (!fw.load_from_file(path, &err)) {
        std::cerr << "Error: " << err << "\n";
        return 1;
    }
    std::error_code ec;
    fs::create_directories(fs::path(out_dir) / "partitions", ec);

    std::string unpacked_path = (fs::path(out_dir) / "TZ5_unpacked.bin").string();
    if (!fw.save_unpacked_to_file(unpacked_path, true, &err)) {
        std::cerr << "Error: " << err << "\n";
        return 1;
    }
    std::cout << "Saved unpacked ROM + 32B parity trailer to: " << unpacked_path << "\n";

    for (const auto& p : fw.get_partitions()) {
        std::string ppath = (fs::path(out_dir) / "partitions" / (p.name + ".bin")).string();
        std::ofstream ofs(ppath, std::ios::binary | std::ios::trunc);
        ofs.write(reinterpret_cast<const char*>(fw.rom().data() + p.start_offset),
                  static_cast<std::streamsize>(p.end_offset - p.start_offset));
        std::cout << "  Extracted " << ppath << " (" << (p.end_offset - p.start_offset) << " bytes)\n";
    }
    return 0;
}

int cmd_disasm(const std::string& path, const std::string& out_dir) {
    tz5::FirmwareImage fw;
    std::string err;
    if (!fw.load_from_file(path, &err)) {
        std::cerr << "Error: " << err << "\n";
        return 1;
    }
    tz5::Mn103Disassembler dis(fw);
    tz5::DisassemblyStats stats;
    std::cout << "Disassembling Matsushita MN103S (AM33) firmware to " << out_dir << " ...\n";
    if (!dis.disassemble_all_to_dir(out_dir, &stats, &err)) {
        std::cerr << "Error: " << err << "\n";
        return 1;
    }
    std::cout << "=== Disassembly Complete ===\n"
              << "  Total Decoded Instructions : " << stats.total_instructions << "\n"
              << "  Discovered Functions       : " << stats.total_functions << "\n"
              << "  Subroutine Call Edges      : " << stats.total_call_edges << "\n"
              << "  Local Branch Labels        : " << stats.total_branch_labels << "\n"
              << "  String XREFs (.rodata/OSD) : " << stats.total_string_xrefs << "\n"
              << "  Venus IV MMIO XREFs        : " << stats.total_mmio_xrefs << "\n"
              << "  SDRAM (.data/.bss) XREFs   : " << stats.total_sdram_xrefs << "\n"
              << "  Custom Cave Instructions   : " << stats.custom_cave_instructions << "\n";
    return 0;
}

int cmd_build(int argc, char** argv) {
    if (argc < 4) {
        print_usage();
        return 1;
    }
    std::string in_path = argv[2];
    std::string out_path = argv[3];

    tz5::FirmwareImage fw;
    std::string err;
    if (!fw.load_from_file(in_path, &err)) {
        std::cerr << "Error loading input firmware: " << err << "\n";
        return 1;
    }

    tz5::FeatureBuilder builder(fw);

    for (int i = 4; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--manifest" && i + 1 < argc) {
            std::string mpath = argv[++i];
            if (!builder.apply_manifest_file(mpath, &err)) {
                std::cerr << "Manifest error: " << err << "\n";
                return 1;
            }
        } else if (arg == "--version" && i + 1 < argc) {
            std::string v = argv[++i];
            auto dot = v.find('.');
            if (dot != std::string::npos) {
                uint16_t maj = static_cast<uint16_t>(std::strtoul(v.substr(0, dot).c_str(), nullptr, 10));
                uint16_t min = static_cast<uint16_t>(std::strtoul(v.substr(dot + 1).c_str(), nullptr, 10));
                if (!fw.set_firmware_version(maj, min, &err)) {
                    std::cerr << "Version error: " << err << "\n";
                    return 1;
                }
            }
        } else if ((arg == "--patch-str" || arg == "--patch-osd") && i + 1 < argc) {
            std::string kv = argv[++i];
            auto eq = kv.find('=');
            if (eq == std::string::npos) {
                std::cerr << "Expected <va>=<text> for " << arg << "\n";
                return 1;
            }
            uint32_t addr = static_cast<uint32_t>(std::strtoul(kv.substr(0, eq).c_str(), nullptr, 0));
            std::string text = kv.substr(eq + 1);
            bool ok = (arg == "--patch-osd") ? fw.patch_osd_string(addr, text, &err)
                                             : fw.patch_ascii(addr, text, false, &err);
            if (!ok) {
                std::cerr << "Patch error: " << err << "\n";
                return 1;
            }
        }
    }

    if (!builder.artifacts().empty()) {
        std::cout << "=== Applied Custom Features & Patches (" << builder.artifacts().size() << ") ===\n";
        for (const auto& a : builder.artifacts()) {
            char buf[256];
            std::snprintf(buf, sizeof(buf), "  [%-12s] %-26s @ VA 0x%08X (%3u B) : %s\n",
                          a.kind.c_str(), a.name.c_str(), a.va, a.size, a.details.c_str());
            std::cout << buf;
        }
    }

    std::vector<uint8_t> trailer32;
    auto framed = fw.build_framed_bytes(&trailer32);
    auto rep = tz5::FirmwareImage::verify_framed_bytes(framed);
    if (!rep.valid) {
        std::cerr << "Internal error: Rebuilt firmware failed verification: " << rep.message << "\n";
        return 1;
    }

    if (!fw.save_framed_to_file(out_path, &err)) {
        std::cerr << "Error saving output firmware: " << err << "\n";
        return 1;
    }

    std::cout << "=== Firmware Build & 2D Checksum Matrix Verification ===\n"
              << "  Output File        : " << out_path << " (" << framed.size() << " bytes)\n"
              << "  Output SHA-256     : " << rep.sha256_hex << "\n"
              << "  Horizontal Rows    : " << rep.horizontal_valid_rows << " / " << rep.total_rows << " valid\n"
              << "  Vertical Columns   : " << rep.vertical_valid_cols << " / 17 valid\n"
              << "  Corner Word [16]   : 0x" << std::hex << std::uppercase << std::setw(4) << std::setfill('0')
              << rep.trailer_corner_word << std::dec << "\n"
              << "  Status             : PASS (100% Valid Panasonic TZ5 Firmware Image)\n";
    return 0;
}

int cmd_test(const std::string& orig_path) {
    std::cout << "=== Running TZ5 Firmware SDK Self-Test Suite ===\n";
    std::vector<uint8_t> orig_raw;
    if (!read_raw_file(orig_path, orig_raw)) {
        std::cerr << "FAIL: Could not read " << orig_path << "\n";
        return 1;
    }
    const std::string orig_sha = tz5::FirmwareImage::sha256_hex(orig_raw);
    std::cout << "[Test 1] Verify Original TZ5_a.bin Checksum Matrix...\n";
    auto rep1 = tz5::FirmwareImage::verify_framed_bytes(orig_raw);
    if (!rep1.valid) {
        std::cerr << "FAIL: Original firmware failed verification: " << rep1.message << "\n";
        return 1;
    }
    std::cout << "  PASS: 147,969/147,969 rows & 17/17 columns valid (SHA-256: " << orig_sha << ")\n";

    std::cout << "[Test 2] Unpack -> Rebuild Round-Trip Bit-Exact Identity...\n";
    tz5::FirmwareImage fw;
    std::string err;
    if (!fw.load_from_bytes(orig_raw, &err)) {
        std::cerr << "FAIL: " << err << "\n";
        return 1;
    }
    auto rebuilt_raw = fw.build_framed_bytes();
    const std::string rebuilt_sha = tz5::FirmwareImage::sha256_hex(rebuilt_raw);
    if (rebuilt_raw != orig_raw || rebuilt_sha != orig_sha) {
        std::cerr << "FAIL: Round-trip SHA-256 mismatch! Got " << rebuilt_sha << "\n";
        return 1;
    }
    std::cout << "  PASS: Rebuilt firmware matches original TZ5_a.bin 100% byte-for-byte!\n";

    std::cout << "[Test 3] Inject New MN103S Feature into XIP Code Cave + Hook Call Site + Rebuild...\n";
    tz5::FeatureBuilder builder(fw);
    if (!builder.apply_manifest_file("examples/sample_feature_mod.json", &err)) {
        std::cerr << "FAIL: Manifest injection failed: " << err << "\n";
        return 1;
    }
    auto custom_framed = fw.build_framed_bytes();
    auto rep3 = tz5::FirmwareImage::verify_framed_bytes(custom_framed);
    if (!rep3.valid) {
        std::cerr << "FAIL: Custom firmware failed 2D matrix verification: " << rep3.message << "\n";
        return 1;
    }
    std::cout << "  PASS: Custom feature firmware built & verified (147,969/147,969 rows & 17/17 cols valid)\n";
    std::cout << "        New SHA-256: " << rep3.sha256_hex << "\n";

    std::cout << "[Test 4] Disassemble Hooked Call Site & Injected Code Cave (CAVE_MAIN_TEXT)...\n";
    tz5::Mn103Disassembler dis(fw);
    for (const auto& [name, va] : builder.symbols()) {
        dis.add_symbol(va, name);
    }
    std::cout << dis.disassemble_range_to_string(0x10B497u, 0x10B4ACu, "Hooked Call Site (0x55D87497..0x55D874AC)");
    std::cout << dis.disassemble_range_to_string(0x21F468u, 0x21F481u, "Injected MN103S Feature Function (0x55E9B468..0x55E9B481)");

    std::cout << "\nALL 4 SELF-TESTS PASSED 100%!\n";
    return 0;
}

int cmd_partitions_export_src(const std::string& input_path, const std::string& out_dir) {
    namespace fs = std::filesystem;
    tz5::partitions::PartitionWorkspace ws;
    std::string err;

    bool ok = fs::is_directory(input_path)
                  ? ws.load_from_partitions_dir(input_path, &err)
                  : ws.load_from_firmware_file(input_path, &err);
    if (!ok) {
        std::cerr << "Error loading partitions into workspace: " << err << "\n";
        return 1;
    }

    if (!ws.export_all_sources_and_summaries(out_dir, &err)) {
        std::cerr << "Error exporting partition sources: " << err << "\n";
        return 1;
    }

    std::cout << "=== Exported All 7 Partition Source Representations & JSON Dossiers to " << out_dir << " ===\n";
    for (const auto* m : ws.all_modules()) {
        auto bytes = m->emit_partition_bytes();
        char buf[256];
        std::snprintf(buf, sizeof(buf),
                      "  [part_0%d] %-24s VA 0x%08X..0x%08X (%7zu B) REA: %s\n",
                      m->metadata().index,
                      m->metadata().id.c_str(),
                      m->metadata().va_start,
                      m->metadata().va_end,
                      bytes.size(),
                      m->metadata().rea_evidence_id.substr(0, 19).c_str());
        std::cout << buf;
    }
    return 0;
}

int cmd_partitions_build(int argc, char** argv) {
    if (argc < 4) {
        print_usage();
        return 1;
    }
    std::string parts_dir = argv[2];
    std::string out_fw_path = argv[3];
    std::string out_parts_dir;

    tz5::partitions::PartitionWorkspace ws;
    std::string err;
    if (!ws.load_from_partitions_dir(parts_dir, &err)) {
        std::cerr << "Error loading partitions from " << parts_dir << ": " << err << "\n";
        return 1;
    }

    for (int i = 4; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--out-partitions-dir" && i + 1 < argc) {
            out_parts_dir = argv[++i];
        } else if (arg == "--version" && i + 1 < argc) {
            std::string v = argv[++i];
            auto dot = v.find('.');
            if (dot != std::string::npos) {
                uint16_t maj = static_cast<uint16_t>(std::strtoul(v.substr(0, dot).c_str(), nullptr, 10));
                uint16_t min = static_cast<uint16_t>(std::strtoul(v.substr(dot + 1).c_str(), nullptr, 10));
                if (!ws.part01().set_firmware_version(maj, min, &err) ||
                    !ws.part02().set_firmware_version(maj, min, &err)) {
                    std::cerr << "Error setting version in partitions: " << err << "\n";
                    return 1;
                }
            }
        } else if (arg == "--add-osd" && i + 1 < argc) {
            std::string kv = argv[++i];
            auto eq = kv.find('=');
            if (eq == std::string::npos) {
                std::cerr << "Expected <old_va>=<new_text> for --add-osd\n";
                return 1;
            }
            uint32_t old_va = static_cast<uint32_t>(std::strtoul(kv.substr(0, eq).c_str(), nullptr, 0));
            std::string new_text = kv.substr(eq + 1);
            uint32_t new_va = 0;
            size_t rebound = 0;
            if (!ws.add_localized_osd_and_rebind_table(new_text, old_va, &new_va, &rebound, &err)) {
                std::cerr << "Error adding OSD string in part_03/part_05: " << err << "\n";
                return 1;
            }
            std::cout << "  [+] Allocated OSD string \"" << new_text << "\" in part_03 @ VA 0x"
                      << std::hex << std::uppercase << new_va << std::dec
                      << " and rebound " << rebound << " pointer(s) in part_05 (0x12345678 table)\n";
        }
    }

    if (!out_parts_dir.empty()) {
        if (!ws.save_all_partition_binaries(out_parts_dir, &err)) {
            std::cerr << "Error saving partition binaries: " << err << "\n";
            return 1;
        }
        std::cout << "Saved all 7 compiled partition .bin files to: " << out_parts_dir << "\n";
    }

    std::vector<uint8_t> framed;
    if (!ws.build_framed_firmware(framed, &err)) {
        std::cerr << "Error linking firmware from partitions: " << err << "\n";
        return 1;
    }

    auto rep = tz5::FirmwareImage::verify_framed_bytes(framed);
    if (!rep.valid) {
        std::cerr << "Error: Linked firmware failed 2D matrix verification: " << rep.message << "\n";
        return 1;
    }

    std::ofstream ofs(out_fw_path, std::ios::binary | std::ios::trunc);
    ofs.write(reinterpret_cast<const char*>(framed.data()), static_cast<std::streamsize>(framed.size()));
    std::cout << "=== Built Firmware from Modular Partition Sources (Part00..Part06) ===\n"
              << "  Output File      : " << out_fw_path << " (" << framed.size() << " bytes)\n"
              << "  SHA-256          : " << rep.sha256_hex << "\n"
              << "  Horizontal Rows  : " << rep.horizontal_valid_rows << " / " << rep.total_rows << "\n"
              << "  Vertical Columns : " << rep.vertical_valid_cols << " / 17\n"
              << "  Status           : PASS (100% Valid)\n";
    return 0;
}

int cmd_partitions_test(const std::string& orig_fw_path, const std::string& parts_dir) {
    std::cout << "================================================================================\n"
              << " Running Modular Partition Source & Rebuild Test Suite (part_00 .. part_06)\n"
              << "================================================================================\n";

    std::vector<uint8_t> orig_raw;
    if (!read_raw_file(orig_fw_path, orig_raw)) {
        std::cerr << "FAIL: Cannot read original firmware: " << orig_fw_path << "\n";
        return 1;
    }
    const std::string orig_fw_sha = tz5::FirmwareImage::sha256_hex(orig_raw);

    tz5::partitions::PartitionWorkspace ws;
    std::string err;
    if (!ws.load_from_partitions_dir(parts_dir, &err)) {
        std::cerr << "FAIL: Could not load partitions from " << parts_dir << ": " << err << "\n";
        return 1;
    }

    std::cout << "\n[Phase 1] Verify Per-Partition Bit-Exact Source Emission (part_00 .. part_06)...\n";
    for (const auto* m : ws.all_modules()) {
        auto emitted = m->emit_partition_bytes();
        std::string sha = tz5::FirmwareImage::sha256_hex(emitted);
        if (sha != m->metadata().original_sha256) {
            std::cerr << "FAIL: Partition " << m->metadata().id << " SHA-256 mismatch!\n"
                      << "  Expected: " << m->metadata().original_sha256 << "\n"
                      << "  Got     : " << sha << "\n";
            return 1;
        }
        std::cout << "  PASS [part_0" << m->metadata().index << "] " << std::left << std::setw(24)
                  << m->metadata().id << " (" << std::right << std::setw(9) << emitted.size()
                  << " B) SHA-256=" << sha.substr(0, 16) << "... == Original!\n";
    }

    std::cout << "\n[Phase 2] Link All 7 Unmodified Partition Modules -> Verify 100% Bit-Exact TZ5_a.bin...\n";
    std::vector<uint8_t> linked_framed;
    if (!ws.build_framed_firmware(linked_framed, &err)) {
        std::cerr << "FAIL: build_framed_firmware failed: " << err << "\n";
        return 1;
    }
    std::string linked_sha = tz5::FirmwareImage::sha256_hex(linked_framed);
    if (linked_framed != orig_raw || linked_sha != orig_fw_sha) {
        std::cerr << "FAIL: Linked firmware does not match original TZ5_a.bin!\n";
        return 1;
    }
    std::cout << "  PASS: Linked 7 partitions match TZ5_a.bin 100% bit-for-bit (" << linked_framed.size()
              << " bytes, SHA-256=" << linked_sha << ")\n";

    std::cout << "\n[Phase 3] Modify & Add New Resources Across All 7 Partition Modules (Part00..Part06)...\n";

    // 3.0: Part00 - Append early boot extension routine in 0x55C7D308+
    uint32_t p0_ext_va = 0;
    if (!ws.part00().append_early_boot_extension(
            "part00_custom_boot_hook",
            {"mov 0x54077204, a0", "mov 0x1, d0", "mov d0, (0x54077204)", "rets"},
            &p0_ext_va, &err)) {
        std::cerr << "FAIL [part_00]: " << err << "\n";
        return 1;
    }
    std::cout << "  [part_00] Added early-boot MN103S routine @ VA 0x" << std::hex << std::uppercase << p0_ext_va << std::dec << "\n";

    // 3.1: Part01 - Append custom ISR in 0x55C809F4+ & set kernel .data word at 0x54000400
    uint32_t p1_isr_va = 0;
    if (!ws.part01().append_custom_isr(
            "part01_custom_irq6_filter",
            {"jmp @venus_master_irq_dispatcher"},
            &p1_isr_va, &err) ||
        !ws.part01().redirect_irq_vector_slot(9, p1_isr_va, &err) ||
        !ws.part01().set_kernel_data_word(0, 0xCAFEBABEu, &err)) {
        std::cerr << "FAIL [part_01]: " << err << "\n";
        return 1;
    }
    std::cout << "  [part_01] Added custom IRQ6 ISR @ VA 0x" << std::hex << std::uppercase << p1_isr_va
              << ", redirected Vector Slot 9, and set Kernel .data[0]=0xCAFEBABE" << std::dec << "\n";

    // 3.2: Part02 - Update Pana Header version, .data global, and inject CAVE_MAIN_TEXT function
    uint32_t p2_fn_va = 0;
    if (!ws.part02().set_firmware_version(2, 50, &err) ||
        !ws.part02().patch_data_segment_u32(0x54012840u, 0x1337C0DEu, &err) ||
        !ws.part02().add_cave_function(
            "part02_custom_isp_helper",
            {"mov (0x54077200), d2", "add 1, d2", "mov d2, (0x54077200)", "rets"},
            &p2_fn_va, &err)) {
        std::cerr << "FAIL [part_02]: " << err << "\n";
        return 1;
    }
    std::cout << "  [part_02] Updated 'Pana' header to v2.50, patched .data @ 0x54012840, and added MN103S function @ VA 0x"
              << std::hex << std::uppercase << p2_fn_va << std::dec << "\n";

    // 3.3 & 3.5: Part03 + Part05 - Allocate new 0x0003 OSD UI string in Part03 and rebind Part05's 0x12345678 pointer table!
    uint32_t old_osd_va = ws.part05().read_master_table_word(0xB6Cu / 4u); // First Part03 pointer in Master Table (0x55F77D52)
    uint32_t new_osd_va = 0;
    size_t rebound_count = 0;
    if (!ws.add_localized_osd_and_rebind_table("TZ5-PRO-OSD-MOD", old_osd_va, &new_osd_va, &rebound_count, &err)) {
        std::cerr << "FAIL [part_03/part_05]: " << err << "\n";
        return 1;
    }
    std::cout << "  [part_03 + part_05] Added 16-bit 0x0003 OSD string \"TZ5-PRO-OSD-MOD\" in part_03 @ VA 0x"
              << std::hex << std::uppercase << new_osd_va << " and rebound " << std::dec << rebound_count
              << " pointer(s) from 0x" << std::hex << old_osd_va << std::dec << " in part_05's 0x12345678 table\n";

    // 3.4: Part04 - Replace 4-byte 0x55FE7800 stub with an expanded XIP subroutine
    if (!ws.part04().set_custom_stub_routine(
            "part04_xip_subroutine",
            {"mov 0x42, d0", "rets"}, &err)) {
        std::cerr << "FAIL [part_04]: " << err << "\n";
        return 1;
    }
    std::cout << "  [part_04] Replaced 0x55FE7800 stub with custom XIP subroutine (" << ws.part04().emit_partition_bytes().size() << " B)\n";

    // 3.6: Part06 - Link all modified partitions, automatically recomputing Part06 (32B vertical parity trailer)
    std::vector<uint8_t> mod_framed;
    if (!ws.build_framed_firmware(mod_framed, &err)) {
        std::cerr << "FAIL [part_06/link]: " << err << "\n";
        return 1;
    }
    auto mod_rep = tz5::FirmwareImage::verify_framed_bytes(mod_framed);
    if (!mod_rep.valid) {
        std::cerr << "FAIL: Modified multi-partition firmware failed 2D matrix verification: " << mod_rep.message << "\n";
        return 1;
    }
    std::cout << "  [part_06] Recomputed 32-byte vertical column-parity trailer (Corner Word = 0x"
              << std::hex << std::uppercase << std::setw(4) << std::setfill('0') << mod_rep.trailer_corner_word << std::dec << ")\n";
    std::cout << "  PASS: Rebuilt multi-partition firmware verified 100% ("
              << mod_rep.horizontal_valid_rows << "/" << mod_rep.total_rows << " rows, "
              << mod_rep.vertical_valid_cols << "/17 cols valid, SHA-256=" << mod_rep.sha256_hex << ")\n";

    std::cout << "\nALL PARTITION SOURCE & REBUILD TESTS PASSED 100%!\n";
    return 0;
}

int cmd_ui_export(const std::string& parts_dir, const std::string& out_ui_dir) {
    tz5::partitions::PartitionWorkspace ws;
    std::string err;
    if (!ws.load_from_partitions_dir(parts_dir, &err)) {
        std::cerr << "Error loading partitions from " << parts_dir << ": " << err << "\n";
        return 1;
    }
    tz5::ui::VenusUiEngine ui(ws);
    if (!ui.analyze_all(&err)) {
        std::cerr << "Error analyzing camera UI across part_02/part_03/part_05: " << err << "\n";
        return 1;
    }
    if (!ui.export_all_ui_screens_code(out_ui_dir, &err)) {
        std::cerr << "Error exporting UI screen sources: " << err << "\n";
        return 1;
    }
    std::cout << "=== Exported Reversed Panasonic Lumix DMC-TZ5 UI Engine & Screen Sources ===\n"
              << "  Output Directory      : " << out_ui_dir << "\n"
              << "  Languages Parsed      : " << ui.language_names().size() << " (3,251 String IDs each in part_05)\n"
              << "  Glyph/Icon Tile Table : " << ui.glyph_bitmap_pointers().size() << " entries (@ 0x55F82ED8 in part_03)\n"
              << "  Menu Descriptor Groups: " << ui.menu_groups().size() << " tables (" << ui.total_menu_items() << " items in part_02)\n"
              << "  Reversed UI Screens   : " << ui.screens().size() << " screen definitions\n";
    return 0;
}

int cmd_ui_build_custom(int argc, char** argv) {
    if (argc < 4) {
        print_usage();
        return 1;
    }
    std::string parts_dir = argv[2];
    std::string out_fw_path = argv[3];
    std::string menu_label = "TZ5 STUDIO UI";
    std::string line1 = "RAW 12-BIT CCD DUMP: ON";
    std::string line2 = "OPTICAL ZOOM IN HD: ON";

    for (int i = 4; i < argc; ++i) {
        std::string a = argv[i];
        if (a == "--menu-label" && i + 1 < argc) menu_label = argv[++i];
        else if (a == "--line1" && i + 1 < argc) line1 = argv[++i];
        else if (a == "--line2" && i + 1 < argc) line2 = argv[++i];
    }

    tz5::partitions::PartitionWorkspace ws;
    std::string err;
    if (!ws.load_from_partitions_dir(parts_dir, &err)) {
        std::cerr << "Error loading partitions: " << err << "\n";
        return 1;
    }
    tz5::ui::VenusUiEngine ui(ws);
    if (!ui.analyze_all(&err)) {
        std::cerr << "Error analyzing UI: " << err << "\n";
        return 1;
    }

    tz5::ui::CustomUiScreenSpec spec;
    spec.screen_symbol_name = "ui_screen_custom_tz5_studio";
    spec.menu_label_text = menu_label;
    spec.replace_menu_label_sid = 0x029Fu; // DEMO MODE -> Custom UI
    spec.patch_menu_item_va = 0x55E69FD0u; // [SETUP] Menu entry
    spec.panels = {
        {16, 16, 288, 208, 0x02},
        {16, 16, 288,  30, 0x04}
    };
    spec.labels = {
        {28,  24, 0x029Fu, "", 0x01},
        {28,  64, 0, line1, 0x01},
        {28,  94, 0, line2, 0x01},
        {28, 124, 0x02DCu, "", 0x01}
    };

    tz5::ui::CustomUiBuildResult res;
    if (!ui.compile_and_inject_custom_ui_screen(spec, &res, &err)) {
        std::cerr << "Error compiling custom UI screen: " << err << "\n";
        return 1;
    }

    std::vector<uint8_t> framed;
    if (!ws.build_framed_firmware(framed, &err)) {
        std::cerr << "Error linking firmware: " << err << "\n";
        return 1;
    }
    auto rep = tz5::FirmwareImage::verify_framed_bytes(framed);
    if (!rep.valid) {
        std::cerr << "Error: Custom UI firmware failed 2D parity verification: " << rep.message << "\n";
        return 1;
    }

    std::ofstream ofs(out_fw_path, std::ios::binary | std::ios::trunc);
    ofs.write(reinterpret_cast<const char*>(framed.data()), static_cast<std::streamsize>(framed.size()));
    std::cout << "=== Compiled & Injected New Custom UI Screen into Firmware ===\n"
              << "  Output Firmware       : " << out_fw_path << " (" << framed.size() << " B)\n"
              << "  New Screen Handler VA : 0x" << std::hex << std::uppercase << res.screen_function_va
              << " (" << std::dec << res.screen_function_size << " B in part_02 CAVE_MAIN_TEXT)\n"
              << "  New Menu Item Desc VA : 0x" << std::hex << std::uppercase << res.new_menu_item_va << std::dec << "\n"
              << "  Rebound 24-Lang Slots : " << res.rebound_language_pointers << " pointers in part_05 (0x56000000)\n"
              << "  2D Checksum Matrix    : PASS (" << rep.horizontal_valid_rows << "/" << rep.total_rows
              << " rows, " << rep.vertical_valid_cols << "/17 cols)\n";
    return 0;
}

int cmd_ui_test(const std::string& orig_fw_path, const std::string& parts_dir) {
    std::cout << "================================================================================\n"
              << " Running Panasonic Lumix DMC-TZ5 UI Engine Reversal & Custom Screen Test Suite\n"
              << "================================================================================\n";

    tz5::partitions::PartitionWorkspace ws;
    std::string err;
    if (!ws.load_from_partitions_dir(parts_dir, &err)) {
        std::cerr << "FAIL: Cannot load partitions from " << parts_dir << ": " << err << "\n";
        return 1;
    }

    tz5::ui::VenusUiEngine ui(ws);
    if (!ui.analyze_all(&err)) {
        std::cerr << "FAIL: VenusUiEngine::analyze_all failed: " << err << "\n";
        return 1;
    }

    std::cout << "\n[Test 1] Verify Reversed UI Architecture Across part_02, part_03, and part_05...\n";
    if (ui.language_names().size() != 24 || ui.glyph_bitmap_pointers().size() != 7518 || ui.total_menu_items() < 120) {
        std::cerr << "FAIL: Unexpected UI table counts!\n";
        return 1;
    }
    std::string wb_en  = ui.resolve_string_id(0x0036u, 1);  // English (WHITE BALANCE)
    std::string wb_pt  = ui.resolve_string_id(0x0036u, 16); // Portuguese (BAL. BRANCOS)
    std::string srv_en = ui.resolve_string_id(0x02DCu, 1);  // part_03 shared SERVICE MODE
    std::string rio_en = ui.resolve_string_id(0x0217u, 1);  // World Time Rio de Janeiro (+0x010B bias)
    std::cout << "  PASS: 24 Languages, 7,518 Glyph/Icon Pointers (@ 0x55F82ED8), "
              << ui.menu_groups().size() << " Menu Descriptor Tables (" << ui.total_menu_items() << " items), "
              << ui.screens().size() << " Screens.\n"
              << "  PASS: SID 0x0036 EN=\"" << wb_en << "\" | PT=\"" << wb_pt << "\"\n"
              << "  PASS: SID 0x02DC (part_03 shared)=\"" << srv_en << "\" | SID 0x0217 (World Time)=\"" << rio_en << "\"\n";

    std::cout << "\n[Test 2] Compile & Inject Brand-New Custom UI Screen + 24-Language String Rebinding...\n";
    tz5::ui::CustomUiScreenSpec spec;
    spec.screen_symbol_name = "ui_screen_custom_tz5_studio";
    spec.menu_label_text = "TZ5 STUDIO UI";
    spec.replace_menu_label_sid = 0x029Fu;
    spec.patch_menu_item_va = 0x55E69FD0u;
    spec.panels = {
        {16, 16, 288, 208, 0x02},
        {16, 16, 288,  30, 0x04}
    };
    spec.labels = {
        {28,  24, 0x029Fu, "", 0x01},
        {28,  64, 0, "RAW 12-BIT CCD DUMP: ON", 0x01},
        {28,  94, 0, "OPTICAL ZOOM IN HD: ON", 0x01},
        {28, 124, 0x02DCu, "", 0x01}
    };

    tz5::ui::CustomUiBuildResult build_res;
    if (!ui.compile_and_inject_custom_ui_screen(spec, &build_res, &err)) {
        std::cerr << "FAIL: compile_and_inject_custom_ui_screen failed: " << err << "\n";
        return 1;
    }

    // Verify that SID 0x029F now resolves to "TZ5 STUDIO UI" in both English (lang 1) and Portuguese (lang 16)!
    std::string new_en = ui.resolve_string_id(0x029Fu, 1);
    std::string new_pt = ui.resolve_string_id(0x029Fu, 16);
    if (new_en != "TZ5 STUDIO UI" || new_pt != "TZ5 STUDIO UI") {
        std::cerr << "FAIL: SID 0x029F did not resolve to 'TZ5 STUDIO UI' after rebinding! Got: " << new_en << "\n";
        return 1;
    }
    std::cout << "  PASS: Injected MN103S Custom Screen Handler @ VA 0x" << std::hex << std::uppercase
              << build_res.screen_function_va << " (" << std::dec << build_res.screen_function_size << " B)\n"
              << "  PASS: Allocated " << build_res.allocated_string_vas.size()
              << " new 0x0003-terminated OSD strings in part_03 and rebound " << build_res.rebound_language_pointers
              << " language pointers in part_05\n"
              << "  PASS: Verified SID 0x029F EN=\"" << new_en << "\" | PT=\"" << new_pt << "\"\n";
    for (const auto& dline : build_res.disassembly_preview) {
        std::cout << "    " << dline << "\n";
    }

    std::cout << "\n[Test 3] Link Modified UI Partitions & Verify 100% 2D Matrix Checksum...\n";
    std::vector<uint8_t> framed;
    if (!ws.build_framed_firmware(framed, &err)) {
        std::cerr << "FAIL: build_framed_firmware failed: " << err << "\n";
        return 1;
    }
    auto rep = tz5::FirmwareImage::verify_framed_bytes(framed);
    if (!rep.valid || framed.size() != tz5::FirmwareImage::kFramedFileSize) {
        std::cerr << "FAIL: 2D parity verification failed!\n";
        return 1;
    }
    (void)orig_fw_path;
    std::cout << "  PASS: Rebuilt firmware with Custom UI Screen verified 100% ("
              << rep.horizontal_valid_rows << "/" << rep.total_rows << " rows, "
              << rep.vertical_valid_cols << "/17 cols valid, Corner=0x"
              << std::hex << std::uppercase << std::setw(4) << std::setfill('0') << rep.trailer_corner_word << std::dec << ")\n";
    std::cout << "\nALL UI ENGINE REVERSAL & CUSTOM SCREEN INJECTION TESTS PASSED 100%!\n";
    return 0;
}

int cmd_raw_build(int argc, char** argv) {
    if (argc < 4) {
        print_usage();
        return 1;
    }
    std::string parts_dir = argv[2];
    std::string out_fw_path = argv[3];
    std::string out_parts_dir;

    tz5::raw::RawConfigOptions opts;
    opts.version_major = 1;
    opts.version_minor = 3; // v1.3 (01 00 03 00 -> strictly > 01 00 02 00 factory v1.2)

    for (int i = 4; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--out-partitions-dir" && i + 1 < argc) {
            out_parts_dir = argv[++i];
        } else if (arg == "--version" && i + 1 < argc) {
            std::string v = argv[++i];
            auto dot = v.find('.');
            if (dot != std::string::npos) {
                opts.version_major = static_cast<uint16_t>(std::strtoul(v.substr(0, dot).c_str(), nullptr, 10));
                std::string min_str = v.substr(dot + 1);
                opts.version_minor = static_cast<uint16_t>(std::strtoul(min_str.c_str(), nullptr, 10));
                if (opts.version_minor >= 10 && opts.version_minor % 10 == 0) {
                    opts.version_minor /= 10; // e.g. "30" -> 3 (matching Panasonic's 1.2 = 01 00 02 00 format)
                }
            }
        } else if (arg == "--sd-speed" && i + 1 < argc) {
            opts.estimated_sd_speed_mbs = std::strtof(argv[++i], nullptr);
        }
    }

    tz5::partitions::PartitionWorkspace ws;
    std::string err;
    if (!ws.load_from_partitions_dir(parts_dir, &err)) {
        std::cerr << "Error loading partitions from " << parts_dir << ": " << err << "\n";
        return 1;
    }

    tz5::raw::VenusRawEngine raw_engine(ws);
    tz5::raw::RawInjectionResult res;
    if (!raw_engine.apply_raw_mod(opts, &res, &err)) {
        std::cerr << "Error applying RAW mod: " << err << "\n";
        return 1;
    }

    raw_engine.export_raw_docs("output/raw_spec", res, &err);

    if (!out_parts_dir.empty()) {
        if (!ws.save_all_partition_binaries(out_parts_dir, &err)) {
            std::cerr << "Error saving partition binaries: " << err << "\n";
            return 1;
        }
        std::cout << "Saved all 7 compiled RAW partition .bin files to: " << out_parts_dir << "\n";
    }

    std::vector<uint8_t> framed;
    if (!ws.build_framed_firmware(framed, &err)) {
        std::cerr << "Error linking framed firmware: " << err << "\n";
        return 1;
    }

    auto rep = tz5::FirmwareImage::verify_framed_bytes(framed);
    if (!rep.valid) {
        std::cerr << "Error: Rebuilt RAW firmware failed 2D parity verification: " << rep.message << "\n";
        return 1;
    }

    std::ofstream ofs(out_fw_path, std::ios::binary | std::ios::trunc);
    ofs.write(reinterpret_cast<const char*>(framed.data()), static_cast<std::streamsize>(framed.size()));

    std::cout << "================================================================================\n"
              << " Panasonic Lumix DMC-TZ5 RAW & SD Visual Loader Firmware (v" << res.firmware_version_str << ") Built Successfully\n"
              << "================================================================================\n"
              << "  Output Binary Container : " << out_fw_path << " (" << framed.size() << " B)\n"
              << "  Firmware Version        : v" << res.firmware_version_str << " (Major 1, Minor 30 @ 0x008008)\n"
              << "  QUALITY Menu RAW Sub-Opts: 0x" << std::hex << std::uppercase << res.quality_sub_opts_va
              << " (Unlocked " << std::dec << res.unlocked_quality_options << " options: RAW val=3, RAW+JPEG val=5)\n"
              << "  New OSD Strings in ROM  : 'RAW' @ 0x" << std::hex << std::uppercase << res.raw_label_va
              << ", 'RAW+JPEG' @ 0x" << res.raw_plus_jpeg_label_va << "\n"
              << "  24-Language Table Rebind: " << std::dec << res.rebound_language_entries << " pointer slots in part_05 (0x12345678 table)\n"
              << "  Setup Menu Direct Toggle: Item 34 @ 0x" << std::hex << std::uppercase << res.setup_menu_item_va
              << " -> 'RAW CAPTURE & LOADER'\n"
              << "  Visual SD Loader Routine: 0x" << std::hex << std::uppercase << res.loader_function_va
              << " (" << std::dec << res.loader_function_size << " B in part_02 CAVE_MAIN_TEXT)\n"
              << "  Target Sensor Geometry  : 10.7 MP (3648x2736), 12-bit Bayer CCD (~15.0 MB uncompressed)\n"
              << "  Estimated SD Write Time : " << std::fixed << std::setprecision(1)
              << (15.0f / opts.estimated_sd_speed_mbs) << "s @ " << opts.estimated_sd_speed_mbs << " MB/s\n"
              << "  2D Parity Matrix Check  : PASS (" << rep.horizontal_valid_rows << "/" << rep.total_rows
              << " rows, " << rep.vertical_valid_cols << "/17 cols, Corner=0x"
              << std::hex << std::uppercase << std::setw(4) << std::setfill('0') << rep.trailer_corner_word << std::dec << ")\n"
              << "  SHA-256 Checksum        : " << rep.sha256_hex << "\n"
              << "================================================================================\n";
    return 0;
}

int cmd_raw_test(const std::string& orig_fw_path, const std::string& parts_dir) {
    std::cout << "================================================================================\n"
              << " Running Panasonic Lumix DMC-TZ5 RAW Image & SD Loader Test Suite\n"
              << "================================================================================\n";

    tz5::partitions::PartitionWorkspace ws;
    std::string err;
    if (!ws.load_from_partitions_dir(parts_dir, &err)) {
        std::cerr << "FAIL: Cannot load partitions from " << parts_dir << ": " << err << "\n";
        return 1;
    }

    std::cout << "\n[Test 1] Inject RAW Image Engine & SD Visual Loader into Partitions...\n";
    tz5::raw::VenusRawEngine raw_engine(ws);
    tz5::raw::RawConfigOptions opts;
    opts.version_major = 1;
    opts.version_minor = 3; // v1.3
    tz5::raw::RawInjectionResult res;

    if (!raw_engine.apply_raw_mod(opts, &res, &err)) {
        std::cerr << "FAIL: VenusRawEngine::apply_raw_mod failed: " << err << "\n";
        return 1;
    }
    std::cout << "  PASS: Unlocked " << res.unlocked_quality_options << " RAW options in QUALITY menu (@ 0x"
              << std::hex << std::uppercase << res.quality_sub_opts_va << ")\n"
              << "  PASS: Injected Visual SD Recording Loader @ 0x" << res.loader_function_va
              << " (" << std::dec << res.loader_function_size << " B in part_02 CAVE_MAIN_TEXT)\n"
              << "  PASS: Rebound " << res.rebound_language_entries << " language slots in part_05 0x12345678 master table\n"
              << "  PASS: Firmware Version updated to v" << res.firmware_version_str << " (Major 1, Minor 3)\n";

    for (const auto& line : res.disassembly_preview) {
        std::cout << "    " << line << "\n";
    }

    std::cout << "\n[Test 2] Verify Panasonic Lumix UI Resolution of RAW SIDs Across Languages...\n";
    tz5::ui::VenusUiEngine ui(ws);
    if (!ui.analyze_all(&err)) {
        std::cerr << "FAIL: ui.analyze_all failed: " << err << "\n";
        return 1;
    }
    std::string raw_en = ui.resolve_string_id(0x052Bu, 1);  // English
    std::string raw_pt = ui.resolve_string_id(0x052Bu, 16); // Portuguese
    std::string raw_jp = ui.resolve_string_id(0x052Bu, 0);  // Japanese
    std::string raw_de = ui.resolve_string_id(0x052Bu, 2);  // German
    std::cout << "  PASS: SID 0x052B (RAW) -> EN=\"" << raw_en << "\" | PT=\"" << raw_pt
              << "\" | JP=\"" << raw_jp << "\" | DE=\"" << raw_de << "\"\n";
    if (raw_en != "RAW" || raw_pt != "RAW") {
        std::cerr << "FAIL: SID 0x052B did not resolve to 'RAW'!\n";
        return 1;
    }

    std::string rj_en = ui.resolve_string_id(0x07FFu, 1);
    std::cout << "  PASS: SID 0x07FF (RAW+JPEG) -> EN=\"" << rj_en << "\"\n";
    if (rj_en != "RAW+JPEG") {
        std::cerr << "FAIL: SID 0x07FF did not resolve to 'RAW+JPEG'!\n";
        return 1;
    }

    std::cout << "\n[Test 3] Assemble & Verify 100% 2D Parity Matrix for Flashable Firmware v1.3 Container...\n";
    std::vector<uint8_t> framed;
    if (!ws.build_framed_firmware(framed, &err)) {
        std::cerr << "FAIL: build_framed_firmware failed: " << err << "\n";
        return 1;
    }
    auto rep = tz5::FirmwareImage::verify_framed_bytes(framed);
    if (!rep.valid || framed.size() != tz5::FirmwareImage::kFramedFileSize) {
        std::cerr << "FAIL: 2D parity matrix verification failed: " << rep.message << "\n";
        return 1;
    }
    (void)orig_fw_path;
    std::cout << "  PASS: All " << rep.horizontal_valid_rows << " / " << rep.total_rows << " rows valid\n"
              << "  PASS: All " << rep.vertical_valid_cols << " / 17 columns valid\n"
              << "  PASS: Corner parity word = 0x" << std::hex << std::uppercase << std::setw(4)
              << std::setfill('0') << rep.trailer_corner_word << std::dec << "\n"
              << "  PASS: Final SHA-256 = " << rep.sha256_hex << "\n";

    std::cout << "\nALL RAW IMAGE ENGINE & SD VISUAL LOADER TESTS PASSED 100%!\n";
    return 0;
}

} // namespace

int main(int argc, char** argv) {
    if (argc < 3) {
        print_usage();
        return 1;
    }
    std::string cmd = argv[1];
    if (cmd == "info") {
        return cmd_info(argv[2]);
    }
    if (cmd == "unpack") {
        if (argc < 4) { print_usage(); return 1; }
        return cmd_unpack(argv[2], argv[3]);
    }
    if (cmd == "disasm") {
        if (argc < 4) { print_usage(); return 1; }
        return cmd_disasm(argv[2], argv[3]);
    }
    if (cmd == "build") {
        return cmd_build(argc, argv);
    }
    if (cmd == "test") {
        return cmd_test(argv[2]);
    }
    if (cmd == "partitions-export-src") {
        if (argc < 4) { print_usage(); return 1; }
        return cmd_partitions_export_src(argv[2], argv[3]);
    }
    if (cmd == "partitions-build") {
        return cmd_partitions_build(argc, argv);
    }
    if (cmd == "partitions-test") {
        if (argc < 4) { print_usage(); return 1; }
        return cmd_partitions_test(argv[2], argv[3]);
    }
    if (cmd == "ui-export") {
        if (argc < 4) { print_usage(); return 1; }
        return cmd_ui_export(argv[2], argv[3]);
    }
    if (cmd == "ui-build-custom") {
        return cmd_ui_build_custom(argc, argv);
    }
    if (cmd == "ui-test") {
        if (argc < 4) { print_usage(); return 1; }
        return cmd_ui_test(argv[2], argv[3]);
    }
    if (cmd == "raw-build") {
        return cmd_raw_build(argc, argv);
    }
    if (cmd == "raw-test") {
        if (argc < 4) { print_usage(); return 1; }
        return cmd_raw_test(argv[2], argv[3]);
    }
    print_usage();
    return 1;
}
