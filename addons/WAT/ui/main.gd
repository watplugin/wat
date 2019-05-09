tool
extends Panel

onready var run_button = $Split/Config/Button
onready var clear_button = $Split/Config/Button2
onready var display = $Split/Display
const _TEST_DIR: String = "res://tests/"
const TEST = preload("res://addons/WAT/test/test.gd")
var tests: Array = []
var cursor: int = -1
var waiting: bool = false
var current: TEST

func _ready():
	self.run_button.connect("pressed", self, "_run")
	self.clear_button.connect("pressed", self.display, "reset")

func _run():
	_start()
	while _is_active():
		self.current = _get_next()
		assert(current is TEST)
		add_child(current)
		_run_test()
		if _is_active(): # loop into _end_test directly?
			_end_test()
			
func _run_test(): # maybe add as data memeber
	current._start()
	while current._is_active():
		var method = current._get_next()
		current.case.add_method(method)
		current._pre()
		# var function = current.call(method)
		# if func not funcref:
			# continue
		# else
			# waiting = true
			# return
		# else wait
		current.call(method) # pause here?
		if _is_active():
			current._post()
	if _is_active():
		current._end() # // Will cause issues
		current.IO.clear_all_temp_directories()
		
func _resume() -> void:
	# resume method // method.resume()
	# current.post // 
	# next
	pass
		
func _start() -> void:
	if self.current != null:
		self.current.free()
	self.cursor = -1
	display.reset()
	_set_tests()
	
func _is_active() -> bool:
	return not waiting and self.cursor < tests.size() - 1
	
func _get_next() -> TEST:
	self.cursor +=1
	return self.tests[self.cursor].new()
	
func _end_test() -> void:
	display.display(current.case)
	current.free()

func _set_tests() -> void:
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
	self.tests = results
