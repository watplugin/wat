extends EditorScript
tool

func _run():
	var path = "res://addons/WAT/expectations"
	var d = Directory.new()
	d.open(path)
	d.list_dir_begin(true)
	var file = d.get_next()
	while file != "":
		if file.ends_with(".gd"):
			replace(path + "/" + file)
		file = d.get_next()
	print("end")

func replace(file: String):
	var s = load(file)
	if not s.source_code.begins_with('extends "base.gd"'):
		s.source_code = s.source_code.insert(0, 'extends "base.gd"\n\n')
		ResourceSaver.save(file, s)
		print("break")
