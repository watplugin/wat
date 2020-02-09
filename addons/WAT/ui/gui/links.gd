extends HBoxContainer
tool

func _ready() -> void:
	_link($Issue, "https://github.com/CodeDarigan/WAT/issues/new")
	_link($RequestDocs, "https://github.com/CodeDarigan/WAT-docs/issues/new")
	_link($OnlineDocs, "https://wat.readthedocs.io/en/latest/index.html")
	_link($Support, "https://www.ko-fi.com/alexanddraw")
	
func _link(button: Button, link: String):
	button.connect("pressed", OS, "shell_open", [link], CONNECT_DEFERRED)
