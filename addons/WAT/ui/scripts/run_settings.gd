extends HBoxContainer
tool

onready var Repeater: SpinBox = $Repeats
onready var Threads: SpinBox = $Threads
onready var RunInEditor: CheckBox = $RunInEditor
var repeats setget ,_get_repeats
var threads setget ,_get_threads
var run_in_editor: bool setget ,_get_run_in_editor_toggle

func _ready() -> void:
	if not Engine.is_editor_hint():
		RunInEditor.disabled = true
	else:
		_set_default_launch_type()
	Threads.max_value = OS.get_processor_count() - 1

func _get_repeats() -> int:
	return Repeater.value as int
	
func _get_threads() -> int:
	return Threads.value as int
	
func _get_run_in_editor_toggle() -> bool:
	return RunInEditor.pressed if Engine.is_editor_hint() else true
	
func _set_default_launch_type() -> void:
	var value: int = ProjectSettings.get_setting("WAT/Default_Launch")
	if value == 0:
		RunInEditor.pressed = false
	else:
		RunInEditor.pressed = true
