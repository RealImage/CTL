include_directories( "${CMAKE_CURRENT_SOURCE_DIR}" )

include_directories( ${IlmBase_INCLUDE_DIRS} )
link_directories( ${IlmBase_LIBRARY_DIRS} )

set(IlmCtl_SRC_LIST  CtlAddr.cpp
                     CtlAlign.cpp
                     CtlExc.cpp
                     CtlFunctionCall.cpp
                     CtlInterpreter.cpp
                     CtlLContext.cpp
                     CtlLex.cpp
                     CtlMessage.cpp
                     CtlModule.cpp
                     CtlModuleSet.cpp
                     CtlParser.cpp
                     CtlRcPtr.cpp
                     CtlSymbolTable.cpp
                     CtlSyntaxTree.cpp
                     CtlTokens.cpp
                     CtlType.cpp
                     CtlTypeStorage.cpp
                     CtlStdType.cpp
    )

# fix for lrand48 on Windows
if (WIN32)
  include_directories( "${CMAKE_CURRENT_SOURCE_DIR}/lrand48" )
  set(IlmCtl_SRC_LIST ${IlmCtl_SRC_LIST} 
                      ${CMAKE_CURRENT_SOURCE_DIR}/lrand48/_rand48.cpp 
                      ${CMAKE_CURRENT_SOURCE_DIR}/lrand48/lrand48.cpp) 
endif()

add_library( IlmCtl ${DO_SHARED} ${IlmCtl_SRC_LIST})

target_link_libraries( IlmCtl Iex IlmThread Half )

set_target_properties( IlmCtl PROPERTIES
  VERSION ${CTL_VERSION}
  SOVERSION ${CTL_VERSION}
)

install( FILES
	CtlAddr.h
	CtlAlign.h
	CtlErrors.h
	CtlExc.h
	CtlFunctionCall.h
	CtlInterpreter.h
	CtlLContext.h
	CtlMessage.h
	CtlModule.h
	CtlRcPtr.h
	CtlReadWriteAccess.h
	CtlSymbolTable.h
	CtlSyntaxTree.h
	CtlTokens.h
	CtlType.h
	CtlTypeStorage.h
	CtlStdType.h
	CtlVersion.h
 DESTINATION include/CTL )

install( TARGETS IlmCtl DESTINATION lib )
