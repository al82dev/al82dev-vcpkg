@echo off
setlocal DisableDelayedExpansion
call clang-integration\config.cmd
set "VC_ROOT=%CLANG_SYSROOT%/toolsets/%CLANG_TOOLSET_VERSION%"
set "SDK_ROOT=%CLANG_SYSROOT%/windows-sdk/%CLANG_SDK_VERSION%"
set "INCLUDE=%VC_ROOT%/include;%SDK_ROOT%/include/ucrt;%SDK_ROOT%/include/shared;%SDK_ROOT%/include/um;%SDK_ROOT%/include/winrt;%SDK_ROOT%/include/cppwinrt"
set "LIB=%VC_ROOT%/lib/x64;%SDK_ROOT%/lib/ucrt/x64;%SDK_ROOT%/lib/um/x64"
set "PATH=%CLANG_LLVM_ROOT%/bin;%SDK_ROOT%/bin/x64;A:/al82dev-vcpkg/installed/x64-windows-clang/bin;%PATH%"
downloads\tools\cmake-4.4.4-windows\cmake-4.4.4-windows-x86_64\bin\cmake.exe -S C:/llvm-project-23.1.0.src/llvm -B buildtrees/llvm-clang-md -G Ninja -DCMAKE_MAKE_PROGRAM=A:/al82dev-vcpkg/downloads/tools/ninja-1.13.2-windows/ninja.exe -DCMAKE_TOOLCHAIN_FILE=A:/al82dev-vcpkg/scripts/toolchains/windows-clang-standalone.cmake -DVCPKG_TARGET_ARCHITECTURE=x64 -DVCPKG_CRT_LINKAGE=dynamic -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=A:/al82dev-vcpkg/buildtrees/llvm-clang-md-install -DLLVM_ENABLE_PROJECTS=clang "-DLLVM_TARGETS_TO_BUILD=AArch64;ARM;X86;BPF;WebAssembly;RISCV;NVPTX" -DLLVM_USE_CRT_RELEASE=MD -DLLVM_ENABLE_RTTI=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_ZLIB=ON -DLLVM_ENABLE_ZSTD=ON -DLLVM_TABLEGEN=C:/clang-llvm/bin/llvm-tblgen.exe -DCLANG_TABLEGEN=C:/clang-llvm/bin/clang-tblgen.exe -DCMAKE_PREFIX_PATH=A:/al82dev-vcpkg/installed/x64-windows-clang -DMSVC_DIA_SDK_DIR=A:/vc2026-runtime/toolsets/14.52.36815/dia -DDIASDK_LIBRARIES=A:/vc2026-runtime/toolsets/14.52.36815/dia/lib/x64/diaguids.lib -DCMAKE_PROJECT_INCLUDE=A:/al82dev-vcpkg/buildtrees/slang-diagnostic-deps.cmake -DLLVM_PARALLEL_LINK_JOBS=2 -DLLVM_ENABLE_DIA_SDK=OFF
exit /b %errorlevel%
