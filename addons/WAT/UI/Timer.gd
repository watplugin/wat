extends Label
tool

var ms = 0
var s = 0
var m = 0
var timer

func _ready() -> void:
	self.timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	self.timer.connect("timeout", self, "_add_ms")

func _process(delta):
	if ms > 9:
		s += 1
		ms = 0
	if s > 59:
		m += 1
		s = 0
	self.text = "%s: %s: %s" % [m, s, ms]

func _start() -> void:
	ms = 0
	s = 0
	m = 0
	self.timer.start()

func _stop() -> void:
	self.timer.stop()

func _add_ms():
	ms += 1
