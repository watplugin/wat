extends Node

signal ENDED
var test: WATTest
var methods: Array = []
var active_method: String
var rerun_method: bool
var Yield: Timer
var case

func _init(test: WATTest, methods: Array, case, Yield) -> void:
	self.test = test
	self.methods = methods
	self.case = case
	self.Yield = Yield
	add_child(test)

func start():
	test.start()
	pre()

func pre():
	if not methods.empty() or test.rerun_method:
		active_method = active_method if test.rerun_method else methods.pop_front()
		test.pre()
		execute()
	else:
		end()

func execute():
	case.add_method(_displayable_method())
	test.call(active_method)
	if Yield.active():
		Yield.connect("resume", self, "post", [], CONNECT_ONESHOT)
		return
	post()

func post():
	test.post()
	pre()

func end():
	test.end()
	remove_child(test)
	test.free()
	emit_signal("ENDED", case)

func until_signal(time_limit: float, emitter: Object, event: String) -> Timer:
	return Yield.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Timer:
	return Yield.until_timeout(time_limit)

func _displayable_method() -> String:
	return active_method.substr(active_method.find("_"), active_method.length()).replace("_", " ")