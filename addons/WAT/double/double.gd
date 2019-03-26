extends Node
class_name WATDouble

# Should probably split this into three; 
# One for save/load
# one for method managing
# one for middle-man class? 
const _TEMP: String = "user://WATemp/"
const TOKENIZER = preload("res://addons/WAT/double/tokenizer.gd")
const REWRITER = preload("res://addons/WAT/double/rewriter.gd")
const SCRIPT = preload("res://addons/WAT/double/Blank.gd")
const METHOD = preload("method.gd")
var _methods: Dictionary = {}
var instance: Object # May need to change if doubling scenes?

func _init(script):
	if _is_script(script):
		_double_script(_load_script(script))
	elif _is_scene(script):
		_double_scene(_load_script(script)) # All of scenes scripts require a double ref? Maybe root it through parent?
		
func _double_scene(scene):
	pass

func _double_script(script: Script):
	var source = TOKENIZER.start(script)
	# We could probably delegate this to a new class
	for method in source.methods:
		_add_method(method.name)
	var rewrite: String = REWRITER.start(source)
	_save(source.title, rewrite) # Another place for a delegate
	self.instance = _load(source.title)
	instance.set_meta("double", self)
	
func _load_script(script) -> Script:
	assert(script is Script or script is String)
	return script if script is Script else load(script)
	
func _load_scene(scene):
	pass
		
func mfadouble_script(script):
	var source = TOKENIZER.start(script)
	for method in source.methods:
		_add_method(method.name)
	var doubled_source: String = REWRITER.start(source)
	_save(source.title, doubled_source)
	self.instance = _load(source.title)
	instance.set_meta("double", self)
	
func _is_scene(script) -> bool:
	return (script is String and script.ends_with("tscn")) or script is PackedScene
	
func _is_script(script) -> bool:
	return (script is String and script.ends_with("gd") or script is Script)

### MAKE NEW CLASS
static func _load(title: String) -> Object:
	return load("%s%s.gd" % [_TEMP, title]).new()
	
static func _save(title: String, rewrite: String) -> void:
	_create_directory()
	SCRIPT.source_code = rewrite
	ResourceSaver.save("%s%s.gd" % [_TEMP, title], SCRIPT)

static func _create_directory() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(_TEMP):
		dir.make_dir(_TEMP)

# MAKE NEW CLASS
func _add_method(_name: String) -> void:
	var method: METHOD = METHOD.new(_name)
	_methods[_name] = method

func get_retval(id: String, arguments: Dictionary):
	return _methods[id].get_retval(arguments)

func stub(id: String, arguments: Dictionary, retval) -> void:
	_methods[id].stub(arguments, retval)

func call_count(method: String) -> int:
	return _methods[method].call_count
	
func calls(method) -> Array:
	return _methods[method].calls

