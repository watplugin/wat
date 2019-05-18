extends Node
tool

var queue: Array = []

func until_signal(time_limit: float, emitter: Object, event: String) -> YieldTimer:
	var yield_timer: YieldTimer = YieldTimer.new(time_limit, emitter, event)
	queue.append(yield_timer)
	add_child(yield_timer)
	yield_timer.start()
	return yield_timer
	
func until_timeout(time_limit: float) -> YieldTimer:
	var yield_timer: YieldTimer = YieldTimer.new(time_limit, self, "", true)
	queue.append(yield_timer)
	add_child(yield_timer)
	yield_timer.start()
	return yield_timer
	
func output(msg):
	get_parent().output(msg)
	
func resume(yield_timer: YieldTimer):
	remove_child(yield_timer)
	queue.erase(yield_timer)
	yield_timer.queue_free()
	if queue.size() > 0:
		return
	get_parent().resume()

class YieldTimer extends Timer:
	signal finished
	var emitter: Object
	var event: String
	var resumed: bool = false
	
	func _init(time_limit: float, emitter: Object, event: String, time_limit_only: bool = false) -> void:
		one_shot = true
		wait_time = time_limit
		connect("timeout", self, "_on_timeout")
		if time_limit_only:
			return
		self.emitter = emitter
		self.event = event
		emitter.connect(event, self, "_on_signal")
	
	func _on_timeout():
		get_parent().output("Yield Timed Out")
		emit_signal("finished")
		if not resumed:
			resumed = true
			get_parent().resume(self)
			
	func _on_signal():
		get_parent().output("{ Signal: %s } was emitted from { emitter: %s } before time out" % [event, emitter])
		emit_signal("finished")
		if not resumed:
			resumed = true
			get_parent().resume(self)

	func _process(delta):
		if emitter != null and event != null:
			get_parent().output("Yielding for { Signal: %s } from { Emitter: %s } for %s" % [event, emitter, time_left])
		else:
			get_parent().output("Yielding for %s" % time_left)