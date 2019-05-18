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
	self.queue.clear()