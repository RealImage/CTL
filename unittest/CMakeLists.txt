
enable_testing()

add_custom_target( check COMMAND ${CMAKE_CTEST_COMMAND} )

add_subdirectory( IlmCtl )
add_subdirectory( IlmCtlMath )

if (OpenEXR_FOUND)
add_subdirectory( ctlrender )
add_subdirectory( IlmImfCtl )
endif()

