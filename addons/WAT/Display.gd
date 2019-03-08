tool
extends Tree

const PASSED: Color = Color(0, 1, 0, 1)
var _root: TreeItem

func _enter_tree() -> void:
	reset()

func reset() -> void:
	self.clear()
	self._root = create_item()
	self._root.set_text(0, "Test Root Created")

func display(testcase: WATCase) -> void:
	var script_item: TreeItem = create_item(self._root)
	_display(testcase, script_item)
	for test in testcase.tests():
		var method_item: TreeItem = create_item(script_item)
		_display(test, method_item)
		for expectation in test.expectations:
			var expect_item: TreeItem = create_item(method_item)
			_display(expectation, expect_item, true)

func _display(test, item: TreeItem, is_expectation: bool = false) -> void:
	item.set_text(0, test.details)
	if is_expectation:
		item.set_text(1, "Expected: %s, Got: %s" % [test.expected, test.got])
	if test.success:
		item.set_custom_color(0, PASSED)
		item.set_custom_color(1, PASSED)
