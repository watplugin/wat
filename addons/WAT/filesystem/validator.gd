extends Reference

# To search broken script source for WAT.Test usage.
const WAT_TEST_PATTERN = "(\\bextends\\s+WAT.Test\\b)" + \
	"|(\\bextends\\b\\s+\\\"res:\\/\\/addons\\/WAT\\/test\\/test.gd\\\")" + \
	"|(class\\s\\w[\\w<>]+\\s*:\\s*WAT.Test[\\s\\{])"

var path: String setget load_path
var regex: RegEx
var script_resource: Script setget ,get_script_resource
var script_instance setget ,get_script_instance
# If true, test scripts with 0 defined test methods should be skipped.
var skip_empty: bool = true

func _init(regex_pattern = WAT_TEST_PATTERN):
	regex = RegEx.new()
	regex.compile(regex_pattern)

# Frees the script_instance on destroy.
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and is_instance_valid(script_instance):
		# Cannot call _clear_resource() at predelete stage.
		script_instance.free()

# Clears the script resource and frees the script instance.
func _clear_resource() -> void:
	if is_instance_valid(script_instance):
		script_instance.free()
	script_instance = null
	script_resource = null

# Checks if the Script's source code is matching the compiled regex pattern.
func _is_matching_regex_pattern() -> bool:
	return true if script_resource and \
			regex.search(script_resource.source_code) else false

func _is_valid_gdscript() -> bool:
	return path.ends_with(".gd") and path != "res://addons/WAT/test/test.gd"
	
func _is_valid_compiled_gdscript() -> bool:
	return path.ends_with(".gdc") and path != "res://addons/WAT/test/test.gdc"
	
func _is_valid_csharp() -> bool:
	return path.ends_with(".cs") and not "addons/WAT" in path

func _is_valid_file() -> bool:
	return _is_valid_gdscript() or _is_valid_compiled_gdscript() or \
			(ClassDB.class_exists("CSharpScript") and _is_valid_csharp())

func is_valid_test() -> bool:
	return get_script_resource() and get_script_instance() or \
			get_load_error() == ERR_PARSE_ERROR and _is_matching_regex_pattern()

# Returns error code during resource load.
func get_load_error() -> int:
	var error = ERR_SKIP
	if script_resource:
		# Script resource with 0 methods signify parse error / uncompiled.
		# Loaded scripts always have at least one method from its base class.
		error = OK if not script_resource.get_script_method_list().empty() \
				else ERR_PARSE_ERROR
	return error

func get_script_instance():
	# Create script_instance if no errors are found. Performed once and stored.
	if not script_instance and get_load_error() == OK and \
			(script_resource.get("IS_WAT_TEST") if not _is_valid_csharp() \
			else _is_matching_regex_pattern()):
		script_instance = script_resource.new()
	return script_instance

func get_script_resource() -> Script:
	return script_resource

func load_path(resource_path: String, refresh: bool = true) -> void:
	_clear_resource()
	path = resource_path
	if _is_valid_file():
		# .cs scripts should load from cache due to how it is compiled.
		# .gd scripts need to be reloaded on filesystem update.
		script_resource = ResourceLoader.load(path, "Script",
				refresh and not _is_valid_csharp())
