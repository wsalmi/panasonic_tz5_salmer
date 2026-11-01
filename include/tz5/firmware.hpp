#pragma once

#include <cstddef>
#include <cstdint>
#include <optional>
#include <span>
#include <string>
#include <vector>

namespace tz5 {

struct VerifyReport {
    bool valid = false;
    size_t total_rows = 0;
    size_t horizontal_valid_rows = 0;
    size_t horizontal_bad_rows = 0;
    int64_t first_bad_row = -1;
    size_t vertical_valid_cols = 0;
    size_t vertical_bad_cols = 0;
    uint16_t trailer_corner_word = 0;
    std::string sha256_hex;
    std::string message;
};

struct PartitionInfo {
    int index = 0;
    std::string name;
    uint32_t start_offset = 0;
    uint32_t end_offset = 0;
    uint32_t active_end_offset = 0;
    uint32_t va_start = 0;
    std::string description;
};

struct CodeCave {
    std::string name;
    uint32_t rom_offset = 0;
    uint32_t va = 0;
    uint32_t capacity = 0;
    uint32_t used = 0;
    std::string description;
};

class FirmwareImage {
public:
    static constexpr size_t kRecordSize = 34;
    static constexpr size_t kRecordPayloadSize = 32;
    static constexpr size_t kTotalRows = 147969;
    static constexpr size_t kPayloadRows = 147968;
    static constexpr size_t kFramedFileSize = kTotalRows * kRecordSize;          // 5,030,946 bytes
    static constexpr size_t kRomPayloadSize = kPayloadRows * kRecordPayloadSize; // 4,734,976 bytes (0x484000)
    static constexpr size_t kUnpackedWithTrailerSize = kTotalRows * kRecordPayloadSize; // 4,735,008 bytes (0x484020)

    static constexpr uint32_t kRomBaseVa   = 0x55C7C000u;
    static constexpr uint32_t kRomEndVa    = kRomBaseVa + static_cast<uint32_t>(kRomPayloadSize); // 0x56100000
    static constexpr uint32_t kDataRomOff  = 0x00014000u;
    static constexpr uint32_t kDataRamVa   = 0x54012840u;
    static constexpr uint32_t kDataSize    = 0x0000B02Cu; // 45,100 bytes -> 0x5401D86C
    static constexpr uint32_t kBssRamStart = 0x5401D86Cu;
    static constexpr uint32_t kBssRamEnd   = 0x54077238u;

    FirmwareImage();

    // Load either a 5,030,946-byte framed TZ5_a.bin OR a 4,734,976/4,735,008-byte unpacked ROM
    bool load_from_file(const std::string& path, std::string* err = nullptr);
    bool load_from_bytes(std::span<const uint8_t> data, std::string* err = nullptr);

    // Verify a framed 5,030,946-byte firmware image against the 2D (147,969 x 17) zero-sum matrix
    static VerifyReport verify_framed_bytes(std::span<const uint8_t> framed_data);

    // Unpack 5,030,946-byte framed image to 4,734,976-byte contiguous ROM image
    static std::vector<uint8_t> unpack_framed_to_rom(std::span<const uint8_t> framed_data,
                                                     std::vector<uint8_t>* out_trailer32 = nullptr);

    // Build a valid 5,030,946-byte framed TZ5_a.bin image from the current 0x484000-byte ROM image
    // Recomputes the 32-byte vertical column-parity trailer (0x484000..0x484020) and all 147,969 row checksums
    std::vector<uint8_t> build_framed_bytes(std::vector<uint8_t>* out_trailer32 = nullptr) const;
    bool save_framed_to_file(const std::string& path, std::string* err = nullptr) const;
    bool save_unpacked_to_file(const std::string& path, bool include_trailer = true, std::string* err = nullptr) const;

    // Access contiguous 0x484000-byte ROM
    const std::vector<uint8_t>& rom() const { return rom_; }
    std::vector<uint8_t>& rom_mut() { return rom_; }

    // Address translation (supports ROM VAs 0x55C7C000..0x560FFFFF, SDRAM .data VAs 0x54012840..0x5401D86C, or raw offsets < 0x484000)
    static std::optional<uint32_t> resolve_to_rom_offset(uint32_t va_or_offset);
    static constexpr uint32_t rom_offset_to_va(uint32_t rom_offset) { return kRomBaseVa + rom_offset; }

    // Read primitives from ROM offset
    uint8_t read_u8(uint32_t rom_offset) const;
    uint16_t read_u16_le(uint32_t rom_offset) const;
    uint16_t read_u16_be(uint32_t rom_offset) const;
    uint32_t read_u32_le(uint32_t rom_offset) const;
    int32_t read_i32_le(uint32_t rom_offset) const;
    int16_t read_i16_le(uint32_t rom_offset) const;

    // Patching primitives (accept either Virtual Address or ROM offset)
    bool patch_bytes(uint32_t va_or_offset, std::span<const uint8_t> bytes, std::string* err = nullptr);
    bool patch_u8(uint32_t va_or_offset, uint8_t val, std::string* err = nullptr);
    bool patch_u16_le(uint32_t va_or_offset, uint16_t val, std::string* err = nullptr);
    bool patch_u32_le(uint32_t va_or_offset, uint32_t val, std::string* err = nullptr);
    bool patch_ascii(uint32_t va_or_offset, const std::string& text, bool null_terminate = false, std::string* err = nullptr);
    bool patch_osd_string(uint32_t va_or_offset, const std::string& text, std::string* err = nullptr);
    bool set_firmware_version(uint16_t major, uint16_t minor, std::string* err = nullptr);

    // Partition & XIP Code-Cave inspection and allocation
    std::vector<PartitionInfo> get_partitions() const;
    const std::vector<CodeCave>& code_caves() const { return caves_; }
    std::optional<uint32_t> allocate_in_cave(const std::string& cave_name, size_t size, size_t alignment = 4,
                                             std::string* err = nullptr);

    // Cryptographic SHA-256 helper
    static std::string sha256_hex(std::span<const uint8_t> data);

private:
    void init_default_caves();

    std::vector<uint8_t> rom_;
    std::vector<CodeCave> caves_;
};

} // namespace tz5
