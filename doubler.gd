extends Resource
tool

# TODO
# SceneVersion of doubler

const STATIC: String = "static "
const REMOTE: String = "remote "
const REMOTESYNC: String = "remotesync "
const MASTER: String = "master "
const PUPPET: String = "puppet "
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")
const Method = preload("method.gd")
export (String) var index
export(String) var base_script: String
export(String) var inner: String
var save_path: String = ""
var cache = []
var methods = {} # {Spying: ?, Stub: {MATCH_PATTERNS, default}, dummied} # Can probably rename to methods
var _created = false
var is_scene = false
var base_methods: Dictionary = {}
var klasses: Array = []
var dependecies: Array = []

func add_method(name: String, keyword: String = "") -> void:
	var method: Method
	if not methods.has(name): # If methods does not have method
		method = Method.new(name)
		methods[name] = method
		method.args = base_methods[name]
	else:
		method = methods[name]
	if method.keyword == "" and keyword != "":
		method.keyword = keyword

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object and not item is Reference:
				item.free()

func call_count(method: String) -> int:
	return methods[method].calls.size()

func dummy(method: String, keyword: String = "") -> void:
	add_method(method, keyword)
	methods[method].dummy()

func stub(method: String, return_value, arguments: Array = [], keyword: String = "") -> void:
	add_method(method, keyword)
	methods[method].stub(return_value, arguments)

func get_stub(method: String, args: Array):
	return methods[method].get_stub(args)

func spy(method: String) -> void:
	add_method(method)
	methods[method].spy()

func found_matching_call(method, expected_args: Array):
	return methods[method].found_matching_call(expected_args)

func add_call(method: String, args: Array = []) -> void:
	methods[method].add_call(args)

func call_super(method: String, args: Array = [], keyword: String = "") -> void:
	stub(method, CallSuper.new(), args, keyword)

class CallSuper:

	func _init():
		pass

func add_inner_class(klass, name):
	klasses.append({"doubler": klass, "name": name})

func save() -> String:
	var script = GDScript.new()
	script.source_code = doubled_source_code()
	save_path = "user://WATemp/S%s.gd" % index
	ResourceSaver.save(save_path, script)
	return save_path

func doubled_source_code():
	var script_writer = load("res://script_writer.gd").new()
	var source: String
	source += script_writer.write(self)
	source += add_inner_class_source_code()
	return source

func add_inner_class_source_code():
	var source: String = ""
	for klass in klasses:
		var save_path = klass.doubler.save() # We don't want to call this by scriptwriter
		source += "\nclass %s extends '%s':\n\tconst PLACEHOLDER = 0" % [klass.name, save_path]
	return source

func object() -> Object:
	if _created:
		return null
	_created = true
	# Add a error check here to inform people they've already instanced it.
	# CREATE BASE HERE?
	var save_path = save()
	var object = load(save_path).callv("new", self.dependecies)
	cache.append(object)
	### BEGIN TEST
	## END TEST
	return object