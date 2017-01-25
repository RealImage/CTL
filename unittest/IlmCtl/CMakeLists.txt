include_directories( ${IlmBase_INCLUDE_DIRS} )

add_executable(IlmCtlTest 
    main.cpp
    testCppCall.cpp
    testEndOfLine.cpp
    testExamples.cpp
    testHugeInit.cpp
    testParser.cpp
    testVarying.cpp
    testVaryingLookup.cpp
    testVaryingReturn.cpp
)

include_directories( "${CMAKE_CURRENT_SOURCE_DIR}" 
                     "${PROJECT_SOURCE_DIR}/lib/IlmCtl"  
                     "${PROJECT_SOURCE_DIR}/lib/IlmCtlSimd" )
                     
target_link_libraries(IlmCtlTest IlmCtlSimd IlmCtlMath IlmCtl)
target_link_libraries(IlmCtlTest Half)

add_test( IlmCtl IlmCtlTest )
add_dependencies(check IlmCtlTest)

set(ILM_CTL_TEST_FILES 
        common.ctl
        example.ctl
        testArray.ctl
        testCast.ctl
        testComments.ctl
        testCppCall.ctl
        testCtlVersion.ctl
        test.ctl
        testDefaults.ctl
        testEmpty.ctl
        testExamples.ctl
        testExamplesNamespace.ctl
        testExpr.ctl
        testFunc.ctl
        testHugeInit.ctl
        testInterpolator.ctl
        testLiterals.ctl
        testLookupTables.ctl
        testLoops.ctl
        testName2.ctl
        testName.ctl
        testNameSpace2.ctl
        testNameSpace.ctl
        testNoName.ctl
        testParse.ctl
        testScope2.ctl
        testScope.ctl
        testStdLibrary.ctl
        testStruct.ctl
        testTypes.ctl
        testVarying.ctl
        testVaryingLookup.ctl
        testVaryingReturn.ctl
        testVSArrays.ctl)
        
if (MSVC)
  file(COPY ${ILM_CTL_TEST_FILES} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Debug)
  file(COPY ${ILM_CTL_TEST_FILES} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release)
else()
  file(COPY ${ILM_CTL_TEST_FILES} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif()



