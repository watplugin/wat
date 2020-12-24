extends Node

const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
var editor: EditorInterface

func _init() -> void:
	editor = EditorPlugin.new().get_editor_interface()

func run(tests, runner) -> void:
	var instance = load("res://addons/WAT/test_runner/TestRunner.tscn").instance()
	instance.tests = tests
	var scene = PackedScene.new()
	scene.pack(instance)
	ResourceSaver.save("res://addons/WAT/test_runner/TestRunner.tscn", scene)
	var plugin = EditorPlugin.new()
	plugin.get_editor_interface().reload_scene_from_path("res://addons/WAT/test_runner/TestRunner.tscn")
	plugin.get_editor_interface().play_custom_scene(TestRunner)
	plugin.make_bottom_panel_item_visible(runner)
	runner.Summary.start_time()
	
func is_finished() -> bool:
	return not editor.is_playing_scene()
