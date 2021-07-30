extends Reference
class_name _watTestParcel

var run_type: int
var tests

func _init(_run_type: int, _tests) -> void:
	run_type = _run_type
	tests = weakref(_tests)
	
func get_tests() -> Array:
	return tests.get_ref().get_tests()
