extends Label
tool

var running = false
var base: float

func _ready():
	print("running timer")
	self.text = "0"
	set_process(true)

func _process(delta):
	if running:
		self.text = str(OS.get_ticks_msec() - base) + " ms"
		self.text += "1"

func _start() -> void:
	self.text = "0"
	base = OS.get_ticks_msec()
	running = true

func _stop() -> void:
	print("stopping timer")
	running = false
	self.text = str(OS.get_ticks_msec() - base) + " ms"
