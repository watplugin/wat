extends Node

# Do these need to be dictionaries for the network? Or is that 4.0?
		
class TestTag extends Reference:
	var tag: String
	var tests: Array = []
	var name
	
	func _init(_tag: String) -> void:
		tag = _tag
		name = tag
		
	func get_tests() -> Array:
		var scripts: Array = []
		for test in tests:
			scripts += test.get_tests()
		return scripts
		
		
class TestFailures extends Reference:
	var tests: Array = []
	
	func get_tests() -> Array:
		return tests
