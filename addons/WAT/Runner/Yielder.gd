extends Node
tool

var queue: Array = []
signal resume

func until_signal(time_limit: float, emitter: Object, event: String) -> YieldTimer:
	output("Yielding: { signal: %s, emitter: %s, time: %s }" % [event, emitter, time_limit])
	var yield_timer: YieldTimer = YieldTimer.new(time_limit, emitter, event)
	return start(yield_timer)
	
func start(yield_timer):
	queue.append(yield_timer)
	add_child(yield_timer)
	yield_timer.start()
	return yield_timer

func until_timeout(time_limit: float) -> YieldTimer:
	output("Yielding: { time: %s }" % time_limit)
	var yield_timer: YieldTimer = YieldTimer.new(time_limit, self, "", true)
	return start(yield_timer)

func resume(yield_timer: YieldTimer):
	queue.erase(yield_timer)
	yield_timer.queue_free()
	if queue.size() > 0:
		return
	emit_signal("resume")

func output(msg):
	get_parent().output(msg)

func _process(delta):
	if queue.empty():
		return
	get_parent().output(str(queue[0].message()))

class YieldTimer extends Timer:
	signal finished
	var emitter: Object
	var event: String
	var waiting_for_signal: bool = false

	func _init(time_limit: float, emitter: Object, event: String, time_limit_only: bool = false) -> void:
		one_shot = true
		wait_time = time_limit
		connect("timeout", self, "_resume")
		if time_limit_only:
			return
		waiting_for_signal = true
		self.emitter = emitter
		self.event = event
		emitter.connect(event, self, "_resume")

	func _resume(a = null, b = null, c = null, d = null, e = null, f = null, g = null, h = null, i = null, j = null, k = null):
		emit_signal("finished")
		set_block_signals(true)
		get_parent().resume(self)
		
	func message() -> String:
		if waiting_for_signal:
			return "Yielding: { Signal: %s, emitter: %s, time: %s }" % [event, emitter, time_left]
		else:
			return "Yielding: { time: %s }" % time_left