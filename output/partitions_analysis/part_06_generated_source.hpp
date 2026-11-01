// ============================================================================
// PARTITION 06 SOURCE MODULE: part_06_parity_trailer
// File: part_06_0x484000_0x484020.bin (32 bytes)
// Unpacked Flash Range : 0x484000 .. 0x484020 (Row 147,968 of 2D Matrix)
// Virtual Address (VA) : 0x56100000 .. 0x56100020
// REA Evidence ID      : ev_0b97032c09f8891c07077289b35967440a949db77f9f74b22c8dcfb89c5d9b8b
// ============================================================================

#include <array>
#include <cstdint>

namespace tz5::part06_src {

// Vertical 16-column big-endian two's-complement parity words:
// W[147968, c] = (-sum_{r=0..147967} W[r, c]) & 0xFFFF
constexpr std::array<uint16_t, 16> kVerticalColumnParityWords = {
    0x18F8u, 0xD940u, 0x6631u, 0x723Fu, 0xCC11u, 0x0B3Bu, 0x5C3Cu, 0x99AFu,
    0x64C1u, 0x7A2Du, 0x0E9Bu, 0x44D4u, 0x1D5Fu, 0xC6FEu, 0x35F1u, 0xE180u
};
constexpr uint16_t kCornerChecksumWord = 0x39F6u;

} // namespace tz5::part06_src
