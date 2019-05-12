extends Node

signal finished
var timer: Timer
var resumed: bool = false
var emitter
var event

func _init(time_limit: float, emitter: Object, event: String, time_limit_only: bool = false) -> void:
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = time_limit
	self.add_child(timer)
	timer.connect("timeout", self, "on_timeout")
	if time_limit_only:
		return
	self.emitter = emitter
	self.event = event
	emitter.connect(event, self, "on_signal")
	
func on_timeout():
	get_parent().output("Yield timed out")
	self.queue_free()
	self.set_process(false)
	emit_signal("finished")
	if not resumed:
		resumed = true
		get_parent().resume(self)


func on_signal():
	get_parent().output("Signal was emitted before time out")
	self.queue_free()
	self.set_process(false)
	emit_signal("finished")
	if not resumed:
		resumed = true
		get_parent().resume(self)

func _process(delta):
	if emitter != null and event != null:
		get_parent().output("Yielding for { Signal: %s } from { Emitter: %s } for %s" % [event, emitter, timer.time_left])
	else:
		get_parent().output("Yielding for %s" % timer.time_left)