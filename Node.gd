extends Node

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	x("func example")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func x(string):
	match Array(string.split(" "))[0]:
		"func", "static", "class":
			print("yes")
		_:
			print("wildcard")


