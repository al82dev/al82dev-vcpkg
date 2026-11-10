if(NOT TARGET zstd::libzstd_static)
    find_package(zstd CONFIG REQUIRED
        PATHS "A:/al82dev-vcpkg/installed/x64-windows-clang-static-md/share/zstd"
        NO_DEFAULT_PATH)
endif()

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR AND NOT _SLANG_DIAGNOSTIC_DEFERRED)
    set(_SLANG_DIAGNOSTIC_DEFERRED TRUE)
    function(slang_diagnostic_adjust_spirv)
        if(TARGET SPIRV-Tools-opt)
            target_compile_options(SPIRV-Tools-opt PRIVATE -Wno-error=c++98-compat-extra-semi)
        endif()
        if(TARGET slang-rhi-warnings-as-errors)
            set_property(TARGET slang-rhi-warnings-as-errors PROPERTY INTERFACE_COMPILE_OPTIONS "")
        endif()
    endfunction()
    cmake_language(DEFER CALL slang_diagnostic_adjust_spirv)
endif()
