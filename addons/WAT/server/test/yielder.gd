extends Timer

signal finished
var _emitter: Object
var _event: String

func _init() -> void:
	one_shot = true
	connect("timeout", self, "_on_resume", [], CONNECT_DEFERRED)

func until_timeout(time: float) -> Timer:
	start(time)
	return self
	
func until_signal(time: float, emitter: Object, event: String) -> Timer:
	_emitter = emitter
	_event = event
	_emitter.connect(event, self, "_on_resume", [], CONNECT_DEFERRED)
	start(time)
	return self

func _on_resume(a = null, b = null, c = null, d = null, e = null, f = null) -> void:
	stop()
	if is_instance_valid(_emitter) and _emitter.is_connected(_event, self, "_on_resume"):
		_emitter.disconnect(_event, self, "_on_resume")
	# Our adapter is connected to this. When this is emitted our adapter
	# ..will call "_next" which call defers _change_state. Since it is a deferred
	# ..call the test will resume first. Therefore if a new yield gets constructed
	# ..in the interim we will be able to check if we have restarted the yield clock
	emit_signal("finished", [a, b, c, d, e, f])

func is_active() -> bool:
	return not is_stopped() and time_left > 0
