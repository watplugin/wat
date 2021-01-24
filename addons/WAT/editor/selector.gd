extends HBoxContainer
tool

signal _tests_selected
onready var TestMenu: Button = $TestMenu
onready var ViewMenu: PopupMenu = $View.get_popup()
onready var Repeater: SpinBox = $Repeat
onready var Threads: SpinBox = $Threads
onready var RunInEdtor: CheckBox = $CheckBox

func _ready() -> void:
	Threads.max_value = OS.get_processor_count() - 1
	TestMenu.connect("_tests_selected", self, "_on_tests_selected")

func _on_tests_selected(tests: Array) -> void:
	tests = duplicate_tests(tests)
	emit_signal("_tests_selected", tests, Repeater.value as int, RunInEdtor.pressed)
	
func _on_QuickStart_pressed():
	var scripts = duplicate_tests(TestMenu.tests(WAT.Settings.test_directory()))
	emit_signal("_tests_selected", scripts)


func duplicate_tests(scripts: Array) -> Array:
	var duplicates = []
	for i in Repeater.value as int:
		duplicates += scripts.duplicate()
	scripts += duplicates
	return scripts
	
