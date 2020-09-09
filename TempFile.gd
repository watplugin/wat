extends Node


func _ready():
	var main_src: String
	var dir = Directory.new()
	var path = "res://addons/WAT/core/assertions/is_not"
	dir.open(path)
	dir.list_dir_begin(true)
	var filename = dir.get_next()
	while filename != "":
		var file: Script = load(path + "/" + filename)
		var src: String = rewrite_source(filename.replace(".gd", ""), file.source_code)
		main_src += src
		filename = dir.get_next()
	dir.list_dir_end()
	var script = GDScript.new()
	script.source_code = main_src
	ResourceSaver.save("res://is_not.gd", script)
	get_tree().quit()

func rewrite_source(filename: String, source: String) -> String:
	source = source.replace('extends "../base.gd"', "")
	source = source.replace("func", "static func")
	source = source.replace("_init", filename)
	source = source.replace("self.", "var ")
	source = source.replace("var success else", "success else")
	source = source.replace("var context = context", "REPLACE THIS")
	source = source.replace("void", "AssertionResult")
	var rewritten: String
	var lines = source.split("\n", true)
	for line in lines:
		if("REPLACE THIS" in line):
			continue
		rewritten += line + "\n"
	rewritten += "\treturn _result(success, passed, result, context)"
	return rewritten
