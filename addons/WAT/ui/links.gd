extends MenuButton
tool

func _ready() -> void:
	set_focus_mode(FOCUS_ALL)
	var p: PopupMenu = get_popup()
	p.set_item_metadata(0, "https://ko-fi.com/alexanddraw")
	p.set_item_metadata(1, "https://github.com/AlexDarigan/WAT/issues/new")
	p.connect("index_pressed", self, "_on_idx_pressed")

func _on_idx_pressed(idx: int) -> void:
	OS.shell_open(get_popup().get_item_metadata(idx))
