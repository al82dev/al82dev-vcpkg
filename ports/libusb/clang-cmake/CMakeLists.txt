cmake_minimum_required(VERSION 3.20)
project(libusb LANGUAGES C RC)

if(NOT DEFINED LIBUSB_SOURCE_DIR)
    message(FATAL_ERROR "LIBUSB_SOURCE_DIR is required")
endif()

set(src "${LIBUSB_SOURCE_DIR}/libusb")
add_library(libusb
    "${src}/core.c"
    "${src}/descriptor.c"
    "${src}/hotplug.c"
    "${src}/io.c"
    "${src}/strerror.c"
    "${src}/sync.c"
    "${src}/os/events_windows.c"
    "${src}/os/threads_windows.c"
    "${src}/os/windows_common.c"
    "${src}/os/windows_usbdk.c"
    "${src}/os/windows_winusb.c"
)
if(BUILD_SHARED_LIBS)
    target_sources(libusb PRIVATE "${src}/libusb-1.0.def" "${src}/libusb-1.0.rc")
endif()
target_include_directories(libusb PRIVATE "${LIBUSB_SOURCE_DIR}/msvc" "${src}")
target_compile_definitions(libusb PRIVATE _WIN32_WINNT=_WIN32_WINNT_VISTA _CRT_SECURE_NO_WARNINGS)
set_target_properties(libusb PROPERTIES OUTPUT_NAME "libusb-1.0" PREFIX "")
install(TARGETS libusb RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
