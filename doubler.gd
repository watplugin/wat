extends Resource
tool

# TODO
# SuperCall (Stub to call super if passed x, y, z OR default to call super if not stubbed?)
# CalledWithArguments check
# SceneVersion of doubler
# Keywords for static methods etc
# Add dependency managers

export (String) var index
export(String) var base_script: String
export(Array, String) var modified_source_code: Array = []
var save_path: String = ""
var cache = []
var stubs = {} # {method: retval}
var spies = {} # method / count
var definitions = {} # {Spying: ?, Stub: {MATCH_PATTERNS, default}, dummied}
var _created = false
var is_scene = false

const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")

func add_method(method: String) -> void:
	if definitions.has(method):
		return
	definitions[method] = {spying = false, stubbed = false, calls_super = false}

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object:
				item.free()

func call_count(method: String) -> int:
	return spies[method].size()

func dummy(method: String) -> void:
	add_method(method)
	definitions[method].stubbed = true
	if not stubs.has(method):
		stubs[method] = {default = null, patterns = []}
	stubs[method].default = null

func stub(method: String, return_value, arguments: Array = []) -> void:
	add_method(method)
	definitions[method].stubbed = true
	if not stubs.has(method):
		stubs[method] = {default = null, patterns = []}
	if arguments.empty():
		stubs[method].default = return_value
	else:
		stubs[method].patterns.append({args = arguments, "return_value": return_value})

func get_stub(method: String, args: Array):
	var stubbed: Dictionary = stubs[method]
	for pattern in stubbed.patterns:
		if _pattern_matched(pattern.args, args):
			return pattern.return_value
	return stubbed.default

func _pattern_matched(pattern: Array, args: Array) -> bool:
	var indices: Array = []
	for index in pattern.size():
		if pattern[index] is Object and pattern[index].get_class() == "Any":
			continue
		indices.append(index)
	for i in indices:
		# We check based on type first otherwise some errors occur (ie object can't be compared to int)
		if typeof(pattern[i]) != typeof(args[i]) or pattern[i] != args[i]:
			return false
	return true

func spy(method: String) -> void:
	add_method(method)
	definitions[method].spying = true
	spies[method] = []

func found_matching_call(method, expected_args: Array):
	var calls: Array = spies[method]
	for call in calls:
		if _pattern_matched(expected_args, call):
			print("was called")
			return true
	return false

#func _found_matching_call(double, method: String, args) -> bool:
#	for call in double._methods[method].calls:
#			if key_value_match(args, call):
#				return true
#	return false
#
#func key_value_match(a: Dictionary, b: Dictionary) -> bool:
#	for key in a:
#		if a[key] != b[key]:
#			return false
#	return true

func add_call(method: String, args: Array = []) -> void:
	spies[method].append(args)

func create_function(name: String) -> String:
	var method: Dictionary = definitions[name]
	var function_text: String = "func %s(a, b):" % name
	function_text += "\n\tvar args = [a, b]"
	if method.spying:
		function_text += "\n\tload('%s').add_call('%s', args)" % [resource_path, name]
	if method.stubbed:
		function_text += "\n\treturn load('%s').get_stub('%s', args)" % [resource_path, name]
	assert(function_text.split("\n").size() > 1)
	return function_text

func object() -> Object:
	if _created:
		return null
	_created = true
	# Add a error check here to inform people they've already instanced it.
	var script = GDScript.new()
	var source: String = 'extends "%s"\n' % base_script
	for name in definitions:
		source += create_function(name)
	script.source_code = source
	save_path = "user://WATemp/S%s.gd" % index
	ResourceSaver.save(save_path, script)
	var object = load(save_path).new()
	cache.append(object)
	### BEGIN TEST
	## END TEST
	return object