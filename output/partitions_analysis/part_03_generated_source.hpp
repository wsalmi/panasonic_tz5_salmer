// ============================================================================
// PARTITION 03 SOURCE MODULE: part_03_osd_ui
// File: part_03_0x224000_0x31f118.bin (1028376 base bytes + 0 ext bytes)
// Unpacked Flash Range : 0x224000 .. 0x31F118 (CAVE_UPPER_ROM -> 0x36B800)
// Virtual Address (VA) : 0x55EA0000 .. 0x55F9B118
// REA Evidence ID      : ev_bfea28937a85208940f8156388aee0b05e10d32ea20643ace8882213e9615172
// Discovered 0x0003 OSD Strings : 82
// Discovered 0x0000 UTF-16LE    : 32
// ============================================================================

#include <cstdint>

namespace tz5::part03_src {

struct OsdEntry { uint32_t va; const char* text; };

constexpr OsdEntry kSampleOsdStrings[] = {
    { 0x55EA09F0u, "    " },
    { 0x55EA0BBAu, "                               " },
    { 0x55EA0FCCu, "ENGLISH" },
    { 0x55EA0FDCu, "DEUTSCH" },
    { 0x55EA1006u, "AIS" },
    { 0x55EA100Eu, "ITALIANO" },
    { 0x55EA104Cu, "POLSKI" },
    { 0x55EA105Eu, "ESKY" },
    { 0x55EA1068u, "MAGYAR" },
    { 0x55EA1076u, "NEDERLANDS" },
    { 0x55EA10F8u, "AIS" },
    { 0x55EA1100u, "SUOMI" },
    { 0x55EA110Cu, "DANSK" },
    { 0x55EA1118u, "SVENSKA" },
    { 0x55EA1128u, "VER." },
    { 0x55EA1132u, "ADJ." },
    { 0x55EA113Cu, "REC." },
    { 0x55EA1146u, "START" },
    { 0x55EA115Eu, "SERVICE MODE" },
    { 0x55EA1182u, "SHUTTER" },
    { 0x55EA11AAu, "DELETE" },
    { 0x55EA11C8u, "MENU" },
    { 0x55EA11E2u, "(P)" },
    { 0x55EA1216u, "OIS" },
    { 0x55EA121Eu, "INITIAL SETTINGS" },
    { 0x55EA1240u, "NONE(JAPAN)" },
    { 0x55EA12D4u, "LENS" },
    { 0x55EA12DEu, "SOFT" },
    { 0x55EA12E8u, "HARD" },
    { 0x55EA12F2u, "UNDEFINED" },
    { 0x55EA1362u, "2.5M" },
    { 0x55EA1372u, "100" },
    { 0x55EA137Au, "200" },
    { 0x55EA1382u, "400" },
    { 0x55EA138Au, "800" },
    { 0x55EA1392u, "1600" },
    { 0x55EA13A8u, "7.5M" },
    { 0x55EA13B8u, "8.5M" },
    { 0x55EA13C8u, "10M" },
    { 0x55EA13D0u, "0.3M EZ" },
};

} // namespace tz5::part03_src
