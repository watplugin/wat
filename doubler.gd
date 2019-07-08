extends Resource
tool

export(int) var index: int
export(String) var base_script: String
export(Array, String) var modified_source_code: Array = []

func dummy(method):
	print("dummying method")
	modified_source_code.append("func add(a, b):\n\treturn null")


func object() -> Object:
	var script = load("res://addons/WAT/double/objects/blank.gd").duplicate()
	var source: String = 'extends "%s"\ntool\n' % base_script
	for change in modified_source_code:
		source += change
	script.source_code = source
	var save_path = "user://WATemp/S%s.gd" % index as String
	ResourceSaver.save(save_path, script)
	var dbl = load(save_path)
	dbl.set_script(script)
	print(dbl.source_code)
	print(dbl.new().add(10, 54))
	return dbl.new()
#	return load(save_path).new() # Might be better to load the doubled version?