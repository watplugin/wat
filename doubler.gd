extends Resource
tool

export (String) var index
export(String) var base_script: String
export(Array, String) var modified_source_code: Array = []
var save_path: String = ""
var object
var cache = []
var stubs = {} # {method: retval}
var spies = {} # method / count
var definitions = {} # {Spying: ?, Stub: {MATCH_PATTERNS, default}, dummied}
var _created = false
var is_scene = false

const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object:
				item.free()

func call_count(method):
	return spies[method]
	print("checking call count for %s")

func dummy(method):
	print("dummying method: ", method )
	if not definitions.has(method):
		definitions[method] = {spying = false, stubbed = false, calls_super = false}
	definitions[method].stubbed = true
	if not stubs.has(method):
		stubs[method] = {default = null, patterns = []}
	stubs[method].default = null

func stub(method: String, return_value, arguments: Array = []):
	if not definitions.has(method):
		definitions[method] = {spying = false, stubbed = false, calls_super = false}
	definitions[method].stubbed = true
	print("stubbing method: %s with return value of: %s" % [method, return_value])
	if not stubs.has(method):
		stubs[method] = {default = null, patterns = []}
	if stubs.has("method"):
		push_error("WAT: This Method has already been stubbed")
		return
		# We're returning this directly, problablly need a new method
	if arguments.empty():
		stubs[method].default = return_value
	else:
		stubs[method].patterns.append({args = arguments, "return_value": return_value})

func get_stub(method, args):
	print(stubs)
	var stubbed = stubs[method]
	print(method)
	print(stubbed)
	for s in stubbed.patterns:
		if args == s.args:
			# This might cause issues with special objects
			print("returning ", s.return_value)
			return s.return_value
	# If none match, we return the default
	return stubbed.default

func spy(method: String) -> void:
	if not definitions.has(method):
		definitions[method] = {spying = false, stubbed = false, calls_super = false}
	definitions[method].spying = true
	spies[method] = 0

func create_function(name):
	var method = definitions[name]
	var function_text = "func %s(a, b):" % name
	function_text += "\n\tvar args = [a, b]"
	if method.spying:
		function_text += "\n\tload('%s').spies['%s'] += 1" % [resource_path, name]
	if method.stubbed:
		function_text += "\n\treturn load('%s').get_stub('%s', args)" % [resource_path, name]
	assert(function_text.split("\n").size() > 1)
	return function_text

func object():
	if _created:
		return null
	_created = true
	# Add a error check here to inform people they've already instanced it.
	# Our items are stored in memory and it is bit of a pain to free them if they're referenced
#	delete_old_script_if_it_exists()
	var mini_test = false
	var script = GDScript.new()
#	var script = load("res://addons/WAT/double/objects/blank.gd").duplicate(true)
	var source: String = 'extends "%s"\n' % base_script
	for name in definitions:
		source += create_function(name)
#	for change in modified_source_code:
#		source += change
#		mini_test = true
	script.source_code = source
	print("000000000000000000000000")
	print(script.source_code)
	print("1111111111111111111111111")

	# Freeing these objects are a pain so we want to create a fresh copy time we instance it.
	# However why are we instancing a new copy instead of locking this down after our first instance
	# Forcing users to explicitly call another doubler for the second double (keeping it 1:1 doubler: doubled)
	save_path = "user://WATemp/S%s.gd" % index
	print("saving @%s" % save_path)
	ResourceSaver.save(save_path, script)
	var object = load(save_path).new()
	cache.append(object)
	print("loading @%s" % save_path)
	### BEGIN TEST
	if mini_test:
		var equal = object.get_script().source_code == script.source_code
		print("equal source code?: ", equal)
		if not equal:
			print("---BEGIN-BEFORE-SAVE---\n", script.source_code, "\n---END-BEFORE-SAVE---\n")
			print("---BEGIN-AFTER-LOAD---\n", object.get_script().source_code, "\n---END-AFTER-LOAD")
	## END TEST
	return object

#func delete_old_script_if_it_exists():
#	print("save_path:", save_path)
#	if save_path.empty() or save_path == "":
#		print("not deleting")
#		return
#	var dir = Directory.new()
#	var exists = dir.file_exists(save_path)
#	print("exists?: ", exists, "->", save_path)
#	if exists:
#		dir.remove(save_path)
#		print("deleting")
#	var dir = Directory.new()
#	dir.open("user://WATemp")
#	if dir.file_exists(save_path):
#		print("removing: ", save_path)
#		dir.remove(save_path)

#
#	var dbl = load(save_path)
#	dbl.set_script(script)
#	print(dbl.source_code)
#	print(dbl.new().add(10, 54))
#	return dbl.new()
##	return load(save_path).new() # Might be better to load the doubled version?