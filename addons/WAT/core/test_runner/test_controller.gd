extends Node

const Log: Script = preload("res://addons/WAT/log.gd")
const Test: Script = preload("res://addons/WAT/core/test/test.gd")
const Case: Script = preload("res://addons/WAT/core/test/case.gd")
const Assertions: Script = preload("res://addons/WAT/core/assertions/assertions.gd")
const Parameters: Script = preload("res://addons/WAT/core/test/parameters.gd")
const Recorder: Script = preload("res://addons/WAT/core/test/recorder.gd")
const Watcher: Script = preload("res://addons/WAT/core/test/watcher.gd")
const Any: Script = preload("res://addons/WAT/core/test/any.gd")
const Director: Script = preload("res://addons/WAT/core/double/factory.gd")
const Registry: Script = preload("res://addons/WAT/core/double/registry.gd")
const Yielder: Script = preload("res://addons/WAT/core/test/yielder.gd")
enum { START, PRE, EXECUTE, POST, END }
signal finished
signal done

var _test: Test
var _case: Node
var _state: int = START
var _cursor: int = -1
var _methods: PoolStringArray = []
var _current_method: String
var _assertions: Assertions
var _parameters: Parameters
var _watcher: Watcher
var _director: Director
var _registry: Registry
var _yielder: Yielder

func _init() -> void:
	_assertions = Assertions.new()
	_parameters = Parameters.new()
	_watcher = Watcher.new()
	_director = Director.new()
	_registry = Registry.new()
	_yielder = Yielder.new()
	_director.registry = _registry
	add_child(_yielder)
	_yielder.connect("finished", self, "_next")

func run(test: Dictionary) -> void:
	Log.method("run", self)
	_test = test["script"].new()
	_case = Case.new(_test, test["path"])
	_test.asserts = _assertions
	_test.parameters = _parameters
	_test.recorder = Recorder
	_test.watcher = _watcher
	_test.direct = _director
	_test.yielder = _yielder
	_test.any = Any
	if test.has("method"):
		_methods.append(test["method"])
	else:
		_methods = _test.methods()
	if _methods.empty():
		push_warning("No Tests found in " + test["path"] + "")
		call_deferred("_complete")
		return
	_test.connect("cancelled", self, "_on_test_cancelled")
	_test.connect("described", _case, "_on_test_method_described")
	_assertions.connect("asserted", _case, "_on_asserted")
	_assertions.connect("asserted", _test, "_on_last_assertion")
	add_child(_test)
	_start()
	
func _change_state() -> void:
	if _yielder.is_active():
		return
	if _state == END: #or _is_done(): // This is exiting too quickly
		_complete()
		return
	match _state:
		START:
			_pre()
		PRE:
			_execute()
		EXECUTE:
			_post()
		POST:
			_pre() if not _is_done() else _end()
		END:
			_end()
			
func _next(vargs: Array = []) -> void:
	# When yielding until signals or timeouts, this gets called on resume
	# We call defer here to give the __testcase method time to reach either the end
	# or an extra yield at which point we're able to check the _state of the yield and
	# see if we stay paused or can continue
	call_deferred("_change_state")
			
func _start() -> void:
	_cursor = -1
	_state = START
	_test.start()
	_next()
	
func _pre() -> void:
	_state = PRE
	_test.pre()
	_next()
	
func _execute() -> void:
	_state = EXECUTE
	_current_method = _next_test_method()
	_case.add_method(_current_method)
	_test.call(_current_method)
	_next()
	
func _post() -> void:
	_state = POST #if _is_done() else END
	_test.post()
	_next()
	
func _end() -> void:
	_state = END
	_test.end()
	_next()
	
func _next_test_method() -> String:
	if _test.rerun_method:
		return _current_method
	_cursor += 1
	return _methods[_cursor]
		
func _is_done() -> bool:
	return _cursor == _methods.size() - 1 and not _test.rerun_method
	
func get_results() -> Dictionary:
	_case.calculate()
	var results: Dictionary = _case.to_dictionary()
	_case.free()
	return results
	
func _complete() -> void:
	Log.event("finished", self)
	_test.free()
	emit_signal("finished")

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_registry.clear()
		_assertions.free()
		_registry.free()
		_director.free()
		_watcher.clear()
		if is_instance_valid(_case):
			_case.free()
