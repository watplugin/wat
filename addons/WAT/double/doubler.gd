extends Reference
class_name WATDouble

# Controllers
const TOKENIZER = preload("res://addons/WAT/double/tokenizer.gd")
const REWRITER = preload("res://addons/WAT/double/rewriter.gd")

# Data Structures
const BLANK: Script = preload("res://addons/WAT/double/blank.gd")
const SCRIPT_DATA = preload("res://addons/WAT/double/script_data.gd")
const SCENE_DATA = 20
const TEMP_DIR_PATH: String = "user://WATemp/"
const SCRIPT_PATH: String = "%s%s.gd"
const SCENE_PATH: String = "%s%s.tscn"
const NO_SUB_DIR: String = ""

static func scene(tscn):
	# load_scene
	# tokenize scene
	# rewrite scene
	# save scene
	# create
	pass

static func script(gdscript) -> SCRIPT_DATA:
	var script: Script = _load_script(gdscript)
	var tokens = TOKENIZER.start(script)
	var rewrite: String = REWRITER.start(tokens)
	_save_script(tokens.title, rewrite) 
	return SCRIPT_DATA.new(tokens.methods, _load_doubled_script(tokens.title))

	
static func _load_script(gdscript) -> Script:
	assert(gdscript is Script or (gdscript is String and gdscript.ends_with(".gd")))
	return gdscript if gdscript is Script else load(gdscript)
	
static func _save_script(title: String, rewrite: String, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> void:
	_create_directory_if_it_does_not_exist(path)
	# Blank is probably not the best term
	BLANK.source_code = rewrite
	ResourceSaver.save(SCRIPT_PATH % [path, title], BLANK)
	
static func _load_doubled_script(title: String, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> Script:
	return load(SCRIPT_PATH % [path, title]).new()
	
static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)
