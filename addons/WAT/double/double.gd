extends Node
class_name WATDouble

const _TEMP: String = "user://WATemp/"
const FILE_PATH: String = "%s%s.gd"
const TOKENIZER = preload("res://addons/WAT/double/tokenizer.gd")
const REWRITER = preload("res://addons/WAT/double/rewriter.gd")
const SCRIPT = preload("res://addons/WAT/double/Blank.gd")
const DOUBLE = preload("method.gd")

static func script(gdscript) -> DOUBLE:
	var script = _load_script(gdscript)
	var source = TOKENIZER.start(script)
	var rewrite: String = REWRITER.start(source)
	_save(source.title, rewrite)
	return DOUBLE.new(source.methods, _load(source.title))
	
static func scene(tscn):
	pass
	
static func _load_script(script) -> Script:
	assert(script is Script or (script is String and script.ends_with(".gd")))
	return script if script is Script else load(script)
	
static func _load_scene(tscn) -> PackedScene:
	assert((tscn is String and tscn.ends_with("tscn")) or tscn is PackedScene)
	return tscn if tscn is PackedScene else load(tscn)
	
### MAKE NEW CLASS
static func _load(title: String) -> Object:
	return load(FILE_PATH % [_TEMP, title]).new()
	
static func _save(title: String, rewrite: String) -> void:
	_create_directory_if_it_does_not_exist_yet()
	SCRIPT.source_code = rewrite
	ResourceSaver.save(FILE_PATH % [_TEMP, title], SCRIPT)

static func _create_directory_if_it_does_not_exist_yet() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(_TEMP):
		dir.make_dir(_TEMP)


