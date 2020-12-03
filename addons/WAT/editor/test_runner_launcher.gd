tool
extends Node

enum RUN { ALL, DIRECTORY, SCRIPT, TAGGED, METHOD, RERUN_FAILURES }
const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
var Strategy: Dictionary = {"repeat": 0}
var Root: PanelContainer
var Server: Node
var Selection

func _on_run_pressed(option: int) -> void:
	match option:
		RUN.ALL:
			Strategy["paths"] = Selection.get_all()
		RUN.DIRECTORY:
			Strategy["paths"] = Selection.get_directory()
		RUN.SCRIPT:
			Strategy["paths"] = Selection.get_script()
		RUN.TAGGED:
			push_warning("Tag Run Not Implemented")
		RUN.METHOD:
			push_warning("Method Run Not Implemented")
	run()

func run(strat = null) -> void:
	if strat != null:
		Strategy = strat
		Strategy["repeat"] = 1
	Server.host()
	_run_as_editor() if Engine.is_editor_hint() else _run_as_game()
	yield(Server, "client_connected")
	Server.send_strategy(Strategy)
	
func _run_as_editor() -> void:
	var plugin = EditorPlugin.new()
	plugin.get_editor_interface().play_custom_scene(TestRunner)
	plugin.make_bottom_panel_item_visible(Root)
	
func _run_as_game() -> void:
	var instance = preload(TestRunner).instance()
	#instance.is_editor = false
	add_child(instance)
	
	
	

