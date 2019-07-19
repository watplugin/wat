extends Node

signal ENDED
var test: WATTest
var methods: Array = []
var active_method: String
var rerun_method: bool
var Yield: Timer
var case: Reference

func _init(test: WATTest, case: Reference, Yield: Timer) -> void:
	self.test = test
	self.case = case
	self.Yield = Yield

func _add_methods() -> void:
	for method in test.get_method_list():
		if method.name.begins_with("test"):
			methods.append(method.name)

func start() -> void:
	_add_methods()
	test.start()
	pre()

func pre() -> void:
	if not methods.empty() or test.rerun_method:
		active_method = active_method if test.rerun_method else methods.pop_front()
		test.pre()
		execute()
	else:
		end()

func execute() -> void:
	case.add_method(active_method)
	test.call(active_method)
	if Yield.active():
		Yield.connect("resume", self, "post", [], CONNECT_ONESHOT)
		return
	post()

func post() -> void:
	test.post()
	pre()

func end() -> void:
	test.end()
	remove_child(test)
	test.free()
	emit_signal("ENDED", case)

func until_signal(time_limit: float, emitter: Object, event: String) -> Timer:
	return Yield.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Timer:
	return Yield.until_timeout(time_limit)