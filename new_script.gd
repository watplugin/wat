extends EditorScript
tool

#func _run():
#	var path = "res://addons/WAT/expectations"
#	var d = Directory.new()
#	d.open(path)
#	d.list_dir_begin(true)
#	var file = d.get_next()
#	while file != "":
#		if file.ends_with(".gd") and not (file.begins_with("0_index") or file.begins_with("base")):
#			replace(path + "/" + file)
#		file = d.get_next()
#	print("end")
#
#func replace(file: String):
#	var script = load(file)
#	var list = Array(file.replace(".gd", "").split("/")).back().split("_")
#	for i in list.size():
#		list[i] = list[i].capitalize()
#	var box = "[Expect.]"
#	var default = PoolStringArray(list).join(" ")
#	box = box.insert(8, default).replace(" ", "")
##	print(script.source_code)
#	var replacer = 'self.context = "{expect} %s" % context'.format({"expect": box})
##	print()
#	script.source_code = script.source_code.replace("self.context = context", replacer)
#	ResourceSaver.save(file, script)
##	print(script.source_code)
##	var s = load(file)
##	if not s.source_code.begins_with('extends "base.gd"'):
##		s.source_code = s.source_code.insert(0, 'extends "base.gd"\n\n')
##		ResourceSaver.save(file, s)
##		print("break")
##
