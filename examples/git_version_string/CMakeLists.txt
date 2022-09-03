cmake_minimum_required(VERSION 3.22)
project(example VERSION 1.42.3)

find_package(cmrk REQUIRED)

cmrk_option(
  NAME EXAMPLE_VERSION_STRING
  DOC "The version string to print"
  DEFAULT_FN cmrk_git_version_string
)

configure_file(include/config.h.in include/config.h)

add_executable(example src/main.cpp)
target_include_directories(example PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include" "${CMAKE_CURRENT_BINARY_DIR}/include")
