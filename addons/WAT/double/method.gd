extends Reference

var name: String = ""
var spying: bool = false
var stubbed: bool = false
var calls_super: bool = false
var args: String = ""
var keyword: String = ""
var calls: Array = []
var stubs: Array = []
var supers: Array = []
var default

func _init(name: String, keyword: String, args: String) -> void:
	self.name = name
	self.keyword = keyword
	self.args = args

func dummy() -> Reference:
	stubbed = true
	default = null
	return self

func spy() -> Reference:
	spying = true
	return self

func stub(return_value, arguments: Array = []):
	stubbed = true
	if arguments.empty():
		default = return_value
	else:
		stubs.append({args = arguments, "return_value": return_value})
	return self

func add_call(args: Array = []) -> void:
	calls.append(args)

func get_stub(args: Array = []):
	for stub in stubs:
		if _pattern_matched(stub.args, args):
			return stub.return_value
	return default

func executes(args: Array) -> bool:
	for s in supers:
		if self._pattern_matched(s, args):
			return true
	for s in stubs:
		if self._pattern_matched(s.args, args):
			return false
	if supers.has([]):
		return true
	return false

func call_super(args: Array = []) -> void:
	supers.append(args)
	calls_super = true

func found_matching_call(expected_args: Array = []) -> bool:
	for call in calls:
		if _pattern_matched(expected_args, call):
			return true
	return false

func _pattern_matched(pattern: Array = [], args: Array = []) -> bool:
	var indices: Array = []
	if pattern.size() != args.size():
		return false
	for index in pattern.size():
		if pattern[index] is Object and pattern[index].get_class() == "Any":
			continue
		indices.append(index)
	for i in indices:
		# We check based on type first otherwise some errors occur (ie object can't be compared to int)
		if typeof(pattern[i]) != typeof(args[i]) or pattern[i] != args[i]:
			return false
	return true
