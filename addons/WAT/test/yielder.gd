extends Node

signal finished
var timer: Timer

func _init(time_limit: float, emitter: Object, event: String) -> void:
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = time_limit
	timer.connect("timeout", self, "on_timeout")
	emitter.connect(event, self, "on_signal")
	self.add_child(timer)
	
func on_timeout():
	get_parent().output("Yield timed out")
	self.queue_free()
	self.set_process(false)
	emit_signal("finished")

func on_signal():
	get_parent().output("Signal was emitted before time out")
	self.queue_free()
	self.set_process(false)
	emit_signal("finished")

func _process(delta):
	get_parent().output("Yielding: Time Left: %s" % timer.time_left)