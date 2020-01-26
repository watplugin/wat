extends EditorScript
tool

func _run():
	var d = Directory.new()
	d.open("res://addons/WAT/assertions/is")
	d.list_dir_begin(true)
	var filename = d.get_next()
	while filename != "":
		print(filename)
		var res = load("res://addons/WAT/assertions/is/%s" % filename)
		print(res.source_code)
#		res.source_code = res.source_code.replace('extends "base.gd"', 'extends "../base.gd"')
#		ResourceSaver.save(res.resource_path, res)
		filename = d.get_next()
