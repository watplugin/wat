extends Reference
	
static func is_valid_test(p: String) -> bool:
	return _is_valid_gdscript(p) or _is_valid_compiled_gdscript(p) or _is_valid_csharp(p)
			
static func _is_valid_gdscript(p: String) -> bool:
	return p.ends_with(".gd") and p != "res://addons/WAT/test/test.gd" and load(p).get("IS_WAT_TEST")
	
static func _is_valid_compiled_gdscript(p: String) -> bool:
	return p.ends_with(".gdc") and p != "res://addons/WAT/test/test.gdc" and load(p).get("IS_WAT_TEST")
	
static func _is_valid_csharp(p: String) -> bool:
	# TODO: This requires extra checking for invalid or uncompiled csharp scripts
	# Any errors about no method or new function new found exists here
	if p.ends_with(".cs") and not "addons/WAT" in p and load(p).has_method("new"):
		var test = load(p).new()
		if test.get("IS_WAT_TEST"):
			test.free()
			return true
		else:
			test.free()
			return false
	return false
