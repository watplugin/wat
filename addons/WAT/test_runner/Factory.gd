extends Node

export(Script) var TestController
var _created_test_count: int = 0
var _test_scripts: Array = []

func get_test_scripts(scripts: Array) -> void:
	_test_scripts = scripts

func get_next_test() -> Node:
	_created_test_count += 1
	return Node.new()
	# Create Test
	# Create Controller (inserting test)
	
func is_done() -> bool:
	return true if _created_test_count == _test_scripts.size() else false
