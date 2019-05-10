tool
extends Panel

onready var run_button = $Split/Config/Button
onready var clear_button = $Split/Config/Button2
onready var display = $Split/Display
const _TEST_DIR: String = "res://tests/"
const TEST = preload("res://addons/WAT/test/test.gd")
var tests: Array = []
var cursor: int = 0
var test: TEST
var paused: bool = false

func _ready():
	self.run_button.connect("pressed", self, "start")
	self.clear_button.connect("pressed", self.display, "reset")

func start():
	display.reset()
	self.tests = _get_tests()
	print("Test Script Count: %s" % self.tests.size())
	self.cursor = -1
	_loop()
	
func _loop():
	while self.cursor < self.tests.size() - 1:
		# Handle Pause Here
		self.cursor += 1
		_set_tests()
		_execute_test_methods()
		if paused:
			return
		_finish_test()
			
func _set_tests():
		print(self.cursor , " is cursor count")
		test = self.tests[self.cursor].new()
		add_child(test)
		test.cursor = 0
		test._set_test_methods()
		test._start()
		
func _execute_test_methods():
	while test.cursor < test.methods.size() - 1:
		test.cursor += 1
		var method: String = test.methods[test.cursor]
		test.case.add_method(method)
		test._pre()
		test.call(method)
		if paused:
			return
		test._post()
		
func resume():
	print("resuming: called from main.gd")
	paused = false
	test._post()
	_execute_test_methods()
	_finish_test()
	_loop()
		
func _finish_test():
	display.display(test.case)
	test._end()
	test.IO.clear_all_temp_directories()

func _get_tests() -> Array:
	# In future this might be better in its own script
	var ONLY_SEARCH_CHILDREN: bool = true
	var results: Array = []
	var dir: Directory = Directory.new()
	dir.open(_TEST_DIR)
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title = dir.get_next()
	while title != "":
		if title.begins_with("test_") and title.ends_with(".gd"):
			results.append(load(_TEST_DIR + title))
		title = dir.get_next()
	return results