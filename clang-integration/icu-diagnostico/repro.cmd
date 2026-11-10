@echo off
setlocal DisableDelayedExpansion
call "%~dp0..\config.cmd"
if not defined CLANG_LLVM_ROOT exit /b 2
if not defined CLANG_MSYS_ROOT exit /b 2
set "PATH=%CLANG_MSYS_ROOT%\usr\bin;%PATH%"
if not defined ASTRO_INPUT set "ASTRO_INPUT=%CLANG_MSYS_ROOT%/tmp/astro-02d6d5.cpp"
if not exist "%CLANG_MSYS_ROOT%\usr\bin\bash.exe" (
  echo No se encontro bash en el MSYS2 configurado. 1>&2
  exit /b 2
)
"%CLANG_MSYS_ROOT%\usr\bin\bash.exe" --noprofile --norc "%~dp0repro.sh"
exit /b %errorlevel%
