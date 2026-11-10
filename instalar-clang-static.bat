@echo off
setlocal DisableDelayedExpansion
cd /d "%~dp0" || exit /b 1
set "VCPKG_CLANG_TRIPLET=x64-windows-clang-static"
call "%~dp0clang-integration\vcpkg-clang.cmd" install ^
  aom assimp boost-algorithm boost-align boost-array boost-assert ^
  boost-atomic boost-bind boost-chrono boost-cmake boost-compat boost-concept-check ^
  boost-config boost-container boost-container-hash boost-conversion boost-core boost-date-time ^
  boost-describe boost-detail boost-exception boost-function boost-function-types boost-functional ^
  boost-fusion boost-headers boost-integer boost-intrusive boost-io boost-iterator ^
  boost-lexical-cast boost-move boost-mp11 boost-mpl boost-numeric-conversion boost-optional ^
  boost-predef boost-preprocessor boost-range boost-ratio boost-regex boost-smart-ptr ^
  boost-static-assert boost-system boost-thread boost-throw-exception boost-tokenizer boost-tuple ^
  boost-type-traits boost-typeof boost-uninstall boost-unordered boost-utility boost-variant2 ^
  boost-winapi box2d box3d brotli bullet3 bzip2[tool] ^
  cglm cgltf chipmunk cpu-features cpuid cpuinfo ^
  curl[ssl,sspi] dav1d dirent double-conversion draco egl-registry ^
  eigen3 fluidsynth freetype[brotli,bzip2,png,zlib] ftgl gcem gettext[tools] ^
  gettext-libintl glew gli glib glm glslang ^
  harfbuzz[freetype,glib] highway icu[tools] imgui[docking-experimental,freetype,opengl2-binding,opengl3-binding,sdl3-binding] jasper jhasse-poly2tri ^
  joltphysics ktx kubazip lcms libavif[aom,dav1d] libdwarf ^
  libffi libflac[stack-protector] libgeotiff libiconv libigl libjpeg-turbo ^
  libjxl liblzma libogg libpng libpq[lz4,openssl,zlib] libraw ^
  libsass libsigcpp libspng libtheora libtommath libusb ^
  libvorbis libwebp[libwebpmux,nearlossless,simd,unicode] libxmp[depackers,prowizard] libyuv lz4 md4c ^
  minizip mmx mpg123 nlohmann-json opengl opengl-registry ^
  openssl opus opusfile pcre2[jit,platform-default-features] polyclipping proj[net,tiff] ^
  pugixml rapidjson reactphysics3d sdl3[dbus,libusb,vulkan] sdl3-image[avif,jpeg,jxl,png,tiff,webp] sdl3-mixer[fluidsynth,libflac,libvorbis,libxmp,mpg123,opusfile,wavpack] ^
  sdl3-net sdl3-ttf shader-slang sqlite3[json1,tool] stb tiff[jpeg,lzma,zip] ^
  tinyxml2 utfcpp vcpkg-boost:x64-windows-clang vcpkg-cmake:x64-windows-clang vcpkg-cmake-config:x64-windows-clang vcpkg-cmake-get-vars:x64-windows-clang ^
  vcpkg-make:x64-windows-clang vcpkg-tool-meson:x64-windows-clang wavpack zlib zstd ^
  --triplet=x64-windows-clang-static --host-triplet=x64-windows-clang --allow-unsupported --no-binarycaching --editable --recurse
exit /b %ERRORLEVEL%
