extends Resource
tool

# TODO
# SuperCall (Stub to call super if passed x, y, z OR default to call super if not stubbed?)
# CalledWithArguments check
# SceneVersion of doubler
# Keywords for static methods etc
# Add dependency managers (Constructor and Setter)
# Deal with Inner Classes


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
#export(Array, String) var modified_source_code: Array = []
var save_path: String = ""
var cache = []
var stubs = {} # {method: retval} # We can add this to the method object directly
var spies = {} # method / count # We can add this to the method object directly
var methods = {} # {Spying: ?, Stub: {MATCH_PATTERNS, default}, dummied} # Can probably rename to methods
var _created = false
var is_scene = false



func add_method(method: String, keyword: String = "") -> void:
	if not methods.has(method):
		methods[method] = Method.new(method)
	if methods[method].keyword == "" and keyword != "":
		methods[method].keyword = keyword

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object and not item is Reference:
				item.free()

func call_count(method: String) -> int:
	return methods[method].calls.size()

func dummy(method: String, keyword: String = "") -> void:
	add_method(method, keyword)
	methods[method].stubbed = true
	if not stubs.has(method):
		stubs[method] = {default = null, patterns = []}
	stubs[method].default = null

func stub(method: String, return_value, arguments: Array = [], keyword: String = "") -> void:
	add_method(method, keyword)
	methods[method].stubbed = true

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
	methods[method].spying = true
	spies[method] = []

func found_matching_call(method, expected_args: Array):
	var calls: Array = methods[method].calls
	for call in calls:
		if _pattern_matched(expected_args, call):
			return true
	return false

func add_call(method: String, args: Array = []) -> void:
	methods[method].add_call(args)

func call_super(method: String, args: Array = [], keyword: String = "") -> void:
	stub(method, CallSuper.new(), args, keyword)

class CallSuper:

	func _init():
		pass

var instanced_base

func instance_base():
	self.instanced_base = load(base_script).new()

var klasses: Array = []

func add_inner_class(klass, name):
	klasses.append({"doubler": klass, "name": name})

func method_args():
	var base_methods: Dictionary
	for m in self.instanced_base.get_method_list():
		if methods.has(m.name):
			methods[m.name].args = "a,b,c,d,e,f,g,h,i,j,".substr(0, m.args.size() * 2 - 1)

func save() -> String:
	instance_base()
	method_args()
	var script = GDScript.new()
	var source: String
	# Top Level Code
	if inner != "":
		source = 'extends "%s".%s\n' % [base_script, inner]
		source += "\nconst BASE = preload('%s').%s\n\n" % [base_script, inner]
	else:
		source = 'extends "%s"\n' % base_script
		source += "\nconst BASE = preload('%s')\n\n" % base_script
	for name in methods:
		source += methods[name].to_string(self.resource_path)

	# Add Inner Classes Here?
	var x = false
	for klass in klasses:
		# class Name extends Path\n\t const PLACEHOLDER = 0
		var save_path = klass.doubler.save()
		source += "\nclass %s extends '%s':\n\tconst PLACEHOLDER = 0" % [klass.name, save_path]
		x = true
	if x:
		print(source)
	script.source_code = source
	if inner != "":
		print("BEGIN\n%s\nEND" % script.source_code)
	save_path = "user://WATemp/S%s.gd" % index
	ResourceSaver.save(save_path, script)
	return save_path

func object() -> Object:
	if _created:
		return null
	_created = true
	# Add a error check here to inform people they've already instanced it.
	# CREATE BASE HERE?
	instance_base()
	method_args()
	var save_path = save()
	var object = load(save_path).new()
	cache.append(object)
	### BEGIN TEST
	## END TEST
	return object