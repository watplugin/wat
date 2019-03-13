extends Node

# extend from resource_path (a doubled script is essentially an overriden subclass)
# check if class_name exists, if it does, replace it with a newline

# func name(param: type, param, )

const USERDIR: String = "user://WAT/"
var _script: Script
var _source: String
var _tokens: Array
var _rewrite: String

func rewrite(script: Script):
	_script = script
	self._source = script.source_code
	_tokenize()
	_parse_to_string()
#	print(_tokens)
	# to string
	# tokenizer
	# parse tokenizer
	# save to USER/WAT/TEMP
	_save_as("test", str(_tokens))
	return null
	
func _tokenize():
	var _results: Array = _source.split("\n")
	for line in _tokens:
		if "var" in line or "func" in line:
			_tokens.append(line)
	_tokens.insert(0, 'extends "%s"' % _script.resource_path)
	_tokens = _results
	print_debug("size: ", _tokens.size())

func _parse_to_string():
	pass
	
func _save_as(title: String, content: String) -> void:
	var file: File = File.new()
	file.open("%s%s.gd", file.WRITE)
	file.store_string(content)
	file.close()

func _create_directory() -> void: # Maybe change this to a bool?
	var dir = Directory.new()
	if not dir.dir_exists(USERDIR):
		dir.make_dir(USERDIR)


#
###	# Add self as metadata to script (we could do a property object but using metadata is more inconspicoius)
### Requirements? (Not set in stone)
### Doubler - Delegates to others
### Writer - Reads/Write saves scripts (probably to a user://WATemp folder
### Config for type checking (do we keep as is, remove param/return types or mod elsewhere?)
### Handle variables (like constants etc)
### Add a Method Class, a Call class (or data structure?)