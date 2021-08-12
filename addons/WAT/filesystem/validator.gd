extends Reference
	

# if path ends with base csharp test path
# if p does not have wattest or p is not csharp script

static func is_valid_test(path: String) -> bool:
	return is_valid_gdscript(path) or is_valid_compiled_gdscript(path) or is_valid_csharp(path)

static func is_valid_gdscript(path: String) -> bool:
	return _is_gdscript(path) and not _is_base_gdscript_test(path) and _is_gdscript_wat_test(path)

static func is_valid_csharp(path: String) -> bool:
	return _is_csharp(path) and not _is_base_csharp_test(path) and _is_csharp_wat_test(path)
	
static func is_valid_compiled_gdscript(path: String) -> bool:
	return _is_compiled_gdscript(path) and not _is_base_compiled_gdscript_test(path) and _is_gdscript_wat_test(path)

static func _is_gdscript(path: String) -> bool:
	return path.ends_with(".gd")
	
static func _is_compiled_gdscript(path: String) -> bool:
	return path.ends_with(".gdc")
	
static func _is_csharp(path: String) -> bool:
	return path.ends_with(".cs")
	
static func _is_base_gdscript_test(path: String) -> bool:
	return path == "res://addons/WAT/test/test.gd"
	
static func _is_base_csharp_test(path: String) -> bool:
	return path == "res://addons/WAT/mono/Test.cs"
	
static func _is_base_compiled_gdscript_test(path: String) -> bool:
	return path == "res://addons/WAT/test/test.gdc"
	
static func _is_gdscript_wat_test(path: String) -> bool:
	return load(path).get("IS_WAT_TEST")
	
static func _is_csharp_wat_test(path: String) -> bool:
	# Dreadful but Godot is not great from GDScript for this
	return "[Test" in load(path).source_code
