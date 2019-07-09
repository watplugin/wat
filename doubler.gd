extends Resource
tool

export(int) var index: int
export(String) var base_script: String
export(Array, String) var modified_source_code: Array = []
var save_path: String = ""
var object
var count = 0
var cache = []

const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object:
				item.free()

func dummy(method):
	print("dummying method: ", method )
	modified_source_code.append("func add(a, b):\n\tprint('Calling add with', str(a), '&', str(b))\n\treturn null")

func stub(method: String, return_value):
	print("stubbing method: %s with return value of: %s" % [method, return_value])
	if return_value is bool:
		return_value = str(return_value).to_lower()
	modified_source_code.append("func add(a, b):\n\tprint('Calling add with', str(a), '&', str(b))\n\treturn %s" % str(return_value))

func object() -> Object:
	# Add a error check here to inform people they've already instanced it.
	# Our items are stored in memory and it is bit of a pain to free them if they're referenced
	delete_old_script_if_it_exists()
	var mini_test = false
	var script = GDScript.new()
#	var script = load("res://addons/WAT/double/objects/blank.gd").duplicate(true)
	var source: String = 'extends "%s"\n' % base_script
	for change in modified_source_code:
		source += change
		mini_test = true
	script.source_code = source

	# Freeing these objects are a pain so we want to create a fresh copy time we instance it.
	# However why are we instancing a new copy instead of locking this down after our first instance
	# Forcing users to explicitly call another doubler for the second double (keeping it 1:1 doubler: doubled)
	save_path = "user://WATemp/S%s%s.gd" % [FILESYSTEM.file_list("user://WATemp").size() as String, count as String]
	count += 1
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

func delete_old_script_if_it_exists():
	print("save_path:", save_path)
	if save_path.empty() or save_path == "":
		print("not deleting")
		return
	var dir = Directory.new()
	var exists = dir.file_exists(save_path)
	print("exists?: ", exists, "->", save_path)
	if exists:
		dir.remove(save_path)
		print("deleting")
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