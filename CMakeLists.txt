cmake_minimum_required(VERSION 3.22)
project(cmrk LANGUAGES NONE VERSION 0.1.0)

##
# Project options

option(cmrk_INSTALL_RULES "Include the cmrk install rules" "${PROJECT_IS_TOP_LEVEL}")

##
# FetchContent support

set(CMRK_MODULES
    BundleStatic
    GitVersionString
    Option
    TargetExportScript
    UnsetFunction
    )

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src")

if (NOT PROJECT_IS_TOP_LEVEL)
  foreach (module IN LISTS CMRK_MODULES)
    include("${module}")
  endforeach ()
endif ()

if (NOT cmrk_INSTALL_RULES)
  return()
endif ()

##
# Install rules

# Suppress GNUInstallDirs warning about unknown architecture
set(CMAKE_INSTALL_LIBDIR "")

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(cmrk_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATADIR}/cmake/cmrk"
    CACHE STRING "Location to install CMake package files")

install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/src/"
        DESTINATION "${cmrk_INSTALL_CMAKEDIR}"
	COMPONENT cmrk)

configure_package_config_file(
  cmake/cmrk-config.cmake.in
  cmrk-config.cmake
  INSTALL_DESTINATION "${cmrk_INSTALL_CMAKEDIR}"
  NO_SET_AND_CHECK_MACRO
)

write_basic_package_version_file(
  cmrk-config-version.cmake
  COMPATIBILITY ExactVersion
)

install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/cmrk-config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/cmrk-config-version.cmake"
  DESTINATION "${cmrk_INSTALL_CMAKEDIR}"
  COMPONENT cmrk
)
