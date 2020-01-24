extends Node

class State:
	const START: String = "start"
	const PRE: String = "pre"
	const EXECUTE: String = "execute"
	const POST: String = "post"
	const END: String = "end"
	
var _state: String # start, pre, execute, post, end
#var _test: WA
var _yielder # = load("res://addons/WAT/runner/_yielder.gd").new()
var _methods: Array = []
signal finish

#func _init(test: WAT.Test, yielder: WAT.Yielder) -> void:
#	name = "Test Adapter"
#	_test = test
#	_yielder = yielder

func methods() -> PoolStringArray:
	var retval: PoolStringArray = []
	return retval

func _ready() -> void:
	_methods = methods() as Array
	_yielder.connect("finished", self, "_next")
#	add_child(_test)
	add_child(_yielder)
	_start()

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
			_pre()
		State.PRE:
			_execute()
		State.EXECUTE:
			_post()
		State.POST:
			_pre()
		State.END:
			_end()
	
func _start():
	_state = State.START
	start()
	_next()
	
func _pre():
	if _methods.empty():
		_state = State.END
		_next()
		return
	_state = State.PRE
	pre()
	_next()
	
func _execute():
	_state = State.EXECUTE
	var test_method: String = _methods.pop_back()
	call(test_method)
	_next()
	
func _post():
	_state = State.POST
	post()
	_next()
	
func _end():
	_state = State.END
	end()
	emit_signal("finish")
	
func _exit_tree() -> void:
#	_test.free()
	queue_free()
	
func start():
	pass
	
func pre():
	pass
	
func post():
	pass
	
func end():
	pass
