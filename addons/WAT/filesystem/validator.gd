extends Reference

# To search broken script source for WAT.Test usage.
const REGEX_PATTERN = "(\\bextends\\s+WAT.Test\\b)" + \
	"|(\\bextends\\b\\s+\\\"res:\\/\\/addons\\/WAT\\/test\\/test.gd\\\")" + \
	"|(class\\s\\w[\\w<>]+\\s*:\\s*WAT.Test[\\s\\{])"

var path: String
var script_resource: Script setget ,get_script_resource
var script_instance: Node setget ,get_script_instance

func _init(resource_path: String):
	path = resource_path
	if _is_valid_file():
		script_resource = ResourceLoader.load(path, "Script")

# Frees the script_instance on destroy.
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and is_instance_valid(script_instance):
		script_instance.queue_free()

# Checks if the Script's source has "extends WAT.Test"
func _is_extending_wat_test() -> bool:
	var result = null
	if script_resource:
		var regex = RegEx.new()
		regex.compile(REGEX_PATTERN)
		result = regex.search(script_resource.source_code)
	return result != null

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
	var resource = get_script_resource()
	var instance = get_script_instance()
	return resource and resource.get("IS_WAT_TEST") or \
			instance and instance.get("IS_WAT_TEST") or \
			get_load_error() == ERR_PARSE_ERROR and _is_extending_wat_test()

# Returns error code during resource load.
func get_load_error() -> int:
	var error = ERR_SKIP
	if script_resource:
		# Script resource with 0 methods signify parse error / uncompiled.
		# Loaded scripts always have at least one method from its base class.
		error = OK if not script_resource.get_script_method_list().empty() \
				else ERR_PARSE_ERROR
	return error

func get_script_instance() -> Node:
	# Create script_instance if no errors are found. Performed once and stored.
	if not script_instance and get_load_error() == OK:
		script_instance = script_resource.new()
	return script_instance

func get_script_resource() -> Script:
	return script_resource
