extends TextEdit
tool

var current_line: int = -1
var timer

func add_line(msg):
		self.text += "%s\n" % msg
		current_line += 1
		cursor_set_line(current_line)

