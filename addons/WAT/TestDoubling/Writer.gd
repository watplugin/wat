extends Reference

const _USERDIR: String = "user://WATemp/"

class Source extends Reference:
	var extending: String
	var script: Script
	var string: String
	var tokens: Array
	var methods: Array
	var rewrite: String
	var title: String
	
	func _init():
		# Its seem in-editor scripts have a hard time freeing themselves? So we do it before hand just to be sure
		extending = ""
		string = ""
		tokens = []
		methods = []
		rewrite = ""
		title = ""
	
func rewrite(script: Script):
	var source = Source.new()
	_set_script(source, script)
	_set_extends(source, script)
	_set_title(source)
	# This is so we don't rewrite variables that already exist in parent scopes
	while script:
		source.string = script.source_code
		_tokenize(source)
		# This becomes null if it hits a built in class
		script = script.get_base_script()
	_parse(source)
	_save(source)
	return _instance(source)

func _set_script(source: Source, script) -> void:
	assert(script is Script or Script is String)
	source.script = script if script is Script else load(script)

func _tokenize(source: Source) -> void:
	var lines: Array = source.string.split("\n")
	for line in lines:
		if line.begins_with("func") and not line.split(" ")[1] in source.methods:
			source.tokens.append(line.dedent())
			source.methods.append(line.split(" ")[1])
#		elif not is_parent_scope and (line.begins_with("var") or line.begins_with("const") or line.begins_with("signal")):
#			source.tokens.append(line.dedent())

func _parse(source: Source) -> void:
	for line in source.tokens:
		if line.begins_with("func"):
			source.rewrite += "\n%s" % (line + _arguments(_parameter_dict(line)) + _retval_delegate(_identifier(line)))
		elif line.begins_with("var") or line.begins_with("const") or line.begins_with("signal"):
			source.rewrite += "%s\n" % line

func _instance(source: Source) -> Script:
	return load("%s%s.gd" % [_USERDIR, source.title]).new()

func _save(source) -> void:
	_create_directory()
	var file: File = File.new()
	#warning-ignore:return_value_discarded
	file.open("%s%s.gd" % [_USERDIR, source.title], file.WRITE)
	file.store_string(source.rewrite)
	file.close()

func _create_directory() -> void: # Maybe change this to a bool?
	var dir = Directory.new()
	if not dir.dir_exists(_USERDIR):
		dir.make_dir(_USERDIR)
		
# Helper queries
func _set_extends(source, script) -> void:
	source.rewrite = 'extends "%s"\n\n' % script.resource_path
	
func _set_title(source: Source) -> void:
	source.title = "Doubled_%s" % Array(source.script.resource_path.replace(".gd", "").split("/")).pop_back()
	
func _parameter_dict(line: String) -> Dictionary:
	var results: Dictionary = {}
	for parameter in _parameter_list(line):
		parameter = parameter.dedent()
		if parameter.empty():
			continue
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