extends Reference

const STATIC: String = "static "
const REMOTE: String = "remote "
const REMOTESYNC: String = "remotesync "
const MASTER: String = "master "
const PUPPET: String = "puppet "
const SCRIPT_WRITER = preload("script_writer.gd")
const Method = preload("method.gd")
var klass: String
var inner_klass: String = ""
var methods: Dictionary = {}
var _created: bool = false
var is_scene: bool = false
var klasses: Array = []
var base_methods: Dictionary = {}
var dependecies: Array = []
var is_built_in: bool = false
var object
var registry

# Used to handle exported nodepaths
# <var name> <var value>
var nodepaths: Dictionary = {}

func _init(_registry, _klass: String, _inner_klass: String, deps: Array = []) -> void:
	klass = _klass
	inner_klass = _inner_klass
	dependecies = deps
	is_built_in = ClassDB.class_exists(_klass)
	registry = _registry
	registry.register(self)
	parse_for_methods()
	
func method(name: String, optKeyword: String = "", optRetval = "") -> Method:
	if not methods.has(name):
		var base: Dictionary = base_methods[name]
		var keyword = base.keyword if optKeyword == "" else optKeyword
		var retval = base.return_type if optRetval == "" else optRetval
		methods[name] = Method.new(name, keyword, base.args, retval)
	return methods[name]

func clear():
	if is_instance_valid(object) and object is Object and not object is Reference:
		object.free()
	object = null

## BEGIN METHOD CLASS
func call_count(method: String) -> int:
	return methods[method].calls.size()

func get_stub(method: String, args: Array):
	# We might be able to write this into source?
	# However reducing how much we write might be best
	return methods[method].get_stub(args)

func found_matching_call(method, expected_args: Array):
	# Requires changing an expectation method
	return methods[method].found_matching_call(expected_args)

func add_call(method: String, args: Array = []) -> void:
	methods[method].add_call(args)
	
func append_function(function: Dictionary) -> void:
	if base_methods.has(function["name"]):
		return # already parsed in a subclasses
	base_methods[function["name"]] = function
	
func parse_for_methods() -> void:
	var script: GDScript
	var engine_methods: Array = []
	if is_built_in:
		engine_methods = ClassDB.class_get_method_list(klass)
	elif inner_klass != "":
		var inner_script = _load_nested_class()
		parse_inner_klass_methods(inner_script.get_script_method_list())
		engine_methods = ClassDB.class_get_method_list(klass)
	else:
		script = load(klass)
		engine_methods = ClassDB.class_get_method_list(script.get_instance_base_type())
		while script != null:
			parse_script(script.source_code)
			script = script.get_base_script()
	parse_builtins(engine_methods)

	
func parse_builtins(engine_methods: Array) -> void:
	for method in engine_methods:
		var function = {
			"keyword": "",
			"name": method.name,
			"args": "",
			"return_type": "",
		}
		
		function["args"] = parse_engine_method_arguments(method.args, method.default_args)
		append_function(function)
		
func parse_inner_klass_methods(inner_klass_methods: Array) -> void:
	var names: String = "abcdefghijklmnopqrstuvwyxz"
	for method in inner_klass_methods:
		var function = {
			"keyword": "",
			"name": method.name,
			"args": "",
			"return_type": "",
		}
		var argString = ""
		for arg in method.args.size():
			argString += "%s, " % names[arg]
		argString = argString.rstrip(", ")
		function["args"] = argString
		append_function(function)
		
func parse_engine_method_arguments(args: Array, default_args: Array) -> String:
	var stringArgs = ""
	var non_defaults: Array = args.slice(0, args.size() - default_args.size())
	var defaults: Array = args.slice(args.size() - default_args.size(), args.size())
	for arg in non_defaults:
		stringArgs += "%s, " % arg.name
	for idx in default_args.size():
		stringArgs += "%s = %s, " % [defaults[idx].name, default_args[idx]]
	stringArgs = stringArgs.rstrip(", ")
	return stringArgs
	
func parse_script(source_code: String):
	var function: Dictionary = {}
	for line in source_code.split("\n"):
		if line.begins_with("func"):
			append_function(parse_function(line))
		elif line.begins_with("static func"):
			append_function(parse_function(line, "static "))
		elif line.begins_with("remote func"):
			append_function(parse_function(line, "remote "))
		elif line.begins_with("master func"):
			append_function(parse_function(line, "master "))
		elif line.begins_with("puppet func"):
			append_function(parse_function(line, "puppet "))
		elif line.begins_with("slave func"):
			append_function(parse_function(line, "slave "))
			
func parse_function(line: String, keyword: String = "") -> Dictionary:
	var function = {
			"keyword": keyword,
			"name": "",
			"args": "",
			"return_type": ""
		}
	
	# Get Name
	var start: int = line.find("func") + 5
	var length: int = line.find("(") - start 
	function["name"] = line.substr(start, length)
	
	# Get Return Type
	var Rstart = line.find("-> ")
	var Rlength = line.find_last(":") - Rstart
	if "->" in line:
		function["return_type"] = line.substr(Rstart, Rlength)
	
	var argStart = line.find("(") + 1
	var argLength = line.find(")") - argStart
	function["args"] = line.substr(argStart, argLength)
	
	return function
	
func add_inner_class(klass: Object, name: String) -> void:
	klasses.append({"director": klass, "name": name})

func script():
	var script = GDScript.new()
	for klass in klasses:
		klass.director.script()
	script.source_code = SCRIPT_WRITER.new().write(self)
	script.reload() # Necessary to load source code into memory
	return script

func double(deps: Array = [], show_error = true) -> Object:
	if _created:
		# Can only create unique instances
		if show_error:
			push_error("WAT: You can only create one instance of a double. Create a new doubler Object for new Test Doubles")
		return object
	_created = true
	if not deps.empty() and dependecies.empty():
		dependecies = deps
	var script = script()
	object = script.callv("new", dependecies)
	object.WATRegistry.append(registry)
	for m in methods.values():
		m.double = object
	for prop_name in nodepaths:
		object.set(prop_name, nodepaths[prop_name])
	return object
	
func _load_nested_class() -> Script:
	var expression = Expression.new()
	var script = load(klass)
	expression.parse("%s" % [inner_klass])
	return expression.execute([], script, true)
