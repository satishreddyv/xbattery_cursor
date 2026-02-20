# Toolchain file for NXP S32K1xx / S32K3xx (Cortex-M4F / Cortex-M7) with arm-none-eabi-gcc
# Xbattery
# Usage: cmake -DTARGET_MCU=S32K144  (S32K1xx, default)
#        cmake -DTARGET_MCU=S32K344  (S32K3xx/4xx)

set(CMAKE_SYSTEM_NAME Generic)

# Optional: set if toolchain is not on PATH
if(DEFINED ENV{ARM_TOOLCHAIN_PREFIX})
    set(TC_PREFIX "$ENV{ARM_TOOLCHAIN_PREFIX}")
else()
    set(TC_PREFIX "arm-none-eabi-")
endif()

set(CMAKE_C_COMPILER   "${TC_PREFIX}gcc")
set(CMAKE_ASM_COMPILER "${TC_PREFIX}gcc")
set(CMAKE_LINKER       "${TC_PREFIX}ld")

# Select CPU flags based on TARGET_MCU (cache variable passed with -D)
if("${TARGET_MCU}" MATCHES "S32K3|S32K4")
    set(CMAKE_SYSTEM_PROCESSOR cortex-m7)
    set(CPU_FLAGS "-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard")
    message(STATUS "Toolchain: Cortex-M7 (S32K3xx/4xx) for ${TARGET_MCU}")
else()
    set(CMAKE_SYSTEM_PROCESSOR cortex-m4)
    set(CPU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")
    message(STATUS "Toolchain: Cortex-M4F (S32K1xx) for ${TARGET_MCU}")
endif()

set(CMAKE_C_FLAGS_INIT   "${CPU_FLAGS} -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS_DEBUG  "-O0 -g -gdwarf-2")
set(CMAKE_C_FLAGS_RELEASE "-Os")

set(CMAKE_ASM_FLAGS_INIT   "${CPU_FLAGS} -x assembler-with-cpp -Wa,--no-warn")
set(CMAKE_ASM_FLAGS_DEBUG  "-g -gdwarf-2")
set(CMAKE_ASM_FLAGS_RELEASE "")

set(CMAKE_EXE_LINKER_FLAGS_INIT
    "${CPU_FLAGS} -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections -Wl,-Map=${CMAKE_PROJECT_NAME}.map")

if(NOT CMAKE_OBJCOPY)
    set(CMAKE_OBJCOPY "arm-none-eabi-objcopy")
endif()