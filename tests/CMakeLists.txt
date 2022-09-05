cmake_minimum_required(VERSION 3.24)
project(cmrk-tests LANGUAGES NONE)

enable_testing()

##
# Test harness

set(cmrk_config_project_root "${CMAKE_CURRENT_LIST_DIR}/..")
cmake_path(NORMAL_PATH cmrk_config_project_root)

macro(set_file_or_default var file default)
    if (EXISTS "${file}")
        file(READ "${file}" "${var}")
        string(STRIP "${${var}}" "${var}")
    else ()
        set("${var}" "${default}")
    endif ()
endmacro()

function(add_cmrk_test)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "NAME" "")

    file(READ "${ARG_NAME}.cmake" cmrk_config_test_contents)
    set_file_or_default(expected_stdout "${ARG_NAME}-stdout.txt" ".*")
    set_file_or_default(expected_stderr "${ARG_NAME}-stderr.txt" "^$")

    configure_file(templates/CMakeLists.txt.in "${ARG_NAME}/CMakeLists.txt")

    set(test_source_dir "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}")
    set(test_binary_dir "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}/build")

    add_test(
        NAME  "${ARG_NAME}"
        COMMAND "${CMAKE_COMMAND}" -G Ninja -S "${test_source_dir}" -B "${test_binary_dir}" --fresh
        # CONFIGURATIONS <config>...
        # WORKING_DIRECTORY <dir>
        # COMMAND_EXPAND_LISTS
    )

    set_tests_properties(
        "${ARG_NAME}"
        PROPERTIES
        # ATTACHED_FILES
        # ATTACHED_FILES_ON_FAIL
        # COST
        # DEPENDS
        # DISABLED
        # ENVIRONMENT
        # ENVIRONMENT_MODIFICATION
        # FAIL_REGULAR_EXPRESSION
        # FIXTURES_CLEANUP
        # FIXTURES_REQUIRED
        # FIXTURES_SETUP
        # LABELS
        # MEASUREMENT
        # PASS_REGULAR_EXPRESSION
        # PROCESSOR_AFFINITY
        # PROCESSORS
        # REQUIRED_FILES
        # RESOURCE_GROUPS
        # RESOURCE_LOCK
        # RUN_SERIAL
        # SKIP_REGULAR_EXPRESSION
        SKIP_RETURN_CODE 42
        # TIMEOUT
        # TIMEOUT_AFTER_MATCH
        # WILL_FAIL
        # WORKING_DIRECTORY
    )
endfunction()

##
# Test case definitions

add_cmrk_test(NAME DebugPrintVariables/default-environment)
