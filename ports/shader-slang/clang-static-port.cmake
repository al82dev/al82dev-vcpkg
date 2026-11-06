# Build the public archives with the selected static CRT. The upstream LLVM
# backend is a separately loaded module; build it in Release against the
# configured Clang installation and use that module with either archive.
file(STRINGS "${_clang_vcpkg_root}/clang-integration/config.cmd" _clang_root_lines
    REGEX "^set \"CLANG_LLVM_ROOT=[^\"]+\"$")
list(LENGTH _clang_root_lines _clang_root_count)
if(NOT _clang_root_count EQUAL 1)
    message(FATAL_ERROR "Configure exactly one CLANG_LLVM_ROOT in clang-integration/config.cmd.")
endif()
list(GET _clang_root_lines 0 _clang_root_line)
string(REGEX REPLACE "^set \"CLANG_LLVM_ROOT=([^\"]+)\"$" "\\1" _clang_llvm_root "${_clang_root_line}")
file(STRINGS "${_clang_vcpkg_root}/clang-integration/config.cmd" _clang_toolset_lines
    REGEX "^set \"CLANG_TOOLSET_VERSION=[^\"]+\"$")
list(LENGTH _clang_toolset_lines _clang_toolset_count)
if(NOT _clang_toolset_count EQUAL 1)
    message(FATAL_ERROR "Configure exactly one CLANG_TOOLSET_VERSION in clang-integration/config.cmd.")
endif()
list(GET _clang_toolset_lines 0 _clang_toolset_line)
string(REGEX REPLACE "^set \"CLANG_TOOLSET_VERSION=([^\"]+)\"$" "\\1" _clang_toolset "${_clang_toolset_line}")
set(_clang_dia "${_CLANG_SYSROOT}/toolsets/${_clang_toolset}/dia")
if(NOT EXISTS "${_clang_llvm_root}/lib/cmake/clang/ClangConfig.cmake")
    message(FATAL_ERROR "The configured Clang root needs its matching LLVM and Clang CMake packages.")
endif()
set(_clang_zstd_static "${CURRENT_INSTALLED_DIR}/share/zstd")
if(NOT EXISTS "${_clang_zstd_static}/zstdConfig.cmake")
    message(FATAL_ERROR "The static shader-slang build needs the target triplet's zstd package.")
endif()
if(VCPKG_CONCURRENCY GREATER 4)
    set(VCPKG_CONCURRENCY 4)
endif()
vcpkg_add_to_path(PREPEND "${CURRENT_INSTALLED_DIR}/bin")
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DFETCHCONTENT_FULLY_DISCONNECTED=OFF
        -DSLANG_LIB_TYPE=STATIC
        -DSLANG_ENABLE_TESTS=OFF
        -DSLANG_ENABLE_EXAMPLES=OFF
        "-DLLVM_DIR=${_clang_llvm_root}/lib/cmake/llvm"
        "-DClang_DIR=${_clang_llvm_root}/lib/cmake/clang"
        "-DMSVC_DIA_SDK_DIR=${_clang_dia}"
        "-DDIASDK_LIBRARIES=${_clang_dia}/lib/x64/diaguids.lib"
        "-DSLANG_CLANG_ZSTD_DIR=${_clang_zstd_static}"
        "-DCMAKE_PROJECT_INCLUDE=${CMAKE_CURRENT_LIST_DIR}/clang-project-include.cmake"
    OPTIONS_RELEASE
        -DSLANG_SLANG_LLVM_FLAVOR=USE_SYSTEM_LLVM
        "-DZLIB_LIBRARY=${CURRENT_INSTALLED_DIR}/lib/zs.lib"
        "-DZLIB_INCLUDE_DIR=${CURRENT_INSTALLED_DIR}/include"
    OPTIONS_DEBUG
        -DSLANG_SLANG_LLVM_FLAVOR=DISABLE
    MAYBE_UNUSED_VARIABLES LLVM_DIR Clang_DIR ZLIB_LIBRARY ZLIB_INCLUDE_DIR MSVC_DIA_SDK_DIR DIASDK_LIBRARIES
)
vcpkg_cmake_build(TARGET copy-gfx-slang-modules)
vcpkg_cmake_install()
vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}" --install "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        --prefix "${CURRENT_PACKAGES_DIR}" --component slang-llvm
    WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
    LOGNAME "clang-static-install-llvm-${TARGET_TRIPLET}"
)

# Upstream's exported static targets omit their private archive dependencies.
# Preserve those archives and provide a relocatable link interface for clients.
foreach(_clang_cfg IN ITEMS release debug)
    if(_clang_cfg STREQUAL "release")
        set(_clang_build "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel")
        set(_clang_output "${CURRENT_PACKAGES_DIR}/lib/slang-internal")
        set(_clang_config Release)
    else()
        set(_clang_build "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg")
        set(_clang_output "${CURRENT_PACKAGES_DIR}/debug/lib/slang-internal")
        set(_clang_config Debug)
    endif()
    file(INSTALL
        "${_clang_build}/${_clang_config}/lib/compiler-core.lib"
        "${_clang_build}/${_clang_config}/lib/core.lib"
        "${_clang_build}/external/miniz/miniz.lib"
        "${_clang_build}/external/lz4/build/cmake/lz4.lib"
        "${_clang_build}/external/cmark/src/cmark-gfm.lib"
        DESTINATION "${_clang_output}")
endforeach()
vcpkg_cmake_config_fixup(CONFIG_PATH cmake PACKAGE_NAME slang)
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools" "${CURRENT_PACKAGES_DIR}/debug/tools")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
file(RENAME "${CURRENT_PACKAGES_DIR}/debug/bin" "${CURRENT_PACKAGES_DIR}/debug/tools/${PORT}")
file(COPY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/slang-llvm.dll"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/tools/${PORT}")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/share/doc/slang/generated/tests/_meta/remediations"
    "${CURRENT_PACKAGES_DIR}/share/doc/slang/generated/tests/_meta/reviews")
foreach(_clang_cfg IN ITEMS release debug)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/slang/slangTargets-${_clang_cfg}.cmake"
        "\${_IMPORT_PREFIX}/debug/bin/" "\${_IMPORT_PREFIX}/debug/tools/${PORT}/" IGNORE_UNCHANGED)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/slang/slangTargets-${_clang_cfg}.cmake"
        "\${_IMPORT_PREFIX}/bin/" "\${_IMPORT_PREFIX}/tools/${PORT}/" IGNORE_UNCHANGED)
endforeach()
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/slang/slangConfig.cmake"
    [[HINTS "${PACKAGE_PREFIX_DIR}/bin" ENV PATH]]
    [[PATHS "${PACKAGE_PREFIX_DIR}/tools/shader-slang" NO_DEFAULT_PATH REQUIRED]])
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/slang/slangConfigVersion.cmake"
    [[if("${CMAKE_SIZEOF_VOID_P}" STREQUAL ""]]
    [[if(#[=[ host tool ]=] "TRUE"]])
file(READ "${CMAKE_CURRENT_LIST_DIR}/clang-static-consumer.cmake" _clang_static_consumer)
file(APPEND "${CURRENT_PACKAGES_DIR}/share/slang/slangConfig.cmake" "\n${_clang_static_consumer}\n")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/clang-static-usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME usage)
file(GLOB _clang_licenses LIST_DIRECTORIES false "${SOURCE_PATH}/LICENSES/*.txt" "${SOURCE_PATH}/external/*/LICENSE*")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" ${_clang_licenses})
