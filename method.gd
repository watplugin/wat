extends Reference

var name: String = ""
var spying: bool = false
var stubbed: bool = false
var calls_super: bool = false
var args: String = ""
var keyword: String = ""
var calls: Array = []
var stubs: Array = []
var default

func _init(name):
	self.name = name

func to_string(doubler: String):
	var text: String
	text += "%sfunc %s(%s):" % [keyword, name, args]
	text += "\n\tvar args = [%s]" % args
	if spying:
		text += "\n\tload('%s').add_call('%s', args)" % [doubler, name]
	if stubbed:
		text += "\n\tvar retval = load('%s').get_stub('%s', args)" % [doubler, name]
		text += "\n\treturn retval if not retval is load('%s').CallSuper else .%s(%s)\n" % [doubler, name, args]
	return text

func dummy():
	stubbed = true
	default = null

func spy():
	spying = true

func stub(return_value, arguments: Array = []):
	stubbed = true
	if arguments.empty():
		default = return_value
	else:
		stubs.append({args = arguments, "return_value": return_value})

func add_call(args) -> void:
	calls.append(args)

func get_stub(args):
	for stub in stubs:
		if _pattern_matched(stub.args, args):
			return stub.return_value
	return default

func found_matching_call(expected_args) -> bool:
	for call in calls:
		if _pattern_matched(expected_args, call):
			return true
	return false

func _pattern_matched(pattern: Array, args: Array) -> bool:
	var indices: Array = []
	for index in pattern.size():
		if pattern[index] is Object and pattern[index].get_class() == "Any":
			continue
		indices.append(index)
	for i in indices:
		# We check based on type first otherwise some errors occur (ie object can't be compared to int)
		if typeof(pattern[i]) != typeof(args[i]) or pattern[i] != args[i]:
			return false
	return true