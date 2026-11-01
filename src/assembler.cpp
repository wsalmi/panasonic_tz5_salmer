#include "tz5/assembler.hpp"
#include "tz5/symbols.hpp"

#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>

namespace tz5 {

namespace {

std::string trim(const std::string& s) {
    size_t b = 0;
    while (b < s.size() && std::isspace(static_cast<unsigned char>(s[b]))) ++b;
    size_t e = s.size();
    while (e > b && std::isspace(static_cast<unsigned char>(s[e - 1]))) --e;
    return s.substr(b, e - b);
}

std::optional<uint8_t> parse_dreg(const std::string& tok) {
    if (tok == "d0") return 0;
    if (tok == "d1") return 1;
    if (tok == "d2") return 2;
    if (tok == "d3") return 3;
    return std::nullopt;
}

std::optional<uint8_t> parse_areg(const std::string& tok) {
    if (tok == "a0") return 0;
    if (tok == "a1") return 1;
    if (tok == "a2") return 2;
    if (tok == "a3") return 3;
    return std::nullopt;
}

uint8_t parse_reg_mask_str(const std::string& s) {
    uint8_t mask = 0;
    if (s.find("d2") != std::string::npos) mask |= 0x80u;
    if (s.find("d3") != std::string::npos) mask |= 0x40u;
    if (s.find("a2") != std::string::npos) mask |= 0x20u;
    if (s.find("a3") != std::string::npos) mask |= 0x10u;
    if (s.find("other") != std::string::npos) mask |= 0x08u;
    if (s.find("exreg0") != std::string::npos) mask |= 0x04u;
    if (s.find("exreg1") != std::string::npos) mask |= 0x02u;
    if (s.find("exother") != std::string::npos) mask |= 0x01u;
    return mask;
}

std::optional<uint32_t> resolve_val(const std::string& expr,
                                    const std::unordered_map<std::string, uint32_t>& symbols) {
    std::string t = trim(expr);
    if (t.empty()) return std::nullopt;
    if (t[0] == '@') {
        t = t.substr(1);
    }
    auto it = symbols.find(t);
    if (it != symbols.end()) {
        return it->second;
    }
    char* endp = nullptr;
    unsigned long long v = std::strtoull(t.c_str(), &endp, 0);
    if (endp && *endp == '\0') {
        return static_cast<uint32_t>(v);
    }
    return std::nullopt;
}

std::string hex32_str(uint32_t v) {
    char buf[24];
    std::snprintf(buf, sizeof(buf), "0x%08X", v);
    return buf;
}

} // namespace

Mn103Assembler::Mn103Assembler(uint32_t base_va) : base_va_(base_va) {}

void Mn103Assembler::emit8(uint8_t b) {
    code_.push_back(b);
}

void Mn103Assembler::emit16_le(uint16_t w) {
    code_.push_back(static_cast<uint8_t>(w & 0xFFu));
    code_.push_back(static_cast<uint8_t>((w >> 8) & 0xFFu));
}

void Mn103Assembler::emit32_le(uint32_t d) {
    code_.push_back(static_cast<uint8_t>(d & 0xFFu));
    code_.push_back(static_cast<uint8_t>((d >> 8) & 0xFFu));
    code_.push_back(static_cast<uint8_t>((d >> 16) & 0xFFu));
    code_.push_back(static_cast<uint8_t>((d >> 24) & 0xFFu));
}

void Mn103Assembler::nop() {
    emit8(0xCBu);
}

void Mn103Assembler::movm_push(uint8_t mask) {
    emit8(0xCFu);
    emit8(mask);
}

void Mn103Assembler::movm_pop(uint8_t mask) {
    emit8(0xCEu);
    emit8(mask);
}

void Mn103Assembler::add_sp(int8_t imm8) {
    emit8(0xF8u);
    emit8(0xFEu);
    emit8(static_cast<uint8_t>(imm8));
}

void Mn103Assembler::mov_imm8_dn(uint8_t dn, uint8_t imm8) {
    emit8(static_cast<uint8_t>(0x80u + (dn & 3u)));
    emit8(imm8);
}

void Mn103Assembler::mov_imm16_dn(uint8_t dn, uint16_t imm16) {
    emit8(static_cast<uint8_t>(0x2Cu + (dn & 3u)));
    emit16_le(imm16);
}

void Mn103Assembler::mov_imm32_dn(uint8_t dn, uint32_t imm32) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0xCCu + (dn & 3u)));
    emit32_le(imm32);
}

void Mn103Assembler::mov_imm32_an(uint8_t an, uint32_t imm32) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0xDCu + (an & 3u)));
    emit32_le(imm32);
}

void Mn103Assembler::mov_dn_abs32(uint8_t dn, uint32_t addr32) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0x80u + (dn & 3u)));
    emit32_le(addr32);
}

void Mn103Assembler::mov_abs32_dn(uint32_t addr32, uint8_t dn) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0xA0u + (dn & 3u)));
    emit32_le(addr32);
}

void Mn103Assembler::movb_dn_abs32(uint8_t dn, uint32_t addr32) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0x84u + (dn & 3u)));
    emit32_le(addr32);
}

void Mn103Assembler::movbu_abs32_dn(uint32_t addr32, uint8_t dn) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0xA4u + (dn & 3u)));
    emit32_le(addr32);
}

void Mn103Assembler::movhu_dn_abs32(uint8_t dn, uint32_t addr32) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0x88u + (dn & 3u)));
    emit32_le(addr32);
}

void Mn103Assembler::movhu_abs32_dn(uint32_t addr32, uint8_t dn) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0xACu + (dn & 3u)));
    emit32_le(addr32);
}

void Mn103Assembler::add_imm8_dn(uint8_t dn, int8_t imm8) {
    emit8(static_cast<uint8_t>(0x20u + (dn & 3u)));
    emit8(static_cast<uint8_t>(imm8));
}

void Mn103Assembler::add_imm32_dn(uint8_t dn, uint32_t imm32) {
    emit8(0xFCu);
    emit8(static_cast<uint8_t>(0xD0u + (dn & 3u)));
    emit32_le(imm32);
}

void Mn103Assembler::call_rel32(uint32_t target_va, uint8_t mask, uint8_t stack_disp) {
    uint32_t pc = current_va();
    auto disp32 = static_cast<uint32_t>(static_cast<int32_t>(target_va - pc));
    emit8(0xDDu);
    emit32_le(disp32);
    emit8(mask);
    emit8(stack_disp);
}

void Mn103Assembler::calls_rel32(uint32_t target_va) {
    uint32_t pc = current_va();
    auto disp32 = static_cast<uint32_t>(static_cast<int32_t>(target_va - pc));
    emit8(0xFCu);
    emit8(0xFFu);
    emit32_le(disp32);
}

void Mn103Assembler::jmp_rel32(uint32_t target_va) {
    uint32_t pc = current_va();
    auto disp32 = static_cast<uint32_t>(static_cast<int32_t>(target_va - pc));
    emit8(0xDCu);
    emit32_le(disp32);
}

void Mn103Assembler::jmp_rel16(uint32_t target_va) {
    uint32_t pc = current_va();
    auto disp16 = static_cast<uint16_t>(static_cast<int16_t>(target_va - pc));
    emit8(0xCCu);
    emit16_le(disp16);
}

void Mn103Assembler::ret(uint8_t mask, uint8_t stack_disp) {
    emit8(0xDFu);
    emit8(mask);
    emit8(stack_disp);
}

void Mn103Assembler::retf(uint8_t mask, uint8_t stack_disp) {
    emit8(0xDEu);
    emit8(mask);
    emit8(stack_disp);
}

void Mn103Assembler::rets() {
    emit8(0xF0u);
    emit8(0xFCu);
}

bool Mn103Assembler::assemble_line(const std::string& raw_line,
                                   const std::unordered_map<std::string, uint32_t>& symbols,
                                   std::string* err) {
    std::string line = raw_line;
    auto semi = line.find(';');
    if (semi != std::string::npos) {
        line = line.substr(0, semi);
    }
    line = trim(line);
    if (line.empty()) return true;

    std::string op;
    std::string rest;
    {
        size_t sp = 0;
        while (sp < line.size() && !std::isspace(static_cast<unsigned char>(line[sp]))) ++sp;
        op = line.substr(0, sp);
        rest = (sp < line.size()) ? trim(line.substr(sp)) : "";
    }

    if (op == "nop") {
        nop();
        return true;
    }
    if (op == "rets") {
        rets();
        return true;
    }
    if (op == "jmp") {
        auto target = resolve_val(rest, symbols);
        if (!target) {
            if (err) *err = "Unresolved jmp target: " + rest;
            return false;
        }
        jmp_rel32(*target);
        return true;
    }
    if (op == "calls") {
        auto target = resolve_val(rest, symbols);
        if (!target) {
            if (err) *err = "Unresolved calls target: " + rest;
            return false;
        }
        calls_rel32(*target);
        return true;
    }
    if (op == "call") {
        // Format: call <target>, [regs], <stack_disp>
        auto c1 = rest.find(',');
        auto b_end = rest.find(']');
        if (c1 == std::string::npos || b_end == std::string::npos) {
            if (err) *err = "Invalid call syntax (expected: call target, [regs], imm8): " + raw_line;
            return false;
        }
        std::string target_str = trim(rest.substr(0, c1));
        std::string mask_str = rest.substr(c1 + 1, b_end - c1);
        auto c2 = rest.find(',', b_end);
        uint8_t stack_disp = 0;
        if (c2 != std::string::npos) {
            stack_disp = static_cast<uint8_t>(std::strtoul(trim(rest.substr(c2 + 1)).c_str(), nullptr, 0));
        }
        auto target = resolve_val(target_str, symbols);
        if (!target) {
            if (err) *err = "Unresolved call target: " + target_str;
            return false;
        }
        call_rel32(*target, parse_reg_mask_str(mask_str), stack_disp);
        return true;
    }
    if (op == "ret" || op == "retf") {
        auto b_end = rest.find(']');
        if (b_end == std::string::npos) {
            if (err) *err = "Invalid ret syntax (expected: ret [regs], imm8): " + raw_line;
            return false;
        }
        std::string mask_str = rest.substr(0, b_end + 1);
        auto c2 = rest.find(',', b_end);
        uint8_t stack_disp = 0;
        if (c2 != std::string::npos) {
            stack_disp = static_cast<uint8_t>(std::strtoul(trim(rest.substr(c2 + 1)).c_str(), nullptr, 0));
        }
        if (op == "ret") {
            ret(parse_reg_mask_str(mask_str), stack_disp);
        } else {
            retf(parse_reg_mask_str(mask_str), stack_disp);
        }
        return true;
    }
    if (op == "movm") {
        if (rest.find("(sp),") == 0) {
            movm_pop(parse_reg_mask_str(rest));
            return true;
        }
        movm_push(parse_reg_mask_str(rest));
        return true;
    }
    if (op == "add") {
        auto comma = rest.find(',');
        if (comma == std::string::npos) {
            if (err) *err = "Invalid add syntax: " + raw_line;
            return false;
        }
        std::string lhs = trim(rest.substr(0, comma));
        std::string rhs = trim(rest.substr(comma + 1));
        if (rhs == "sp") {
            int val = static_cast<int>(std::strtol(lhs.c_str(), nullptr, 0));
            add_sp(static_cast<int8_t>(val));
            return true;
        }
        auto dn = parse_dreg(rhs);
        auto val = resolve_val(lhs, symbols);
        if (dn && val) {
            int32_t sval = static_cast<int32_t>(*val);
            if (sval >= -128 && sval <= 127) {
                add_imm8_dn(*dn, static_cast<int8_t>(sval));
            } else {
                add_imm32_dn(*dn, *val);
            }
            return true;
        }
    }
    if (op == "mov" || op == "movb" || op == "movbu" || op == "movhu") {
        auto comma = rest.find(',');
        if (comma == std::string::npos) {
            if (err) *err = "Invalid mov syntax: " + raw_line;
            return false;
        }
        std::string src = trim(rest.substr(0, comma));
        std::string dst = trim(rest.substr(comma + 1));

        // Case 1: mov (addr32), dn
        if (src.size() > 2 && src.front() == '(' && src.back() == ')') {
            auto addr = resolve_val(src.substr(1, src.size() - 2), symbols);
            auto dn = parse_dreg(dst);
            if (addr && dn) {
                if (op == "movbu" || op == "movb") movbu_abs32_dn(*addr, *dn);
                else if (op == "movhu") movhu_abs32_dn(*addr, *dn);
                else mov_abs32_dn(*addr, *dn);
                return true;
            }
        }
        // Case 2: mov dn, (addr32)
        if (dst.size() > 2 && dst.front() == '(' && dst.back() == ')') {
            auto dn = parse_dreg(src);
            auto addr = resolve_val(dst.substr(1, dst.size() - 2), symbols);
            if (dn && addr) {
                if (op == "movb" || op == "movbu") movb_dn_abs32(*dn, *addr);
                else if (op == "movhu") movhu_dn_abs32(*dn, *addr);
                else mov_dn_abs32(*dn, *addr);
                return true;
            }
        }
        // Case 3: mov imm32/@sym, dn or an
        auto imm = resolve_val(src, symbols);
        if (imm) {
            if (auto dn = parse_dreg(dst)) {
                mov_imm32_dn(*dn, *imm);
                return true;
            }
            if (auto an = parse_areg(dst)) {
                mov_imm32_an(*an, *imm);
                return true;
            }
        }
    }

    if (err) *err = "Unsupported MN103S assembly instruction: " + raw_line;
    return false;
}

FeatureBuilder::FeatureBuilder(FirmwareImage& fw) : fw_(fw) {
    for (const auto& [va, name] : get_default_code_symbols()) {
        symbols_[name] = va;
    }
}

void FeatureBuilder::define_symbol(const std::string& name, uint32_t va) {
    symbols_[name] = va;
}

bool FeatureBuilder::add_ascii_string(const std::string& name,
                                      const std::string& text,
                                      const std::string& cave_name,
                                      uint32_t* out_va,
                                      std::string* err) {
    size_t sz = text.size() + 1;
    auto va_opt = fw_.allocate_in_cave(cave_name, sz, 4, err);
    if (!va_opt) return false;

    if (!fw_.patch_ascii(*va_opt, text, true, err)) return false;
    symbols_[name] = *va_opt;
    if (out_va) *out_va = *va_opt;

    artifacts_.push_back(InjectedArtifact{
        "ascii_string", name, *va_opt, static_cast<uint32_t>(sz), "\"" + text + "\" in " + cave_name
    });
    return true;
}

bool FeatureBuilder::add_osd_string(const std::string& name,
                                    const std::string& text,
                                    const std::string& cave_name,
                                    uint32_t* out_va,
                                    std::string* err) {
    size_t sz = (text.size() + 1) * 2;
    auto va_opt = fw_.allocate_in_cave(cave_name, sz, 4, err);
    if (!va_opt) return false;

    if (!fw_.patch_osd_string(*va_opt, text, err)) return false;
    symbols_[name] = *va_opt;
    if (out_va) *out_va = *va_opt;

    artifacts_.push_back(InjectedArtifact{
        "osd_string", name, *va_opt, static_cast<uint32_t>(sz), "OSD \"" + text + "\" (0x0003 term) in " + cave_name
    });
    return true;
}

bool FeatureBuilder::inspect_call_target(uint32_t call_insn_va,
                                         const std::string& orig_sym_name,
                                         uint32_t* out_orig_target_va,
                                         std::string* err) {
    auto off_opt = FirmwareImage::resolve_to_rom_offset(call_insn_va);
    if (!off_opt) {
        if (err) *err = "Call site address out of ROM range: " + hex32_str(call_insn_va);
        return false;
    }
    uint32_t off = *off_opt;
    uint8_t op = fw_.read_u8(off);
    uint32_t orig_target = 0;
    if (op == 0xDDu) {
        int32_t disp32 = fw_.read_i32_le(off + 1);
        orig_target = static_cast<uint32_t>(static_cast<int64_t>(call_insn_va) + disp32);
    } else if (op == 0xCDu) {
        int16_t disp16 = fw_.read_i16_le(off + 1);
        orig_target = static_cast<uint32_t>(static_cast<int64_t>(call_insn_va) + disp16);
    } else {
        if (err) *err = "Instruction at " + hex32_str(call_insn_va) + " is not a call (0xDD/0xCD)";
        return false;
    }
    symbols_[orig_sym_name] = orig_target;
    if (out_orig_target_va) *out_orig_target_va = orig_target;
    return true;
}

bool FeatureBuilder::add_function(const std::string& name,
                                  const std::vector<std::string>& asm_lines,
                                  const std::string& cave_name,
                                  uint32_t* out_va,
                                  std::string* err) {
    // First determine next 4-byte aligned VA in cave_name without consuming yet
    uint32_t preview_va = 0;
    for (const auto& c : fw_.code_caves()) {
        if (c.name == cave_name) {
            uint32_t aligned = c.used;
            uint32_t rem = (c.va + aligned) % 4u;
            if (rem != 0) aligned += (4u - rem);
            preview_va = c.va + aligned;
            break;
        }
    }
    if (preview_va == 0) {
        if (err) *err = "Unknown code cave: " + cave_name;
        return false;
    }

    Mn103Assembler as(preview_va);
    for (const auto& line : asm_lines) {
        if (!as.assemble_line(line, symbols_, err)) {
            return false;
        }
    }

    const auto& bytes = as.bytes();
    auto va_opt = fw_.allocate_in_cave(cave_name, bytes.size(), 4, err);
    if (!va_opt || *va_opt != preview_va) {
        if (err && err->empty()) *err = "Failed to allocate code cave space for function " + name;
        return false;
    }

    if (!fw_.patch_bytes(*va_opt, bytes, err)) return false;
    symbols_[name] = *va_opt;
    if (out_va) *out_va = *va_opt;

    artifacts_.push_back(InjectedArtifact{
        "function", name, *va_opt, static_cast<uint32_t>(bytes.size()),
        "MN103S native function (" + std::to_string(asm_lines.size()) + " insns) in " + cave_name
    });
    return true;
}

bool FeatureBuilder::hook_call_site(uint32_t call_insn_va,
                                    const std::string& target_fn_name,
                                    std::string* err) {
    auto off_opt = FirmwareImage::resolve_to_rom_offset(call_insn_va);
    if (!off_opt) {
        if (err) *err = "Hook call site out of ROM range: " + hex32_str(call_insn_va);
        return false;
    }
    auto target_opt = resolve_val(target_fn_name, symbols_);
    if (!target_opt) {
        if (err) *err = "Unknown hook target symbol: " + target_fn_name;
        return false;
    }
    uint32_t off = *off_opt;
    uint8_t op = fw_.read_u8(off);
    if (op != 0xDDu) {
        if (err) *err = "Hook site at " + hex32_str(call_insn_va) + " must be a 32-bit call (0xDD)";
        return false;
    }
    int32_t old_disp = fw_.read_i32_le(off + 1);
    uint32_t old_target = static_cast<uint32_t>(static_cast<int64_t>(call_insn_va) + old_disp);
    uint32_t new_disp = static_cast<uint32_t>(static_cast<int32_t>(*target_opt - call_insn_va));

    if (!fw_.patch_u32_le(off + 1, new_disp, err)) return false;

    artifacts_.push_back(InjectedArtifact{
        "call_hook", target_fn_name, call_insn_va, 7u,
        "Redirected call at " + hex32_str(call_insn_va) + " from " + hex32_str(old_target) + " -> " + hex32_str(*target_opt)
    });
    return true;
}

namespace {

// Minimal zero-dependency parser for our structured JSON feature manifest
std::string extract_json_string(const std::string& obj, const std::string& key) {
    std::string pat = "\"" + key + "\"";
    auto pos = obj.find(pat);
    if (pos == std::string::npos) return {};
    auto colon = obj.find(':', pos + pat.size());
    if (colon == std::string::npos) return {};
    auto q1 = obj.find('"', colon + 1);
    if (q1 == std::string::npos) return {};
    std::string out;
    for (size_t i = q1 + 1; i < obj.size(); ++i) {
        if (obj[i] == '\\' && i + 1 < obj.size()) {
            out.push_back(obj[i + 1]);
            ++i;
        } else if (obj[i] == '"') {
            return out;
        } else {
            out.push_back(obj[i]);
        }
    }
    return out;
}

std::vector<std::string> extract_json_string_array(const std::string& obj, const std::string& key) {
    std::vector<std::string> res;
    std::string pat = "\"" + key + "\"";
    auto pos = obj.find(pat);
    if (pos == std::string::npos) return res;
    auto b1 = obj.find('[', pos + pat.size());
    auto b2 = obj.find(']', b1);
    if (b1 == std::string::npos || b2 == std::string::npos) return res;
    std::string arr = obj.substr(b1 + 1, b2 - b1 - 1);
    size_t i = 0;
    while (i < arr.size()) {
        auto q1 = arr.find('"', i);
        if (q1 == std::string::npos) break;
        std::string item;
        size_t j = q1 + 1;
        for (; j < arr.size(); ++j) {
            if (arr[j] == '\\' && j + 1 < arr.size()) {
                item.push_back(arr[j + 1]);
                ++j;
            } else if (arr[j] == '"') {
                break;
            } else {
                item.push_back(arr[j]);
            }
        }
        res.push_back(item);
        i = j + 1;
    }
    return res;
}

std::vector<std::string> extract_json_object_array(const std::string& json, const std::string& array_key) {
    std::vector<std::string> objs;
    std::string pat = "\"" + array_key + "\"";
    auto pos = json.find(pat);
    if (pos == std::string::npos) return objs;
    auto b1 = json.find('[', pos + pat.size());
    if (b1 == std::string::npos) return objs;

    int bracket_depth = 1;
    int brace_depth = 0;
    size_t obj_start = 0;
    bool in_str = false;
    for (size_t i = b1 + 1; i < json.size() && bracket_depth > 0; ++i) {
        char c = json[i];
        if (c == '\\' && in_str) {
            ++i;
            continue;
        }
        if (c == '"') {
            in_str = !in_str;
            continue;
        }
        if (in_str) continue;
        if (c == '[') bracket_depth++;
        else if (c == ']') bracket_depth--;
        else if (c == '{') {
            if (brace_depth == 0) obj_start = i;
            brace_depth++;
        } else if (c == '}') {
            brace_depth--;
            if (brace_depth == 0) {
                objs.push_back(json.substr(obj_start, i - obj_start + 1));
            }
        }
    }
    return objs;
}

} // namespace

bool FeatureBuilder::apply_manifest_file(const std::string& manifest_path, std::string* err) {
    std::ifstream ifs(manifest_path);
    if (!ifs) {
        if (err) *err = "Failed to open feature manifest: " + manifest_path;
        return false;
    }
    std::ostringstream ss;
    ss << ifs.rdbuf();
    const std::string json = ss.str();

    // 1. Optional version override: "version": "1.99"
    std::string ver = extract_json_string(json, "version");
    if (!ver.empty()) {
        auto dot = ver.find('.');
        if (dot != std::string::npos) {
            uint16_t maj = static_cast<uint16_t>(std::strtoul(ver.substr(0, dot).c_str(), nullptr, 10));
            uint16_t min = static_cast<uint16_t>(std::strtoul(ver.substr(dot + 1).c_str(), nullptr, 10));
            if (!fw_.set_firmware_version(maj, min, err)) return false;
            artifacts_.push_back(InjectedArtifact{
                "patch", "firmware_version", 0x55C84008u, 4u,
                "Updated Pana header version to " + std::to_string(maj) + "." + std::to_string(min)
            });
        }
    }

    // 2. Define symbols / inspect original call targets first
    for (const auto& obj : extract_json_object_array(json, "symbols")) {
        std::string name = extract_json_string(obj, "name");
        std::string va_s = extract_json_string(obj, "va");
        if (!name.empty() && !va_s.empty()) {
            uint32_t va = static_cast<uint32_t>(std::strtoul(va_s.c_str(), nullptr, 0));
            define_symbol(name, va);
        }
    }

    // 3. Allocate custom strings (ASCII or OSD 16-bit) in code caves
    for (const auto& obj : extract_json_object_array(json, "cave_strings")) {
        std::string name = extract_json_string(obj, "name");
        std::string text = extract_json_string(obj, "text");
        std::string kind = extract_json_string(obj, "encoding");
        std::string cave = extract_json_string(obj, "cave");
        if (cave.empty()) cave = "CAVE_MAIN_TEXT";
        if (kind == "osd16") {
            if (!add_osd_string(name, text, cave, nullptr, err)) return false;
        } else {
            if (!add_ascii_string(name, text, cave, nullptr, err)) return false;
        }
    }

    // 4. Inspect call hooks before assembling functions so @orig_<fn> symbols are available
    auto hooks = extract_json_object_array(json, "call_hooks");
    for (const auto& obj : hooks) {
        std::string site_s = extract_json_string(obj, "call_va");
        std::string orig_sym = extract_json_string(obj, "save_orig_as");
        if (!site_s.empty() && !orig_sym.empty()) {
            uint32_t site_va = static_cast<uint32_t>(std::strtoul(site_s.c_str(), nullptr, 0));
            if (!inspect_call_target(site_va, orig_sym, nullptr, err)) return false;
        }
    }

    // 5. Assemble and inject new MN103S functions into code caves
    for (const auto& obj : extract_json_object_array(json, "cave_functions")) {
        std::string name = extract_json_string(obj, "name");
        std::string cave = extract_json_string(obj, "cave");
        if (cave.empty()) cave = "CAVE_MAIN_TEXT";
        auto lines = extract_json_string_array(obj, "asm");
        if (!add_function(name, lines, cave, nullptr, err)) return false;
    }

    // 6. Apply call hooks
    for (const auto& obj : hooks) {
        std::string site_s = extract_json_string(obj, "call_va");
        std::string target_fn = extract_json_string(obj, "target");
        uint32_t site_va = static_cast<uint32_t>(std::strtoul(site_s.c_str(), nullptr, 0));
        if (!hook_call_site(site_va, target_fn, err)) return false;
    }

    // 7. Apply direct patches (in-place ASCII orOSD strings)
    for (const auto& obj : extract_json_object_array(json, "patches")) {
        std::string addr_s = extract_json_string(obj, "va");
        std::string kind = extract_json_string(obj, "kind");
        std::string val = extract_json_string(obj, "value");
        uint32_t addr = static_cast<uint32_t>(std::strtoul(addr_s.c_str(), nullptr, 0));
        if (kind == "osd16") {
            if (!fw_.patch_osd_string(addr, val, err)) return false;
            artifacts_.push_back(InjectedArtifact{
                "patch", "osd16_patch", addr, static_cast<uint32_t>((val.size() + 1) * 2),
                "Patched OSD string at " + hex32_str(addr) + " -> \"" + val + "\""
            });
        } else if (kind == "ascii") {
            if (!fw_.patch_ascii(addr, val, false, err)) return false;
            artifacts_.push_back(InjectedArtifact{
                "patch", "ascii_patch", addr, static_cast<uint32_t>(val.size()),
                "Patched ASCII string at " + hex32_str(addr) + " -> \"" + val + "\""
            });
        }
    }

    return true;
}

} // namespace tz5
