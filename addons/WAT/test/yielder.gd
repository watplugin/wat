extends Node

signal finished
var timer: Timer

func _init(time_limit: float, emitter: Object, event: String) -> void:
	print("WAT: Yielding for signal: %s from emitter: %s with timeout of %s" % [event, emitter, time_limit])
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = time_limit
	timer.connect("timeout", self, "on_timeout")
	emitter.connect(event, self, "on_signal")
	self.add_child(timer)
	
func on_timeout():
	print("WAT: Yield timed out")
	self.queue_free()
	emit_signal("finished")

func on_signal():
	print("WAT: Signal was emitted before time out")
	self.queue_free()
	emit_signal("finished")

func _process(delta):
	print("WAT: Yielding: Time Left: %s" % timer.time_left)