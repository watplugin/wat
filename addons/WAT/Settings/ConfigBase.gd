extends Resource

# Use The Settings in WAT instead

export(bool) var keep_typed_parameters_in_doubled_scripts = true
export(bool) var keep_typed_return_values_in_doubled_scripts = true
export(bool) var exclude_void_typed_return_values_in_doubled_scripts = true
export(bool) var double_strategy_is_partial = false
export(bool) var tests_include_subdirectories = true
export(bool) var show_subdirectories_in_their_own_tabs = false
export(bool) var display_tests_that_pass = true
export(bool) var display_tests_that_fail = true
export(String) var main_test_folder = "res://tests/"
export(Array, String) var test_script_prefixes = []
export(String) var test_method_prefix = "test_"


