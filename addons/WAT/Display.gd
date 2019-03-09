tool
extends Tree

enum {
	SCRIPT
	METHOD
	EXPECTATION
}

enum {
	TOTAL
	PASSED
}

const TOTALS: Dictionary = {SCRIPT: {TOTAL: 0, PASSED: 0}, METHOD: {TOTAL: 0, PASSED: 0}, EXPECTATION: {TOTAL: 0, PASSED: 0}}
const SUCCESS: Color = Color(0, 1, 0, 1)
var _root: TreeItem

func _enter_tree() -> void:
	reset()

func reset() -> void:
	# ADD A DICT CLEAR METHOD HERE
	self.clear()
	self._root = create_item()
	self._root.set_text(0, "Test Root Created")
	
func display(testcase: WATCase) -> void:
	TOTALS[SCRIPT][TOTAL] += 1
	var script: TreeItem = create_item(self._root)
	for test in testcase.tests():
		_add_tests(testcase, script)
	_set_base_details(script, testcase)
	
func _add_tests(testcase: WATCase, root_script: TreeItem) -> void:
	TOTALS[METHOD][TOTAL] += 1
	
	for test in testcase.tests():
		var method: TreeItem = create_item(root_script)
		for expectation in test.expectations:
			_add_expectation(expectation, method)
		_set_base_details(method, test)

func _add_expectation(expectation: Dictionary, method: TreeItem):
	TOTALS[EXPECTATION][TOTAL] += 1
	# We may need to expand this further later
	_set_base_details(create_item(method), expectation)
		
func _set_base_details(item: TreeItem, test) -> void:
	item.set_text(0, test.details)
	if test.success:
		item.set_custom_color(0, SUCCESS)

