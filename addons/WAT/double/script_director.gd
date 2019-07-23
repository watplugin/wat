extends Resource
tool

const STATIC: String = "static "
const REMOTE: String = "remote "
const REMOTESYNC: String = "remotesync "
const MASTER: String = "master "
const PUPPET: String = "puppet "
const FILESYSTEM = preload("res://addons/WAT/filesystem.gd")
const SCRIPT_WRITER = preload("res://addons/WAT/double/script_writer.gd")
const Method = preload("res://addons/WAT/double/method.gd")
export (String) var index
export(String) var base_script: String
export(String) var inner: String
var cache: Array = []
var methods: Dictionary = {}
var _created: bool = false
var is_scene: bool = false # Requires some updating post our scene version
var klasses: Array = []
var base_methods: Dictionary = {}
var dependecies: Array = []

func method(name: String, keyword: String = "") -> Method:
	if not methods.has(name):
		methods[name] = Method.new(name, keyword, base_methods[name])
	return methods[name]

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object and not item is Reference and is_instance_valid(item):
				item.free()

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

func call_super(method: String, args: Array = [], keyword: String = "") -> void:
	var m = method(method, keyword)
	m.call_super(args)

func add_inner_class(klass: Resource, name: String) -> void:
	klasses.append({"director": klass, "name": name})

func save() -> String:
	var script = GDScript.new()
	for klass in klasses:
		klass.director.save()
	script.source_code = SCRIPT_WRITER.new().write(self)
	var save_path = "user://WATemp/S%s.gd" % index
	ResourceSaver.save(save_path, script)
	return save_path

func double(show_error = true) -> Object:
	if _created:
		# Can only create unique instances
		if show_error:
			push_error("WAT: You can only create one instance of a double. Create a new doubler Object for new Test Doubles")
		return null
	_created = true
	var save_path = save()
	var object = load(save_path).callv("new", self.dependecies)
	cache.append(object)
	return object