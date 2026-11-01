#pragma once

#include "tz5/firmware.hpp"

#include <cstdint>
#include <optional>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace tz5 {

struct DecodedInstruction {
    uint32_t va = 0;
    uint32_t rom_offset = 0;
    uint8_t size = 1;
    std::string mnemonic;
    std::string operands;
    std::string comment;
    std::optional<uint32_t> branch_target;
    std::optional<uint32_t> mem_or_imm_ref;
    bool is_call = false;
    bool is_return = false;
};

struct DisassemblyStats {
    size_t total_instructions = 0;
    size_t total_functions = 0;
    size_t total_call_edges = 0;
    size_t total_branch_labels = 0;
    size_t total_string_xrefs = 0;
    size_t total_mmio_xrefs = 0;
    size_t total_sdram_xrefs = 0;
    size_t custom_cave_instructions = 0;
};

class Mn103Disassembler {
public:
    explicit Mn103Disassembler(const FirmwareImage& fw);

    void add_symbol(uint32_t va, const std::string& name);
    const std::unordered_map<uint32_t, std::string>& symbols() const { return symbols_; }

    DecodedInstruction decode_one(uint32_t rom_offset) const;

    std::string disassemble_range_to_string(uint32_t start_rom_offset,
                                            uint32_t end_rom_offset,
                                            const std::string& section_title);

    bool disassemble_all_to_dir(const std::string& out_dir,
                                DisassemblyStats* out_stats = nullptr,
                                std::string* err = nullptr);

    static std::string format_reg_mask(uint8_t mask);

private:
    void run_discovery_pass(DisassemblyStats& stats);
    std::string resolve_target_label(uint32_t target_va) const;
    std::string build_ref_comment(uint32_t ref_va) const;
    std::string read_ascii_preview(uint32_t rom_offset, size_t max_len = 48) const;
    std::string read_osd_preview(uint32_t rom_offset, size_t max_chars = 36) const;

    const FirmwareImage& fw_;
    std::unordered_map<uint32_t, std::string> symbols_;
    std::unordered_set<uint32_t> function_entries_;
    std::unordered_set<uint32_t> branch_labels_;
    std::unordered_map<uint32_t, size_t> call_counts_;
};

} // namespace tz5
