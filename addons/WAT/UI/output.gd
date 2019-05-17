extends TextEdit
tool

var queue: Array = []
var cache: String = ""
var cursor: int = 0
var timer: Timer

func _output(msg):
	queue.append("%s\n" % msg)
	
func _process(delta):
	_pop_message()
	
#func _ready():
#	set_process(true)

func _pop_message():
	if queue.size() > 0:
		var msg = queue.pop_front()
		if msg.begins_with("Yielding"):
			self.text = self.cache + msg
		else:
			self.text += msg
			self.cache = text
			self.cursor += 3
		cursor_set_line(self.cursor)
	
func _clear():
	self.cursor = 0
	cursor_set_line(self.cursor)
	self.text = ""
	self.queue = []

#func _output(msg):
##	self.paused = true
##	self.timer.start()
##	while not timer.is_stopped():
##		pass
#	var output = "%s\n" % msg
##	self.text += output
#	self.cache += output
#	current_line += 1
#	cursor_set_line(current_line)
#
#func _process(delta):
#	self.text = self.cache
