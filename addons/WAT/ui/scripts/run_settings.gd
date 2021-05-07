extends HBoxContainer
tool

onready var Repeater: SpinBox = $Repeats
onready var Threads: SpinBox = $Threads
var repeats setget ,_get_repeats
var threads setget ,_get_threads

func _ready() -> void:
	Threads.max_value = OS.get_processor_count() - 1

func _get_repeats() -> int:
	return Repeater.value as int
	
func _get_threads() -> int:
	return Threads.value as int
