
add_definitions(-std=c++11)

include_directories("${IlmBase_INCLUDE_DIRS}"
                    "${CMAKE_CURRENT_SOURCE_DIR}"
                    "${PROJECT_SOURCE_DIR}/lib/IlmCtl"
                    "${PROJECT_SOURCE_DIR}/lib/IlmCtlMath"
                    "${PROJECT_SOURCE_DIR}/lib/IlmCtlSimd")

add_executable(ctl-performance-test main.cpp)
target_link_libraries(ctl-performance-test IlmCtlSimd IlmCtlMath IlmCtl)

add_test(performance-test ctl-performance-test)

set(CTL_PT_TEST_FILES applyLookup.ctl)

if (MSVC)
  file(COPY ${CTL_PT_TEST_FILES} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Debug)
  file(COPY ${CTL_PT_TEST_FILES} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release)
else()
  file(COPY ${CTL_PT_TEST_FILES} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif()
