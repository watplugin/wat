extends Resource
tool

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
	return spies[method]

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
	for s in stubbed.patterns:
		if args == s.args:
			# This might cause issues with special objects
			return s.return_value
	return stubbed.default

func spy(method: String) -> void:
	add_method(method)
	definitions[method].spying = true
	spies[method] = 0

func create_function(name: String) -> String:
	var method: Dictionary = definitions[name]
	var function_text: String = "func %s(a, b):" % name
	function_text += "\n\tvar args = [a, b]"
	if method.spying:
		function_text += "\n\tload('%s').spies['%s'] += 1" % [resource_path, name]
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