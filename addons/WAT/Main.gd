tool
extends Panel

onready var run_button = $Split/Config/Button
onready var clear_button = $Split/Config/Button2
onready var display = $Split/Display
#var example = preload("res://tests/test_calculator_methods.gd")
const _TEST_DIR: String = "res://tests/"

func _ready():
	self.run_button.connect("pressed", self, "_run")
	self.clear_button.connect("pressed", self.display, "reset")

func _run():
	display.reset()
	for script in self.tests():
		var test: WATT = script.new()
		add_child(test)
		test.run()
		display.display(test.testcase)
		test.free() # This might cause issues?

func tests() -> Array:
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
