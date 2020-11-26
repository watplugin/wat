extends Node

enum { START, PRE, EXECUTE, POST, END }
signal finished
var _state = START
var _yielder: WAT.Yielder
var _test: WAT.Test
var _case: WAT.TestCase
var _methods: PoolStringArray = []
var _current_method: String
var _cursor = 0
var results: Dictionary setget ,_get_results

func _get_results() -> Dictionary:
	_case.calculate()
	return _case.to_dictionary()

func _init(test, yielder, case) -> void:
	_test = test
	_yielder = yielder
	_case = case
	_methods = _test.methods()
	add_child(_yielder)
	add_child(_test)
	
func run() -> void:
	_start()
	
func _change_state() -> void:
	if _yielder.is_active():
		return
	if _state == END:
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
	_state = START
	_test.start()
	_next()
	
func _pre() -> void:
	_state = PRE
	_test.pre()
	_next()
	
func _execute() -> void:
	_state = EXECUTE
	_current_method = _methods[_cursor]
	_case.add_method(_current_method)
	_test.call(_current_method)
	_cursor += 1
	_next()
	
func _post() -> void:
	# This was at pre for a reason, we need to check against repeats or non-starter scripts
	_state = POST if _is_done() else END
	_test.post()
	_next()
	
func _end() -> void:
	_state = END
	_test.end()
	_next()
	
func _is_done() -> bool:
	return _cursor == _methods.size()
	
