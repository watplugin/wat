extends Node

enum { START, PRE, EXECUTE, POST, END }
signal finished
var _state = START
var _yielder
var _test
var _methods
var _cursor = 0

func _init(test, yielder) -> void:
	_test = test
	_yielder = yielder
	_methods = _test.methods()
	_yielder.connect("finished", self, "_next")
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
	# We're checking if the code ends here?
	_state = PRE
	_test.pre()
	
func _execute() -> void:
	_state = EXECUTE
	_test.call(_methods[_cursor])
	_cursor += 1
	_next()
	
func _post() -> void:
	_state = POST if _is_done() else END
	_test.post()
	_next()
	
func _end() -> void:
	_state = END
	_test.end()
	
func _is_done() -> bool:
	return _cursor == _methods.size()
	
