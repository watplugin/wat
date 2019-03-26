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

# Goal 1: All Nodes share the same meta method instance
# Goal 2: Add a toggle for scene or script double (this is probably what should be duplicated)
# Goal 3: Adding a toggle in rewriter is likely unnecessary (double will always be double)
static func scene(tscn):
	# Require to push directories
	
	# Loading Scene
	var scene = _load_scene(tscn)
	
	# Create Scene Dir
	_create_directory_if_it_does_not_exist_yet()
	var dir = Directory.new()
	dir.make_dir(_TEMP + scene.name)
	var dirpath = _TEMP + scene.name
	var frontier: Array = []
	for node in scene.get_children():
		frontier.append(node)
	while not frontier.empty():
		var node = frontier.pop_front()
		frontier += node.get_children()
		if node.script != null: # if custom script
			var script = _load_script(node.script)
			var source = TOKENIZER.start(script) # If two different nodes share the same method, add a qualifer later on?
			# var methods
			var rewrite: String = REWRITER.start(source)
			SCRIPT.source_code = rewrite
			ResourceSaver.save(FILE_PATH % [dirpath, source.title], SCRIPT)
			node.set_script(load(FILE_PATH % [dirpath, source.title]))
	var double = PackedScene.new()
	double.pack(scene)
	ResourceSaver.save(_TEMP + dirpath + "/" + scene.name + ".gd", double)
	return null
			
static func _load_script(script) -> Script:
	assert(script is Script or (script is String and script.ends_with(".gd")))
	return script if script is Script else load(script)
	
static func _load_scene(tscn) -> Node:
	assert((tscn is String and tscn.ends_with("tscn")) or tscn is PackedScene)
	return tscn.instance() if tscn is PackedScene else load(tscn).instance()
	
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


