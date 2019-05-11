tool
extends EditorPlugin

const NAME: String = "WAT:TestRunner"
const MAIN: PackedScene = preload("ui/Main.tscn")
const LOG : PackedScene = preload("ui/Log.tscn")
var _screen: Panel
var _log: TextEdit

func _enter_tree() -> void:
	self._screen = MAIN.instance()
	self._log = LOG.instance()
	add_control_to_bottom_panel(self._log, "WAT Log")
	get_editor_interface().get_editor_viewport().add_child(self._screen)
	make_bottom_panel_item_visible(self._log)
	self._screen._log = self._log
	self._screen.plugin = self
	make_visible(false)

func _exit_tree() -> void:
	remove_control_from_bottom_panel(self._log)
	self._log.queue_free()
	self._screen.queue_free()

func has_main_screen() -> bool:
   return true

func make_visible(visible: bool) -> void:
	self._screen.show() if visible else self._screen.hide()

func get_plugin_name() -> String:
   return NAME