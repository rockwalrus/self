#!/usr/bin/env cmake

include(CheckSymbolExists)
if(CYGWIN)
  check_symbol_exists(profil "unistd.h" HAVE_PROFIL)
  if(NOT HAVE_PROFIL)
    set(NEED_CYGWIN_PROFIL ON)
  endif()
endif()
