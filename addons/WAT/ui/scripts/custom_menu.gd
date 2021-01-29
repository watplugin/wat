extends PopupPanel


var _items: Array = []
var _current_idx: int = -1

func get_current_index():
	return _items[_current_idx]
	
func add_item(item, idx) -> void:
	_items.append(item)
