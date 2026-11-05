@echo off
setlocal DisableDelayedExpansion
call clang-integration\config.cmd
set "VC_ROOT=%CLANG_SYSROOT%/toolsets/%CLANG_TOOLSET_VERSION%"
set "SDK_ROOT=%CLANG_SYSROOT%/windows-sdk/%CLANG_SDK_VERSION%"
set "INCLUDE=%VC_ROOT%/include;%SDK_ROOT%/include/ucrt;%SDK_ROOT%/include/shared;%SDK_ROOT%/include/um;%SDK_ROOT%/include/winrt;%SDK_ROOT%/include/cppwinrt"
set "LIB=%VC_ROOT%/lib/x64;%SDK_ROOT%/lib/ucrt/x64;%SDK_ROOT%/lib/um/x64"
set "PATH=%CLANG_LLVM_ROOT%/bin;%SDK_ROOT%/bin/x64;%PATH%"
downloads\tools\cmake-4.4.4-windows\cmake-4.4.4-windows-x86_64\bin\cmake.exe -S buildtrees\shader-slang-source-v2026.20 -B buildtrees\shader-slang-clang-diagnostic -G Ninja -DCMAKE_MAKE_PROGRAM=A:/al82dev-vcpkg/downloads/tools/ninja-1.13.2-windows/ninja.exe -DCMAKE_TOOLCHAIN_FILE=A:/al82dev-vcpkg/scripts/toolchains/windows-clang-standalone.cmake -DVCPKG_TARGET_ARCHITECTURE=x64 -DVCPKG_CRT_LINKAGE=dynamic -DCMAKE_BUILD_TYPE=Release -DSLANG_ENABLE_TESTS=OFF -DSLANG_ENABLE_EXAMPLES=OFF -DSLANG_SLANG_LLVM_FLAVOR=USE_SYSTEM_LLVM -DLLVM_DIR=C:/clang-llvm/lib/cmake/llvm -DClang_DIR=C:/clang-llvm/lib/cmake/clang -DSLANG_VERSION=2026.20 -DCMAKE_PREFIX_PATH=A:/al82dev-vcpkg/installed/x64-windows-clang -DMSVC_DIA_SDK_DIR=A:/vc2026-runtime/toolsets/14.52.36815/dia -Dzstd_DIR=A:/al82dev-vcpkg/installed/x64-windows-clang-static-md/share/zstd -DDIASDK_LIBRARIES=A:/vc2026-runtime/toolsets/14.52.36815/dia/lib/x64/diaguids.lib -DCMAKE_PROJECT_INCLUDE=A:/al82dev-vcpkg/buildtrees/slang-diagnostic-deps.cmake -DSPIRV_WERROR=OFF -DSLANG_RHI_BUILD_TESTS=OFF -DSLANG_RHI_BUILD_EXAMPLES=OFF
exit /b %errorlevel%
