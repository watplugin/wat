tool
extends Tree

enum {
	SCRIPT
	METHOD
	EXPECTATION
}


const PASSED: Color = Color(0, 1, 0, 1)
var _root: TreeItem

func _enter_tree() -> void:
	reset()

func reset() -> void:
	self.clear()
	self._root = create_item()
	self._root.set_text(0, "Test Root Created")
	
func display(testcase: WATCase) -> void:
	var script: TreeItem = create_item(self._root)
	for test in testcase.tests():
		_add_tests(testcase, script)
	_set_base_details(script, testcase)
	
func _add_tests(testcase: WATCase, root_script: TreeItem) -> void:
	for test in testcase.tests():
		var method: TreeItem = create_item(root_script)
		for expectation in test.expectations:
			_add_expectation(expectation, method)
		_set_base_details(method, test)

func _add_expectation(expectation: Dictionary, method: TreeItem):
	# We may need to expand this further later
	_set_base_details(create_item(method), expectation)
		
func _set_base_details(item: TreeItem, test) -> void:
	item.set_text(0, test.details)
	if test.success:
		item.set_custom_color(0, PASSED)

