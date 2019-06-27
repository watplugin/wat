extends Node
tool

signal resume
var queue: Array

func until_signal(time_limit: float, emitter: Object, event: String) -> Timer:
	output("Yielding: { signal: %s, emitter: %s, time: %s }" % [event, emitter, time_limit])
	var yield_timer: YieldTimer = YieldTimer.new()
	yield_timer.wait_time = time_limit
	emitter.connect(event, yield_timer, "emit_signal", ["finished"])
	return start(yield_timer)

func start(yield_timer):
	yield_timer.add_user_signal("finished")
	yield_timer.one_shot = true
	yield_timer.connect("timeout", yield_timer, "emit_signal", ["finished"])
	yield_timer.connect("finished", self, "resume", [yield_timer], CONNECT_DEFERRED)
	queue.append(yield_timer)
	add_child(yield_timer)
	yield_timer.start()
	return yield_timer

func until_timeout(time_limit: float) -> YieldTimer:
	output("Yielding: { time: %s }" % time_limit)
	var yield_timer: YieldTimer = YieldTimer.new()
	yield_timer.wait_time = time_limit
	return start(yield_timer)

func resume(yield_timer: YieldTimer):
	print("resume called")
	queue.erase(yield_timer)
	yield_timer.queue_free()
	if queue.size() > 0:
		return
	emit_signal("resume") # This resume is for the runner

func output(msg):
	get_parent().output(msg)

func _process(delta):
	if queue.size() > 0:
		get_parent().output(queue.back().message())

class YieldTimer extends Timer:

	func message() -> String:
		return "Yielding: { time: %s }" % time_left