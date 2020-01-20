extends Reference

const EXPECT = preload("res://addons/WAT/constants/expectation_list.gd")
const CRASH_IF_TEST_FAILS: bool = true
signal OUTPUT
signal CRASHED
signal asserted

func output(data, crash_on_failure: bool = false) -> void:
	if crash_on_failure and not data.success:
		print("l11: expectations, emitting crash")
		emit_signal("CRASHED", data)
	else:
		emit_signal("asserted", data)

func loop(method: String, data: Array) -> void:
	for set in data:
		callv(method, set)

func is_true(condition: bool, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_TRUE.new(condition, context), crash_on_failure)

func is_false(condition: bool, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_FALSE.new(condition, context), crash_on_failure)

func is_equal(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_EQUAL.new(a, b, context), crash_on_failure)

func is_not_equal(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_EQUAL.new(a, b, context), crash_on_failure)

func is_greater_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_GREATER_THAN.new(a, b, context), crash_on_failure)

func is_less_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_LESS_THAN.new(a, b, context), crash_on_failure)

func is_equal_or_greater_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_EQUAL_OR_GREATER_THAN.new(a, b, context), crash_on_failure)

func is_equal_or_less_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_EQUAL_OR_LESS_THAN.new(a, b, context), crash_on_failure)

func is_in_range(value, low, high, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_IN_RANGE.new(value, low, high, context), crash_on_failure)

func is_not_in_range(value, low, high, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_IN_RANGE.new(value, low, high, context), crash_on_failure)

func has(value, container, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.HAS.new(value, container, context), crash_on_failure)

func does_not_have(value, container, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.DOES_NOT_HAVE.new(value, container, context), crash_on_failure)

func is_class_instance(instance, type, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_CLASS_INSTANCE.new(instance, type, context), crash_on_failure)

func is_not_class_instance(instance, type, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_CLASS_INSTANCE.new(instance, type, context), crash_on_failure)

func is_built_in_type(value, type, context: String = "", crash_on_failure: bool = false) -> void:
	print("WARNING: is_built_in_type is deprecated. Use is_x where x is builtin type")
	output(EXPECT.IS_BUILT_IN_TYPE.new(value, type, context), crash_on_failure)

func is_not_built_in_type(value, type: int, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_BUILT_IN_TYPE.new(value, type, context), crash_on_failure)

func is_null(value, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NULL.new(value, context), crash_on_failure)

func is_not_null(value, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_NULL.new(value, context), crash_on_failure)

func string_contains(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_CONTAINS.new(value, string, context), crash_on_failure)

func string_does_not_contain(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_DOES_NOT_CONTAIN.new(value, string, context), crash_on_failure)

func string_begins_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_BEGINS_WITH.new(value, string, context), crash_on_failure)

func string_does_not_begin_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_DOES_NOT_BEGIN_WITH.new(value, string, context), crash_on_failure)

func string_ends_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_ENDS_WITH.new(value, string, context), crash_on_failure)

func string_does_not_end_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.STRING_DOES_NOT_END_WITH.new(value, string, context), crash_on_failure)

func was_called(double, method: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.SCRIPT_WAS_CALLED.new(double, method, context), crash_on_failure)

func was_not_called(double, method: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.SCRIPT_WAS_NOT_CALLED.new(double, method, context), crash_on_failure)

func was_called_with_arguments(double, method: String, arguments: Array, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.CALLED_WITH_ARGUMENTS.new(double, method, arguments, context), crash_on_failure)

func signal_was_emitted(emitter, _signal, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.SIGNAL_WAS_EMITTED.new(emitter, _signal, context), crash_on_failure)

func signal_was_not_emitted(emitter, _signal: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.SIGNAL_WAS_NOT_EMITTED.new(emitter, _signal, context), crash_on_failure)

func signal_was_emitted_with_arguments(emitter, _signal, arguments: Array, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.SIGNAL_WAS_EMITTED_WITH_ARGUMENTS.new(emitter, _signal, arguments, context), crash_on_failure)

func file_exists(path: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.FILE_EXISTS.new(path, context), crash_on_failure)

func file_does_not_exist(path: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.FILE_DOES_NOT_EXIST.new(path, context), crash_on_failure)

func is_freed(obj, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_FREED.new(obj, context), crash_on_failure)

func is_not_freed(obj, context: String = "", crash_on_failure: bool = false) -> void:
	output(EXPECT.IS_NOT_FREED.new(obj, context), crash_on_failure)

func is_bool(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_BOOL.new(value, context), crash_on_failure)

func is_not_bool(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_BOOL.new(value, context), crash_on_failure)

func is_int(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_INT.new(value, context), crash_on_failure)

func is_not_int(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_INT.new(value, context), crash_on_failure)

func is_float(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_FLOAT.new(value, context), crash_on_failure)

func is_not_float(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_FLOAT.new(value, context), crash_on_failure)

func is_String(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_STRING.new(value, context), crash_on_failure)

func is_not_String(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_STRING.new(value, context), crash_on_failure)

func is_Vector2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_VECTOR2.new(value, context), crash_on_failure)

func is_not_Vector2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_VECTOR2.new(value, context), crash_on_failure)

func is_Rect2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_RECT2.new(value, context), crash_on_failure)

func is_not_Rect2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_RECT2.new(value, context), crash_on_failure)

func is_Vector3(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_VECTOR3.new(value, context), crash_on_failure)

func is_not_Vector3(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_VECTOR3.new(value, context), crash_on_failure)

func is_Transform2D(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_TRANSFORM2D.new(value, context), crash_on_failure)

func is_not_Transform2D(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_TRANSFORM2D.new(value, context), crash_on_failure)

func is_Plane(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_PLANE.new(value, context), crash_on_failure)

func is_not_Plane(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_PLANE.new(value, context), crash_on_failure)

func is_Quat(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_QUAT.new(value, context), crash_on_failure)

func is_not_Quat(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_QUAT.new(value, context), crash_on_failure)

func is_AABB(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_AABB.new(value, context), crash_on_failure)

func is_not_AABB(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_AABB.new(value, context), crash_on_failure)

func is_Basis(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_BASIS.new(value, context), crash_on_failure)

func is_not_Basis(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_BASIS.new(value, context), crash_on_failure)

func is_Transform(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_TRANSFORM.new(value, context), crash_on_failure)

func is_not_Transform(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_TRANSFORM.new(value, context), crash_on_failure)

func is_Color(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_COLOR.new(value, context), crash_on_failure)

func is_not_Color(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_COLOR.new(value, context), crash_on_failure)

func is_NodePath(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NODEPATH.new(value, context), crash_on_failure)

func is_not_NodePath(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_NODEPATH.new(value, context), crash_on_failure)

func is_RID(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_RID.new(value, context), crash_on_failure)

func is_not_RID(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_RID.new(value, context), crash_on_failure)

func is_Object(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_OBJECT.new(value, context), crash_on_failure)

func is_not_Object(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_OBJECT.new(value, context), crash_on_failure)

func is_Dictionary(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_DICTIONARY.new(value, context), crash_on_failure)

func is_not_Dictionary(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_DICTIONARY.new(value, context), crash_on_failure)

func is_Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_ARRAY.new(value, context), crash_on_failure)

func is_not_Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_ARRAY.new(value, context), crash_on_failure)

func is_PoolByteArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_POOLBYTEARRAY.new(value, context), crash_on_failure)

func is_not_PoolByteArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_POOLBYTEARRAY.new(value, context), crash_on_failure)

func is_PoolIntArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_POOLINTARRAY.new(value, context), crash_on_failure)

func is_not_PoolIntArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_POOLINTARRAY.new(value, context), crash_on_failure)

func is_PoolRealArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_POOLREALARRAY.new(value, context), crash_on_failure)

func is_not_PoolRealArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_POOLREALARRAY.new(value, context), crash_on_failure)

func is_PoolStringArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_POOLSTRINGARRAY.new(value, context), crash_on_failure)

func is_not_PoolStringArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_POOLSTRINGARRAY.new(value, context), crash_on_failure)

func is_PoolVector2Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_POOLVECTOR2ARRAY.new(value, context), crash_on_failure)

func is_not_PoolVector2Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_POOLVECTOR2ARRAY.new(value, context), crash_on_failure)

func is_PoolVector3Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_POOLVECTOR3ARRAY.new(value, context), crash_on_failure)

func is_not_PoolVector3Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_POOLVECTOR3ARRAY.new(value, context), crash_on_failure)

func is_PoolColorArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_POOLCOLORARRAY.new(value, context), crash_on_failure)

func is_not_PoolColorArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(EXPECT.IS_NOT_POOLCOLORARRAY.new(value, context), crash_on_failure)
