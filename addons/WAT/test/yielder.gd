extends Node

signal finished
var emitted: bool = false
var time_limit: float
var timer: Timer
var _signal: String
var testrunner

func _init(time_limit: float, emitter: Object, _signal: String, testrunner) -> void:
	print("WAT: Yielding for signal: %s from emitter: %s with timeout of %s" % [_signal, emitter, time_limit])
	self.timer = Timer.new()
	self.timer.one_shot = true
	self.timer.wait_time = time_limit
	timer.connect("timeout", self, "on_timeout")
	emitter.connect(_signal, self, "on_signal")
	self._signal = _signal
	self.testrunner = testrunner
	testrunner.add_child(self)
	self.add_child(timer)
	self.timer.start()
	self.testrunner.paused = true
	
func on_timeout():
	print("WAT: Yield timed out")
	self.queue_free()
	emit_signal("finished")

func on_signal():
	print("WAT: Signal: %s was emitted before time out: %s" % [_signal, time_limit])
	self.queue_free()
	emitted = true
	emit_signal("finished")

func _process(delta):
	print("WAT: Yielding: Time Left: %s" % timer.time_left)