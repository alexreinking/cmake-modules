set(cmrk_test_cache "baz")  # shadow the cache entry
set(cmrk_test_cache "foo" CACHE STRING "")
set(cmrk_test_normal "bar")

cmrk_debug_print_variables(
    INCLUDE_REGEX "^cmrk_test_"
)
