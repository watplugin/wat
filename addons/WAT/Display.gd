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
	
func display(testcase: WATCase) -> void:
	var script_item: TreeItem = create_item(self._root)
	_display(testcase.details, testcase.success, script_item)
	for test in testcase.tests():
		var method_item: TreeItem = create_item(script_item)
		_display(test.details, test.success, method_item)
		for expectation in test.expectations:
			var expect_item: TreeItem = create_item(method_item)
			_display(expectation.details, expectation.success, expect_item)
	
func _display(details: String, success: bool, item: TreeItem) -> void:
	item.set_text(0, details)
	if success:
		item.set_custom_color(0, PASSED)
