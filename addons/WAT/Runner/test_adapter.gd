extends Node

signal ENDED
var Test: Node
var Yield: Timer
var case: Reference
var methods: Array = []
var active_method: String
var rerun_method: bool

func _init(Test: Node, Yield: Timer, case: Reference) -> void:
	self.Test = Test
	self.case = case
	self.Yield = Yield

func _add_methods() -> void:
	for method in Test.get_method_list():
		if method.name.begins_with("test"):
			methods.append(method.name)

func _ready() -> void:
	case.title = Test.title()
	case.path = Test.path()
	Test.expect.connect("OUTPUT", case, "_add_expectation")
	Test.connect("described", case, "_add_method_context")
	add_child(Yield)
	add_child(Test)
	Test.Yield = Yield

func start() -> void:
	_add_methods()
	Test.start()
	pre()

func pre() -> void:
	if not methods.empty() or Test.rerun_method:
		active_method = active_method if Test.rerun_method else methods.pop_front()
		Test.pre()
		execute()
	else:
		end()

func execute() -> void:
	case.add_method(active_method)
	Test.call(active_method)
	if Yield.active():
		if not Yield.is_connected("resume", self, "post"):
			Yield.connect("resume", self, "post")
		return
	post()

func post() -> void:
	Test.post()
	pre()

func end() -> void:
	Test.end()
	remove_child(Test)
	Test.free()
	emit_signal("ENDED", case)