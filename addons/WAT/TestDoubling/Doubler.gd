extends Node
# If we're prefixing everything with WAT, might be better
# to have a WAT accessor script (maybe the config?)
class_name WATDouble

const USERDIR = "user://WAT/"
const _WRITER = preload("Writer.gd")
var instance
var writer = _WRITER.new()
var methods: Dictionary = {}

func _init(script: Script) -> void:
	var instance = writer.rewrite(script)