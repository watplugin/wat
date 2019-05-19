extends Reference

const _USERDIR: String = "user://WATemp/"
const SOURCE = preload("res://addons/WAT/double/objects/source.gd")


static func start(script) -> SOURCE:
	script = script if script is Script else load(script)
	var title: String = "Doubled_%s" % Array(script.resource_path.replace(".gd", "").split("/")).pop_back()
	var extend: String = 'extends "%s"\n\n' % script.resource_path
	var source: String = ""
	while script:
		source += script.source_code
		# This becomes null if it hits a built-in class
		script = script.get_base_script()
	var tokens: Array = _tokenize(source)
	return SOURCE.new(title, extend, tokens)
	
static func _tokenize(source: String):
	var tokens: Array = _extract_tokens(source)
	var duplicates: Array = []
	var results: Array = []
	for token in tokens:
		var identifier = _extract_name(token)
		if identifier in duplicates:
			# Skip if already parsed
			continue
		duplicates.append(identifier)
		results.append(_recreate_method(identifier, _extract_parameters(token), _extract_return_type(token)))
	return results
	
static func _extract_tokens(source: String) -> Array:
	var lines: Array = source.split("\n")
	var tokens: Array = []
	for line in lines:
		if line.begins_with("func"):
			tokens.append(line)
	return tokens
		
static func _extract_name(method: String) -> String:
	return method.replace("(", " ").split(" ")[1]
	
static func _extract_parameters(method: String) -> Array:
	var list: Array = str(method.split("(")[1]).split(")")[0].split(",")
	var results: Array = []
	for parameter in list:
		if parameter.empty():
			break
		results.append(_define_parameter(parameter))
	return results
	
static func _define_parameter(parameter: String) -> Dictionary:
	var _refined: Array = parameter.dedent().split(":")
	var result: Dictionary = {name = "", type = "null", typed = false}
	result.name = _refined.pop_front()
	if not _refined.empty():
		result.type = _refined.pop_front().strip_edges()
		result.typed = true
	return result

static func _extract_return_type(method: String) -> Dictionary:
	var result: Dictionary = {type = "var", typed = false}
	var type: String = method.replace("->", " ").replace(":", "").split(")")[1].dedent() # Issue
	if not type.empty():
		result.type = type.strip_edges()
		result.typed = true
	return result
	
static func _recreate_method(identifier: String, parameters: Array, retval: Dictionary) -> Dictionary:
	# We could create the methods here?
	return {"name": identifier, "parameters": parameters, "retval": retval}