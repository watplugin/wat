extends Reference

const STATIC: String = "static "
const REMOTE: String = "remote "
const REMOTESYNC: String = "remotesync "
const MASTER: String = "master "
const PUPPET: String = "puppet "
const SCRIPT_WRITER = preload("res://addons/WAT/double/script_writer.gd")
const Method = preload("res://addons/WAT/double/method.gd")
var index: String
var base_script: String
var inner: String = ""
var methods: Dictionary = {}
var _created: bool = false
var is_scene: bool = false
var klasses: Array = []
var base_methods: Dictionary = {}
var dependecies: Array = []
var instance_id: int
var is_built_in: bool = false
var object



func _init(i: String, path: String, inner_klass: String, deps: Array = [], builtin: bool = false) -> void:
	index = i
	base_script = path
	inner = inner_klass
	dependecies = deps
	is_built_in = builtin
	_initialize()

func _initialize() -> void:
	ProjectSettings.get_setting("WAT/TestDouble").register(self)
	
func method(name: String, keyword: String = "") -> Method:
	if not methods.has(name):
		methods[name] = Method.new(name, keyword, base_methods[name])
	return methods[name]

func clear():
	if is_instance_valid(object) and object is Object and not object is Reference:
		object.free()
	object = null

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

func add_inner_class(klass: Object, name: String) -> void:
	klasses.append({"director": klass, "name": name})

func script():
	var script = GDScript.new()
	for klass in klasses:
		klass.director.script()
	script.source_code = SCRIPT_WRITER.new().write(self)
	script.reload() # Necessary to load source code into memory
	return script

func double(deps: Array = [], show_error = true):
	if _created:
		# Can only create unique instances
		if show_error:
			push_error("WAT: You can only create one instance of a double. Create a new doubler Object for new Test Doubles")
		return null
	_created = true
	if not deps.empty() and dependecies.empty():
		dependecies = deps
	object = script().callv("new", dependecies)
	# This is a nasty abuse of const collections not being strongly-typed
	# We're mainly doing this for easy use of static methods
	return object

func method_list() -> Array:
	if is_built_in:
		return ClassDB.class_get_method_list(base_script)
	if inner == "":
		var s = load(base_script)
		var list = s.get_script_method_list()
		list += ClassDB.class_get_method_list(s.get_instance_base_type())
		var filtered = {}
		for m in list:
			if m.name in filtered:
				continue
			filtered[m.name] = m
		return filtered.values()
	var s = _load_nested_class(base_script, inner)
	var list = s.get_script_method_list()
	list += ClassDB.class_get_method_list(s.get_instance_base_type())
	var filtered = {}
	for m in list:
		if m.name in filtered:
			continue
		filtered[m.name] = m
	return filtered.values()

func _load_nested_class(p, i) -> Script:
	var expression = Expression.new()
	var script = load(p)
	expression.parse("%s" % [i])
	return expression.execute([], script, true)
