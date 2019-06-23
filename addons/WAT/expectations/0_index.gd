const EXPECT = preload("res://addons/WAT/constants/expectation_list.gd")
const CRASH_IF_TEST_FAILS: bool = true
signal OUTPUT
signal CRASHED

func output(data, crash_on_failure: bool = false) -> void:
	data.expected = "Expect:    %s" % data.expected
	if crash_on_failure:
		emit_signal("CRASHED", data)
	else:
		emit_signal("OUTPUT", data)

func is_true(condition: bool, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_TRUE.new(condition, expected), crash_on_failure)

func is_false(condition: bool, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_FALSE.new(condition, expected), crash_on_failure)

func is_equal(a, b, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_EQUAL.new(a, b, expected), crash_on_failure)

func is_not_equal(a, b, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_EQUAL.new(a, b, expected), crash_on_failure)

func is_greater_than(a, b, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_GREATER_THAN.new(a, b, expected), crash_on_failure)

func is_less_than(a, b, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_LESS_THAN.new(a, b, expected), crash_on_failure)

func is_equal_or_greater_than(a, b, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_EQUAL_OR_GREATER_THAN.new(a, b, expected), crash_on_failure)

func is_equal_or_less_than(a, b, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_EQUAL_OR_LESS_THAN.new(a, b, expected), crash_on_failure)

func is_in_range(value, low, high, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_IN_RANGE.new(value, low, high, expected), crash_on_failure)

func is_not_in_range(value, low, high, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_IN_RANGE.new(value, low, high, expected), crash_on_failure)

func has(value, container, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.HAS.new(value, container, expected), crash_on_failure)

func does_not_have(value, container, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.DOES_NOT_HAVE.new(value, container, expected), crash_on_failure)

func is_class_instance(instance, type, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_CLASS_INSTANCE.new(instance, type, expected), crash_on_failure)

func is_not_class_instance(instance, type, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_CLASS_INSTANCE.new(instance, type, expected), crash_on_failure)

func is_built_in_type(value, type, expected: String, crash_on_failure: bool = false) -> void:
	print("WARNING: is_built_in_type is deprecated. Use is_x where x is builtin type")
	output(EXPECT.IS_BUILT_IN_TYPE.new(value, type, expected), crash_on_failure)

func is_not_built_in_type(value, type: int, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_BUILT_IN_TYPE.new(value, type, expected), crash_on_failure)

func is_null(value, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NULL.new(value, expected), crash_on_failure)

func is_not_null(value, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_NULL.new(value, expected), crash_on_failure)

func string_contains(value, string: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_CONTAINS.new(value, string, expected), crash_on_failure)

func string_does_not_contain(value, string: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_DOES_NOT_CONTAIN.new(value, string, expected), crash_on_failure)

func string_begins_with(value, string: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_BEGINS_WITH.new(value, string, expected), crash_on_failure)

func string_does_not_begin_with(value, string: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_DOES_NOT_BEGIN_WITH.new(value, string, expected), crash_on_failure)

func string_ends_with(value, string: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_ENDS_WITH.new(value, string, expected), crash_on_failure)

func string_does_not_end_with(value, string: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_DOES_NOT_END_WITH.new(value, string, expected), crash_on_failure)

func was_called(double, a: String = "", b: String = "", c: String = "") -> void:
	_scene_was_called(double, a, b, c) if double.is_scene else _script_was_called(double, a, b)

func _scene_was_called(double, nodepath: String, method: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.SCENE_WAS_CALLED.new(double, nodepath, method, expected), crash_on_failure)

func _script_was_called(double, method: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.SCRIPT_WAS_CALLED.new(double, method, expected), crash_on_failure)

func was_not_called(double, a: String = "", b: String = "", c: String = "") -> void:\
	_scene_was_not_called(double, a, b, c) if double.is_scene else _script_was_not_called(double, a, b)
#
func _scene_was_not_called(double, nodepath: String, method: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.SCENE_WAS_NOT_CALLED.new(double, nodepath, method, expected), crash_on_failure)
#
func _script_was_not_called(double, method: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.SCRIPT_WAS_NOT_CALLED.new(double, method, expected), crash_on_failure)

func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.CALLED_WITH_ARGUMENTS.new(double, method, arguments, expected), crash_on_failure)

func signal_was_emitted(emitter, _signal, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.SIGNAL_WAS_EMITTED.new(emitter, _signal, expected), crash_on_failure)

func signal_was_not_emitted(emitter, _signal: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.SIGNAL_WAS_NOT_EMITTED.new(emitter, _signal, expected), crash_on_failure)

func signal_was_emitted_with_arguments(emitter, _signal, arguments: Array, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.SIGNAL_WAS_EMITTED_WITH_ARGUMENTS.new(emitter, _signal, arguments, expected), crash_on_failure)

func file_exists(path: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.FILE_EXISTS.new(path, expected), crash_on_failure)

func file_does_not_exist(path: String, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.FILE_DOES_NOT_EXIST.new(path, expected), crash_on_failure)

func is_freed(obj, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_FREED.new(obj, expected), crash_on_failure)

func is_not_freed(obj, expected: String, crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_FREED.new(obj, expected), crash_on_failure)

func is_bool(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_BOOL.new(value, expected), crash_on_failure)

func is_not_bool(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_BOOL.new(value, expected), crash_on_failure)

func is_int(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_INT.new(value, expected), crash_on_failure)

func is_not_int(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_INT.new(value, expected), crash_on_failure)

func is_float(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_FLOAT.new(value, expected), crash_on_failure)

func is_not_float(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_FLOAT.new(value, expected), crash_on_failure)

func is_String(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_STRING.new(value, expected), crash_on_failure)

func is_not_String(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_STRING.new(value, expected), crash_on_failure)

func is_Vector2(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_VECTOR2.new(value, expected), crash_on_failure)

func is_not_Vector2(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_VECTOR2.new(value, expected), crash_on_failure)

func is_Rect2(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_RECT2.new(value, expected), crash_on_failure)

func is_not_Rect2(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_RECT2.new(value, expected), crash_on_failure)

func is_Vector3(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_VECTOR3.new(value, expected), crash_on_failure)

func is_not_Vector3(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_VECTOR3.new(value, expected), crash_on_failure)

func is_Transform2D(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_TRANSFORM2D.new(value, expected), crash_on_failure)

func is_not_Transform2D(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_TRANSFORM2D.new(value, expected), crash_on_failure)

func is_Plane(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_PLANE.new(value, expected), crash_on_failure)

func is_not_Plane(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_PLANE.new(value, expected), crash_on_failure)

func is_Quat(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_QUAT.new(value, expected), crash_on_failure)

func is_not_Quat(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_QUAT.new(value, expected), crash_on_failure)

func is_AABB(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_AABB.new(value, expected), crash_on_failure)

func is_not_AABB(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_AABB.new(value, expected), crash_on_failure)

func is_Basis(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_BASIS.new(value, expected), crash_on_failure)

func is_not_Basis(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_BASIS.new(value, expected), crash_on_failure)

func is_Transform(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_TRANSFORM.new(value, expected), crash_on_failure)

func is_not_Transform(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_TRANSFORM.new(value, expected), crash_on_failure)

func is_Color(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_COLOR.new(value, expected), crash_on_failure)

func is_not_Color(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_COLOR.new(value, expected), crash_on_failure)

func is_NodePath(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NODEPATH.new(value, expected), crash_on_failure)

func is_not_NodePath(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_NODEPATH.new(value, expected), crash_on_failure)

func is_RID(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_RID.new(value, expected), crash_on_failure)

func is_not_RID(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_RID.new(value, expected), crash_on_failure)

func is_Object(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_OBJECT.new(value, expected), crash_on_failure)

func is_not_Object(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_OBJECT.new(value, expected), crash_on_failure)

func is_Dictionary(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_DICTIONARY.new(value, expected), crash_on_failure)

func is_not_Dictionary(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_DICTIONARY.new(value, expected), crash_on_failure)

func is_Array(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_ARRAY.new(value, expected), crash_on_failure)

func is_not_Array(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_ARRAY.new(value, expected), crash_on_failure)

func is_PoolByteArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_POOLBYTEARRAY.new(value, expected), crash_on_failure)

func is_not_PoolByteArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_POOLBYTEARRAY.new(value, expected), crash_on_failure)

func is_PoolIntArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_POOLINTARRAY.new(value, expected), crash_on_failure)

func is_not_PoolIntArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_POOLINTARRAY.new(value, expected), crash_on_failure)

func is_PoolRealArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_POOLREALARRAY.new(value, expected), crash_on_failure)

func is_not_PoolRealArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_POOLREALARRAY.new(value, expected), crash_on_failure)

func is_PoolStringArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_POOLSTRINGARRAY.new(value, expected), crash_on_failure)

func is_not_PoolStringArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_POOLSTRINGARRAY.new(value, expected), crash_on_failure)

func is_PoolVector2Array(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_POOLVECTOR2ARRAY.new(value, expected), crash_on_failure)

func is_not_PoolVector2Array(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_POOLVECTOR2ARRAY.new(value, expected), crash_on_failure)

func is_PoolVector3Array(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_POOLVECTOR3ARRAY.new(value, expected), crash_on_failure)

func is_not_PoolVector3Array(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_POOLVECTOR3ARRAY.new(value, expected), crash_on_failure)

func is_PoolColorArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_POOLCOLORARRAY.new(value, expected), crash_on_failure)

func is_not_PoolColorArray(value, expected: String, crash_on_failure: bool = false) -> void:
        output(EXPECT.IS_NOT_POOLCOLORARRAY.new(value, expected), crash_on_failure)