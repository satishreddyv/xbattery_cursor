# Xbattery - NXP S32K multi-target (S32K1xx and S32K3xx/4xx)
# Usage:
#   S32K144 (default): cmake -B build/s32k144 -S . -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake -DTARGET_MCU=S32K144
#   S32K344:           cmake -B build/s32k344 -S . -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake -DTARGET_MCU=S32K344

cmake_minimum_required(VERSION 3.10)

set(TARGET_MCU "S32K144" CACHE STRING "Target MCU variant (e.g. S32K144, S32K344)")
set_property(CACHE TARGET_MCU PROPERTY STRINGS S32K116 S32K118 S32K142 S32K144 S32K146 S32K148
                                                S32K312 S32K314 S32K322 S32K324 S32K344 S32K358 S32K388)

project(xbattery_cursor VERSION 0.1.0 LANGUAGES C ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Select variant-specific files
if(TARGET_MCU MATCHES "^S32K3|^S32K4")
    set(MCU_FAMILY "S32K3xx")
    set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/startup/S32K344_ram.ld)
    set(STARTUP_FILE  startup/startup_S32K344.S)
    set(SYSTEM_FILE   src/system_S32K344.c)
    add_compile_definitions(CPU_S32K344 MCU_S32K3XX)
else()
    set(MCU_FAMILY "S32K1xx")
    set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/startup/S32K144_ram.ld)
    set(STARTUP_FILE  startup/startup_S32K144.S)
    set(SYSTEM_FILE   src/system_S32K144.c)
    add_compile_definitions(CPU_S32K144 MCU_S32K1XX)
endif()

message(STATUS "Target MCU : ${TARGET_MCU} (family: ${MCU_FAMILY})")
message(STATUS "Linker     : ${LINKER_SCRIPT}")

add_executable(${CMAKE_PROJECT_NAME}.elf
    src/main.c
    ${SYSTEM_FILE}
    ${STARTUP_FILE}
)

target_include_directories(${CMAKE_PROJECT_NAME}.elf PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/startup
)

target_compile_definitions(${CMAKE_PROJECT_NAME}.elf PRIVATE
    TARGET_MCU="${TARGET_MCU}"
)

target_link_options(${CMAKE_PROJECT_NAME}.elf PRIVATE
    -T ${LINKER_SCRIPT}
)

# Post-build: generate .bin and .hex
add_custom_command(TARGET ${CMAKE_PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${CMAKE_PROJECT_NAME}.elf> ${CMAKE_PROJECT_NAME}.bin
    COMMAND ${CMAKE_OBJCOPY} -O ihex   $<TARGET_FILE:${CMAKE_PROJECT_NAME}.elf> ${CMAKE_PROJECT_NAME}.hex
    COMMENT "Generating ${CMAKE_PROJECT_NAME}.bin and .hex for ${TARGET_MCU}"
)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()