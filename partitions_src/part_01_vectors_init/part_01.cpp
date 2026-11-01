#include "part_01_vectors_init/part_01.hpp"
#include "tz5/assembler.hpp"
#include "tz5/symbols.hpp"

#include <cstdio>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5::partitions {

Part01VectorsInit::Part01VectorsInit() : bytes_(kOriginalSize, 0xFFu) {
    meta_.index = 1;
    meta_.id = "part_01_vectors_init";
    meta_.filename = "part_01_0x004000_0x0049f2.bin";
    meta_.unpacked_start = kUnpackedStart;
    meta_.unpacked_end = kUnpackedEnd;
    meta_.region_limit = kRegionLimit;
    meta_.va_start = kBaseVa;
    meta_.va_end = kBaseVa + kOriginalSize;
    meta_.original_sha256 = "93de706269e2dd0bb7d8272f76d83791013dab63e1f2a9b6a60d75778c2bcf77";
    meta_.rea_evidence_id = "ev_20a0133a9d605ff899bbf5c8f10a9173e701d5f47c5cbeebbc9c722701e0f62b";
    meta_.rea_manifest_id = "agm_d5e0a2a6a14832c020db0d772b663cd59a459ec6b4390c0a366d591e5853ffed";
    meta_.role_summary = "MN103S Hardware Reset & Interrupt Vector Table (Slots 0..9), Kernel RAM Init & Watchdog/IRQ Thunks";
}

bool Part01VectorsInit::load_from_partition_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Cannot open part_01 file: " + path;
        return false;
    }
    auto sz = static_cast<size_t>(ifs.tellg());
    if (sz < kOriginalSize || sz > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "Invalid part_01 size";
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

bool Part01VectorsInit::load_from_full_rom(std::span<const uint8_t> full_rom, std::string* err) {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "ROM too small to contain part_01";
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

std::vector<uint8_t> Part01VectorsInit::emit_partition_bytes() const {
    std::vector<uint8_t> out = bytes_;
    if (!ext_bytes_.empty()) {
        out.insert(out.end(), ext_bytes_.begin(), ext_bytes_.end());
    }
    return out;
}

bool Part01VectorsInit::write_into_full_rom(std::vector<uint8_t>& full_rom, std::string* err) const {
    if (full_rom.size() < kRegionLimit) {
        if (err) *err = "Target ROM buffer too small for part_01";
        return false;
    }
    auto emitted = emit_partition_bytes();
    if (emitted.size() > (kRegionLimit - kUnpackedStart)) {
        if (err) *err = "part_01 emitted bytes exceed 0x008000 region limit";
        return false;
    }
    std::fill(full_rom.begin() + kUnpackedStart, full_rom.begin() + kRegionLimit, 0xFFu);
    std::memcpy(full_rom.data() + kUnpackedStart, emitted.data(), emitted.size());
    return true;
}

std::span<const uint8_t> Part01VectorsInit::kernel_data_init_image() const {
    return std::span<const uint8_t>(bytes_.data() + kKernelDataRelOff, kKernelDataSize);
}

bool Part01VectorsInit::set_firmware_version(uint16_t major, uint16_t minor, std::string* err) {
    constexpr size_t kVersionRelOff = 0x0006A0u;
    if (bytes_.size() < kVersionRelOff + 20) {
        if (err) *err = "part_01 buffer too small for version descriptor";
        return false;
    }
    // Panasonic Lumix stores the camera firmware version in 16-bit BCD at 0x55C806A0:
    // e.g. v1.2 -> 0x0120 (bytes: 0x20, 0x01); v1.3 -> 0x0130; v1.4 -> 0x0140
    uint16_t min_norm = (minor < 10) ? (minor * 10) : minor;
    uint8_t maj_bcd = static_cast<uint8_t>(((major / 10) << 4) | (major % 10));
    uint8_t min_bcd = static_cast<uint8_t>(((min_norm / 10) << 4) | (min_norm % 10));

    bytes_[kVersionRelOff + 0] = min_bcd;
    bytes_[kVersionRelOff + 1] = maj_bcd;

    // Panasonic build counter rules (verified in RTOS updater sub_55D0CEFB):
    // Factory v1.2 has Word 1 = 58 (0x003A), Word 9 = 57 (0x0039).
    // Word 1 MUST be strictly greater than the installed ROM counter.
    // Rule: Word 1 == Word 9 + 1.
    uint16_t candidate_counter = 58;
    if (min_norm > 20) {
        candidate_counter = static_cast<uint16_t>(58 + (min_norm - 20) / 10);
    }
    uint16_t base_counter = static_cast<uint16_t>(candidate_counter - 1);

    bytes_[kVersionRelOff + 2] = static_cast<uint8_t>(candidate_counter & 0xFFu);
    bytes_[kVersionRelOff + 3] = static_cast<uint8_t>((candidate_counter >> 8) & 0xFFu);

    bytes_[kVersionRelOff + 18] = static_cast<uint8_t>(base_counter & 0xFFu);
    bytes_[kVersionRelOff + 19] = static_cast<uint8_t>((base_counter >> 8) & 0xFFu);

    return true;
}

bool Part01VectorsInit::redirect_irq_vector_slot(int slot_index, uint32_t new_handler_va, std::string* err) {
    if (slot_index < 3 || slot_index > 9) {
        if (err) *err = "IRQ vector slot_index must be in 3..9 (0x55C80018..0x55C80048)";
        return false;
    }
    uint32_t rel_off = static_cast<uint32_t>(slot_index * 8);
    uint32_t slot_va = kBaseVa + rel_off;
    int64_t disp64 = static_cast<int64_t>(new_handler_va) - static_cast<int64_t>(slot_va);
    auto disp32 = static_cast<int32_t>(disp64);
    uint32_t udisp = static_cast<uint32_t>(disp32);

    // Emit 5-byte relative jmp (0xDC <disp32>) + 3 zero padding bytes
    bytes_[rel_off + 0] = 0xDCu;
    bytes_[rel_off + 1] = static_cast<uint8_t>(udisp & 0xFFu);
    bytes_[rel_off + 2] = static_cast<uint8_t>((udisp >> 8) & 0xFFu);
    bytes_[rel_off + 3] = static_cast<uint8_t>((udisp >> 16) & 0xFFu);
    bytes_[rel_off + 4] = static_cast<uint8_t>((udisp >> 24) & 0xFFu);
    bytes_[rel_off + 5] = 0x00u;
    bytes_[rel_off + 6] = 0x00u;
    bytes_[rel_off + 7] = 0x00u;

    parse_structures();
    return true;
}

bool Part01VectorsInit::set_kernel_data_word(uint32_t word_index, uint32_t value, std::string* err) {
    if (word_index >= (kKernelDataSize / 4u)) {
        if (err) *err = "word_index out of range (0..10 for 44-byte kernel .data)";
        return false;
    }
    uint32_t off = kKernelDataRelOff + word_index * 4u;
    bytes_[off + 0] = static_cast<uint8_t>(value & 0xFFu);
    bytes_[off + 1] = static_cast<uint8_t>((value >> 8) & 0xFFu);
    bytes_[off + 2] = static_cast<uint8_t>((value >> 16) & 0xFFu);
    bytes_[off + 3] = static_cast<uint8_t>((value >> 24) & 0xFFu);
    return true;
}

bool Part01VectorsInit::append_custom_isr(const std::string& name,
                                          const std::vector<std::string>& asm_lines,
                                          uint32_t* out_va,
                                          std::string* err) {
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
        if (err) *err = "Insufficient space in part_01 expansion cave";
        return false;
    }
    ext_bytes_.insert(ext_bytes_.end(), as.bytes().begin(), as.bytes().end());
    if (out_va) *out_va = fn_va;
    parse_structures();
    return true;
}

void Part01VectorsInit::parse_structures() {
    vector_slots_.clear();
    subroutines_.clear();

    static constexpr const char* kSlotNames[10] = {
        "vec_hardware_reset",
        "vec_nmi_entry",
        "vec_trap_rti",
        "vec_irq_group0",
        "vec_irq_group1",
        "vec_irq_group2",
        "vec_irq_group3",
        "vec_irq_group4",
        "vec_irq_group5",
        "vec_irq_group6"
    };

    for (int s = 0; s < 10; ++s) {
        uint32_t rel = static_cast<uint32_t>(s * 8);
        if (rel + 8 > bytes_.size()) break;
        HardwareVectorSlot slot;
        slot.slot_index = s;
        slot.name = kSlotNames[s];
        slot.slot_va = kBaseVa + rel;
        std::memcpy(slot.raw_bytes.data(), bytes_.data() + rel, 8);

        if (slot.raw_bytes[0] == 0xFCu && slot.raw_bytes[1] == 0xDDu) {
            uint32_t t = static_cast<uint32_t>(slot.raw_bytes[2]) |
                         (static_cast<uint32_t>(slot.raw_bytes[3]) << 8) |
                         (static_cast<uint32_t>(slot.raw_bytes[4]) << 16) |
                         (static_cast<uint32_t>(slot.raw_bytes[5]) << 24);
            slot.target_va = t;
            char buf[96];
            std::snprintf(buf, sizeof(buf), "mov 0x%08X, a1; jmp (a1)", t);
            slot.instruction_desc = buf;
        } else if (slot.raw_bytes[0] == 0xCCu) {
            int16_t disp16 = static_cast<int16_t>(
                static_cast<uint16_t>(slot.raw_bytes[1]) |
                (static_cast<uint16_t>(slot.raw_bytes[2]) << 8));
            slot.target_va = static_cast<uint32_t>(static_cast<int64_t>(slot.slot_va) + disp16);
            char buf[64];
            std::snprintf(buf, sizeof(buf), "jmp 0x%08X", slot.target_va);
            slot.instruction_desc = buf;
        } else if (slot.raw_bytes[0] == 0xF0u && slot.raw_bytes[1] == 0xFDu) {
            slot.target_va = slot.slot_va;
            slot.instruction_desc = "rti";
        } else if (slot.raw_bytes[0] == 0xDCu) {
            int32_t disp32 = static_cast<int32_t>(
                static_cast<uint32_t>(slot.raw_bytes[1]) |
                (static_cast<uint32_t>(slot.raw_bytes[2]) << 8) |
                (static_cast<uint32_t>(slot.raw_bytes[3]) << 16) |
                (static_cast<uint32_t>(slot.raw_bytes[4]) << 24));
            slot.target_va = static_cast<uint32_t>(static_cast<int64_t>(slot.slot_va) + disp32);
            char buf[64];
            std::snprintf(buf, sizeof(buf), "jmp 0x%08X", slot.target_va);
            slot.instruction_desc = buf;
        }
        vector_slots_.push_back(slot);
    }

    subroutines_.push_back({
        0x55C80050u,
        0x004050u,
        "kernel_reset_handler",
        "void kernel_reset_handler(void)",
        "Primary CPU reset handler jumped to from Slot 0 (0x55C80000); initializes PSW/registers and calls kernel_early_ram_init.",
        "void kernel_reset_handler(void) {\n"
        "    cpu_disable_interrupts();\n"
        "    kernel_early_ram_init();\n"
        "    crt0_main_firmware_entry();\n"
        "}"
    });
    subroutines_.push_back({
        0x55C800D1u,
        0x0040D1u,
        "kernel_early_ram_init",
        "void kernel_early_ram_init(void)",
        "Zeros 74,680 bytes of kernel .bss (0x5400042C..0x540127E4) and copies 44 bytes of kernel .data from 0x55C80638 to 0x54000400.",
        "void kernel_early_ram_init(void) {\n"
        "    memset((void*)0x5400042C, 0, 0x540127E4 - 0x5400042C);\n"
        "    memcpy((void*)0x54000400, (const void*)0x55C80638, 0x2C);\n"
        "}"
    });
    subroutines_.push_back({
        0x55C80107u,
        0x004107u,
        "nmi_watchdog_handler",
        "void nmi_watchdog_handler(void)",
        "Non-maskable interrupt & watchdog exception handler branched from Slot 1 (0x55C80008).",
        "void nmi_watchdog_handler(void) {\n"
        "    VENUS_INTC_ACK = 0x03F7;\n"
        "    system_fault_halt();\n"
        "}"
    });
}

std::string Part01VectorsInit::generate_source_documentation() const {
    std::ostringstream oss;
    oss << "// ============================================================================\n"
        << "// PARTITION 01 SOURCE MODULE: " << meta_.id << "\n"
        << "// File: " << meta_.filename << " (" << bytes_.size() << " base bytes + " << ext_bytes_.size() << " ext bytes)\n"
        << "// Unpacked Flash Range : 0x004000 .. 0x0049F2 (Expansion Cave -> 0x008000)\n"
        << "// Virtual Address (VA) : 0x55C80000 .. 0x55C809F2\n"
        << "// REA Evidence ID      : " << meta_.rea_evidence_id << "\n"
        << "// ============================================================================\n\n"
        << "#include <cstdint>\n\n"
        << "namespace tz5::part01_src {\n\n"
        << "// Hardware Interrupt Vector Table (0x55C80000..0x55C8004F)\n";

    for (const auto& v : vector_slots_) {
        oss << "// Slot " << v.slot_index << " [" << v.name << "] @ VA 0x"
            << std::hex << std::uppercase << v.slot_va << " -> Target VA 0x" << v.target_va
            << " (" << v.instruction_desc << ")\n";
    }
    oss << "\n";
    for (const auto& sub : subroutines_) {
        oss << "// Function: " << sub.name << " @ VA 0x" << std::hex << sub.va << "\n"
            << "// " << sub.summary << "\n"
            << sub.pseudo_c << "\n\n";
    }
    oss << "} // namespace tz5::part01_src\n";
    return oss.str();
}

std::string Part01VectorsInit::generate_json_summary() const {
    auto emitted = emit_partition_bytes();
    std::ostringstream oss;
    oss << "{\n"
        << "  \"partition_index\": 1,\n"
        << "  \"id\": \"" << meta_.id << "\",\n"
        << "  \"va_start\": \"0x55C80000\",\n"
        << "  \"va_end\": \"0x" << std::hex << std::uppercase << (kBaseVa + emitted.size()) << std::dec << "\",\n"
        << "  \"base_size\": " << bytes_.size() << ",\n"
        << "  \"extension_size\": " << ext_bytes_.size() << ",\n"
        << "  \"free_cave_bytes\": " << (kRegionLimit - kUnpackedStart - emitted.size()) << ",\n"
        << "  \"sha256\": \"" << FirmwareImage::sha256_hex(emitted) << "\",\n"
        << "  \"rea_evidence_id\": \"" << meta_.rea_evidence_id << "\",\n"
        << "  \"vector_slot_count\": " << vector_slots_.size() << ",\n"
        << "  \"kernel_data_ram_va\": \"0x54000400\",\n"
        << "  \"kernel_data_size\": " << kKernelDataSize << ",\n"
        << "  \"kernel_bss_range\": \"0x5400042C..0x540127E4\"\n"
        << "}\n";
    return oss.str();
}

} // namespace tz5::partitions
