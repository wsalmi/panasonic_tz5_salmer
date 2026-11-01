// ============================================================================
// PARTITION 05 SOURCE MODULE: part_05_resource_tables
// File: part_05_0x374000_0x480f08.bin (1101576 base bytes + 0 ext bytes)
// Unpacked Flash Range : 0x374000 .. 0x480F08 (CAVE_TAIL_ROM -> 0x484000)
// Virtual Address (VA) : 0x55FF0000 .. 0x560FCF08
// REA Evidence ID      : ev_c6e9740541df83835fc86bc158e5e961f3c212b783e6641ea74303c66b52bce9
// ============================================================================

#include <cstdint>

namespace tz5::part05_src {

// [Sub-Segment 05a] 64 KB Zero-Initialized Arena (0x55FF0000..0x55FFFFFF)
constexpr uint32_t kZeroArenaBaseVa = 0x55FF0000u;
constexpr uint32_t kZeroArenaSize   = 0x00010000u;

// [Sub-Segment 05b] Master Resource & OSD Pointer Table (0x56000000..0x56050E98)
constexpr uint32_t kMasterTableVa    = 0x56000000u;
constexpr uint32_t kMasterTableMagic = 0x12345678u;
constexpr uint32_t kFirstUpperResVa  = 0x56050E98u;
constexpr size_t   kTotalTableWords  = 82853;
constexpr size_t   kPart03Pointers   = 60504;
constexpr size_t   kPart05Pointers   = 17520;

} // namespace tz5::part05_src
