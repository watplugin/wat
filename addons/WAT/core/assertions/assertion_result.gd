extends Reference

var success: bool setget _readonly
var expected: String setget _readonly
var actual: String setget _readonly
var notes: String = "No Notes" setget _readonly
var context: String setget _readonly

func _init(_success: bool, _expected: String, _actual: String, 
			_context: String, _notes: String = "No Notes") -> void:
	success = _success
	expected = _expected
	actual = _actual
	notes = _notes
	context = _context

func to_dictionary() -> Dictionary:
	return {
				"success": success,
				"expected": expected,
				"actual": actual,
				"context": context
			}
			
func _readonly(value):
	push_warning("Invalid Set Value (%s). Property is readonly" % value)
