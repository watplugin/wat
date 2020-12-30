extends HBoxContainer
tool

export(Dictionary) var links = {} 

# Might need to be tool
func _ready() -> void:
	for nodepath in links:
		_link(get_node(nodepath), links[nodepath])
	
func _link(button: Button, link: String):
	button.connect("pressed", OS, "shell_open", [link], CONNECT_DEFERRED)
