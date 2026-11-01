// ============================================================================
// PARTITION 00 SOURCE MODULE: part_00_bootloader
// File: part_00_0x000000_0x001305.bin (4869 base bytes + 0 ext bytes)
// Unpacked Flash Range : 0x000000 .. 0x001305 (Expansion Cave -> 0x004000)
// Virtual Address (VA) : 0x55C7C000 .. 0x55C7D305
// REA Evidence ID      : ev_2a77ce06d889473bea4de5ee8738aefd66fba752dc805aac44ab907818a3f3da
// ============================================================================

#include <cstdint>

namespace tz5::part00_src {

constexpr uint32_t kBootInitialTargetVa = 0x54080000u;

// Function: boot_reset_entry @ VA 0x55C7C000 (ROM+0x0)
// Initializes CPU stack/jump pointer (0x54080000), configures Venus IV bus/PLL registers, and branches to updater/boot dispatcher.
void boot_reset_entry(void) {
    uintptr_t* boot_vec = (uintptr_t*)0x54080000;
    venus_sysclk_init(0x0400);
    boot_flash_updater_main();
}

// Function: boot_flash_updater_main @ VA 0x55C7C0E3 (ROM+0xE3)
// Relocates flash programming engines to On-Chip Fast RAM (0x400001E4 & 0x4000071C) so NOR flash can be erased/reprogrammed while executing from RAM.
int boot_flash_updater_main(void) {
    memcpy((void*)0x400001E4, (const void*)0x55C7C850, 0x538);
    memcpy((void*)0x4000071C, (const void*)0x55C7CD88, 0x57C);
    VENUS_FLASH_DMA_CTRL = 0x0001;
    return ((int(*)(void))0x400001E4)();
}

} // namespace tz5::part00_src
