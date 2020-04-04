extends Reference

const Boolean: Script = preload("boolean/namespace.gd")
const Double: Script = preload("double/namespace.gd")
const Equality: Script = preload("equality/namespace.gd")
const _File: Script = preload("class/file/namespace.gd")
const _Range: Script = preload("range/namespace.gd")
const Signal: Script = preload("signal/namespace.gd")
const _String: Script = preload("string/namespace.gd")
const _Object: Script = preload("class/object/namespace.gd")
const _Is: Script = preload("is/namespace.gd")
const IsNot: Script = preload("is_not/namespace.gd")
const Null: Script = preload("null/namespace.gd")

# Not in any namespace
const DoesNotHave: Script = preload("does_not_have.gd")
const Has: Script = preload("has.gd")
const Fail: Script = preload("fail.gd")

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
	output(Boolean.IsTrue.new(condition, context), crash_on_failure)

func is_false(condition: bool, context: String = "", crash_on_failure: bool = false) -> void:
	output(Boolean.IsFalse.new(condition, context), crash_on_failure)

func is_equal(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(Equality.IsEqual.new(a, b, context), crash_on_failure)

func is_not_equal(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(Equality.IsNotEqual.new(a, b, context), crash_on_failure)

func is_greater_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(Equality.IsGreaterThan.new(a, b, context), crash_on_failure)

func is_less_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(Equality.IsLessThan.new(a, b, context), crash_on_failure)

func is_equal_or_greater_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(Equality.IsEqualOrGreaterThan.new(a, b, context), crash_on_failure)

func is_equal_or_less_than(a, b, context: String = "", crash_on_failure: bool = false) -> void:
	output(Equality.IsEqualOrLessThan.new(a, b, context), crash_on_failure)

func is_in_range(value, low, high, context: String = "", crash_on_failure: bool = false) -> void:
	output(_Range.IsInRange.new(value, low, high, context), crash_on_failure)

func is_not_in_range(value, low, high, context: String = "", crash_on_failure: bool = false) -> void:
	output(_Range.IsNotInRange.new(value, low, high, context), crash_on_failure)

func has(value, container, context: String = "", crash_on_failure: bool = false) -> void:
	output(Has.new(value, container, context), crash_on_failure)

func does_not_have(value, container, context: String = "", crash_on_failure: bool = false) -> void:
	output(DoesNotHave.new(value, container, context), crash_on_failure)

func is_class_instance(instance, type, context: String = "", crash_on_failure: bool = false) -> void:
	output(_Is.IsClassInstance.new(instance, type, context), crash_on_failure)

func is_not_class_instance(instance, type, context: String = "", crash_on_failure: bool = false) -> void:
	output(IsNot.IsNotClassInstance.new(instance, type, context), crash_on_failure)

func is_built_in_type(value, type, context: String = "", crash_on_failure: bool = false) -> void:
	print("WARNING: is_built_in_type is deprecated. Use is_x where x is builtin type")
	output(_Is.IsBuiltInType.new(value, type, context), crash_on_failure)

func is_not_built_in_type(value, type: int, context: String = "", crash_on_failure: bool = false) -> void:
	output(IsNot.IsNotBuiltInType.new(value, type, context), crash_on_failure)

func is_null(value, context: String = "", crash_on_failure: bool = false) -> void:
	output(Null.IsNull.new(value, context), crash_on_failure)

func is_not_null(value, context: String = "", crash_on_failure: bool = false) -> void:
	output(Null.IsNotNull.new(value, context), crash_on_failure)

func string_contains(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_String.Contains.new(value, string, context), crash_on_failure)

func string_does_not_contain(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_String.DoesNotContain.new(value, string, context), crash_on_failure)

func string_begins_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_String.BeginsWith.new(value, string, context), crash_on_failure)

func string_does_not_begin_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_String.DoesNotBeginWith.new(value, string, context), crash_on_failure)

func string_ends_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_String.EndsWith.new(value, string, context), crash_on_failure)

func string_does_not_end_with(value, string: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_String.DoesNotEndWith.new(value, string, context), crash_on_failure)

func was_called(double, method: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(Double.WasCalled.new(double, method, context), crash_on_failure)

func was_not_called(double, method: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(Double.WasNotCalled.new(double, method, context), crash_on_failure)

func was_called_with_arguments(double, method: String, arguments: Array, context: String = "", crash_on_failure: bool = false) -> void:
	output(Double.WasCalledWithArguments.new(double, method, arguments, context), crash_on_failure)

func signal_was_emitted(emitter, _signal, context: String = "", crash_on_failure: bool = false) -> void:
	output(Signal.WasEmitted.new(emitter, _signal, context), crash_on_failure)
	
func signal_was_emitted_x_times(emitter, _signal, times: int, context: String = "", crash_on_failure: bool = false) -> void:
	output(Signal.WasEmittedXTimes.new(emitter, _signal, times, context))

func signal_was_not_emitted(emitter, _signal: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(Signal.WasNotEmitted.new(emitter, _signal, context), crash_on_failure)

func signal_was_emitted_with_arguments(emitter, _signal, arguments: Array, context: String = "", crash_on_failure: bool = false) -> void:
	output(Signal.WasEmittedWithArguments.new(emitter, _signal, arguments, context), crash_on_failure)

func file_exists(path: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_File.Exists.new(path, context), crash_on_failure)

func file_does_not_exist(path: String, context: String = "", crash_on_failure: bool = false) -> void:
	output(_File.DoesNotExist.new(path, context), crash_on_failure)

func object_has_meta(obj, meta: String, context: String, crash_on_failure: bool = false) -> void:
	output(_Object.HasMeta.new(obj, meta, context), crash_on_failure)
	
func object_does_not_have_meta(obj, meta: String, context: String, crash_on_failure: bool = false) -> void:
	output(_Object.DoesNotHaveMeta.new(obj, meta, context), crash_on_failure)
	
func object_has_method(obj, method: String, context: String, crash_on_failure: bool = false) -> void:
	output(_Object.HasMethod.new(obj, method, context), crash_on_failure)
	
func object_does_not_have_method(obj, method: String, context: String, crash_on_failure: bool = false) -> void:
	output(_Object.DoesNotHaveMethod.new(obj, method, context), crash_on_failure)
	
func is_freed(obj, context: String = "", crash_on_failure: bool = false) -> void:
	output(_Object.IsFreed.new(obj, context), crash_on_failure)

func is_not_freed(obj, context: String = "", crash_on_failure: bool = false) -> void:
	output(_Object.IsNotFreed.new(obj, context), crash_on_failure)

func is_bool(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsBool.new(value, context), crash_on_failure)

func is_not_bool(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotBool.new(value, context), crash_on_failure)

func is_int(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsInt.new(value, context), crash_on_failure)

func is_not_int(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotInt.new(value, context), crash_on_failure)

func is_float(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsFloat.new(value, context), crash_on_failure)

func is_not_float(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotFloat.new(value, context), crash_on_failure)

func is_String(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsString.new(value, context), crash_on_failure)

func is_not_String(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotString.new(value, context), crash_on_failure)

func is_Vector2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsVector2.new(value, context), crash_on_failure)

func is_not_Vector2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotVector2.new(value, context), crash_on_failure)

func is_Rect2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsRect2.new(value, context), crash_on_failure)

func is_not_Rect2(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotRect2.new(value, context), crash_on_failure)

func is_Vector3(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsVector3.new(value, context), crash_on_failure)

func is_not_Vector3(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotVector3.new(value, context), crash_on_failure)

func is_Transform2D(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsTransform2D.new(value, context), crash_on_failure)

func is_not_Transform2D(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotTransform2D.new(value, context), crash_on_failure)

func is_Plane(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPlane.new(value, context), crash_on_failure)

func is_not_Plane(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPlane.new(value, context), crash_on_failure)

func is_Quat(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsQuat.new(value, context), crash_on_failure)

func is_not_Quat(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotQuat.new(value, context), crash_on_failure)

func is_AABB(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsAABB.new(value, context), crash_on_failure)

func is_not_AABB(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotAABB.new(value, context), crash_on_failure)

func is_Basis(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsBasis.new(value, context), crash_on_failure)

func is_not_Basis(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotBasis.new(value, context), crash_on_failure)

func is_Transform(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsTransform.new(value, context), crash_on_failure)

func is_not_Transform(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotTransform.new(value, context), crash_on_failure)

func is_Color(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsColor.new(value, context), crash_on_failure)

func is_not_Color(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotColor.new(value, context), crash_on_failure)

func is_NodePath(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsNodePath.new(value, context), crash_on_failure)

func is_not_NodePath(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotNodePath.new(value, context), crash_on_failure)

func is_RID(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsRID.new(value, context), crash_on_failure)

func is_not_RID(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotRID.new(value, context), crash_on_failure)

func is_Object(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsObject.new(value, context), crash_on_failure)

func is_not_Object(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotObject.new(value, context), crash_on_failure)

func is_Dictionary(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsDictionary.new(value, context), crash_on_failure)

func is_not_Dictionary(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotDictionary.new(value, context), crash_on_failure)

func is_Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsArray.new(value, context), crash_on_failure)

func is_not_Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotArray.new(value, context), crash_on_failure)

func is_PoolByteArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPoolByteArray.new(value, context), crash_on_failure)

func is_not_PoolByteArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPoolByteArray.new(value, context), crash_on_failure)

func is_PoolIntArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPoolIntArray.new(value, context), crash_on_failure)

func is_not_PoolIntArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPoolIntArray.new(value, context), crash_on_failure)

func is_PoolRealArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPoolRealArray.new(value, context), crash_on_failure)

func is_not_PoolRealArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPoolRealArray.new(value, context), crash_on_failure)

func is_PoolStringArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPoolStringArray.new(value, context), crash_on_failure)

func is_not_PoolStringArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPoolStringArray.new(value, context), crash_on_failure)

func is_PoolVector2Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPoolVector2Array.new(value, context), crash_on_failure)

func is_not_PoolVector2Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPoolVector2Array.new(value, context), crash_on_failure)

func is_PoolVector3Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPoolVector3Array.new(value, context), crash_on_failure)

func is_not_PoolVector3Array(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPoolVector3Array.new(value, context), crash_on_failure)

func is_PoolColorArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(_Is.IsPoolColorArray.new(value, context), crash_on_failure)

func is_not_PoolColorArray(value, context: String = "", crash_on_failure: bool = false) -> void:
		output(IsNot.IsNotPoolColorArray.new(value, context), crash_on_failure)
		
func fail(context: String = "Unimplemented Test") -> void:
		output(Fail.new(context))
