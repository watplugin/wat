tool
extends Panel

onready var run_button = $Split/Config/Button
onready var display = $Split/Display
#var example = preload("res://tests/test_calculator_methods.gd")
const _TEST_DIR: String = "res://tests/"

func _ready():
	self.run_button.connect("pressed", self, "_run")

func _run():
	display.reset()
	for path in self.tests():
		var test = load(path).new()
		test.title = path # We can probably self-reference path
		add_child(test)
		test.run()
		display.display(test.testcase)
		test.free()
	
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
			results.append(_TEST_DIR + title)
		title = dir.get_next()
	return results
