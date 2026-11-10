# Windows x64 CMake toolchain using the pinned local LLVM and sysroot.
# These paths are inputs only; they are never destinations for generated files.
if(NOT _VCPKG_STANDALONE_CLANG_TOOLCHAIN)
    set(_VCPKG_STANDALONE_CLANG_TOOLCHAIN 1)

    if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        message(FATAL_ERROR "The standalone Clang toolchain supports only the configured x64 sysroot.")
    endif()

    file(STRINGS "${CMAKE_CURRENT_LIST_DIR}/../../clang-integration/config.cmd" _config)
    foreach(_key IN ITEMS CLANG_LLVM_ROOT CLANG_SYSROOT CLANG_TOOLSET_VERSION CLANG_SDK_VERSION)
        set(_found OFF)
        foreach(_line IN LISTS _config)
            if(_line MATCHES "^set \"${_key}=([^\"]+)\"$")
                if(_found)
                    message(FATAL_ERROR "Duplicate configuration setting: ${_key}")
                endif()
                set("_${_key}" "${CMAKE_MATCH_1}")
                set(_found ON)
            endif()
        endforeach()
        if(NOT _found)
            message(FATAL_ERROR "Missing configuration setting: ${_key}")
        endif()
    endforeach()
    set(_clang_root "${_CLANG_LLVM_ROOT}")
    set(_sysroot "${_CLANG_SYSROOT}")
    set(_toolset "${_CLANG_TOOLSET_VERSION}")
    set(_sdk "${_CLANG_SDK_VERSION}")
    set(_vc_root "${_sysroot}/toolsets/${_toolset}")
    set(_sdk_root "${_sysroot}/windows-sdk/${_sdk}")

    foreach(_file IN ITEMS
        "${_clang_root}/bin/clang-cl.exe"
        "${_clang_root}/bin/lld-link.exe"
        "${_clang_root}/bin/llvm-lib.exe"
        "${_clang_root}/bin/llvm-ml64.exe"
        "${_vc_root}/include/vcruntime.h"
        "${_vc_root}/include/vector"
        "${_vc_root}/lib/x64/libcmt.lib"
        "${_sdk_root}/include/ucrt/stdio.h"
        "${_sdk_root}/include/um/Windows.h"
        "${_sdk_root}/lib/ucrt/x64/ucrt.lib"
        "${_sdk_root}/lib/um/x64/kernel32.lib"
        "${_sdk_root}/bin/x64/rc.exe"
        "${_sdk_root}/bin/x64/mt.exe")
        if(NOT EXISTS "${_file}")
            message(FATAL_ERROR "Standalone Clang toolchain input missing: ${_file}")
        endif()
    endforeach()

    set(CMAKE_C_COMPILER "${_clang_root}/bin/clang-cl.exe" CACHE FILEPATH "" FORCE)
    set(CMAKE_CXX_COMPILER "${_clang_root}/bin/clang-cl.exe" CACHE FILEPATH "" FORCE)
    set(CMAKE_LINKER "${_clang_root}/bin/lld-link.exe" CACHE FILEPATH "" FORCE)
    set(CMAKE_AR "${_clang_root}/bin/llvm-lib.exe" CACHE FILEPATH "" FORCE)
    set(CMAKE_ASM_MASM_COMPILER "${_clang_root}/bin/llvm-ml64.exe" CACHE FILEPATH "" FORCE)
    set(CMAKE_RC_COMPILER "${_sdk_root}/bin/x64/rc.exe" CACHE FILEPATH "" FORCE)
    set(CMAKE_MT "${_sdk_root}/bin/x64/mt.exe" CACHE FILEPATH "" FORCE)

    # clang-cl, lld-link, and rc inherit these paths in CMake subprocesses.
    set(ENV{INCLUDE} "${_vc_root}/include;${_sdk_root}/include/ucrt;${_sdk_root}/include/shared;${_sdk_root}/include/um;${_sdk_root}/include/winrt;${_sdk_root}/include/cppwinrt")
    set(ENV{LIB} "${_vc_root}/lib/x64;${_sdk_root}/lib/ucrt/x64;${_sdk_root}/lib/um/x64")
    set(ENV{PATH} "${_clang_root}/bin;${_sdk_root}/bin/x64;$ENV{PATH}")

    include("${CMAKE_CURRENT_LIST_DIR}/windows.cmake")

    # cmcldeps forwards RC flags to clang-cl while scanning resource includes.
    # /c65001 is understood by rc.exe but interpreted as a filename by clang-cl.
    string(REPLACE "/c65001" "" _clang_rc_flags "${CMAKE_RC_FLAGS}")
    set(CMAKE_RC_FLAGS "${_clang_rc_flags}" CACHE STRING "" FORCE)
endif()
