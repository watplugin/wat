extends Reference

const _USERDIR: String = "user://WATemp/"
const SOURCE = preload("res://addons/WAT/double/objects/source.gd")

static func start(script) -> SOURCE:
	script = script if script is Script else load(script)
	var title: String = "Doubled_%s" % Array(script.resource_path.replace(".gd", "").split("/")).pop_back()
	var extend: String = ('extends "%s"\n\n' % script.resource_path).strip_edges()
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
	for data in tokens:
		var token = data.signature
		var identifier = _extract_name(token)
		if identifier in duplicates:
			# Skip if already parsed
			continue
		duplicates.append(identifier)
		results.append(_recreate_method(identifier, _extract_parameters(token), _extract_return_type(token), data.returns_value))
	return results

static func _extract_tokens(source: String) -> Array:
#	var t = []
#	var not_found: int = -1
#	var search_index: int = 0
#	var previous = []
#	print(source, "\nEND")
#	while not search_index in previous:
#		print("search index: %s" % search_index)
#		previous.append(search_index)
#		search_index = source.findn("func", search_index)
#		t.append(source.substr(search_index, 4))
#		search_index += 1
#		print(previous)

	var lines: Array = source.split("\n")
	var tokens: Array = []
	for line in lines:
		if line.begins_with("func"):
			var data = {"signature": line, "returns_value": returns_value(lines, lines.find(line))}
			tokens.append(data)
	return tokens

static func returns_value(lines: Array, index: int) -> bool:
#	var lenght_to_return = lines.find("return", index)

	while index < lines.size()-1:
		index += 1
		var line = lines[index]
#		print("0%s0" % line)
		if line.dedent().begins_with("return"):
			return true
		elif line.dedent().begins_with("func"):
			return false
	return false

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

static func _recreate_method(identifier: String, parameters: Array, retval: Dictionary, returns_value: bool) -> Dictionary:
	# We could create the methods here?
	return {"name": identifier, "parameters": parameters, "retval": retval, "returns_value": returns_value}