include("${CMAKE_CURRENT_LIST_DIR}/internal/BailMacro.cmake")

function(cmrk_git_version_string)
  cmake_parse_arguments(ARG "REQUIRED" "OUTPUT_VARIABLE;TEMPLATE" "" ${ARGN})

  list(APPEND CMAKE_MESSAGE_CONTEXT "${CMAKE_CURRENT_FUNCTION}")

  if (NOT ARG_OUTPUT_VARIABLE)
    message(FATAL_ERROR "expected argument OUTPUT_VARIABLE")
  endif ()

  set(output_value "${PROJECT_VERSION}")

  if (NOT EXISTS "${PROJECT_SOURCE_DIR}/.git")
    _cmrk_bail("missing .git directory")
  endif ()

  find_package(Git)

  if (NOT Git_FOUND)
    _cmrk_bail("could not find git")
  endif ()

  if (NOT ARG_TEMPLATE)
    set(ARG_TEMPLATE "@PROJECT_VERSION@ (git~@GIT_VERSION@)")
  endif ()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" -C "${PROJECT_SOURCE_DIR}" describe --tags
    RESULT_VARIABLE GIT_VERSION_RESULT
    ERROR_VARIABLE  GIT_VERSION_ERROR
    OUTPUT_VARIABLE GIT_VERSION
    ERROR_STRIP_TRAILING_WHITESPACE
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  if (GIT_VERSION_RESULT EQUAL 0)
    if (NOT GIT_VERSION STREQUAL version)
      string(CONFIGURE "${ARG_TEMPLATE}" output_value @ONLY)
      set("${ARG_OUTPUT_VARIABLE}" "${output_value}" PARENT_SCOPE)
    endif ()
  else ()
    _cmrk_bail("`git describe --tags` failed! code ${GIT_VERSION_RESULT}: ${GIT_VERSION_ERROR}")
  endif ()
endfunction()
