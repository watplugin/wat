extends Reference

const TYPES = preload("constants/type_library.gd")
const AssertionResult: Script = preload("res://addons/WAT/core/assertions/assertion_result.gd")
var success: bool
var expected: String = "NULL"
var result: String
var notes: String = "No Notes"
var context

static func type2str(value):
	return TYPES.get_type_string(typeof(value))

static func _result(success: bool, expected: String, actual: String,
						context: String, notes: String = "No Notes"):
	return AssertionResult.new(success, expected, actual, context, notes)

func to_dictionary() -> Dictionary:
	return {
			 "success": success,
			 "expected": expected,
			 "actual": result,
			 "context": context
			}
