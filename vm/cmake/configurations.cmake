#!/usr/bin/env cmake

set(_is_profiled 0)
set(_is_optimized 0)
set(_is_debug 0)

if(SELF_PROFILE)
  set(_is_profiled 1)
endif()

if(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
  #
  # Default build type to release if supported
  #
  if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel." FORCE)
  endif()
  
  # include optimizations for releases
  #
  if(CMAKE_BUILD_TYPE MATCHES "Rel")
    set(_is_optimized 1)
  endif()
    
  # include debug symbols for debug builds
  #
  if(CMAKE_BUILD_TYPE MATCHES "Deb")
    set(_is_debug 1)
  endif()
  
  # Release definitions
  ##
  set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
    COMPILE_DEFINITIONS 
    $<$<CONFIG:Release>:GENERATE_DEBUGGING_AIDS=0>
    $<$<CONFIG:Release>:SPEND_TIME_FOR_DEBUGGING_BY_DEFAULT=0>
    $<$<CONFIG:Release>:TARGET_IS_OPTIMIZED=1>
    $<$<CONFIG:Release>:TARGET_IS_PROFILED=${_is_profiled}>
    $<$<CONFIG:Release>:TARGET_IS_FOR_DEBUGGING=0>)
  if(SELF_FAST_FLOATS)
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
      COMPILE_DEFINITIONS 
      $<$<CONFIG:Release>:FAST_FLOATS>)
  endif()
  
  
  # Release definitions, size optimized
  ##
  set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
    COMPILE_DEFINITIONS
    $<$<CONFIG:MinSizeRel>:GENERATE_DEBUGGING_AIDS=0>
    $<$<CONFIG:MinSizeRel>:SPEND_TIME_FOR_DEBUGGING_BY_DEFAULT=0>
    $<$<CONFIG:MinSizeRel>:TARGET_IS_OPTIMIZED=1>
    $<$<CONFIG:MinSizeRel>:TARGET_IS_PROFILED=${_is_profiled}>
    $<$<CONFIG:MinSizeRel>:TARGET_IS_FOR_DEBUGGING=0>)
  if(SELF_FAST_FLOATS)
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
      COMPILE_DEFINITIONS
      $<$<CONFIG:MinSizeRel>:FAST_FLOATS>)
  endif()
    
  # Debug definitions
  ##
  set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
    COMPILE_DEFINITIONS
    $<$<CONFIG:Debug>:GENERATE_DEBUGGING_AIDS=1>
    $<$<CONFIG:Debug>:SPEND_TIME_FOR_DEBUGGING_BY_DEFAULT=1>
    $<$<CONFIG:Debug>:TARGET_IS_OPTIMIZED=0>
    $<$<CONFIG:Debug>:TARGET_IS_PROFILED=${_is_profiled}>
    $<$<CONFIG:Debug>:TARGET_IS_FOR_DEBUGGING=1>
    $<$<CONFIG:Debug>:GENERATE_ASSERTIONS=>)
  if(SELF_FAST_FLOATS)
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
      COMPILE_DEFINITIONS
      $<$<CONFIG:Debug>:FAST_FLOATS>)
  endif()
  
  # Release definitions, with debug infos
  ##
  set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
    COMPILE_DEFINITIONS
    $<$<CONFIG:RelWithDebInfo>:GENERATE_DEBUGGING_AIDS=1>
    $<$<CONFIG:RelWithDebInfo>:SPEND_TIME_FOR_DEBUGGING_BY_DEFAULT=1>
    $<$<CONFIG:RelWithDebInfo>:TARGET_IS_OPTIMIZED=1>
    $<$<CONFIG:RelWithDebInfo>:TARGET_IS_PROFILED=${_is_profiled}>
    $<$<CONFIG:RelWithDebInfo>:TARGET_IS_FOR_DEBUGGING=1>
    $<$<CONFIG:RelWithDebInfo>:GENERATE_ASSERTIONS=>)
  if(SELF_FAST_FLOATS)
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} APPEND PROPERTY 
      COMPILE_DEFINITIONS
      $<$<CONFIG:RelWithDebInfo>:FAST_FLOATS>)
  endif()
  
  add_definitions(${_flags} ${_defines})
  
  
else()
  
  # we are under a makefile-like config.
  # let the user decide
  set(SELF_BUILD_LEVEL "optimized" 
    CACHE STRING 
    "Select the build level for ${PRODUCT_NAME} from 'optimized', 'debug','optimized_with_debug'")
  if(SELF_BUILD_LEVEL MATCHES "debug")
    set(_is_debug 1)
  endif()
  
  if(SELF_BUILD_LEVEL MATCHES "optimized")
    set(_is_optimized 1)
  endif()
  
  if(SELF_FAST_FLOATS)
    list(APPEND _defines -DFAST_FLOATS)
  endif()
  
  if(_is_debug)
    list(APPEND _defines -DGENERATE_ASSERTIONS)
  endif()
  
  
  list(APPEND _defines
    -DGENERATE_DEBUGGING_AIDS=${_is_debug}
    -DSPEND_TIME_FOR_DEBUGGING_BY_DEFAULT=${_is_debug}
    -DTARGET_IS_OPTIMIZED=${_is_optimized}
    -DTARGET_IS_PROFILED=${_is_profiled}
    -DTARGET_IS_FOR_DEBUGGING=${_is_debug}
  )
  
  foreach(_flag ${_flags})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_flag}")
  endforeach()
  add_definitions(${_defines})

endif()

if(CMAKE_BUILD_TYPE)
  message(STATUS "Configuring for default ${CMAKE_BUILD_TYPE}")
else()
  message(STATUS "Configuring for build level ${SELF_BUILD_LEVEL}")
endif()
