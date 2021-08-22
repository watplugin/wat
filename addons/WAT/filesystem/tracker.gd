tool
extends Reference

### This only works in the Editor Context. There are no similair methods..
### ..available for the Scene Context.

const Settings: GDScript = preload("res://addons/WAT/settings.gd")
signal filesystem_changed

func start_tracking_files(plugin: EditorPlugin) -> void:
	var dock: FileSystemDock = plugin.get_editor_interface().get_file_system_dock()
	for event in ["file_removed", "files_moved", "folder_moved", "folder_removed"]:
		var callback: String = "_on_%s" % event
		if not dock.is_connected(event, self, callback):
			dock.connect(event, self, callback)
	if not plugin.is_connected("resource_saved", self, "_on_resource_saved"):
		plugin.connect("resource_saved", self, "_on_resource_saved")
	
func _stop_tracking_files(plugin: EditorPlugin) -> void:
	var dock: FileSystemDock = plugin.get_editor_interface().get_file_system_dock()
	for event in ["file_removed", "files_moved", "folder_moved", "folder_removed"]:
		var callback: String = "_on_%s" % event
		if dock.is_connected(event, self, callback):
			dock.disconnect(event, self, callback)
	if plugin.is_connected("resource_saved", self, "_on_resource_saved"):
		plugin.disconnect("resource_saved", self, "_on_resource_saved")
		
func _on_filesystem_changed(has_changed: bool) -> void:
	if has_changed:
		emit_signal("filesystem_changed")
		
func _on_file_removed(file: String) -> void:
	_on_filesystem_changed(file.begins_with(Settings.test_directory()))
	
func _on_files_moved(old: String, new: String) -> void:
	_on_filesystem_changed(
		old.begins_with(Settings.test_directory()) 
		or new.begins_with(Settings.test_directory()))
	
func _on_folder_moved(old: String, new: String) -> void:
	_on_filesystem_changed(
		old.begins_with(Settings.test_directory()) 
		or new.begins_with(Settings.test_directory()))
	
func _on_folder_removed(old: String) -> void:
	_on_filesystem_changed(old.begins_with(Settings.test_directory()))
	
func _on_resource_saved(resource: Resource) -> void:
	_on_filesystem_changed(
		resource.resource_path.begins_with(Settings.test_directory()))
