extends Resource

# Use The Settings in WAT instead


### BEGIN GUI ONLY
export(bool) var tests_include_subdirectories = true
export(bool) var show_subdirectories_in_their_own_tabs = false
### END GUI ONLY

### BEGIN MAIN
export(String) var main_test_folder = "res://tests/"
export(String) var test_method_prefix = "test_"
### END MAIN


