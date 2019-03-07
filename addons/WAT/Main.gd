tool
extends Panel

onready var run_button = $Split/Config/Button
onready var display = $Split/Display
var example = preload("res://tests/test_calculator_methods.gd")

func _ready():
	self.run_button.connect("pressed", self, "_run")

func _run():
	display.reset()
	# collect files (we don't do this yet)
	var test: WATT = example.new()
	test.title = "calculator_methods"
	add_child(test)
	test.run()
	display.display(test.testcase)
	test.free()
	# When exiting the loop, displays reset is called