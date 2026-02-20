# Xbattery S32K144 - NXP S32K144 (Cortex-M4F)
# Build: cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake

cmake_minimum_required(VERSION 3.10)
project(xbattery_cursor VERSION 0.1.0 LANGUAGES C ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Linker script path
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/startup/S32K144_ram.ld)

# Executable
add_executable(${CMAKE_PROJECT_NAME}.elf
    src/main.c
    src/system_S32K144.c
    startup/startup_S32K144.S
)

target_include_directories(${CMAKE_PROJECT_NAME}.elf PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/startup
)

target_link_options(${CMAKE_PROJECT_NAME}.elf PRIVATE
    -T ${LINKER_SCRIPT}
)

# Optional: .bin and .hex
add_custom_command(TARGET ${CMAKE_PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${CMAKE_PROJECT_NAME}.elf> ${CMAKE_PROJECT_NAME}.bin
    COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:${CMAKE_PROJECT_NAME}.elf> ${CMAKE_PROJECT_NAME}.hex
    COMMENT "Generating ${CMAKE_PROJECT_NAME}.bin and .hex"
)

# Default to Debug if not set
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

