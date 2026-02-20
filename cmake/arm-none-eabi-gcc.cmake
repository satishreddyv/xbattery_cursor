# Toolchain file for NXP S32K144 (Cortex-M4F) with arm-none-eabi-gcc
# Xbattery

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cortex-m4)

# Optional: set if toolchain is not on PATH
if(DEFINED ENV{ARM_TOOLCHAIN_PREFIX})
    set(TC_PREFIX "$ENV{ARM_TOOLCHAIN_PREFIX}")
else()
    set(TC_PREFIX "arm-none-eabi-")
endif()

set(CMAKE_C_COMPILER   "${TC_PREFIX}gcc")
set(CMAKE_ASM_COMPILER "${TC_PREFIX}gcc")
set(CMAKE_LINKER       "${TC_PREFIX}ld")

# Cortex-M4F: thumb, hard float
set(CPU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

set(CMAKE_C_FLAGS_INIT   "${CPU_FLAGS} -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS_DEBUG  "-O0 -g -gdwarf-2")
set(CMAKE_C_FLAGS_RELEASE "-Os")

set(CMAKE_ASM_FLAGS_INIT   "${CPU_FLAGS} -x assembler-with-cpp -Wa,--no-warn")
set(CMAKE_ASM_FLAGS_DEBUG  "-g -gdwarf-2")
set(CMAKE_ASM_FLAGS_RELEASE "")

# Linker script set by project CMakeLists.txt via LINKER_SCRIPT
set(CMAKE_EXE_LINKER_FLAGS_INIT "${CPU_FLAGS} -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections -Wl,-Map=${CMAKE_PROJECT_NAME}.map")

# Objcopy for .bin/.hex (expect same toolchain on PATH)
if(NOT CMAKE_OBJCOPY)
    set(CMAKE_OBJCOPY "arm-none-eabi-objcopy")
endif()
