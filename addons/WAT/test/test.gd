extends "base_test.gd"
class_name WATTest

class WATState:
	const START: String = "start"
	const PRE: String = "pre"
	const EXECUTE: String = "execute"
	const POST: String = "post"
	const END: String = "end"
	
var _state: String
var _methods: Array = []
var _method: String
var time: float = 0.0
signal completed

func _ready() -> void:
	_yielder.connect("finished", self, "_next")
	add_child(_yielder)

func _next(vargs = null):
	# When yielding until signals or timeouts, this gets called on resume
	# We call defer here to give the __testcase method time to reach either the end
	# or an extra yield at which point we're able to check the _state of the yield and
	# see if we stay paused or can continue
	call_deferred("_change_state")
	
func _change_state() -> void:
	if _yielder.is_active():
		return
	match _state:
		WATState.START:
			_pre()
		WATState.PRE:
			_execute()
		WATState.EXECUTE:
			_post()
		WATState.POST:
			_pre()
		WATState.END:
			_end()
			
func run() -> void:
	_start()
	
func _start():
	_state = WATState.START
	start()
	_next()
	
func _pre():
	time = OS.get_ticks_msec()
	if _methods.empty() and not rerun_method:
		_state = WATState.END
		_next()
		return
	_state = WATState.PRE
	pre()
	_next()
	
func _execute():
	_state = WATState.EXECUTE
	_method = _method if rerun_method else _methods.pop_back()
	_testcase.add_method(_method)
	call(_method)
	_next()
	
func _post():
	_testcase.methods.back().time = (OS.get_ticks_msec() - time) / 1000.0
	_state = WATState.POST
	post()
	_next()
	
func _end():
	_state = WATState.END
	end()
	emit_signal("completed")
	
func _exit_tree() -> void:
	queue_free()
	
func start():
	pass
	
func pre():
	pass
	
func post():
	pass
	
func end():
	pass
