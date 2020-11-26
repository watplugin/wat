extends Node

enum { START, PRE, EXECUTE, POST, END }
signal finished
signal executing
var _state = START
var _yielder
var _test
var _methods
var _current_method
var _cursor = 0

func _init(test, yielder) -> void:
	_test = test
	_yielder = yielder
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
	print("starting")
	_state = START
	_test.start()
	_next()
	
func _pre() -> void:
	# We're checking if the code ends here?
	print("pre")
	_state = PRE
	_test.pre()
	_next()
	
func _execute() -> void:
	print("executing")
	_state = EXECUTE
	_current_method = _methods[_cursor]
	emit_signal("executing", _current_method)
	_test.call(_current_method)
	_cursor += 1
	_next()
	
func _post() -> void:
	print("post")
	_state = POST if _is_done() else END
	_test.post()
	_next()
	
func _end() -> void:
	print("end")
	_state = END
	_test.end()
	_next()
	
func _is_done() -> bool:
	return _cursor == _methods.size()
	
