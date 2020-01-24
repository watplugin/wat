extends Node

class State:
	const START: String = "start"
	const PRE: String = "pre"
	const EXECUTE: String = "execute"
	const POST: String = "post"
	const END: String = "end"
	
var _state: String # start, pre, execute, post, end
var _test: WAT.Test
var _yielder: WAT.Yielder # = load("res://addons/WAT/runner/_yielder.gd").new()
var _methods: Array = []
signal finish

func _init(test: WAT.Test, yielder: WAT.Yielder) -> void:
	name = "Test Adapter"
	_test = test
	_yielder = yielder

func _ready() -> void:
	_methods = _test.methods() as Array
	_yielder.connect("finished", self, "_next")
	add_child(_test)
	add_child(_yielder)

func _next():
	# When yielding until signals or timeouts, this gets called on resume
	# We call defer here to give the __testcase method time to reach either the end
	# or an extra yield at which point we're able to check the _state of the yield and
	# see if we stay paused or can continue
	call_deferred("_change_state")
	
func _change_state() -> void:
	if _yielder.is_active():
		return
	match _state:
		State.START:
			pre()
		State.PRE:
			execute()
		State.EXECUTE:
			post()
		State.POST:
			pre()
		State.END:
			end()
	
func start():
	_state = State.START
	_test.start()
	_next()
	
func pre():
	if _methods.empty():
		_state = State.END
		_next()
		return
	_state = State.PRE
	_test.pre()
	_next()
	
func execute():
	_state = State.EXECUTE
	var test_method: String = _methods.pop_back()
	_test.call(test_method)
	_next()
	
func post():
	_state = State.POST
	_test.post()
	_next()
	
func end():
	_state = State.END
	_test.end()
	emit_signal("finish")
	
func _exit_tree() -> void:
	_test.free()
	queue_free()
