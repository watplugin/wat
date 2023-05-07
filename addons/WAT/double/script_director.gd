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
#	set_methods()
	
func method(name: String) -> Method:
	if not methods.has(name):
		methods[name] = Method.new(name, base_methods[name].keyword, base_methods[name].args)
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
	if not is_built_in and inner_klass == "":
		script = load(klass)
		engine_methods = ClassDB.class_get_method_list(script.get_instance_base_type())
		while script != null:
			parse_script(script.source_code)
			script = script.get_base_script()
	else:
		engine_methods = ClassDB.class_get_method_list(klass)
	parse_builtins(engine_methods)
	print("done")
	
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
	
# Replace SetMethods, MethodList & get_args_with_default with the following

# If not built in OR inner class
	# get_script_method_list() // does this only get the immediate script code?
	# parse source-code by new line
	# if line contains func, parse for {keyword}{name}{args,def-args} -> {return type}
	# after all parsed, get base script, check if base script is is user-defined
	# repeat until base script
# parse base script (def-args with normally here)

#func generate_methods():
#	var functions = [] # {keyword}{name}{arg}{ret}
#	var script: GDScript = null
#	if not is_built_in or not inner_klass:
#		script = load(klass)
#		functions += get_functions(script.source_code)
#
#func get_functions(source_code: String):
#	for line in source_code.split("\n"):
#		if "func" in line:
#			var f = {"keyword": "", "name": "", "args": }
#			print(line)

#func set_methods() -> void:
#	var params: String = "abcdefghijklmnopqrstuvwxyz"
#	for m in method_list():
#		var arguments: String = ""
#		# m.args.size() causes crashes in release exports
#		var idx = 0
#		for i in m.args:
#			arguments = arguments + params[idx] + ", "
#			idx += 1
#		var sanitized = arguments.replace(", ", "")
#		arguments = arguments.rstrip(", ")
#		var default_args = arguments
#		var def_idx = 0
#		# m.default_args.size() causes crashes in release exports
#		for def in m.default_args:
#			def_idx += 1
#		if def_idx > 0:
#			default_args = get_args_with_default(sanitized, m.default_args)
#		base_methods[m.name] = {"arguments": arguments, "default_arguments": default_args}
#
#func get_args_with_default(args: String, base_default_args: Array) -> String:
#	var retval_args: String
#	var substr_start = args.length() - base_default_args.size()
#	var length = args.length() # We're transforming in loop so we capture first
#	var arg_index = 0
#	for i in length:
#		if i < substr_start:
#			retval_args += "%s, " % args[i]
#			continue
#		var letter = args[i]
#		var arg = base_default_args[arg_index]
#		if arg is String:
#			retval_args += '%s = "%s", ' % [letter, str(arg)]
#		else:
#			retval_args += '%s = %s, ' % [letter, arg]
#		arg_index += 1
#	retval_args = retval_args.rstrip(", ")
#	return retval_args
#
#func method_list() -> Array:
#	var list: Array = []
#	if is_built_in:
#		return ClassDB.class_get_method_list(klass)
#	var script = load(klass) if inner_klass == "" else _load_nested_class()
##	# We get our script methods first in case there is a custom constructor
##	# This way we don't end up reading the empty base constructors of Object
#	list += script.get_script_method_list()
#	list += ClassDB.class_get_method_list(script.get_instance_base_type())
#	var filtered = {}
#	for m in list:
#		if m.name in filtered:
#			continue
#		filtered[m.name] = m
#	return filtered.values()	
## END METHOD CLASS

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
	object = script().callv("new", dependecies)
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
