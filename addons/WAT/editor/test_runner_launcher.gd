tool
extends Node

enum RUN { ALL, DIRECTORY, SCRIPT, TAGGED, METHOD, RERUN_FAILURES }
const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
var Strategy: Dictionary = {"repeat": 0}
var Root: PanelContainer
var Server: Node
var sceneWasLaunched: bool = false

func run(strat = null) -> void:
	if strat != null:
		Strategy = strat
		Strategy["repeat"] = 1
	Server.host()
	_run_as_editor() if Engine.is_editor_hint() else _run_as_game()
	yield(Server, "client_connected")
	Server.send_strategy(Strategy)
	sceneWasLaunched = true
	
func _run_as_editor() -> void:
	var plugin = EditorPlugin.new()
	plugin.get_editor_interface().play_custom_scene(TestRunner)
	plugin.make_bottom_panel_item_visible(Root)
	
func _run_as_game() -> void:
	var instance = preload(TestRunner).instance()
	#instance.is_editor = false
	add_child(instance)
	
	
	

