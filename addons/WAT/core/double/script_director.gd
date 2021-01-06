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
	set_methods()
	
func method(name: String, keyword: String = "") -> Method:
	if not methods.has(name):
		methods[name] = Method.new(name, keyword, base_methods[name].arguments, base_methods[name].default_arguments)
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
	
func set_methods() -> void:
	var params: String = "abcdefghij"
	for m in method_list():
		var arguments: String = ""
		# m.args.size() causes crashes in release exports
		var idx = 0
		for i in m.args:
			arguments = arguments + params[idx] + ", "
			idx += 1
		var sanitized = arguments.replace(", ", "")
		arguments = arguments.rstrip(", ")
		var default_args = arguments
		var def_idx = 0
		# m.default_args.size() causes crashes in release exports
		for def in m.default_args:
			def_idx += 1
		if def_idx > 0:
			default_args = get_args_with_default(sanitized, m.default_args)
		base_methods[m.name] = {"arguments": arguments, "default_arguments": default_args}
		
func get_args_with_default(args: String, base_default_args: Array) -> String:
	var retval_args: String
	var substr_start = args.length() - base_default_args.size()
	var length = args.length() # We're transforming in loop so we capture first
	var arg_index = 0
	for i in length:
		if i < substr_start:
			retval_args += "%s, " % args[i]
			continue
		var letter = args[i]
		var arg = base_default_args[arg_index]
		if arg is String:
			retval_args += '%s = "%s", ' % [letter, str(arg)]
		else:
			retval_args += '%s = %s, ' % [letter, arg]
		arg_index += 1
	retval_args = retval_args.rstrip(", ")
	return retval_args

func method_list() -> Array:
	var list: Array = []
	if is_built_in:
		return ClassDB.class_get_method_list(klass)
	var script = load(klass) if inner_klass == "" else _load_nested_class()
#	# We get our script methods first in case there is a custom constructor
#	# This way we don't end up reading the empty base constructors of Object
	list += script.get_script_method_list()
	list += ClassDB.class_get_method_list(script.get_instance_base_type())
	var filtered = {}
	for m in list:
		if m.name in filtered:
			continue
		filtered[m.name] = m
	return filtered.values()	
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
