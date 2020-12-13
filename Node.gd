extends Node
tool

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		if(Engine.is_editor_hint()):
			print("Hello from Engine")
		else:
			print("Hello from Editor")

#func _process(delta):
#	print("IsEngine?: ", Engine.is_editor_hint())
class W
