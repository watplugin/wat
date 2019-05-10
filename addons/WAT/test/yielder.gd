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
	
	# what if other signal?
func on_timeout():
	print("WAT: Yield timed out")
	emit_signal("finished")
	self.queue_free()
	self.testrunner.resume()
	
func on_signal():
	print("WAT: Signal: %s was emitted before time out: %s" % [_signal, time_limit])
	emitted = true
	emit_signal("finished")
	self.testrunner.resume()
	self.free()

var i = 0

func _process(delta):
	if i < 60:
		i += 1
	else:
		print("WAT: Yielding: Time Left: %s" % timer.time_left)