// ============================================================================
// PARTITION 01 SOURCE MODULE: part_01_vectors_init
// File: part_01_0x004000_0x0049f2.bin (2546 base bytes + 0 ext bytes)
// Unpacked Flash Range : 0x004000 .. 0x0049F2 (Expansion Cave -> 0x008000)
// Virtual Address (VA) : 0x55C80000 .. 0x55C809F2
// REA Evidence ID      : ev_20a0133a9d605ff899bbf5c8f10a9173e701d5f47c5cbeebbc9c722701e0f62b
// ============================================================================

#include <cstdint>

namespace tz5::part01_src {

// Hardware Interrupt Vector Table (0x55C80000..0x55C8004F)
// Slot 0 [vec_hardware_reset] @ VA 0x55C80000 -> Target VA 0x55C80050 (mov 0x55C80050, a1; jmp (a1))
// Slot 1 [vec_nmi_entry] @ VA 0x55C80008 -> Target VA 0x55C80107 (jmp 0x55C80107)
// Slot 2 [vec_trap_rti] @ VA 0x55C80010 -> Target VA 0x55C80010 (rti)
// Slot 3 [vec_irq_group0] @ VA 0x55C80018 -> Target VA 0x55E97FC7 (jmp 0x55E97FC7)
// Slot 4 [vec_irq_group1] @ VA 0x55C80020 -> Target VA 0x55E97FC7 (jmp 0x55E97FC7)
// Slot 5 [vec_irq_group2] @ VA 0x55C80028 -> Target VA 0x55E97FC7 (jmp 0x55E97FC7)
// Slot 6 [vec_irq_group3] @ VA 0x55C80030 -> Target VA 0x55E97FC7 (jmp 0x55E97FC7)
// Slot 7 [vec_irq_group4] @ VA 0x55C80038 -> Target VA 0x55E97FC7 (jmp 0x55E97FC7)
// Slot 8 [vec_irq_group5] @ VA 0x55C80040 -> Target VA 0x55E97FC7 (jmp 0x55E97FC7)
// Slot 9 [vec_irq_group6] @ VA 0x55C80048 -> Target VA 0x55E97FC7 (jmp 0x55E97FC7)

// Function: kernel_reset_handler @ VA 0x55C80050
// Primary CPU reset handler jumped to from Slot 0 (0x55C80000); initializes PSW/registers and calls kernel_early_ram_init.
void kernel_reset_handler(void) {
    cpu_disable_interrupts();
    kernel_early_ram_init();
    crt0_main_firmware_entry();
}

// Function: kernel_early_ram_init @ VA 0x55C800D1
// Zeros 74,680 bytes of kernel .bss (0x5400042C..0x540127E4) and copies 44 bytes of kernel .data from 0x55C80638 to 0x54000400.
void kernel_early_ram_init(void) {
    memset((void*)0x5400042C, 0, 0x540127E4 - 0x5400042C);
    memcpy((void*)0x54000400, (const void*)0x55C80638, 0x2C);
}

// Function: nmi_watchdog_handler @ VA 0x55C80107
// Non-maskable interrupt & watchdog exception handler branched from Slot 1 (0x55C80008).
void nmi_watchdog_handler(void) {
    VENUS_INTC_ACK = 0x03F7;
    system_fault_halt();
}

} // namespace tz5::part01_src
