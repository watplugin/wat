tool
extends Panel

onready var run_button = $Split/Config/Button
onready var clear_button = $Split/Config/Button2
onready var display = $Split/Display
const _TEST_DIR: String = "res://tests/"
const TEST = preload("res://addons/WAT/test/test.gd")
var tests: Array = []
var cursor: int = -1
var test: TEST
var paused: bool = false
var cases: Array = []
var _log
var plugin

func output(msg):
	self._log.add_line(msg)

func _ready():
	self.run_button.connect("pressed", self, "start")
	self.clear_button.connect("pressed", self.display, "reset")
	self.clear_button.connect("pressed", self, "clear_lines")
	
func clear_lines():
	self._log.text = ""
	self._log.cache = ""
	self._log.current_line = 5

func start():
	plugin.make_bottom_panel_item_visible(self._log)
	output("WAT: Starting Test Runner")
	self._log.text = ""
	self._log.cache = ""
	self.cursor = -1
	self.cases = []
	self.tests = []
	display.reset()
	self.tests = _get_tests()
	output("WAT: %s Test Scripts Collected" % self.tests.size())
	_loop()
	
func _loop():
	while self.cursor < self.tests.size() - 1:
		self.cursor += 1
		_set_tests()
		output("WAT: Executing Test Script: %s" % test.title)
		_execute_test_methods()
		if paused:
			return
		self.cases.append(test._end())
	display()
	
func display():
	for case in self.cases:
		display.display(case)
			
func _set_tests():
		test = self.tests[self.cursor].new()
		add_child(test)
		test.cursor = -1
		test._set_test_methods()
		test._start()
		
func _execute_test_methods():
	while test.cursor < test.methods.size() - 1:
		test.cursor += 1
		var method: String = test.methods[test.cursor]
		output("WAT: Executing Method: %s from Test Script %s" % [method, test.title])
		test.case.add_method(method)
		test._pre()
		test.call(method)
		if paused:
			return
		test._post()
		
func resume():
	output("WAT: Resuming Test Script %s" % test.title)
	paused = false
	test._post()
	_execute_test_methods()
	self.cases.append(test._end())
	_loop()
	
func _get_tests() -> Array:
	var ONLY_SEARCH_CHILDREN: bool = true
	var tests = []
	var dirs = _get_subdirs()
	dirs.push_front("")
	for d in dirs:
		var dir: Directory = Directory.new()
		dir.open("%s%s" % [_TEST_DIR, d])
		dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
		var title = dir.get_next()
		while title != "":
			if title.begins_with("test_") and title.ends_with(".gd"):
				tests.append(load(_TEST_DIR + d + "/" + title))
			title = dir.get_next()
	return tests
	
func _get_subdirs() -> Array:
	var results: Array = []
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open(_TEST_DIR)
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title = dir.get_next()
	while title != "":
		if dir.current_is_dir():
			results.append(title)
		title = dir.get_next()
	return results