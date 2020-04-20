extends Reference

const That: Script = preload("that.gd")
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
const Property: Script = preload("property/namespace.gd")

# Not in any namespace
const Fail: Script = preload("fail.gd")

const CRASH_IF_TEST_FAILS: bool = true
signal OUTPUT
signal CRASHED
signal asserted

func output(data) -> void:
	emit_signal("asserted", data)

func loop(method: String, data: Array) -> void:
	for set in data:
		callv(method, set)

func is_true(condition: bool, context: String = "") -> void:
	output(Boolean.IsTrue.new(condition, context))

func is_false(condition: bool, context: String = "") -> void:
	output(Boolean.IsFalse.new(condition, context))

func is_equal(a, b, context: String = "") -> void:
	output(Equality.IsEqual.new(a, b, context))

func is_not_equal(a, b, context: String = "") -> void:
	output(Equality.IsNotEqual.new(a, b, context))

func is_greater_than(a, b, context: String = "") -> void:
	output(Equality.IsGreaterThan.new(a, b, context))

func is_less_than(a, b, context: String = "") -> void:
	output(Equality.IsLessThan.new(a, b, context))

func is_equal_or_greater_than(a, b, context: String = "") -> void:
	output(Equality.IsEqualOrGreaterThan.new(a, b, context))

func is_equal_or_less_than(a, b, context: String = "") -> void:
	output(Equality.IsEqualOrLessThan.new(a, b, context))

func is_in_range(value, low, high, context: String = "") -> void:
	output(_Range.IsInRange.new(value, low, high, context))

func is_not_in_range(value, low, high, context: String = "") -> void:
	output(_Range.IsNotInRange.new(value, low, high, context))

func has(value, container, context: String = "") -> void:
	output(Property.Has.new(value, container, context))

func does_not_have(value, container, context: String = "") -> void:
	output(Property.DoesNotHave.new(value, container, context))

func is_class_instance(instance, type, context: String = "") -> void:
	output(_Is.IsClassInstance.new(instance, type, context))

func is_not_class_instance(instance, type, context: String = "") -> void:
	output(IsNot.IsNotClassInstance.new(instance, type, context))

func is_built_in_type(value, type, context: String = "") -> void:
	print("WARNING: is_built_in_type is deprecated. Use is_x where x is builtin type")
	output(_Is.IsBuiltInType.new(value, type, context))

func is_not_built_in_type(value, type: int, context: String = "") -> void:
	output(IsNot.IsNotBuiltInType.new(value, type, context))

func is_null(value, context: String = "") -> void:
	output(Null.IsNull.new(value, context))

func is_not_null(value, context: String = "") -> void:
	output(Null.IsNotNull.new(value, context))

func string_contains(value, string: String, context: String = "") -> void:
	output(_String.Contains.new(value, string, context))

func string_does_not_contain(value, string: String, context: String = "") -> void:
	output(_String.DoesNotContain.new(value, string, context))

func string_begins_with(value, string: String, context: String = "") -> void:
	output(_String.BeginsWith.new(value, string, context))

func string_does_not_begin_with(value, string: String, context: String = "") -> void:
	output(_String.DoesNotBeginWith.new(value, string, context))

func string_ends_with(value, string: String, context: String = "") -> void:
	output(_String.EndsWith.new(value, string, context))

func string_does_not_end_with(value, string: String, context: String = "") -> void:
	output(_String.DoesNotEndWith.new(value, string, context))

func was_called(double, method: String, context: String = "") -> void:
	output(Double.WasCalled.new(double, method, context))

func was_not_called(double, method: String, context: String = "") -> void:
	output(Double.WasNotCalled.new(double, method, context))

func was_called_with_arguments(double, method: String, arguments: Array, context: String = "") -> void:
	output(Double.WasCalledWithArguments.new(double, method, arguments, context))

func signal_was_emitted(emitter, _signal, context: String = "") -> void:
	output(Signal.WasEmitted.new(emitter, _signal, context))
	
func signal_was_emitted_x_times(emitter, _signal, times: int, context: String = "") -> void:
	output(Signal.WasEmittedXTimes.new(emitter, _signal, times, context))

func signal_was_not_emitted(emitter, _signal: String, context: String = "") -> void:
	output(Signal.WasNotEmitted.new(emitter, _signal, context))

func signal_was_emitted_with_arguments(emitter, _signal, arguments: Array, context: String = "") -> void:
	output(Signal.WasEmittedWithArguments.new(emitter, _signal, arguments, context))

func file_exists(path: String, context: String = "") -> void:
	output(_File.Exists.new(path, context))

func file_does_not_exist(path: String, context: String = "") -> void:
	output(_File.DoesNotExist.new(path, context))
	
func that(obj, method: String, arguments: Array = [], context: String = "", passed: String = "", failed: String = "") -> void:
	output(That.new(obj, method, arguments, context, passed, failed))
	 
func object_has_meta(obj, meta: String, context: String) -> void:
	output(_Object.HasMeta.new(obj, meta, context))
	
func object_does_not_have_meta(obj, meta: String, context: String) -> void:
	output(_Object.DoesNotHaveMeta.new(obj, meta, context))
	
func object_has_method(obj, method: String, context: String) -> void:
	output(_Object.HasMethod.new(obj, method, context))
	
func object_does_not_have_method(obj, method: String, context: String) -> void:
	output(_Object.DoesNotHaveMethod.new(obj, method, context))
	
func object_is_queued_for_deletion(obj, context: String) -> void:
	output(_Object.IsQueuedForDeletion.new(obj, context))
	
func object_is_not_queued_for_deletion(obj, context: String) -> void:
	output(_Object.IsNotQueuedForDeletion.new(obj, context))
	
func object_is_connected(sender: Object, _signal: String, receiver: Object, method: String, context: String) -> void:
	output(_Object.IsConnected.new(sender, _signal, receiver, method, context))
	
func object_is_not_connected(sender: Object, _signal: String, receiver: Object, method: String, context: String) -> void:
	output(_Object.IsNotConnected.new(sender, _signal, receiver, method, context))
	
func object_is_blocking_signals(obj, context: String) -> void:
	output(_Object.IsBlockingSignals.new(obj, context))
	
func object_is_not_blocking_signals(obj, context: String) -> void:
	output(_Object.IsNotBlockingSignals.new(obj, context))
	
func object_has_user_signal(obj, _signal: String, context: String) -> void:
	output(_Object.HasUserSignal.new(obj, _signal, context))
	
func object_does_not_have_user_signal(obj, _signal: String, context: String) -> void:
	output(_Object.DoesNotHaveUserSignal.new(obj, _signal, context))
	
func is_freed(obj, context: String = "") -> void:
	output(_Object.IsFreed.new(obj, context))

func is_not_freed(obj, context: String = "") -> void:
	output(_Object.IsNotFreed.new(obj, context))

func is_bool(value, context: String = "") -> void:
		output(_Is.IsBool.new(value, context))

func is_not_bool(value, context: String = "") -> void:
		output(IsNot.IsNotBool.new(value, context))

func is_int(value, context: String = "") -> void:
		output(_Is.IsInt.new(value, context))

func is_not_int(value, context: String = "") -> void:
		output(IsNot.IsNotInt.new(value, context))

func is_float(value, context: String = "") -> void:
		output(_Is.IsFloat.new(value, context))

func is_not_float(value, context: String = "") -> void:
		output(IsNot.IsNotFloat.new(value, context))

func is_String(value, context: String = "") -> void:
		output(_Is.IsString.new(value, context))

func is_not_String(value, context: String = "") -> void:
		output(IsNot.IsNotString.new(value, context))

func is_Vector2(value, context: String = "") -> void:
		output(_Is.IsVector2.new(value, context))

func is_not_Vector2(value, context: String = "") -> void:
		output(IsNot.IsNotVector2.new(value, context))

func is_Rect2(value, context: String = "") -> void:
		output(_Is.IsRect2.new(value, context))

func is_not_Rect2(value, context: String = "") -> void:
		output(IsNot.IsNotRect2.new(value, context))

func is_Vector3(value, context: String = "") -> void:
		output(_Is.IsVector3.new(value, context))

func is_not_Vector3(value, context: String = "") -> void:
		output(IsNot.IsNotVector3.new(value, context))

func is_Transform2D(value, context: String = "") -> void:
		output(_Is.IsTransform2D.new(value, context))

func is_not_Transform2D(value, context: String = "") -> void:
		output(IsNot.IsNotTransform2D.new(value, context))

func is_Plane(value, context: String = "") -> void:
		output(_Is.IsPlane.new(value, context))

func is_not_Plane(value, context: String = "") -> void:
		output(IsNot.IsNotPlane.new(value, context))

func is_Quat(value, context: String = "") -> void:
		output(_Is.IsQuat.new(value, context))

func is_not_Quat(value, context: String = "") -> void:
		output(IsNot.IsNotQuat.new(value, context))

func is_AABB(value, context: String = "") -> void:
		output(_Is.IsAABB.new(value, context))

func is_not_AABB(value, context: String = "") -> void:
		output(IsNot.IsNotAABB.new(value, context))

func is_Basis(value, context: String = "") -> void:
		output(_Is.IsBasis.new(value, context))

func is_not_Basis(value, context: String = "") -> void:
		output(IsNot.IsNotBasis.new(value, context))

func is_Transform(value, context: String = "") -> void:
		output(_Is.IsTransform.new(value, context))

func is_not_Transform(value, context: String = "") -> void:
		output(IsNot.IsNotTransform.new(value, context))

func is_Color(value, context: String = "") -> void:
		output(_Is.IsColor.new(value, context))

func is_not_Color(value, context: String = "") -> void:
		output(IsNot.IsNotColor.new(value, context))

func is_NodePath(value, context: String = "") -> void:
		output(_Is.IsNodePath.new(value, context))

func is_not_NodePath(value, context: String = "") -> void:
		output(IsNot.IsNotNodePath.new(value, context))

func is_RID(value, context: String = "") -> void:
		output(_Is.IsRID.new(value, context))

func is_not_RID(value, context: String = "") -> void:
		output(IsNot.IsNotRID.new(value, context))

func is_Object(value, context: String = "") -> void:
		output(_Is.IsObject.new(value, context))

func is_not_Object(value, context: String = "") -> void:
		output(IsNot.IsNotObject.new(value, context))

func is_Dictionary(value, context: String = "") -> void:
		output(_Is.IsDictionary.new(value, context))

func is_not_Dictionary(value, context: String = "") -> void:
		output(IsNot.IsNotDictionary.new(value, context))

func is_Array(value, context: String = "") -> void:
		output(_Is.IsArray.new(value, context))

func is_not_Array(value, context: String = "") -> void:
		output(IsNot.IsNotArray.new(value, context))

func is_PoolByteArray(value, context: String = "") -> void:
		output(_Is.IsPoolByteArray.new(value, context))

func is_not_PoolByteArray(value, context: String = "") -> void:
		output(IsNot.IsNotPoolByteArray.new(value, context))

func is_PoolIntArray(value, context: String = "") -> void:
		output(_Is.IsPoolIntArray.new(value, context))

func is_not_PoolIntArray(value, context: String = "") -> void:
		output(IsNot.IsNotPoolIntArray.new(value, context))

func is_PoolRealArray(value, context: String = "") -> void:
		output(_Is.IsPoolRealArray.new(value, context))

func is_not_PoolRealArray(value, context: String = "") -> void:
		output(IsNot.IsNotPoolRealArray.new(value, context))

func is_PoolStringArray(value, context: String = "") -> void:
		output(_Is.IsPoolStringArray.new(value, context))

func is_not_PoolStringArray(value, context: String = "") -> void:
		output(IsNot.IsNotPoolStringArray.new(value, context))

func is_PoolVector2Array(value, context: String = "") -> void:
		output(_Is.IsPoolVector2Array.new(value, context))

func is_not_PoolVector2Array(value, context: String = "") -> void:
		output(IsNot.IsNotPoolVector2Array.new(value, context))

func is_PoolVector3Array(value, context: String = "") -> void:
		output(_Is.IsPoolVector3Array.new(value, context))

func is_not_PoolVector3Array(value, context: String = "") -> void:
		output(IsNot.IsNotPoolVector3Array.new(value, context))

func is_PoolColorArray(value, context: String = "") -> void:
		output(_Is.IsPoolColorArray.new(value, context))

func is_not_PoolColorArray(value, context: String = "") -> void:
		output(IsNot.IsNotPoolColorArray.new(value, context))
		
func fail(context: String = "Unimplemented Test") -> void:
		output(Fail.new(context))
