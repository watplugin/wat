extends Reference

const _USERDIR: String = "user://WAT/"
var _script: Script
var _source: String
var _tokens: Array
var _rewrite: String

func rewrite(script: Script):
	_script = script
	self._source = script.source_code
	_tokenize()
	_parse_to_string()
	_save_as("test", _rewrite)
	return null

func _tokenize() -> void:
	_tokens = []
	var _results: Array = _source.split("\n")
	for line in _results:
		if "var" in line or "func" in line:
			_tokens.append(line.dedent())
#
func _parse_to_string() -> void:
	_rewrite = 'extends "%s"\n\n' % _script.resource_path
	for line in _tokens:
		if line.begins_with("func"):
			_rewrite += _method(line)
		elif line.begins_with("var"):
			_rewrite += _var(line)
			
func _method(line: String) -> String:
	var identifier = line.replace("(", " ").split(" ")[1]
	var parameters = line.split("(")[1].split(")")[0].split(",")
	var params: Dictionary = {}
	for parameter in parameters:
		parameter = parameter.dedent()
		if ":" in parameter:
			parameter = parameter.split(":")[0]	
		params['"%s"' % parameter] = parameter
	var signature: String = line # Keeping the return value in there if it is already there
	var arguments: String = "\n\tvar parameters = %s" % params
	var retval: String = "\n\treturn self.get_meta('double').get_retval('%s', parameters)\n" % identifier
	var function = signature + arguments + retval
	return function

func _var(line):
	pass

func _save_as(title: String, content: String) -> void:
	var file: File = File.new()
	#warning-ignore:return_value_discarded
	file.open("%s%s.gd" % [_USERDIR, title], file.WRITE)
	file.store_string(content)
	file.close()

func _create_directory() -> void: # Maybe change this to a bool?
	var dir = Directory.new()
	if not dir.dir_exists(_USERDIR):
		dir.make_dir(_USERDIR)