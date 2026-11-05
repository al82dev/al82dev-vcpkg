@echo off
setlocal DisableDelayedExpansion
call "%~dp0config.cmd"
if not defined CLANG_LLVM_ROOT goto :badconfig
if not defined CLANG_SYSROOT goto :badconfig
if not defined CLANG_TOOLSET_VERSION goto :badconfig
if not defined CLANG_SDK_VERSION goto :badconfig
if not defined CLANG_MSYS_ROOT goto :badconfig
set "VC_ROOT=%CLANG_SYSROOT%/toolsets/%CLANG_TOOLSET_VERSION%"
set "SDK_ROOT=%CLANG_SYSROOT%/windows-sdk/%CLANG_SDK_VERSION%"
if not defined VCPKG_CLANG_TRIPLET set "VCPKG_CLANG_TRIPLET=x64-windows-clang"
if /i "%VCPKG_CLANG_TRIPLET%"=="x64-windows-clang" goto :triplet_ok
if /i "%VCPKG_CLANG_TRIPLET%"=="x64-windows-clang-static" goto :triplet_ok
if /i "%VCPKG_CLANG_TRIPLET%"=="x64-windows-clang-static-md" goto :triplet_ok
echo Invalid VCPKG_CLANG_TRIPLET: %VCPKG_CLANG_TRIPLET% 1>&2
exit /b 2
:triplet_ok
for %%F in ("%~dp0..\vcpkg.exe" "%CLANG_LLVM_ROOT%/bin/clang-cl.exe" "%CLANG_LLVM_ROOT%/bin/lld-link.exe" "%CLANG_LLVM_ROOT%/bin/llvm-lib.exe" "%VC_ROOT%/include/vcruntime.h" "%VC_ROOT%/include/vector" "%VC_ROOT%/lib/x64/libcmt.lib" "%SDK_ROOT%/include/ucrt/stdio.h" "%SDK_ROOT%/include/um/Windows.h" "%SDK_ROOT%/lib/ucrt/x64/ucrt.lib" "%SDK_ROOT%/lib/um/x64/kernel32.lib" "%SDK_ROOT%/bin/x64/rc.exe" "%SDK_ROOT%/bin/x64/mt.exe") do if not exist "%%~F" (
    echo Required input missing: %%~F 1>&2
    exit /b 2
)
set "INCLUDE=%VC_ROOT%/include;%SDK_ROOT%/include/ucrt;%SDK_ROOT%/include/shared;%SDK_ROOT%/include/um;%SDK_ROOT%/include/winrt;%SDK_ROOT%/include/cppwinrt"
set "LIB=%VC_ROOT%/lib/x64;%SDK_ROOT%/lib/ucrt/x64;%SDK_ROOT%/lib/um/x64"
set "PATH=%CLANG_LLVM_ROOT%/bin;%SDK_ROOT%/bin/x64;%PATH%"
if not exist "%CLANG_MSYS_ROOT%/ucrt64/bin/pkg-config.exe" (
    echo pkg-config not found under MSYS root: %CLANG_MSYS_ROOT% 1>&2
    exit /b 2
)
if not exist "%CLANG_MSYS_ROOT%/usr/bin/bash.exe" (
    echo bash not found under MSYS root: %CLANG_MSYS_ROOT% 1>&2
    exit /b 2
)
set "PKG_CONFIG=%CLANG_MSYS_ROOT%/ucrt64/bin/pkg-config.exe"
rem Let vcpkg wrap the compiler selected by the toolchain for Autotools.
set "CC="
set "CXX="
set "VCPKG_DEFAULT_TRIPLET=%VCPKG_CLANG_TRIPLET%"
set "VCPKG_DEFAULT_HOST_TRIPLET=x64-windows-clang"
"%~dp0..\vcpkg.exe" %*
exit /b %ERRORLEVEL%
:badconfig
echo Missing configuration in %~dp0config.cmd 1>&2
exit /b 2
