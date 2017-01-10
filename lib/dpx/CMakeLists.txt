include_directories( "${CMAKE_CURRENT_SOURCE_DIR}" )

include_directories( ${IlmBase_INCLUDE_DIRS} )
link_directories( ${IlmBase_LIBRARY_DIRS} )

add_library( ctldpx
 dpx.cc
 dpx_raw.cc
 dpx_read.cc
 dpx_util.cc
 dpx_write.cc
 dpx_bits.cc
 dpx_validate.cc
 dpx_rw.cc
)

target_link_libraries( ctldpx Iex IlmThread Half )
add_dependencies( ctldpx Iex IlmThread Half )
