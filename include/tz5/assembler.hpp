#pragma once

#include "tz5/firmware.hpp"

#include <cstdint>
#include <string>
#include <unordered_map>
#include <vector>

namespace tz5 {

class Mn103Assembler {
public:
    explicit Mn103Assembler(uint32_t base_va = 0);

    uint32_t base_va() const { return base_va_; }
    uint32_t current_va() const { return base_va_ + static_cast<uint32_t>(code_.size()); }
    const std::vector<uint8_t>& bytes() const { return code_; }

    // Low-level instruction emitters
    void nop();
    void movm_push(uint8_t mask);
    void movm_pop(uint8_t mask);
    void add_sp(int8_t imm8);

    void mov_imm8_dn(uint8_t dn, uint8_t imm8);
    void mov_imm16_dn(uint8_t dn, uint16_t imm16);
    void mov_imm32_dn(uint8_t dn, uint32_t imm32);
    void mov_imm32_an(uint8_t an, uint32_t imm32);

    void mov_dn_abs32(uint8_t dn, uint32_t addr32);
    void mov_abs32_dn(uint32_t addr32, uint8_t dn);
    void movb_dn_abs32(uint8_t dn, uint32_t addr32);
    void movbu_abs32_dn(uint32_t addr32, uint8_t dn);
    void movhu_dn_abs32(uint8_t dn, uint32_t addr32);
    void movhu_abs32_dn(uint32_t addr32, uint8_t dn);

    void add_imm8_dn(uint8_t dn, int8_t imm8);
    void add_imm32_dn(uint8_t dn, uint32_t imm32);

    void call_rel32(uint32_t target_va, uint8_t mask, uint8_t stack_disp);
    void calls_rel32(uint32_t target_va);
    void jmp_rel32(uint32_t target_va);
    void jmp_rel16(uint32_t target_va);
    void ret(uint8_t mask, uint8_t stack_disp);
    void retf(uint8_t mask, uint8_t stack_disp);
    void rets();

    // Assemble a single text instruction line using symbol lookup (e.g., "mov @my_str, a0", "jmp @orig_target")
    bool assemble_line(const std::string& line,
                       const std::unordered_map<std::string, uint32_t>& symbols,
                       std::string* err = nullptr);

private:
    void emit8(uint8_t b);
    void emit16_le(uint16_t w);
    void emit32_le(uint32_t d);

    uint32_t base_va_ = 0;
    std::vector<uint8_t> code_;
};

struct InjectedArtifact {
    std::string kind; // "ascii_string", "osd_string", "function", "call_hook", "patch"
    std::string name;
    uint32_t va = 0;
    uint32_t size = 0;
    std::string details;
};

class FeatureBuilder {
public:
    explicit FeatureBuilder(FirmwareImage& fw);

    void define_symbol(const std::string& name, uint32_t va);
    const std::unordered_map<std::string, uint32_t>& symbols() const { return symbols_; }
    const std::vector<InjectedArtifact>& artifacts() const { return artifacts_; }

    // Allocate a new null-terminated ASCII string in a code cave and register @name symbol
    bool add_ascii_string(const std::string& name,
                          const std::string& text,
                          const std::string& cave_name = "CAVE_MAIN_TEXT",
                          uint32_t* out_va = nullptr,
                          std::string* err = nullptr);

    // Allocate a new 0x0003-terminated 16-bit OSD UI string in a code cave and register @name symbol
    bool add_osd_string(const std::string& name,
                        const std::string& text,
                        const std::string& cave_name = "CAVE_MAIN_TEXT",
                        uint32_t* out_va = nullptr,
                        std::string* err = nullptr);

    // Inspect an existing call instruction (0xDD or 0xCD) at call_insn_va and register its original target as @orig_sym_name
    bool inspect_call_target(uint32_t call_insn_va,
                             const std::string& orig_sym_name,
                             uint32_t* out_orig_target_va = nullptr,
                             std::string* err = nullptr);

    // Assemble and inject a new MN103S function into a code cave and register @name symbol
    bool add_function(const std::string& name,
                      const std::vector<std::string>& asm_lines,
                      const std::string& cave_name = "CAVE_MAIN_TEXT",
                      uint32_t* out_va = nullptr,
                      std::string* err = nullptr);

    // Redirect an existing 0xDD call instruction at call_insn_va to call target_fn_name (or target_va)
    bool hook_call_site(uint32_t call_insn_va,
                        const std::string& target_fn_name,
                        std::string* err = nullptr);

    // Parse and apply a declarative JSON feature manifest file
    bool apply_manifest_file(const std::string& manifest_path, std::string* err = nullptr);

private:
    FirmwareImage& fw_;
    std::unordered_map<std::string, uint32_t> symbols_;
    std::vector<InjectedArtifact> artifacts_;
};

} // namespace tz5
