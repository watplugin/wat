extends Reference

var name: String = ""
var spying: bool = false
var stubbed: bool = false
var calls_super: bool = false
var args: String = ""
var keyword: String = ""
var calls: Array = []

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

func add_call(args) -> void:
	calls.append(args)