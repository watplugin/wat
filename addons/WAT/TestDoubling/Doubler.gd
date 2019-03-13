extends Node
# If we're prefixing everything with WAT, might be better
# to have a WAT accessor script (maybe the config?)
class_name WATDouble

####	# Add self as metadata to script (we could do a property object but using metadata is more inconspicoius)
#### Requirements? (Not set in stone)
#### Doubler - Delegates to others
#### Writer - Reads/Write saves scripts (probably to a user://WATemp folder
#### Config for type checking (do we keep as is, remove param/return types or mod elsewhere?)
#### Handle variables (like constants etc)
#### Add a Method Class, a Call class (or data structure?)

const _WRITER = preload("res://addons/WAT/TestDoubling/Writer.gd")
var instance
var methods: Dictionary = {}

func _init(script: Script) -> void:
	var writer = _WRITER.new().rewrite(script)