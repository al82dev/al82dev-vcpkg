# Revisión de recetas y CMake: lista de paquetes

Estado: **EN CURSO; CMakeLists de proyectos fuente y validación de dependencias pendientes.** Este inventario no es una aprobación de compatibilidad.

La lista de entrada es `X:/scripts/packages_mingw64_v2.txt`. Se observaron 157 entradas distintas; 156 tenían `portfile.cmake` y `threadpool` no tenía port local. No se encontraron `CMakeLists.txt` bajo `buildtrees/<port>/src` para los ports de la lista al momento de la consulta. Los ports que no usan CMake también requieren revisar su sistema de construcción. La disponibilidad posterior de fuentes puede cambiar.

Se recorrieron los manifiestos de forma conservadora incluyendo todas las características y plataformas: 393 nombres y 2412 referencias, con `threadpool` sin manifiesto local. **Ese conjunto es una sobreaproximación, no la resolución real** de las características elegidas. La revisión estática de recetas identificó, entre otros, rutas de SDK, MSYS2 y MSBuild en `ktx`, `opengl`, `vcpkg-msbuild`, `gmp`, `python3`, `cppwinrt` y `opencl`; algunas pertenecen a plataformas o características que podrían no estar activas. Cada caso requiere trazar condiciones y dependencias antes de modificarlo.

`gettext-libintl` tiene un ajuste local para probar `llvm-ar`; `ktx` tiene un ajuste local para usar herramientas MSYS2 existentes. Ambos están **NO VERIFICADOS**. El usuario ejecutará las compilaciones. Los portfiles completos se conservan en el respaldo y deben compararse tras actualizar vcpkg.

## Inspección parcial de fuentes publicadas

- [KTX 4.4.2, CMakeLists principal](https://github.com/KhronosGroup/KTX-Software/blob/v4.4.2/CMakeLists.txt): se observaron ramas para frontend MSVC y Clang, y subdirectorios condicionales. Falta seguir módulos, fuentes parchadas y opciones efectivas. **NO VERIFICADO**.
- [Assimp 6.0.5, CMakeLists principal](https://github.com/assimp/assimp/blob/v6.0.5/CMakeLists.txt): se observó una rama específica para Clang en Windows y opciones bajo `MSVC`. Falta seguir módulos y parches efectivos. **NO VERIFICADO**.
- [SDL 3.4.18, CMakeLists principal](https://github.com/libsdl-org/SDL/blob/release-3.4.18/CMakeLists.txt): se observaron ramas para frontend Clang y ensamblador condicional. Falta evaluar opciones del port, módulos y características solicitadas. **NO VERIFICADO**.

Estas consultas son parciales y no representan la revisión íntegra de ningún proyecto ni de su versión una vez aplicados los parches de vcpkg.

La tabla registra únicamente presencia del port y de un `CMakeLists.txt` en el árbol local, y cuenta referencias del manifiesto base más todas las características, sin filtrar condiciones ni eliminar duplicados. No significa que se hayan examinado o construido todos sus proyectos fuente.

| Entrada solicitada | Portfile local | CMakeLists fuente local | Referencias del manifiesto |
| --- | --- | --- | ---: |
| `aom` | Sí | No | 2 |
| `assimp` | Sí | No | 12 |
| `boost-algorithm` | Sí | No | 18 |
| `boost-align` | Sí | No | 5 |
| `boost-array` | Sí | No | 5 |
| `boost-assert` | Sí | No | 3 |
| `boost-atomic` | Sí | No | 9 |
| `boost-bind` | Sí | No | 4 |
| `boost-chrono` | Sí | No | 16 |
| `boost-cmake` | Sí | No | 2 |
| `boost-compat` | Sí | No | 5 |
| `boost-concept-check` | Sí | No | 5 |
| `boost-config` | Sí | No | 2 |
| `boost-container` | Sí | No | 6 |
| `boost-container-hash` | Sí | No | 5 |
| `boost-conversion` | Sí | No | 6 |
| `boost-core` | Sí | No | 5 |
| `boost-date-time` | Sí | No | 17 |
| `boost-describe` | Sí | No | 4 |
| `boost-detail` | Sí | No | 6 |
| `boost-exception` | Sí | No | 9 |
| `boost-function` | Sí | No | 7 |
| `boost-function-types` | Sí | No | 8 |
| `boost-functional` | Sí | No | 11 |
| `boost-fusion` | Sí | No | 12 |
| `boost-headers` | Sí | No | 1 |
| `boost-integer` | Sí | No | 7 |
| `boost-intrusive` | Sí | No | 5 |
| `boost-io` | Sí | No | 3 |
| `boost-iterator` | Sí | No | 12 |
| `boost-lexical-cast` | Sí | No | 6 |
| `boost-move` | Sí | No | 3 |
| `boost-mp11` | Sí | No | 3 |
| `boost-mpl` | Sí | No | 8 |
| `boost-numeric-conversion` | Sí | No | 9 |
| `boost-optional` | Sí | No | 7 |
| `boost-predef` | Sí | No | 3 |
| `boost-preprocessor` | Sí | No | 3 |
| `boost-range` | Sí | No | 18 |
| `boost-ratio` | Sí | No | 3 |
| `boost-regex` | Sí | No | 10 |
| `boost-smart-ptr` | Sí | No | 6 |
| `boost-static-assert` | Sí | No | 3 |
| `boost-system` | Sí | No | 9 |
| `boost-thread` | Sí | No | 26 |
| `boost-throw-exception` | Sí | No | 4 |
| `boost-tokenizer` | Sí | No | 8 |
| `boost-tuple` | Sí | No | 5 |
| `boost-type-traits` | Sí | No | 3 |
| `boost-typeof` | Sí | No | 3 |
| `boost-uninstall` | Sí | No | 0 |
| `boost-unordered` | Sí | No | 9 |
| `boost-utility` | Sí | No | 9 |
| `boost-variant2` | Sí | No | 5 |
| `boost-winapi` | Sí | No | 4 |
| `box2d` | Sí | No | 2 |
| `box3d` | Sí | No | 2 |
| `brotli` | Sí | No | 2 |
| `bullet3` | Sí | No | 3 |
| `bzip2[tool]` | Sí | No | 1 |
| `cglm` | Sí | No | 2 |
| `cgltf` | Sí | No | 0 |
| `chipmunk` | Sí | No | 2 |
| `cpu-features` | Sí | No | 2 |
| `cpuid` | Sí | No | 2 |
| `cpuinfo` | Sí | No | 2 |
| `curl[non-http,ssl,sspi]` | Sí | No | 27 |
| `dav1d` | Sí | No | 1 |
| `dirent` | Sí | No | 0 |
| `double-conversion` | Sí | No | 2 |
| `draco` | Sí | No | 2 |
| `egl-registry` | Sí | No | 0 |
| `eigen3` | Sí | No | 2 |
| `fluidsynth` | Sí | No | 7 |
| `freetype[brotli,bzip2,png,zlib]` | Sí | No | 6 |
| `ftgl` | Sí | No | 4 |
| `gcem` | Sí | No | 2 |
| `gettext[tools]` | Sí | No | 3 |
| `gettext-libintl` | Sí | No | 2 |
| `glew` | Sí | No | 3 |
| `gli` | Sí | No | 3 |
| `glib` | Sí | No | 9 |
| `glm` | Sí | No | 2 |
| `glslang` | Sí | No | 3 |
| `harfbuzz[freetype,glib]` | Sí | No | 11 |
| `highway` | Sí | No | 2 |
| `icu[tools]` | Sí | No | 3 |
| `imgui[docking-experimental,freetype,opengl2-binding,opengl3-binding,sdl3-binding]` | Sí | No | 15 |
| `jasper` | Sí | No | 3 |
| `jhasse-poly2tri` | Sí | No | 2 |
| `joltphysics` | Sí | No | 2 |
| `ktx` | Sí | No | 6 |
| `kubazip` | Sí | No | 2 |
| `lcms` | Sí | No | 3 |
| `libavif[aom,dav1d]` | Sí | No | 6 |
| `libdwarf` | Sí | No | 4 |
| `libffi` | Sí | No | 2 |
| `libflac[stack-protector]` | Sí | No | 3 |
| `libgeotiff` | Sí | No | 5 |
| `libiconv` | Sí | No | 2 |
| `libigl` | Sí | No | 15 |
| `libjpeg-turbo` | Sí | No | 4 |
| `libjxl` | Sí | No | 7 |
| `liblzma` | Sí | No | 2 |
| `libogg` | Sí | No | 2 |
| `libpng` | Sí | No | 4 |
| `libpq[lz4,openssl,zlib]` | Sí | No | 13 |
| `libraw` | Sí | No | 6 |
| `libsass` | Sí | No | 1 |
| `libsigcpp` | Sí | No | 2 |
| `libspng` | Sí | No | 3 |
| `libtheora` | Sí | No | 3 |
| `libtommath` | Sí | No | 2 |
| `libusb` | Sí | No | 2 |
| `libvorbis` | Sí | No | 3 |
| `libwebp[libwebpmux,nearlossless,simd,unicode]` | Sí | No | 32 |
| `libxmp[depackers,prowizard]` | Sí | No | 2 |
| `libyuv` | Sí | No | 4 |
| `lz4` | Sí | No | 2 |
| `md4c` | Sí | No | 2 |
| `minizip` | Sí | No | 5 |
| `mmx` | Sí | No | 0 |
| `mpg123` | Sí | No | 3 |
| `nlohmann-json` | Sí | No | 2 |
| `opengl` | Sí | No | 1 |
| `opengl-registry` | Sí | No | 1 |
| `openssl` | Sí | No | 3 |
| `opus` | Sí | No | 2 |
| `opusfile` | Sí | No | 5 |
| `pcre2[jit,platform-default-features]` | Sí | No | 3 |
| `polyclipping` | Sí | No | 2 |
| `proj[net,tiff]` | Sí | No | 7 |
| `pugixml` | Sí | No | 2 |
| `qtbase[async-io,brotli,concurrent,dnslookup,doubleconversion,freetype,future,gui,harfbuzz,icu,jpeg,network,opengl,openssl,pcre2,png,sessionmanager,sql-psql,sql-sqlite,sql,testlib,thread,widgets,zstd]` | Sí | No | 75 |
| `rapidjson` | Sí | No | 2 |
| `reactphysics3d` | Sí | No | 2 |
| `sdl3[dbus,libusb,vulkan]` | Sí | No | 6 |
| `sdl3-image[avif,jpeg,jxl,png,tiff,webp]` | Sí | No | 9 |
| `sdl3-mixer[fluidsynth,libflac,libvorbis,libxmp,mpg123,opusfile,wavpack]` | Sí | No | 10 |
| `sdl3-net` | Sí | No | 3 |
| `sdl3-ttf` | Sí | No | 6 |
| `shader-slang` | Sí | No | 1 |
| `sqlite3[json1,tool]` | Sí | No | 4 |
| `stb` | Sí | No | 0 |
| `threadpool` | No | No | 0 |
| `tiff[jpeg,lzma,zip]` | Sí | No | 11 |
| `tinyxml2` | Sí | No | 2 |
| `utfcpp` | Sí | No | 2 |
| `vcpkg-boost` | Sí | No | 2 |
| `vcpkg-cmake` | Sí | No | 0 |
| `vcpkg-cmake-config` | Sí | No | 0 |
| `vcpkg-cmake-get-vars` | Sí | No | 1 |
| `vcpkg-make` | Sí | No | 1 |
| `vcpkg-tool-meson` | Sí | No | 1 |
| `wavpack` | Sí | No | 2 |
| `zlib` | Sí | No | 2 |
| `zstd` | Sí | No | 2 |

## Pendiente

- Obtener acceso a los proyectos fuente exactos y revisar sus `CMakeLists.txt` y módulos, sin compilar.
- Resolver las características y condiciones reales para Windows x64 y recorrer sus dependencias transitivas; no sustituirlas por el conjunto conservador.
- Investigar los candidatos solo cuando su ruta aplique; conservar `NO VERIFICADO` donde falte evidencia.
- Identificar la procedencia o ausencia de `threadpool` antes de asignarle un sustituto.
- Registrar cada cambio, sincronizar el respaldo y dejar que el usuario efectúe la construcción.
