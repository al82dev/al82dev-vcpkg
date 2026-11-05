# The standalone Windows triplet builds Slang from its pinned source instead
# of copying the upstream binary distribution.
if(NOT VERSION STREQUAL "2026.20" OR NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    message(FATAL_ERROR "The standalone Slang source recipe is pinned to 2026.20 and x64.")
endif()

get_filename_component(_clang_buildtrees_root "${CURRENT_BUILDTREES_DIR}" DIRECTORY)
get_filename_component(_clang_vcpkg_root "${_clang_buildtrees_root}" DIRECTORY)
set(_clang_llvm_md "${_clang_buildtrees_root}/llvm-clang-md-install")
set(_clang_zstd "${_clang_vcpkg_root}/installed/x64-windows-clang-static-md/share/zstd")
if(NOT EXISTS "${_clang_llvm_md}/lib/cmake/clang/ClangConfig.cmake" OR NOT EXISTS "${_clang_zstd}/zstdConfig.cmake")
    message(FATAL_ERROR "Standalone Slang needs the /MD LLVM auxiliary installation and static-MD zstd. See clang-integration/slang-diagnostico/README.md.")
endif()

find_program(_clang_git NAMES git git.cmd REQUIRED)
set(SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/clang-source-${VERSION}")
if(NOT EXISTS "${SOURCE_PATH}/.git")
    vcpkg_execute_required_process(
        COMMAND "${_clang_git}" clone --branch "v${VERSION}" --depth 1 --recurse-submodules --shallow-submodules
            https://github.com/shader-slang/slang.git "${SOURCE_PATH}"
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
        LOGNAME "clang-source-clone-${TARGET_TRIPLET}"
    )
endif()
execute_process(COMMAND "${_clang_git}" -C "${SOURCE_PATH}" rev-parse HEAD
    OUTPUT_VARIABLE _clang_source_revision OUTPUT_STRIP_TRAILING_WHITESPACE RESULT_VARIABLE _clang_git_result)
if(NOT _clang_git_result EQUAL 0 OR NOT _clang_source_revision STREQUAL "d9ede2dd5836afc0e9586da18d9236b171d0faa8")
    message(FATAL_ERROR "Unexpected Slang source revision in ${SOURCE_PATH}: ${_clang_source_revision}")
endif()
execute_process(COMMAND "${_clang_git}" -C "${SOURCE_PATH}" submodule status --recursive
    OUTPUT_VARIABLE _clang_submodule_status RESULT_VARIABLE _clang_git_result)
if(NOT _clang_git_result EQUAL 0 OR _clang_submodule_status MATCHES "(^|\n)[-+U]")
    message(FATAL_ERROR "Slang submodules are missing or do not match the pinned source revision.")
endif()
set(_clang_patch "${CMAKE_CURRENT_LIST_DIR}/clang-source-diagnostic.patch")
execute_process(COMMAND "${_clang_git}" -C "${SOURCE_PATH}" apply --check "${_clang_patch}"
    RESULT_VARIABLE _clang_patch_check OUTPUT_QUIET ERROR_QUIET)
if(_clang_patch_check EQUAL 0)
    vcpkg_execute_required_process(
        COMMAND "${_clang_git}" -C "${SOURCE_PATH}" apply "${_clang_patch}"
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
        LOGNAME "clang-source-patch-${TARGET_TRIPLET}"
    )
else()
    execute_process(COMMAND "${_clang_git}" -C "${SOURCE_PATH}" apply --reverse --check "${_clang_patch}"
        RESULT_VARIABLE _clang_patch_applied OUTPUT_QUIET ERROR_QUIET)
    if(NOT _clang_patch_applied EQUAL 0)
        message(FATAL_ERROR "Slang source patch cannot be applied or verified in ${SOURCE_PATH}.")
    endif()
endif()

# The previous upstream port distributed the same Release binaries in both
# configurations. Match that layout while the auxiliary LLVM is Release /MD.
set(_clang_previous_build_type "${VCPKG_BUILD_TYPE}")
set(VCPKG_BUILD_TYPE release)
if(VCPKG_CONCURRENCY GREATER 4)
    set(VCPKG_CONCURRENCY 4)
endif()
vcpkg_add_to_path(PREPEND "${CURRENT_INSTALLED_DIR}/bin")
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DFETCHCONTENT_FULLY_DISCONNECTED=OFF
        -DSLANG_LIB_TYPE=SHARED
        -DSLANG_ENABLE_TESTS=OFF
        -DSLANG_ENABLE_EXAMPLES=OFF
        -DSLANG_SLANG_LLVM_FLAVOR=USE_SYSTEM_LLVM
        "-DLLVM_DIR=${_clang_llvm_md}/lib/cmake/llvm"
        "-DClang_DIR=${_clang_llvm_md}/lib/cmake/clang"
        "-DSLANG_CLANG_ZSTD_DIR=${_clang_zstd}"
        "-DCMAKE_PROJECT_INCLUDE=${CMAKE_CURRENT_LIST_DIR}/clang-project-include.cmake"
    OPTIONS_RELEASE
        -DBUILD_SHARED_LIBS=OFF
)
vcpkg_cmake_build(TARGET copy-gfx-slang-modules)
vcpkg_cmake_install()
vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}" --install "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        --prefix "${CURRENT_PACKAGES_DIR}" --component slang-llvm
    WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
    LOGNAME "clang-install-llvm-${TARGET_TRIPLET}"
)
vcpkg_cmake_config_fixup(CONFIG_PATH cmake PACKAGE_NAME slang)

file(GLOB _clang_runtime_dlls "${CURRENT_PACKAGES_DIR}/bin/*.dll")
file(GLOB _clang_runtime_modules "${CURRENT_PACKAGES_DIR}/bin/slang-standard-module-*" "${CURRENT_PACKAGES_DIR}/bin/*.slang")
file(COPY ${_clang_runtime_dlls} ${_clang_runtime_modules} DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
file(COPY "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug")
vcpkg_copy_tools(TOOL_NAMES slangc slangd slangi slang AUTO_CLEAN)
foreach(_clang_tool IN ITEMS slangc slangd slangi slang)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/slang/slangTargets-release.cmake"
        "\${_IMPORT_PREFIX}/bin/${_clang_tool}.exe" "\${_IMPORT_PREFIX}/tools/${PORT}/${_clang_tool}.exe" IGNORE_UNCHANGED)
endforeach()
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/slang/slangConfig.cmake"
    [[HINTS "${PACKAGE_PREFIX_DIR}/bin" ENV PATH]]
    [[PATHS "${PACKAGE_PREFIX_DIR}/tools/shader-slang" NO_DEFAULT_PATH REQUIRED]])
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/slang/slangConfigVersion.cmake"
    [[if("${CMAKE_SIZEOF_VOID_P}" STREQUAL ""]]
    [[if(#[=[ host tool ]=] "TRUE"]])
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(GLOB _clang_licenses LIST_DIRECTORIES false "${SOURCE_PATH}/LICENSES/*.txt" "${SOURCE_PATH}/external/*/LICENSE*")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" ${_clang_licenses})
set(VCPKG_BUILD_TYPE "${_clang_previous_build_type}")
