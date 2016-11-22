# Until we get some of these modules into the upstream packages, put them here
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules/")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_INSTALL_PREFIX}/share/CMake")

find_package( PkgConfig QUIET )

find_package( IlmBase QUIET )
if( IlmBase_FOUND )
  message( STATUS "found IlmBase, version ${IlmBase_VERSION}" )
  ###
  ### Everyone (well, except for DPX) uses IlmBase, so
  ### make that a global setting
  ###
  include_directories( ${IlmBase_INCLUDE_DIRS} )
  link_directories( ${IlmBase_LIBRARY_DIRS} )
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${IlmBase_CFLAGS}" )
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${IlmBase_CFLAGS}" )
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${IlmBase_LDFLAGS}" )
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${IlmBase_LDFLAGS}" )
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${IlmBase_LDFLAGS}" )
else()
  message( STATUS "IlmBase will be acquired" )
  execute_process(COMMAND git clone git://github.com/openexr/openexr.git ${DEPENDENCIES_DIR}/openexr)
  
  set(IlmBase_SRC_PATH ${DEPENDENCIES_DIR}/openexr/IlmBase)
  set(IlmBase_BUILD_PATH ${CMAKE_BINARY_DIR}/build/deps/openexr/IlmBase)
  
  add_subdirectory(${IlmBase_SRC_PATH})
  
  set(IlmBase_FOUND TRUE)
  
  set(IlmBase_INCLUDE_DIR ${IlmBase_BUILD_PATH}/config/
                          ${IlmBase_SRC_PATH}/Imath/
                          ${IlmBase_SRC_PATH}/Half/
                          ${IlmBase_SRC_PATH}/Iex/
                          ${IlmBase_SRC_PATH}/IexMath/
                          ${IlmBase_SRC_PATH}/IlmThread/
                          ${IlmBase_SRC_PATH}/Imath/
                          CACHE PATHS "IlmBase_INCLUDE_DIR" FORCE)
                          
  set(IlmBase_INCLUDE_DIRS ${IlmBase_INCLUDE_DIR} CACHE PATH "IlmBase include dirs" FORCE)
  
  set(IlmBase_LIBRARY  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CMAKE_STATIC_LIBRARY_PREFIX}Half${CMAKE_STATIC_LIBRARY_SUFFIX}
                       ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CMAKE_STATIC_LIBRARY_PREFIX}Iex-2_2${CMAKE_STATIC_LIBRARY_SUFFIX}
                       ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CMAKE_STATIC_LIBRARY_PREFIX}IexMath-2_2${CMAKE_STATIC_LIBRARY_SUFFIX}
                       ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CMAKE_STATIC_LIBRARY_PREFIX}IlmThread-2_2${CMAKE_STATIC_LIBRARY_SUFFIX}
                       ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${CMAKE_STATIC_LIBRARY_PREFIX}Imath-2_2${CMAKE_STATIC_LIBRARY_SUFFIX}
                       CACHE FILEPATH "IlmBase LIBRARY" FORCE)   
                       
  set(IlmBase_LIBRARIES ${IlmBase_LIBRARY} CACHE FILEPATH "IlmBase LIBRARIES" FORCE)
  set(IlmBase_LIBRARY_DIRS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} CACHE PATHS "IlmBase LIBRARY DIRS" FORCE)
endif()

find_package( TIFF QUIET )
if ( TIFF_FOUND )
  message( STATUS "found TIFF, version ${TIFF_VERSION_STRING}" )
  # Make the variables the same as if pkg-config finds them
  set(TIFF_INCLUDE_DIRS ${TIFF_INCLUDE_DIR})
  get_filename_component(TIFF_LIBRARY_DIR ${TIFF_LIBRARIES} DIRECTORY)
else()
  if ( PKG_CONFIG_FOUND )
    pkg_search_module( TIFF libtiff libtiff-4 )
    if ( TIFF_FOUND )
      message( STATUS "found TIFF via pkg-config, version ${TIFF_VERSION}" )
    endif()
  else()
    message( WARNING "Unable to find TIFF libraries, disabling" )
  endif()
endif()

find_package( OpenEXR QUIET )
if ( OpenEXR_FOUND )
  message( STATUS "Found OpenEXR, version ${OpenEXR_VERSION}" )
else()
  message( WARNING "Unable to find OpenEXR libraries, disabling" )
endif()

find_package( AcesContainer )
if ( AcesContainer_FOUND )
  message( STATUS "Found AcesContainer, version ${AcesContainer_VERSION}" )
else()
  if ( PKG_CONFIG_FOUND )
    pkg_check_modules( AcesContainer AcesContainer )
  else()
    message( WARNING "Unable to find AcesContainer libraries, disabling" )
  endif()
endif()
