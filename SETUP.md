# Xbattery S32K144 – Setup Guide

Embedded development workspace for **NXP S32K144** (Cortex-M4F) using CMake, arm-none-eabi-gcc, and Cortex-Debug in Cursor.

## 1. Install toolchain

### ARM GNU Toolchain

- **Option A**: [Arm GNU Toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads) – choose "arm-none-eabi" for Windows.
- **Option B**: MCUXpresso IDE installs a copy; add its `tools/bin` to PATH (e.g. `C:\NXP\MCUXpressoIDE_xx.x.x\tools\bin`).

Add the `bin` directory containing `arm-none-eabi-gcc.exe` to your **PATH** so these are available:

- `arm-none-eabi-gcc`
- `arm-none-eabi-ld`, `arm-none-eabi-objcopy`, `arm-none-eabi-size`
- `arm-none-eabi-gdb`

### CMake

- Install from [cmake.org](https://cmake.org/download/) (3.10 or newer) and add to PATH.

### Debug probe (for flashing and debugging)

- **J-Link**: Install [SEGGER J-Link](https://www.segger.com/downloads/jlink/). Add the folder containing `JLinkGDBServerCL.exe` to PATH, or set `serverpath` in `.vscode/launch.json`.
- **OpenOCD** (optional): Use an NXP/S32K-capable build if you prefer OpenOCD over J-Link.

## 2. Verify toolchain

From the project root, run:

```powershell
.\scripts\check_toolchain.ps1
```

Resolve any reported missing tools before continuing.

## 3. Cursor extensions

Install these in Cursor (Extensions panel, search by ID or name):

| Extension        | ID                         | Purpose                          |
|------------------|----------------------------|----------------------------------|
| **Cortex-Debug** | `marus25.cortex-debug`     | Debug with J-Link/OpenOCD        |
| **CMake Tools**  | `ms-vscode.cmake-tools`   | Configure and build with CMake   |
| **C/C++**        | `ms-vscode.cpptools`      | IntelliSense for C/C++           |

Optional: in `.vscode/settings.json`, set `C_Cpp.default.compilerPath` to your `arm-none-eabi-gcc` path and `cortex-debug.armToolchainPath` to the folder containing `arm-none-eabi-gdb.exe` if they are not on PATH.

## 4. Configure and build

1. Open this folder in Cursor.
2. **Configure**: Run the task **Configure** (or from terminal):
   ```powershell
   cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake
   ```
3. **Build**: Run the task **Build** (or):
   ```powershell
   cmake --build build --config Debug
   ```

Output: `build/xbattery_cursor.elf` (and optionally `.bin` / `.hex`).

## 5. Debug (J-Link)

1. Connect the S32K144 board via J-Link (SWD).
2. In Cursor, select the launch configuration **Debug (J-Link)** and press **F5** (or Run > Start Debugging).

The **Build** task runs before debug by default. Ensure the executable path in `.vscode/launch.json` matches your build output (e.g. `build/xbattery_cursor.elf`).

## 6. Optional: toolchain path not on PATH

If the ARM toolchain is not on PATH:

- **CMake**: Set `ARM_TOOLCHAIN_PREFIX` or pass `-DCMAKE_C_COMPILER=<path>/arm-none-eabi-gcc` when configuring; or edit `cmake/arm-none-eabi-gcc.cmake` to use a fixed path.
- **Cortex-Debug**: Set `armToolchainPath` in `.vscode/launch.json` to the directory containing `arm-none-eabi-gdb.exe`.
- **C/C++ IntelliSense**: Set `C_Cpp.default.compilerPath` in `.vscode/settings.json` to the full path of `arm-none-eabi-gcc`.

---

**Company**: Xbattery  
**Target**: NXP S32K144 (Cortex-M4F)

---

## New Developer Onboarding (from Git clone)

### Prerequisites
- Windows 10/11, PowerShell 5+, [winget](https://aka.ms/getwinget) (ships with Windows 11; install App Installer on Windows 10)
- A SEGGER J-Link debug probe (for hardware debugging)

### Step 1 â€“ Clone the repository
`powershell
git clone <repo-url> xbattery_cursor
cd xbattery_cursor
`

### Step 2 â€“ Install all required tools in one command
`powershell
winget import -i xbattery-tools.json --accept-package-agreements --accept-source-agreements
`
This installs: **arm-none-eabi-gcc 14.2.Rel1**, **CMake 4.2.3**, **Ninja 1.13.2**.

> Open a new terminal after install so the updated PATH takes effect.

### Step 3 â€“ Verify toolchain
`powershell
.\scripts\check_toolchain.ps1
`
All required items should show **[OK]**.

### Step 4 â€“ Open in Cursor and install extensions
Open this folder in Cursor. When prompted, click **Install All** on the recommended extensions popup (defined in .vscode/extensions.json):
- marus25.cortex-debug
- ms-vscode.cmake-tools
- ms-vscode.cpptools

### Step 5 â€“ Build
Press **Ctrl+Shift+B** (or run task **Build**). Output: uild/xbattery_cursor.elf.

### Step 6 â€“ Debug
Install [SEGGER J-Link](https://www.segger.com/downloads/jlink/), connect the S32K144 board via SWD, then press **F5** and select **Debug (J-Link)**.

---

## Redistribution checklist

| Item | File | Notes |
|---|---|---|
| Project source | src/, startup/ | All C and ASM sources |
| Build system | CMakeLists.txt, cmake/ | CMake + ARM toolchain file |
| Tool manifest | xbattery-tools.json | winget import to reproduce tools |
| Workspace config | .vscode/ | Tasks, launch, settings, extensions |
| AI rules | .cursor/rules/ | MISRA C + embedded best practices |
| Developer guide | SETUP.md | This file |
| Toolchain check | scripts/check_toolchain.ps1 | Verify before first build |
| Git hygiene | .gitignore | Excludes uild/, binaries, local overrides |


---

## Multi-target build (S32K1xx and S32K3xx/4xx)

This workspace supports both MCU families via `-DTARGET_MCU=<variant>`.

### Supported variants

| Family | Core | Variants | Build dir |
|---|---|---|---|
| S32K1xx | Cortex-M4F | S32K142, S32K144, S32K146, S32K148 | `build/s32k144` |
| S32K3xx/4xx | Cortex-M7 | S32K312, S32K314, S32K344, S32K358, S32K388 | `build/s32k344` |

### Build S32K144 (default)

```powershell
cmake -B build/s32k144 -S . -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake -DTARGET_MCU=S32K144 -G Ninja
cmake --build build/s32k144
```

Or use task: **Build (S32K144)** in Cursor.

### Build S32K344 (S32K3xx/4xx)

```powershell
cmake -B build/s32k344 -S . -DCMAKE_TOOLCHAIN_FILE=cmake/arm-none-eabi-gcc.cmake -DTARGET_MCU=S32K344 -G Ninja
cmake --build build/s32k344
```

Or use task: **Build (S32K344)** in Cursor.

### Debug

Select the matching launch configuration in Cursor (F5):
- **Debug S32K144 (J-Link)** â€” connects to S32K1xx board
- **Debug S32K344 (J-Link)** â€” connects to S32K3xx/4xx board

### Key differences S32K1xx â†’ S32K3xx/4xx

| | S32K1xx | S32K3xx/4xx |
|---|---|---|
| CPU flags | `-mcpu=cortex-m4 -mfpu=fpv4-sp-d16` | `-mcpu=cortex-m7 -mfpu=fpv5-d16` |
| Flash base | `0x00000000` | `0x00400000` |
| Flash Config Block | Yes (16 B at `0x400`) | No (uses IVT/Boot Header) |
| FPU | Single-precision | Double-precision |
| D-cache | No | Yes (enable in SystemInit if needed) |
| Stack size | 2 KB | 8 KB |