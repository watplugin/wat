extends Node

signal finished
var emitted: bool = false
var time_limit: float
var timer: Timer
var _signal: String
var testrunner

func _init(time_limit: float, emitter: Object, _signal: String, testrunner) -> void:
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
	print("timed out")
	emit_signal("finished")
	self.testrunner.resume()
	
func on_signal():
	timer.stop()
	print("signal emitted")
	emitted = true
	emit_signal("finished")
	self.testrunner.resume()
	self.queue_free()