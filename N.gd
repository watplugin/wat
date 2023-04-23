extends Node


func opt_(v, b = null): 
	pass
	
func _ready() -> void:
	for method in get_script().get_script_method_list():
		if method.name == "opt_":
			print(method)
