get_filename_component(_slang_static_prefix "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
foreach(_slang_archive IN ITEMS compiler-core core miniz lz4 cmark-gfm)
    target_link_libraries(slang::slang INTERFACE
        "$<$<CONFIG:Debug>:${_slang_static_prefix}/debug/lib/slang-internal/${_slang_archive}.lib>"
        "$<$<NOT:$<CONFIG:Debug>>:${_slang_static_prefix}/lib/slang-internal/${_slang_archive}.lib>")
endforeach()
if(TARGET slang::gfx)
    target_link_libraries(slang::gfx INTERFACE slang::slang)
endif()
unset(_slang_archive)
unset(_slang_static_prefix)
