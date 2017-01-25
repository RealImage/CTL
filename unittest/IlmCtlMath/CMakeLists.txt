include_directories( ${IlmBase_INCLUDE_DIRS} )
link_directories( ${IlmBase_LIBRARY_DIRS} )

add_executable(IlmCtlMathTest 
    main.cpp
    testAffineRec.cpp
    testGaussRec.cpp
)

include_directories( ${IlmBase_INCLUDE_DIRS} )
link_directories( ${IlmBase_LIBRARY_DIRS} )

include_directories( "${CMAKE_CURRENT_SOURCE_DIR}" 
                     "${PROJECT_SOURCE_DIR}/lib/IlmCtlMath" )
                     
target_link_libraries( IlmCtlMathTest IlmCtlMath Half)

add_test( IlmCtlMath IlmCtlMathTest )
add_dependencies(check IlmCtlMathTest)





#LDADD =	@ILMBASE_LIBS@ -L$(top_builddir)/IlmCtlMath \
#	-lIlmCtlMath -lImath -lIex -lHalf -lpthread -lm


