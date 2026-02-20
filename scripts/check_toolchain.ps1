# Xbattery S32K144 - Toolchain check script
# Verifies arm-none-eabi-gcc, CMake, GDB, and optionally J-Link/OpenOCD

$ErrorActionPreference = "Continue"
$allOk = $true

function Test-Command {
    param([string]$Name, [string]$Arg = "--version", [switch]$Optional)
    $exe = Get-Command $Name -ErrorAction SilentlyContinue
    if ($exe) {
        Write-Host "[OK] $Name found: $($exe.Source)" -ForegroundColor Green
        try {
            & $Name $Arg 2>&1 | Out-Null
        } catch { }
        return $true
    } else {
        if ($Optional) {
            Write-Host "[--] $Name not found (optional)" -ForegroundColor Gray
        } else {
            Write-Host "[FAIL] $Name not found. Add ARM GNU toolchain to PATH." -ForegroundColor Red
            $script:allOk = $false
        }
        return $false
    }
}

Write-Host "`n=== Xbattery S32K144 toolchain check ===" -ForegroundColor Cyan
Write-Host ""

# Required: ARM GCC and binutils (same package)
Test-Command "arm-none-eabi-gcc" "-v" | Out-Null
Test-Command "arm-none-eabi-ld" "-v" | Out-Null
Test-Command "arm-none-eabi-objcopy" "-V" | Out-Null

# Required: GDB for Cortex-Debug
Test-Command "arm-none-eabi-gdb" "-v" | Out-Null

# Required: CMake
Test-Command "cmake" "--version" | Out-Null

# Optional: debug servers
Test-Command "JLinkGDBServerCL" "-?" -Optional | Out-Null
Test-Command "openocd" "--version" -Optional | Out-Null

Write-Host ""
if ($allOk) {
    Write-Host "Toolchain check passed. You can configure and build the project." -ForegroundColor Green
} else {
    Write-Host "Fix missing tools (see SETUP.md) and run this script again." -ForegroundColor Yellow
    exit 1
}
