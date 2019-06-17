extends Reference

signal OUTPUT

func output(data) -> void:
	data.expected = "Expect:    %s" % data.expected
	emit_signal("OUTPUT", data)

func is_true(condition: bool, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_true.gd").new(condition, expected))

func is_false(condition: bool, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_false.gd").new(condition, expected))

func is_equal(a, b, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_equal.gd").new(a, b, expected))

func is_not_equal(a, b, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_not_equal.gd").new(a, b, expected))

func is_greater_than(a, b, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_greater_than.gd").new(a, b, expected))

func is_less_than(a, b, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_less_than.gd").new(a, b, expected))

func is_equal_or_greater_than(a, b, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_equal_or_greater_than.gd").new(a, b, expected))

func is_equal_or_less_than(a, b, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_equal_or_less_than.gd").new(a, b, expected))

func is_in_range(value, low, high, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_in_range.gd").new(value, low, high, expected))

func is_not_in_range(value, low, high, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_not_in_range.gd").new(value, low, high, expected))

func has(value, container, expected: String) -> void:
	output(load("res://addons/WAT/expectations/has.gd").new(value, container, expected))

func does_not_have(value, container, expected: String) -> void:
	output(load("res://addons/WAT/expectations/does_not_have.gd").new(value, container, expected))

func is_class_instance(instance, type, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_class_instance.gd").new(instance, type, expected))

func is_not_class_instance(instance, type, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_not_class_instance.gd").new(instance, type, expected))

func is_built_in_type(value, type, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_built_in_type.gd").new(value, type, expected))

func is_not_built_in_type(value, type: int, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_not_built_in_type.gd").new(value, type, expected))

func is_null(value, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_null.gd").new(value, expected))

func is_not_null(value, expected: String) -> void:
	output(load("res://addons/WAT/expectations/is_not_null.gd").new(value, expected))

func string_contains(value, string: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/string_contains.gd").new(value, string, expected))

func string_does_not_contain(value, string: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/string_does_not_contain.gd").new(value, string, expected))

func string_begins_with(value, string: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/string_begins_with.gd").new(value, string, expected))

func string_does_not_begin_with(value, string: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/string_does_not_begin_with.gd").new(value, string, expected))

func string_ends_with(value, string: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/string_ends_with.gd").new(value, string, expected))

func string_does_not_end_with(value, string: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/string_does_not_end_with.gd").new(value, string, expected))

func was_called(double, a: String = "", b: String = "", c: String = "") -> void:
	_scene_was_called(double, a, b, c) if double.is_scene else _script_was_called(double, a, b)

func _scene_was_called(double, nodepath: String, method: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/scene_was_called.gd").new(double, nodepath, method, expected))

func _script_was_called(double, method: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/script_was_called.gd").new(double, method, expected))

func was_not_called(double, a: String = "", b: String = "", c: String = "") -> void:\
	_scene_was_not_called(double, a, b, c) if double.is_scene else _script_was_not_called(double, a, b)
#
func _scene_was_not_called(double, nodepath: String, method: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/scene_was_not_called.gd").new(double, nodepath, method, expected))
#
func _script_was_not_called(double, method: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/script_was_not_called.gd").new(double, method, expected))

func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String) -> void:
	output(load("res://addons/WAT/expectations/called_with_arguments.gd").new(double, method, arguments, expected))

func signal_was_emitted(emitter, _signal, expected: String) -> void:
	output(load("res://addons/WAT/expectations/signal_was_emitted.gd").new(emitter, _signal, expected))

func signal_was_not_emitted(emitter, _signal: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/signal_was_not_emitted.gd").new(emitter, _signal, expected))
	
func file_exists(path: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/file_exists.gd").new(path, expected))
	
func file_does_not_exist(path: String, expected: String) -> void:
	output(load("res://addons/WAT/expectations/file_does_not_exist.gd").new(path, expected))