extends RichTextLabel
tool

var line: int = 0

func _output(msg) -> void:
	bbcode_text += "\n%s: %s" % [line, msg]
	line += 1

func _clear():
	bbcode_text = ""
	line = 0