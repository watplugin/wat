extends Timer
tool

signal resume
signal finished
var emitter_signal
var emitter
var count: int = 0

func _init():
	connect("timeout", self, "resume")

func until_signal(time_limit: float, emitter: Object, event: String):
	paused = true
	emitter.connect(event, self, "timeout")
	self.emitter = emitter
	self.emitter_signal = event
	return until_timeout(time_limit)

func until_timeout(time_limit: float):
	count += 1
	paused = true
	wait_time = time_limit
	one_shot = true
	paused = false
	start()
	return self

func resume() -> void:
	count -= 1
	if emitter != null:
		emitter.disconnect(emitter_signal, self, "timeout")
		emitter = null
		emitter_signal = null
	emit_signal("finished")
	if count <= 0:
		emit_signal("resume")

func active() -> bool:
	return count > 0