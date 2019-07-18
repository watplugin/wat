extends Resource

# Use The Settings in WAT instead

enum S {
	DOUBLE
	PARTIAL
}

### BEGIN DELETE
export(bool) var keep_typed_parameters_in_doubled_scripts = true
export(bool) var keep_typed_return_values_in_doubled_scripts = true
export(bool) var exclude_void_typed_return_values_in_doubled_scripts = true
export(bool) var double_strategy_is_partial = false
### END DELETE

### BEGIN GUI ONLY
export(bool) var tests_include_subdirectories = true
export(bool) var show_subdirectories_in_their_own_tabs = false
### END GUI ONLY

### BEGIN MAIN
export(String) var main_test_folder = "res://tests/"
export(String) var test_method_prefix = "test_"
### END MAIN


