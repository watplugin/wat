extends Timer
tool

const TIMER = 1
signal resume
signal finished
var emitter_signal: String
var emitter: Object
var count: int = 0

func _init() -> void:
	connect("timeout", self, "resume")

func until_signal(time_limit: float, emitter: Object, event: String) -> Timer:
	paused = true
	emitter.connect(event, self, "timeout")
	self.emitter = emitter
	self.emitter_signal = event
	return until_timeout(time_limit)

func until_timeout(time_limit: float) -> Timer:
	count += TIMER
	paused = true
	wait_time = time_limit
	one_shot = true
	paused = false
	start()
	return self

func resume() -> void:
	count -= TIMER
	if emitter != null:
		emitter.disconnect(emitter_signal, self, "timeout")
		emitter = null
		emitter_signal = ""
	emit_signal("finished")
	if count <= 0:
		emit_signal("resume")

func active() -> bool:
	return count > 0