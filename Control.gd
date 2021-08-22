extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


func _ready():
	var x = create_item()
	x.set_text(0, "Text")
	x.set_icon(0, load("res://icon.svg"))
	
func _process(delta) -> void:
	pass
