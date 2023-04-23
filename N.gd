extends Node

signal custom

func _ready():
#	print(get_signal_list())
	add_user_signal("customX")
	for s in get_signal_list():
		print(s.name)
	
