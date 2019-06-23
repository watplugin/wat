extends Label
tool

var ms = 0
var s = 0
var m = 0
var timer

func _ready() -> void:
	self.timer = Timer.new()
	timer.wait_time = 0.1
	timer.autostart = true
	timer.set_process(true)
	self.timer.connect("timeout", self, "_add_ms")
#	set_process(true)

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
	add_child(self.timer)

func _stop() -> void:
	remove_child(self.timer)

func _add_ms():
	ms += 1
