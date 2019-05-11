extends TextEdit
tool

var current_line: int = 5
var timer
var cache: String

func add_line(msg):
		var output = "%s\n" % msg
		if msg.begins_with("WAT: Yielding"):
			self.text = cache + output
		else:
			cache += output
			self.text += output
			current_line += 1
		cursor_set_line(current_line)


