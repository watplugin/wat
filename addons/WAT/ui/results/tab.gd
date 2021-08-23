extends Reference

var tree: Tree
var title: String
var idx: int = 0
var count: int = 0
var passed: int = 0
var _multiplier: int = 0
var _expected_total: int = 0
var success: bool = false
var expected setget ,_get_expected

func _init(_tree: Tree, _title: String, multiplier: int) -> void:
	tree = _tree
	title = _title
	_multiplier = multiplier + 1

func increment_expected_total() -> void:
	# Multiplier tracks how many times we repeat tests
	# count should always be 1
	_expected_total += 1 * _multiplier
	
func on_test_script_finished(successful: bool) -> void:
	if successful:
		passed += 1
	if count == _expected_total and passed == count:
		success = true
		
func _get_expected() -> int:
	return _expected_total
