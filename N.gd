extends Node

var methods: Dictionary = {} # name: {}
var is_built_in = false
var inner_klass = ""
var klass = "res://N.gd"

func _ready():
	parse_for_methods()
	
func append_function(function: Dictionary) -> void:
	if methods.has(function["name"]):
		return # already parsed in a subclasses
	methods[function["name"]] = function
	
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
	
func simple_func() -> void:
	pass
	
func simple_func_args(a, b: int, c = "Hello", d: int = 100) -> void:
	pass
	
static func static_func() -> void:
	pass
	
remote func remote_func() -> void:
	pass
	
master func master_func() -> void:
	pass
	
puppet func puppet_func() -> void:
	pass
	
slave func slave_func() -> void:
	pass
