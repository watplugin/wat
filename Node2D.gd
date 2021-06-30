extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var base_sharp: Script = load("res://addons/WAT/mono/Test.cs")
	var other_sharp: Script = load("res://tests/mono/AttributeTest.cs")
	var s = other_sharp
	while s:
		print(s.resource_path)
		if s.resource_path == base_sharp.resource_path:
			print("yay")
		s = s.get_base_script()
