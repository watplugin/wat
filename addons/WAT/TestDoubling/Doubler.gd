extends Node
# If we're prefixing everything with WAT, might be better
# to have a WAT accessor script (maybe the config?)
class_name WATDouble

const USERDIR = "user://WAT/"
var instance
var methods: Dictionary = {}

func _init(script: Script) -> void:
	print(script.get("class_name"))
	var source: String = _rewrite(script)
	var dir = Directory.new()
	if not dir.dir_exists(USERDIR):
		dir.make_dir(USERDIR)
	var file: File = File.new()
	file.open("%s%s.gd" %[USERDIR, "test"], file.WRITE)
	file.store_string(source)
	file.close()
	
func _rewrite(script: Script) -> String:
	var lines: Array = script.source_code.split('\n')
	var source: String
	source += '"extends %s"' % script.resource_path
	for line in lines:
		source += parse(line)
	return source
	
func parse(line):
	if line.begins_with("func"):
		var split: Array = line.replace("(", " ").replace(")", " ").replace(",", "").replace(" ->", "->").split(" ")
		print(split)
		var keyword: String = split[0]
		var identifer: String = split[1]
#		var parameters: Dictionary = _parameters(split)
		if "->" in split: # is this correct?
			var retval: String = split[split.size()-1].replace("")
	return ""
#
#func _parameters(split: Array):
#	split.remove(0)
#	split.remove(1)
#	for line in split:
#	var parameters: Dictionary # {name: type, name: type, name: type} ?
#
##		var keyword: String = "func"
##		var identifier: String = line.split(" ")[1]
#
## func name(parameters):
##	var parameters: Dictionary = {name: value}
##	return self.get_meta("double").get_retval(name, parameters)
#
##	# Add self as metadata to script (we could do a property object but using metadata is more inconspicoius)
## Requirements? (Not set in stone)
## Doubler - Delegates to others
## Writer - Reads/Write saves scripts (probably to a user://WATemp folder
## Config for type checking (do we keep as is, remove param/return types or mod elsewhere?)
## Handle variables (like constants etc)
## Add a Method Class, a Call class (or data structure?)