extends Reference

const _USERDIR: String = "user://WAT/"
var _script: Script
var _source: String
var _title: String
var _tokens: Array
var _rewrite: String

func rewrite(script: Script):
	_script = script
	self._source = script.source_code
	_set_title()
	_tokenize()
	_parse_to_string()
	_save()
	return null
	
func _set_title():
	_title = "Doubled_%s" % _get_script_title()
	print(_title)

func _tokenize() -> void:
	_tokens = [] # For some reason this doesn't seem to get cleared when creating a new instance despite not being const?
	var _results: Array = _source.split("\n")
	for line in _results:
		if _begins_with_keyword(line):
			_tokens.append(line.dedent())
#
func _parse_to_string() -> void:
	_rewrite = _get_extends()
	for line in _tokens:
		if line.begins_with("func"):
			_rewrite += _method(line)
		elif line.begins_with("var"):
			_rewrite += _var(line)
			
func _method(line: String) -> String:
	# Keeping the return value in there if it is already there (the "line" value)
	var function = line + _arguments(_parameter_dict(line)) + _retval_delegate(_identifier(line))
	return function

func _var(line):
	pass

func _save() -> void:
	var file: File = File.new()
	#warning-ignore:return_value_discarded
	file.open("%s%s.gd" % [_USERDIR, _title], file.WRITE)
	file.store_string(_rewrite)
	file.close()

func _create_directory() -> void: # Maybe change this to a bool?
	var dir = Directory.new()
	if not dir.dir_exists(_USERDIR):
		dir.make_dir(_USERDIR)
		
# Helper queries
func _get_extends() -> String:
	return 'extends "%s"\n\n' % _script.resource_path

func _begins_with_keyword(line: String) -> bool:
	return line.begins_with("var") or line.begins_with("func")
	
func _get_script_title() -> String:
	return Array(_script.resource_path.replace(".gd", "").split("/")).pop_back()
	
func _parameter_dict(line: String) -> Dictionary:
	var results: Dictionary = {}
	for parameter in _parameter_list(line):
		parameter = parameter.dedent()
		if _has_type(parameter):
			parameter = parameter.split(":")[0]
		results['"%s"' % parameter] = parameter
	return results
	
func _parameter_list(line: String) -> Array:
	return Array(line.split("(")[1].split(")")[0].split(","))
	
func _has_type(parameter: String) -> bool:
	return ":" in parameter
	
func _identifier(line: String) -> String:
	return line.replace("(", " ").split(" ")[1]
	
func _arguments(params: Dictionary) -> String:
	return "\n\tvar parameters = %s" % params
	
func _retval_delegate(identifier: String) -> String:
	return "\n\treturn self.get_meta('double').get_retval('%s', parameters)\n" % identifier