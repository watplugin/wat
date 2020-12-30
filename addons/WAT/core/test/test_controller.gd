extends Node

enum { START, PRE, EXECUTE, POST, END }
signal finished
var _state = START
var _assertions: WAT.Asserts = WAT.Asserts.new()
var _yielder: WAT.Yielder = WAT.Yielder.new()
var _parameters: WAT.Parameters = WAT.Parameters.new()
var _watcher: WAT.SignalWatcher = WAT.SignalWatcher.new()
var _director: WAT.TestDoubleFactory = WAT.TestDoubleFactory.new()
var _recorder = WAT.Recorder
var _test: WAT.Test
var _case: WAT.TestCase
var _methods: PoolStringArray = []
var _current_method: String
var _cursor = -1
var _repeat = 0
var results: Dictionary setget ,_get_results

#	test.recorder = Recorder

func _get_results() -> Dictionary:
	_case.calculate()
	return _case.to_dictionary()

func _init(test = null, yielder = null, case = null) -> void:
	# We may need to recreate our yielders per test
	add_child(_yielder)
	_yielder.connect("finished", self, "_next")
	push_warning("Move Registry To Singleton")
	_director.registry = preload("res://addons/WAT/core/double/registry.gd").new()
	
func _setup(test):
	if is_instance_valid(_test):
		remove_child(_test)
		_assertions.disconnect("asserted", _case,"_on_asserted")
		_test.free()
	_test = test
	_methods = _test.methods()
	_case = WAT.TestCase.new(test.title(), test.path(), test.get_script())
	_test.yielder = _yielder
	_test.direct = _director
	_test.asserts = _assertions
	_test.watcher = _watcher
	_test.parameters = _parameters
	_test.recorder = _recorder
	_assertions.connect("asserted", _case, "_on_asserted")
	_test.connect("described", _case, "_on_test_method_described")
	add_child(_test)
	
	
func run(test) -> void:
	_setup(test)
	_start()
	
func _change_state() -> void:
	if _yielder.is_active():
		return
	if _state == END or _is_done():
		emit_signal("finished")
		return
	match _state:
		START:
			_pre()
		PRE:
			_execute()
		EXECUTE:
			_post()
		POST:
			_pre()
		END:
			_end()
			
func _next(vargs = null):
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
	
func _next_test_method() -> String:
	if _test.rerun_method:
		return _current_method
	_cursor += 1
	return _methods[_cursor]
	
func _post() -> void:
	# This was at pre for a reason, we need to check against repeats or non-starter scripts
	_state = POST #if _is_done() else END
	_test.post()
	_next()
	
func _end() -> void:
	_state = END
	_test.end()
	_next()
	
func _is_done() -> bool:
	return _cursor == _methods.size() - 1 and not _test.rerun_method
	
