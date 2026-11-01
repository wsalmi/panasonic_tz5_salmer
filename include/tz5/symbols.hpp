#pragma once

#include <cstdint>
#include <string>
#include <unordered_map>

namespace tz5 {

inline std::unordered_map<uint32_t, std::string> get_default_code_symbols() {
    return {
        {0x55C7C000u, "boot_reset_entry"},
        {0x55C7C0E3u, "boot_flash_updater_main"},
        {0x55C80000u, "vec_hardware_reset"},
        {0x55C80008u, "vec_nmi_entry"},
        {0x55C80010u, "vec_trap_rti"},
        {0x55C80018u, "vec_irq_group0"},
        {0x55C80020u, "vec_irq_group1"},
        {0x55C80028u, "vec_irq_group2"},
        {0x55C80030u, "vec_irq_group3"},
        {0x55C80038u, "vec_irq_group4"},
        {0x55C80040u, "vec_irq_group5"},
        {0x55C80048u, "vec_irq_group6"},
        {0x55C80050u, "kernel_reset_handler"},
        {0x55C800D1u, "kernel_early_ram_init"},
        {0x55C80107u, "nmi_watchdog_handler"},
        {0x55C9B02Cu, "crt0_main_firmware_entry"},
        {0x55C9B06Eu, "rtos_system_startup"},
        {0x55CAD59Fu, "str_printf_format_helper"},
        {0x55CAD5BDu, "str_copy_format_helper"},
        {0x55D6BA71u, "ui_draw_ascii_label"},
        {0x55D6F036u, "ui_refresh_screen_layer"},
        {0x55D87497u, "ui_render_camera_info_title"},
        {0x55D93E08u, "ui_format_lumix_version_banner"},
        {0x55E97FC7u, "venus_master_irq_dispatcher"}
    };
}

inline std::string resolve_mmio_name(uint32_t addr) {
    if (addr >= 0x9C012100u && addr <= 0x9C0121FFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "VENUS_FLASH_DMA_0x%02X", addr & 0xFFu);
        return buf;
    }
    if (addr >= 0x9C002000u && addr <= 0x9C002DFFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "VENUS_ISP_PIPE_0x%04X", addr & 0xFFFFu);
        return buf;
    }
    if (addr >= 0x9C00C000u && addr <= 0x9C00C1FFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "VENUS_INTC_0x%03X", addr & 0xFFFu);
        return buf;
    }
    if (addr >= 0x9C005000u && addr <= 0x9C0055FFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "VENUS_TIMER_PWM_0x%03X", addr & 0xFFFu);
        return buf;
    }
    if (addr >= 0x9C004000u && addr <= 0x9C0041FFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "VENUS_SIO_UART_0x%03X", addr & 0xFFFu);
        return buf;
    }
    if (addr >= 0x9C008000u && addr <= 0x9C0086FFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "VENUS_GPIO_PORT_0x%03X", addr & 0xFFFu);
        return buf;
    }
    if (addr >= 0x9C000000u && addr <= 0x9C0004FFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "VENUS_SYSCLK_PLL_0x%03X", addr & 0xFFFu);
        return buf;
    }
    if (addr >= 0xD8000000u && addr <= 0xD80001FFu) {
        char buf[64];
        std::snprintf(buf, sizeof(buf), "MN103S_INTC_CPU_0x%03X", addr & 0xFFFu);
        return buf;
    }
    return {};
}

} // namespace tz5
