extends Node
tool

signal finished
var context

func launch(tests: Array, threads: int = 1) -> void:
	context = EditorLaunch.new() if Engine.is_editor_hint() else GameLaunch.new()
	context.connect("finished", self, "_on_launch_finished")
	add_child(context)
	context.launch(tests, threads)
	
func _on_launch_finished() -> void:
	context.queue_free()
	emit_signal("finished")
	
class EditorLaunch extends Node:
	signal finished
	const TestRunner: String = "res://addons/WAT/core/test_runner/TestRunner.tscn"
	var editor
	var _wasLaunched
	
	func launch(tests: Array, threads: int = 1) -> void:
		editor = ClassDB.instance("EditorPlugin").get_editor_interface()
		editor.play_custom_scene(TestRunner)
		_wasLaunched = true
	
	func _process(delta: float) -> void:
		if _is_done():
			_wasLaunched = false
			emit_signal("finished")

	func _is_done() -> bool:
		return editor != null and not editor.is_playing_scene() and _wasLaunched
		
class GameLaunch extends Node:
	signal finished
	const TestRunner: String = "res://addons/WAT/core/test_runner/TestRunner.tscn"
	
	func launch(tests: Array, threads: int = 1) -> void:
		var instance = load(TestRunner).instance()
		instance.is_editor = false
		instance.connect("finished", self, "emit_signal", ["finished"])
		add_child(instance)
