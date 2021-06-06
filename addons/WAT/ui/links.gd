extends MenuButton
tool

func _ready() -> void:
	var p: PopupMenu = get_popup()
	p.set_item_metadata(0, "https://ko-fi.com/alexanddraw")
	p.set_item_metadata(1, "https://github.com/CodeDarigan/WAT-GDScript/issues/new")
	p.set_item_metadata(2, "https://github.com/CodeDarigan/WAT-Documentation/issues/new")
	p.set_item_metadata(3, "https://wat.readthedocs.io/en/latest/")
	p.connect("index_pressed", self, "_on_idx_pressed")

func _on_idx_pressed(idx: int) -> void:
	OS.shell_open(get_popup().get_item_metadata(idx))
