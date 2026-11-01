#include "tz5/firmware.hpp"

#include <array>
#include <cstdio>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace tz5 {

namespace {

constexpr std::array<uint32_t, 64> kSha256K = {
    0x428a2f98u, 0x71374491u, 0xb5c0fbcfu, 0xe9b5dba5u, 0x3956c25bu, 0x59f111f1u, 0x923f82a4u, 0xab1c5ed5u,
    0xd807aa98u, 0x12835b01u, 0x243185beu, 0x550c7dc3u, 0x72be5d74u, 0x80deb1feu, 0x9bdc06a7u, 0xc19bf174u,
    0xe49b69c1u, 0xefbe4786u, 0x0fc19dc6u, 0x240ca1ccu, 0x2de92c6fu, 0x4a7484aau, 0x5cb0a9dcu, 0x76f988dau,
    0x983e5152u, 0xa831c66du, 0xb00327c8u, 0xbf597fc7u, 0xc6e00bf3u, 0xd5a79147u, 0x06ca6351u, 0x14292967u,
    0x27b70a85u, 0x2e1b2138u, 0x4d2c6dfcu, 0x53380d13u, 0x650a7354u, 0x766a0abbu, 0x81c2c92eu, 0x92722c85u,
    0xa2bfe8a1u, 0xa81a664bu, 0xc24b8b70u, 0xc76c51a3u, 0xd192e819u, 0xd6990624u, 0xf40e3585u, 0x106aa070u,
    0x19a4c116u, 0x1e376c08u, 0x2748774cu, 0x34b0bcb5u, 0x391c0cb3u, 0x4ed8aa4au, 0x5b9cca4fu, 0x682e6ff3u,
    0x748f82eeu, 0x78a5636fu, 0x84c87814u, 0x8cc70208u, 0x90befffau, 0xa4506cebu, 0xbef9a3f7u, 0xc67178f2u
};

inline uint32_t rotr32(uint32_t x, uint32_t n) {
    return (x >> n) | (x << (32u - n));
}

} // namespace

FirmwareImage::FirmwareImage() : rom_(kRomPayloadSize, 0xFFu) {
    init_default_caves();
}

void FirmwareImage::init_default_caves() {
    caves_.clear();
    caves_.push_back(CodeCave{
        "CAVE_CRT0",
        0x0001F080u,
        kRomBaseVa + 0x0001F080u,
        0x00020000u - 0x0001F080u,
        0u,
        "Early CRT0 flash gap (3,968 B)"
    });
    caves_.push_back(CodeCave{
        "CAVE_MAIN_TEXT",
        0x0021F430u,
        kRomBaseVa + 0x0021F430u,
        0x00224000u - 0x0021F430u,
        0u,
        "Primary XIP feature cave immediately after .text/.rodata (19,408 B)"
    });
    caves_.push_back(CodeCave{
        "CAVE_UPPER_ROM",
        0x0031F120u,
        kRomBaseVa + 0x0031F120u,
        0x0036B800u - 0x0031F120u,
        0u,
        "Large upper XIP ROM cave after OSD UI partition (313,056 B)"
    });
    caves_.push_back(CodeCave{
        "CAVE_TAIL_ROM",
        0x00480F10u,
        kRomBaseVa + 0x00480F10u,
        0x00484000u - 0x00480F10u,
        0u,
        "Tail ROM cave before vertical column-parity trailer (12,528 B)"
    });
}

bool FirmwareImage::load_from_file(const std::string& path, std::string* err) {
    std::ifstream ifs(path, std::ios::binary | std::ios::ate);
    if (!ifs) {
        if (err) *err = "Failed to open firmware file: " + path;
        return false;
    }
    const auto sz = static_cast<size_t>(ifs.tellg());
    ifs.seekg(0, std::ios::beg);
    std::vector<uint8_t> buf(sz);
    if (!ifs.read(reinterpret_cast<char*>(buf.data()), static_cast<std::streamsize>(sz))) {
        if (err) *err = "Failed to read firmware file: " + path;
        return false;
    }
    return load_from_bytes(buf, err);
}

bool FirmwareImage::load_from_bytes(std::span<const uint8_t> data, std::string* err) {
    if (data.size() == kFramedFileSize) {
        VerifyReport rep = verify_framed_bytes(data);
        if (!rep.valid) {
            if (err) *err = "Framed firmware checksum verification failed: " + rep.message;
            return false;
        }
        rom_ = unpack_framed_to_rom(data);
        init_default_caves();
        return true;
    }
    if (data.size() == kRomPayloadSize || data.size() == kUnpackedWithTrailerSize) {
        rom_.assign(data.begin(), data.begin() + static_cast<std::ptrdiff_t>(kRomPayloadSize));
        init_default_caves();
        return true;
    }
    if (err) {
        std::ostringstream oss;
        oss << "Unsupported firmware size: " << data.size() << " bytes (expected "
            << kFramedFileSize << " framed or " << kRomPayloadSize << " unpacked)";
        *err = oss.str();
    }
    return false;
}

VerifyReport FirmwareImage::verify_framed_bytes(std::span<const uint8_t> framed_data) {
    VerifyReport rep;
    rep.sha256_hex = sha256_hex(framed_data);
    if (framed_data.size() != kFramedFileSize) {
        std::ostringstream oss;
        oss << "Invalid framed size " << framed_data.size() << " (expected " << kFramedFileSize << ")";
        rep.message = oss.str();
        return rep;
    }

    rep.total_rows = kTotalRows;
    std::array<uint32_t, 17> col_sums{};
    col_sums.fill(0);

    for (size_t r = 0; r < kTotalRows; ++r) {
        const uint8_t* rec = framed_data.data() + r * kRecordSize;
        uint32_t row_sum = 0;
        for (size_t c = 0; c < 17; ++c) {
            uint16_t w = (static_cast<uint16_t>(rec[c * 2]) << 8) | static_cast<uint16_t>(rec[c * 2 + 1]);
            row_sum += w;
            col_sums[c] += w;
        }
        if ((row_sum & 0xFFFFu) == 0u) {
            rep.horizontal_valid_rows++;
        } else {
            rep.horizontal_bad_rows++;
            if (rep.first_bad_row < 0) {
                rep.first_bad_row = static_cast<int64_t>(r);
            }
        }
    }

    for (size_t c = 0; c < 17; ++c) {
        if ((col_sums[c] & 0xFFFFu) == 0u) {
            rep.vertical_valid_cols++;
        } else {
            rep.vertical_bad_cols++;
        }
    }

    const uint8_t* last_rec = framed_data.data() + (kTotalRows - 1) * kRecordSize;
    rep.trailer_corner_word = (static_cast<uint16_t>(last_rec[32]) << 8) | static_cast<uint16_t>(last_rec[33]);

    rep.valid = (rep.horizontal_bad_rows == 0 && rep.vertical_bad_cols == 0);
    if (rep.valid) {
        rep.message = "100% valid 2D zero-sum matrix (147,969 horizontal rows x 17 vertical columns)";
    } else {
        std::ostringstream oss;
        oss << "Horizontal bad rows: " << rep.horizontal_bad_rows
            << ", Vertical bad cols: " << rep.vertical_bad_cols;
        rep.message = oss.str();
    }
    return rep;
}

std::vector<uint8_t> FirmwareImage::unpack_framed_to_rom(std::span<const uint8_t> framed_data,
                                                         std::vector<uint8_t>* out_trailer32) {
    std::vector<uint8_t> rom(kRomPayloadSize, 0xFFu);
    if (framed_data.size() < kFramedFileSize) {
        return rom;
    }
    for (size_t r = 0; r < kPayloadRows; ++r) {
        std::memcpy(rom.data() + r * kRecordPayloadSize,
                    framed_data.data() + r * kRecordSize,
                    kRecordPayloadSize);
    }
    if (out_trailer32) {
        out_trailer32->resize(kRecordPayloadSize);
        std::memcpy(out_trailer32->data(),
                    framed_data.data() + kPayloadRows * kRecordSize,
                    kRecordPayloadSize);
    }
    return rom;
}

std::vector<uint8_t> FirmwareImage::build_framed_bytes(std::vector<uint8_t>* out_trailer32) const {
    std::vector<uint8_t> framed(kFramedFileSize, 0u);
    std::array<uint32_t, 16> col_accum{};
    col_accum.fill(0u);

    // 1. Emit rows 0 .. 147,967 with their 2-byte horizontal checksums, accumulating vertical column sums
    for (size_t r = 0; r < kPayloadRows; ++r) {
        const uint8_t* src = rom_.data() + r * kRecordPayloadSize;
        uint8_t* dst = framed.data() + r * kRecordSize;
        std::memcpy(dst, src, kRecordPayloadSize);

        uint32_t row_sum = 0;
        for (size_t c = 0; c < 16; ++c) {
            uint16_t w = (static_cast<uint16_t>(src[c * 2]) << 8) | static_cast<uint16_t>(src[c * 2 + 1]);
            row_sum += w;
            col_accum[c] += w;
        }
        uint16_t row_chk = static_cast<uint16_t>((-static_cast<int32_t>(row_sum)) & 0xFFFF);
        dst[32] = static_cast<uint8_t>((row_chk >> 8) & 0xFFu);
        dst[33] = static_cast<uint8_t>(row_chk & 0xFFu);
    }

    // 2. Compute Row 147,968 (the 32-byte vertical column-parity trailer at unpacked 0x484000..0x484020)
    uint8_t* trailer_dst = framed.data() + kPayloadRows * kRecordSize;
    uint32_t trailer_row_sum = 0;
    for (size_t c = 0; c < 16; ++c) {
        uint16_t col_chk = static_cast<uint16_t>((-static_cast<int32_t>(col_accum[c])) & 0xFFFF);
        trailer_dst[c * 2]     = static_cast<uint8_t>((col_chk >> 8) & 0xFFu);
        trailer_dst[c * 2 + 1] = static_cast<uint8_t>(col_chk & 0xFFu);
        trailer_row_sum += col_chk;
    }
    uint16_t corner_chk = static_cast<uint16_t>((-static_cast<int32_t>(trailer_row_sum)) & 0xFFFF);
    trailer_dst[32] = static_cast<uint8_t>((corner_chk >> 8) & 0xFFu);
    trailer_dst[33] = static_cast<uint8_t>(corner_chk & 0xFFu);

    if (out_trailer32) {
        out_trailer32->assign(trailer_dst, trailer_dst + kRecordPayloadSize);
    }
    return framed;
}

bool FirmwareImage::save_framed_to_file(const std::string& path, std::string* err) const {
    auto framed = build_framed_bytes();
    std::ofstream ofs(path, std::ios::binary | std::ios::trunc);
    if (!ofs) {
        if (err) *err = "Failed to open output file for writing: " + path;
        return false;
    }
    if (!ofs.write(reinterpret_cast<const char*>(framed.data()), static_cast<std::streamsize>(framed.size()))) {
        if (err) *err = "Failed to write framed firmware to: " + path;
        return false;
    }
    return true;
}

bool FirmwareImage::save_unpacked_to_file(const std::string& path, bool include_trailer, std::string* err) const {
    std::vector<uint8_t> trailer32;
    if (include_trailer) {
        (void)build_framed_bytes(&trailer32);
    }
    std::ofstream ofs(path, std::ios::binary | std::ios::trunc);
    if (!ofs) {
        if (err) *err = "Failed to open unpacked output file: " + path;
        return false;
    }
    if (!ofs.write(reinterpret_cast<const char*>(rom_.data()), static_cast<std::streamsize>(rom_.size()))) {
        if (err) *err = "Failed to write ROM payload to: " + path;
        return false;
    }
    if (include_trailer && !ofs.write(reinterpret_cast<const char*>(trailer32.data()), static_cast<std::streamsize>(trailer32.size()))) {
        if (err) *err = "Failed to write 32B trailer to: " + path;
        return false;
    }
    return true;
}

std::optional<uint32_t> FirmwareImage::resolve_to_rom_offset(uint32_t va_or_offset) {
    if (va_or_offset < kRomPayloadSize) {
        return va_or_offset;
    }
    if (va_or_offset >= kRomBaseVa && va_or_offset < kRomEndVa) {
        return va_or_offset - kRomBaseVa;
    }
    if (va_or_offset >= kDataRamVa && va_or_offset < (kDataRamVa + kDataSize)) {
        return kDataRomOff + (va_or_offset - kDataRamVa);
    }
    return std::nullopt;
}

uint8_t FirmwareImage::read_u8(uint32_t rom_offset) const {
    if (rom_offset >= rom_.size()) return 0xFFu;
    return rom_[rom_offset];
}

uint16_t FirmwareImage::read_u16_le(uint32_t rom_offset) const {
    if (rom_offset + 1 >= rom_.size()) return 0xFFFFu;
    return static_cast<uint16_t>(rom_[rom_offset]) |
           (static_cast<uint16_t>(rom_[rom_offset + 1]) << 8);
}

uint16_t FirmwareImage::read_u16_be(uint32_t rom_offset) const {
    if (rom_offset + 1 >= rom_.size()) return 0xFFFFu;
    return (static_cast<uint16_t>(rom_[rom_offset]) << 8) |
           static_cast<uint16_t>(rom_[rom_offset + 1]);
}

uint32_t FirmwareImage::read_u32_le(uint32_t rom_offset) const {
    if (rom_offset + 3 >= rom_.size()) return 0xFFFFFFFFu;
    return static_cast<uint32_t>(rom_[rom_offset]) |
           (static_cast<uint32_t>(rom_[rom_offset + 1]) << 8) |
           (static_cast<uint32_t>(rom_[rom_offset + 2]) << 16) |
           (static_cast<uint32_t>(rom_[rom_offset + 3]) << 24);
}

int32_t FirmwareImage::read_i32_le(uint32_t rom_offset) const {
    return static_cast<int32_t>(read_u32_le(rom_offset));
}

int16_t FirmwareImage::read_i16_le(uint32_t rom_offset) const {
    return static_cast<int16_t>(read_u16_le(rom_offset));
}

bool FirmwareImage::patch_bytes(uint32_t va_or_offset, std::span<const uint8_t> bytes, std::string* err) {
    auto off_opt = resolve_to_rom_offset(va_or_offset);
    if (!off_opt) {
        if (err) {
            std::ostringstream oss;
            oss << "Address 0x" << std::hex << va_or_offset << " does not map to ROM or .data image";
            *err = oss.str();
        }
        return false;
    }
    uint32_t off = *off_opt;
    if (off + bytes.size() > rom_.size()) {
        if (err) *err = "Patch exceeds ROM boundary";
        return false;
    }
    std::memcpy(rom_.data() + off, bytes.data(), bytes.size());
    return true;
}

bool FirmwareImage::patch_u8(uint32_t va_or_offset, uint8_t val, std::string* err) {
    return patch_bytes(va_or_offset, std::span<const uint8_t>(&val, 1), err);
}

bool FirmwareImage::patch_u16_le(uint32_t va_or_offset, uint16_t val, std::string* err) {
    uint8_t b[2] = {
        static_cast<uint8_t>(val & 0xFFu),
        static_cast<uint8_t>((val >> 8) & 0xFFu)
    };
    return patch_bytes(va_or_offset, b, err);
}

bool FirmwareImage::patch_u32_le(uint32_t va_or_offset, uint32_t val, std::string* err) {
    uint8_t b[4] = {
        static_cast<uint8_t>(val & 0xFFu),
        static_cast<uint8_t>((val >> 8) & 0xFFu),
        static_cast<uint8_t>((val >> 16) & 0xFFu),
        static_cast<uint8_t>((val >> 24) & 0xFFu)
    };
    return patch_bytes(va_or_offset, b, err);
}

bool FirmwareImage::patch_ascii(uint32_t va_or_offset, const std::string& text, bool null_terminate, std::string* err) {
    std::vector<uint8_t> bytes(text.begin(), text.end());
    if (null_terminate) {
        bytes.push_back(0x00u);
    }
    return patch_bytes(va_or_offset, bytes, err);
}

bool FirmwareImage::patch_osd_string(uint32_t va_or_offset, const std::string& text, std::string* err) {
    std::vector<uint8_t> bytes;
    bytes.reserve((text.size() + 1) * 2);
    for (unsigned char ch : text) {
        bytes.push_back(ch);
        bytes.push_back(0x00u);
    }
    // 0x0003 terminator used by Panasonic OSD string table
    bytes.push_back(0x03u);
    bytes.push_back(0x00u);
    return patch_bytes(va_or_offset, bytes, err);
}

bool FirmwareImage::set_firmware_version(uint16_t major, uint16_t minor, std::string* err) {
    // 1. Update the "Pana" header version words at 0x008008 (major LE16, minor LE16)
    if (!patch_u16_le(0x008008u, major, err)) return false;
    if (!patch_u16_le(0x00800Au, minor, err)) return false;

    // 2. Update the 16-bit BCD Version in the hardware descriptor table at 0x0046A0 (VA 0x55C806A0)
    // Read by the bootloader file validator, update trigger logic, and LCD version OSD
    uint16_t min_norm = (minor < 10) ? (minor * 10) : minor;
    uint8_t maj_bcd = static_cast<uint8_t>(((major / 10) << 4) | (major % 10));
    uint8_t min_bcd = static_cast<uint8_t>(((min_norm / 10) << 4) | (min_norm % 10));
    uint16_t bcd_val = static_cast<uint16_t>(min_bcd | (static_cast<uint16_t>(maj_bcd) << 8));
    if (!patch_u16_le(0x0046A0u, bcd_val, err)) return false;

    return true;
}

std::vector<PartitionInfo> FirmwareImage::get_partitions() const {
    return {
        {0, "part_00_bootloader",     0x000000u, 0x004000u, 0x001305u, kRomBaseVa + 0x000000u, "Bootloader & Flash Updater (RAM 0x400001E4 / 0x54200000)"},
        {1, "part_01_vectors_init",   0x004000u, 0x008000u, 0x0049F2u, kRomBaseVa + 0x004000u, "MN103S Hardware Reset & Interrupt Vector Table + Kernel Init"},
        {2, "part_02_pana_header",    0x008000u, 0x014000u, 0x014000u, kRomBaseVa + 0x008000u, "Pana Firmware Header & DMC-TZ5 / LUMIX Model ID Block"},
        {3, "part_03_data_and_crt0",  0x014000u, 0x020000u, 0x01F076u, kRomBaseVa + 0x014000u, "Initialized .data Image (->0x54012840) + CRT0 Entry (0x55C9B02C)"},
        {4, "part_04_main_firmware",  0x020000u, 0x224000u, 0x21F428u, kRomBaseVa + 0x020000u, "Main Camera RTOS, Venus IV ISP, Lens/OIS, FAT/DCF, Exif & .rodata"},
        {5, "part_05_osd_ui_strings", 0x224000u, 0x36B800u, 0x31F118u, kRomBaseVa + 0x224000u, "Multi-Language 16-bit OSD UI Strings (0x0003 term) & Fonts"},
        {6, "part_06_resource_tables",0x36B800u, 0x484000u, 0x480F08u, kRomBaseVa + 0x36B800u, "Calibration Tables & Master OSD Pointer Table (0x12345678 @ 0x384000)"}
    };
}

std::optional<uint32_t> FirmwareImage::allocate_in_cave(const std::string& cave_name, size_t size, size_t alignment,
                                                        std::string* err) {
    for (auto& cave : caves_) {
        if (cave.name == cave_name) {
            uint32_t aligned_used = cave.used;
            if (alignment > 1) {
                uint32_t rem = (cave.va + aligned_used) % static_cast<uint32_t>(alignment);
                if (rem != 0) {
                    aligned_used += static_cast<uint32_t>(alignment) - rem;
                }
            }
            if (aligned_used + size > cave.capacity) {
                if (err) *err = "Insufficient free space in code cave " + cave_name;
                return std::nullopt;
            }
            uint32_t alloc_va = cave.va + aligned_used;
            cave.used = aligned_used + static_cast<uint32_t>(size);
            return alloc_va;
        }
    }
    if (err) *err = "Unknown code cave name: " + cave_name;
    return std::nullopt;
}

std::string FirmwareImage::sha256_hex(std::span<const uint8_t> data) {
    std::array<uint32_t, 8> h = {
        0x6a09e667u, 0xbb67ae85u, 0x3c6ef372u, 0xa54ff53au,
        0x510e527fu, 0x9b05688cu, 0x1f83d9abu, 0x5be0cd19u
    };

    const uint64_t bit_len = static_cast<uint64_t>(data.size()) * 8ull;
    size_t padded_len = data.size() + 1 + 8;
    size_t rem = padded_len % 64;
    if (rem != 0) padded_len += (64 - rem);

    std::vector<uint8_t> msg(padded_len, 0u);
    if (!data.empty()) {
        std::memcpy(msg.data(), data.data(), data.size());
    }
    msg[data.size()] = 0x80u;
    for (int i = 0; i < 8; ++i) {
        msg[padded_len - 1 - i] = static_cast<uint8_t>((bit_len >> (i * 8)) & 0xFFu);
    }

    std::array<uint32_t, 64> w{};
    for (size_t chunk = 0; chunk < padded_len; chunk += 64) {
        const uint8_t* p = msg.data() + chunk;
        for (size_t i = 0; i < 16; ++i) {
            w[i] = (static_cast<uint32_t>(p[i * 4]) << 24) |
                   (static_cast<uint32_t>(p[i * 4 + 1]) << 16) |
                   (static_cast<uint32_t>(p[i * 4 + 2]) << 8) |
                   static_cast<uint32_t>(p[i * 4 + 3]);
        }
        for (size_t i = 16; i < 64; ++i) {
            uint32_t s0 = rotr32(w[i - 15], 7) ^ rotr32(w[i - 15], 18) ^ (w[i - 15] >> 3);
            uint32_t s1 = rotr32(w[i - 2], 17) ^ rotr32(w[i - 2], 19) ^ (w[i - 2] >> 10);
            w[i] = w[i - 16] + s0 + w[i - 7] + s1;
        }

        uint32_t a = h[0], b = h[1], c = h[2], d = h[3];
        uint32_t e = h[4], f = h[5], g = h[6], hh = h[7];

        for (size_t i = 0; i < 64; ++i) {
            uint32_t S1 = rotr32(e, 6) ^ rotr32(e, 11) ^ rotr32(e, 25);
            uint32_t ch = (e & f) ^ ((~e) & g);
            uint32_t temp1 = hh + S1 + ch + kSha256K[i] + w[i];
            uint32_t S0 = rotr32(a, 2) ^ rotr32(a, 13) ^ rotr32(a, 22);
            uint32_t maj = (a & b) ^ (a & c) ^ (b & c);
            uint32_t temp2 = S0 + maj;

            hh = g;
            g = f;
            f = e;
            e = d + temp1;
            d = c;
            c = b;
            b = a;
            a = temp1 + temp2;
        }

        h[0] += a; h[1] += b; h[2] += c; h[3] += d;
        h[4] += e; h[5] += f; h[6] += g; h[7] += hh;
    }

    std::ostringstream oss;
    oss << std::hex << std::setfill('0');
    for (uint32_t word : h) {
        oss << std::setw(8) << word;
    }
    return oss.str();
}

} // namespace tz5
