cmake_minimum_required(VERSION 3.22)

function(cmrk_option)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "NO_CACHE" "NAME;DOC;TYPE;DEFAULT;DEFAULT_FN" "DEFAULT_FN_ARGS")

  if (DEFINED "${ARG_NAME}")
    return()
  endif ()

  if (NOT ARG_DOC)
    set(ARG_DOC "${PROJECT_NAME}: missing documentation for option ${ARG_NAME}")
  endif ()

  if (NOT ARG_TYPE)
    set(ARG_TYPE STRING)
  endif ()

  if (ARG_DEFAULT AND ARG_DEFAULT_FN)
    message(FATAL_ERROR "cmrk_option: must supply either DEFAULT or DEFAULT_FN, not both")
  endif ()

  if (ARG_DEFAULT_FN)
    cmake_language(CALL "${ARG_DEFAULT_FN}" ${ARG_DEFAULT_FN_ARGS} OUTPUT_VARIABLE value)
  else ()
    set(value "${ARG_DEFAULT}")
  endif ()

  if (ARG_NO_CACHE)
    set("${ARG_NAME}" "${value}" PARENT_SCOPE)
  else ()
    set("${ARG_NAME}" "${value}" CACHE "${ARG_TYPE}" "${ARG_DOC}")
  endif ()
endfunction()
