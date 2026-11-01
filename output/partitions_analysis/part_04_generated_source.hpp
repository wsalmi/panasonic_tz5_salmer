// ============================================================================
// PARTITION 04 SOURCE MODULE: part_04_flash_stub
// File: part_04_0x36b800_0x36b804.bin (4 bytes)
// Unpacked Flash Range : 0x36B800 .. 0x36B804 (Expansion -> 0x374000, 34,816 B)
// Virtual Address (VA) : 0x55FE7800 .. 0x55FE7804
// REA Evidence ID      : ev_836778a76859ffc891e135718b7208f9dd4cd15fcf0fc421181b9d659620de2c
// ============================================================================

#include <cstdint>

namespace tz5::part04_src {

// 4-byte aligned return/nop stub at VA 0x55FE7800 (0xCB = rets/nop in MN103S)
void flash_boundary_stub_0x55FE7800(void) {
    return; // cb cb cb cb
}

} // namespace tz5::part04_src
