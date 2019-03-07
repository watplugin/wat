tool
extends Tree

const PASSED: Color = Color(0, 1, 0, 1)
var _root: TreeItem
	
func _enter_tree() -> void:
	reset()
	var success = create_item(self._root)
	
func reset() -> void:
	self.clear()
	self._root = create_item()
	self._root.set_text(0, "Test Root Created")
	
func display(case):
	pass
	
func _display(result, item):
	pass