extends Node
tool

signal resume
var queue: Array = []
var message: String

func _init():
	set_process(false)

func until_signal(time_limit: float, emitter: Object, event: String) -> Timer:
	var timer: Timer = _setup_timer(time_limit)
	emitter.connect(event, timer, "emit_signal", ["finished"])
	timer.start()
	return timer

func until_timeout(time_limit: float) -> Timer:
	var timer = _setup_timer(time_limit)
	timer.start()
	return timer
	
func _setup_timer(timer_limit: float) -> Timer:
	var timer: Timer = Timer.new()
	timer.wait_time =timer_limit
	timer.one_shot = true
	timer.add_user_signal("finished")
	timer.connect("timeout", timer, "emit_signal", ["finished"])
	timer.connect("finished", self, "_resume", [timer], CONNECT_DEFERRED)
	queue.append(timer)
	add_child(timer)
	return timer

func _resume(timer: Timer) -> void:
	queue.erase(timer)
	timer.queue_free()
	if queue.size() > 0:
		return
	emit_signal("resume") # This resume is for the runner