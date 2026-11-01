cmake_minimum_required(VERSION 3.20)
project(tz5_firmware_sdk VERSION 2.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    add_compile_options(-Wall -Wextra -Wpedantic -O3)
endif()

add_library(tz5_core STATIC
    src/firmware.cpp
    src/disassembler.cpp
    src/assembler.cpp
    partitions_src/part_00_bootloader/part_00.cpp
    partitions_src/part_01_vectors_init/part_01.cpp
    partitions_src/part_02_main_firmware/part_02.cpp
    partitions_src/part_03_osd_ui/part_03.cpp
    partitions_src/part_04_flash_stub/part_04.cpp
    partitions_src/part_05_resource_tables/part_05.cpp
    partitions_src/part_06_parity_trailer/part_06.cpp
    partitions_src/partition_workspace.cpp
    partitions_src/ui_engine/tz5_ui_engine.cpp
    partitions_src/raw_engine/tz5_raw_engine.cpp
)

target_include_directories(tz5_core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/partitions_src
)

add_executable(tz5-fw-tool
    src/main.cpp
)

target_link_libraries(tz5-fw-tool PRIVATE tz5_core)
