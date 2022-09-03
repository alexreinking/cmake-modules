cmake_minimum_required(VERSION 3.22...3.24)

macro(cmrk_unset_function NAME)
  # Redefining the same function twice utterly removes it in all known CMake
  # versions. Upon redefinition of function NAME, CMake saves a copy of the
  # function under the name "_NAME". The second redefinition overwrites this
  # copy, too. CMake does not follow the chain at all (i.e. no __NAME exists).
  foreach (i RANGE 0 1)
    function("${NAME}")
      message(FATAL_ERROR "called unset function ${CMAKE_CURRENT_FUNCTION}")
    endfunction()
  endforeach ()
endmacro()
