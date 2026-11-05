@echo off
setlocal DisableDelayedExpansion
if "%~1"=="" goto :usage
for %%I in ("%~1") do set "DEST=%%~fI"
for %%I in ("%~dp0..") do set "REPO=%%~fI"
if /i "%DEST%"=="%REPO%" goto :protected
if /i "%DEST%"=="C:\clang-llvm" goto :protected
if /i "%DEST%"=="A:\vc2026-runtime" goto :protected
if /i "%DEST:~0,14%"=="C:\clang-llvm\" goto :protected
if /i "%DEST:~0,18%"=="A:\vc2026-runtime\" goto :protected
if exist "%DEST%" (
    echo Destination already exists: %DEST% 1>&2
    exit /b 2
)
set "FILES=triplets\community\x64-windows-clang.cmake triplets\community\x64-windows-clang-static.cmake triplets\community\x64-windows-clang-static-md.cmake scripts\toolchains\windows-clang-standalone.cmake scripts\toolchains\clang-existing-msys.cmake ports\opengl\portfile.cmake ports\openssl\windows\portfile.cmake ports\gettext-libintl\portfile.cmake ports\gettext\portfile.cmake ports\gettext\clang-iconv-flush-signature.patch ports\gettext\clang-po-lex-attributes.patch ports\glew\portfile.cmake ports\glew\clang-vcruntime.patch ports\harfbuzz\portfile.cmake ports\icu\portfile.cmake ports\icu\clang-ecliptic-assignment.patch ports\ktx\portfile.cmake ports\libgeotiff\portfile.cmake ports\libgeotiff\clang-definition.patch ports\libpq\portfile.cmake ports\libpq\windows\clang-c99-probe.patch ports\libpq\windows\clang-windows-frontend.patch ports\libpq\windows\clang-cpuid-probe.patch ports\libflac\portfile.cmake ports\libflac\clang-windows-getenv.patch ports\libusb\portfile.cmake ports\libusb\vcpkg.json ports\libusb\clang-cmake\CMakeLists.txt ports\sdl3\portfile.cmake ports\sdl3\vcpkg.json clang-integration\config.cmd clang-integration\vcpkg-clang.cmd clang-integration\create-backup.cmd clang-integration\README.md clang-integration\CAMBIOS.md clang-integration\REVISION-CMAKE.md clang-integration\icu-diagnostico\repro.cmd clang-integration\icu-diagnostico\repro.sh clang-integration\icu-diagnostico\README.md CLANG-TRIPLETS-SCOPE-LOCK.md"
for %%F in (%FILES%) do if not exist "%REPO%\%%F" (
    echo Source missing: %%F 1>&2
    exit /b 1
)
mkdir "%DEST%" || exit /b 1
for %%F in (%FILES%) do (call :copy "%%F" || exit /b 1)
echo Configuration copied to %DEST%.
echo Copy restore.cmd and README.md from the previous backup, then check all hashes manually.
exit /b 0
:copy
for %%D in ("%DEST%\%~1") do if not exist "%%~dpD" mkdir "%%~dpD" || exit /b 1
copy /b "%REPO%\%~1" "%DEST%\%~1" >nul || exit /b 1
fc /b "%REPO%\%~1" "%DEST%\%~1" >nul || exit /b 1
exit /b 0
:protected
echo Protected destination. 1>&2
exit /b 2
:usage
echo Usage: create-backup.cmd "A:\new-backup-folder" 1>&2
exit /b 2
