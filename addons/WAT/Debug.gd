extends Button
tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var f = preload("res://addons/WAT/system/FileManager.gd").new()
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", f, "do_action")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
