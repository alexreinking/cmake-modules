function(cmrk_copy_runtime_dlls target)
  # Not a DLL system
  if (NOT CMAKE_IMPORT_LIBRARY_SUFFIX)
    return()
  endif ()

  # Only applies to dynamic libraries
  set(allowed_types SHARED_LIBRARY MODULE_LIBRARY EXECUTABLE)
  get_property(type TARGET ${target} PROPERTY TYPE)
  if (NOT type IN_LIST allowed_types)
    return()
  endif ()

  # Don't add the command twice
  get_property(has_cmd TARGET "${target}" PROPERTY _${CMAKE_CURRENT_FUNCTION}_has_cmd)
  if (has_cmd)
    return()
  endif ()

  set(dlls "$<TARGET_RUNTIME_DLLS:${target}>")
  set(dir "$<TARGET_FILE_DIR:${target}>")
  add_custom_command(
    TARGET "${target}" POST_BUILD
    COMMAND "$<$<BOOL:${dlls}>:${CMAKE_COMMAND};-E;copy;${dlls};${dir}>"
    COMMAND_EXPAND_LISTS
  )

  set_property(TARGET "${target}" PROPERTY _${CMAKE_CURRENT_FUNCTION}_has_cmd 1)
endfunction()
