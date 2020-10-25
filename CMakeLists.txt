#!/bin/env cmake

# Prologue
if(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} LESS 2.4) # old style:
    message(FATAL_ERROR "${PROJECT_NAME} requires at least CMake v2.8, you use v${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.")
endif(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} LESS 2.4)
if(APPLE)
  set(CMAKE_TRY_COMPILE_OSX_ARCHITECTURES i386)
endif()

cmake_minimum_required(VERSION 3.16...3.19 FATAL_ERROR)

project(SelfDistribution)

set(SELF_MACOSX_XCODEPROJECTNAME SelfDistribution)
add_subdirectory(vm)
add_subdirectory(tools)
