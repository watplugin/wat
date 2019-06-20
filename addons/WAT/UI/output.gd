extends TextEdit
tool

const VECTOR2: String = "Vector2"
const VECTOR3: String = "Vector3"
const YIELDING: String = "Yielding"
const EXECUTING: String = "Executing"
const PASS: String = "PASSED"
const FAIL: String = "FAILED"
const ENDING: String = "Ending"
const WHITE: Color = Color(1, 1, 1, 1)
const BLACK: Color = Color(0, 0.5, .5, 1)
const YELLOW: Color = Color(1, 1, 0, 1)
const GREEN: Color = Color(0, 1, 0, 1)
const RED: Color = Color(0.5, 0, 0, 1)
#const PURPLE: Color = Color(0.5, 0.5, 1, 1)

var queue: Array = []
var cache: String = ""
var cursor: int = 0
var timer: Timer
var words: String = ""

#	yield(get_tree().get_root().Output, "finished")

signal finished

func _ready():
	add_color_override("member_variable_color", WHITE)
	add_keyword_color(EXECUTING, BLACK)
	add_keyword_color(YIELDING, YELLOW)
	add_keyword_color(PASS, GREEN)
	add_keyword_color(FAIL, RED)
	add_keyword_color(VECTOR2, WHITE)
	add_keyword_color(VECTOR3, WHITE)

func _output(msg):
	queue.append("%s\n" % msg)

func _process(delta):
	_pop_message()

func _pop_message():
	if queue.size() > 0:
		display(queue.pop_front())

func display(msg: String) -> void:
	if msg.begins_with(EXECUTING):
		self.text += msg
	elif msg.begins_with(YIELDING):
		self.text = self.cache
		self.text += msg
	else:
		self.cache += msg
		self.text = self.cache
		self.cursor += 3
	cursor_set_line(self.cursor)

	if msg.begins_with(ENDING):
		emit_signal("finished")

func _clear():
	self.cursor = 0
	cursor_set_line(self.cursor)
	self.text = ""
	self.cache = ""
	self.queue.clear()