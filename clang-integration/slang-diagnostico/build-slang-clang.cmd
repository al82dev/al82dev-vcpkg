@echo off
setlocal DisableDelayedExpansion
call clang-integration\config.cmd
set "VC_ROOT=%CLANG_SYSROOT%/toolsets/%CLANG_TOOLSET_VERSION%"
set "SDK_ROOT=%CLANG_SYSROOT%/windows-sdk/%CLANG_SDK_VERSION%"
set "INCLUDE=%VC_ROOT%/include;%SDK_ROOT%/include/ucrt;%SDK_ROOT%/include/shared;%SDK_ROOT%/include/um;%SDK_ROOT%/include/winrt;%SDK_ROOT%/include/cppwinrt"
set "LIB=%VC_ROOT%/lib/x64;%SDK_ROOT%/lib/ucrt/x64;%SDK_ROOT%/lib/um/x64"
set "PATH=%CLANG_LLVM_ROOT%/bin;%SDK_ROOT%/bin/x64;A:/al82dev-vcpkg/installed/x64-windows-clang/bin;%PATH%"
downloads\tools\cmake-4.4.4-windows\cmake-4.4.4-windows-x86_64\bin\cmake.exe --build buildtrees\shader-slang-clang-diagnostic --parallel 4 > buildtrees\shader-slang-clang-build.log 2>&1
exit /b %errorlevel%
