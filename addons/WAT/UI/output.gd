extends TextEdit
tool
	
var current_line: int = 5
var cache: String

func _output(msg):
		var output = "%s\n" % msg
		if msg.begins_with("Yielding"):
			self.text = cache + output
		else:
			cache += output
			self.text += output
			current_line += 1
		cursor_set_line(current_line)
		
func _clear():
	self.text = ""
	self.cache = ""