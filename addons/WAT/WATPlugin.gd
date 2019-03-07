tool
extends EditorPlugin

const _NAME: String = "WAT:TestRunner"
const _WAT: PackedScene = preload("res://addons/WAT/Main.tscn")
var _screen: Panel

func _enter_tree() -> void:
	self._screen = _WAT.instance()
	get_editor_interface().get_editor_viewport().add_child(self._screen)
	make_visible(false)

func _exit_tree() -> void:
	self._screen.queue_free()

func has_main_screen() -> bool:
   return true

func make_visible(visible: bool) -> void:
	self._screen.show() if visible else self._screen.hide()

func get_plugin_name() -> String:
   return self._NAME