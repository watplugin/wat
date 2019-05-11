extends TextEdit
tool

var current_line: int = 5
var timer
var cache: String

func _init():
	add_keyword_color("Executing", Color(1, 1, 0, 1))
	add_keyword_color("Clearing", Color(1, 0, 1, 1))
	add_keyword_color(".gd", Color(1, 1, 1, 1))

func add_line(msg):
		var output = "%s\n" % msg
		if msg.begins_with("Yielding"):
			self.text = cache + output
		else:
			cache += output
			self.text += output
			current_line += 1
		cursor_set_line(current_line)


