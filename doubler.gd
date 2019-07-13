extends Resource
tool

const STATIC: String = "static "
const REMOTE: String = "remote "
const REMOTESYNC: String = "remotesync "
const MASTER: String = "master "
const PUPPET: String = "puppet "
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")
const SCRIPT_WRITER = preload("res://script_writer.gd")
const Method = preload("method.gd")
export (String) var index
export(String) var base_script: String
export(String) var inner: String
var save_path: String = ""
var cache = []
var methods = {}
var _created = false
var is_scene = false
var base_methods: Dictionary = {}
var klasses: Array = []
var dependecies: Array = []

func method(name: String, keyword: String = "") -> Method:
	if not methods.has(name): # If methods does not have method
		methods[name] = Method.new(name, keyword, base_methods[name])
	return methods[name]

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object and not item is Reference:
				item.free()

func call_count(method: String) -> int:
	return methods[method].calls.size()

func get_stub(method: String, args: Array):
	# We might be able to write this into source?
	# However reducing how much we right might be best
	return methods[method].get_stub(args)

func found_matching_call(method, expected_args: Array):
	return methods[method].found_matching_call(expected_args)

func add_call(method: String, args: Array = []) -> void:
	methods[method].add_call(args)

func call_super(method: String, args: Array = [], keyword: String = "") -> void:
	var m = method(method, keyword)
	m.stub(CallSuper.new(), args)

class CallSuper:

	func _init():
		pass

func add_inner_class(klass, name):
	klasses.append({"doubler": klass, "name": name})

func save() -> String:
	var script = GDScript.new()
	for klass in klasses:
		klass.doubler.save()
	script.source_code = SCRIPT_WRITER.new().write(self)
	save_path = "user://WATemp/S%s.gd" % index
	ResourceSaver.save(save_path, script)
	return save_path

func object() -> Object:
	if _created:
		# Can only create unique instances
		return null
	_created = true
	var save_path = save()
	var object = load(save_path).callv("new", self.dependecies)
	cache.append(object)
	return object