extends Object

const Is: Script = preload("is.gd")
const IsNot: Script = preload("is_not.gd")
const Boolean: Script = preload("boolean.gd")
const Double: Script = preload("double.gd")
const Equality: Script = preload("equality.gd")
const FileX: Script = preload("file.gd")
const Null: Script = preload("null.gd")
const RangeX: Script = preload("range.gd")
const Signal: Script = preload("signal.gd")
const StringX: Script = preload("string.gd")
const Utility: Script = preload("utility.gd")
const Property: Script = preload("property.gd")
const ObjectX: Script = preload("object.gd")
const Collections: Script = preload("collections.gd")
signal asserted

func output(data: Dictionary) -> void:
	emit_signal("asserted", data)

func is_true(condition: bool, context: String = "") -> void:
	output(Boolean.is_true(condition, context))

func is_false(condition: bool, context: String = "") -> void:
	output(Boolean.is_false(condition, context))

func is_equal(a, b, context: String = "") -> void:
	output(Equality.is_equal(a, b, context))

func is_not_equal(a, b, context: String = "") -> void:
	output(Equality.is_not_equal(a, b, context))

func is_greater_than(a, b, context: String = "") -> void:
	output(Equality.is_greater_than(a, b, context))

func is_less_than(a, b, context: String = "") -> void:
	output(Equality.is_less_than(a, b, context))

func is_equal_or_greater_than(a, b, context: String = "") -> void:
	output(Equality.is_equal_or_greater_than(a, b, context))

func is_equal_or_less_than(a, b, context: String = "") -> void:
	output(Equality.is_equal_or_less_than(a, b, context))

func is_in_range(value, low, high, context: String = "") -> void:
	output(RangeX.is_in_range(value, low, high, context))

func is_not_in_range(value, low, high, context: String = "") -> void:
	output(RangeX.is_not_in_range(value, low, high, context))

func has(value, container, context: String = "") -> void:
	output(Property.has(value, container, context))

func does_not_have(value, container, context: String = "") -> void:
	output(Property.does_not_have(value, container, context))

func is_class_instance(instance, type, context: String = "") -> void:
	output(Is.is_class_instance(instance, type, context))

func is_not_class_instance(instance, type, context: String = "") -> void:
	output(Is.is_not_class_instance(instance, type, context))

func is_null(value, context: String = "") -> void:
	output(Null.is_null(value, context))

func is_not_null(value, context: String = "") -> void:
	output(Null.is_not_null(value, context))

func string_contains(value, string: String, context: String = "") -> void:
	output(StringX.contains(value, string, context))

func string_does_not_contain(value, string: String, context: String = "") -> void:
	output(StringX.does_not_contain(value, string, context))

func string_begins_with(value, string: String, context: String = "") -> void:
	output(StringX.begins_with(value, string, context))

func string_does_not_begin_with(value, string: String, context: String = "") -> void:
	output(StringX.does_not_begin_with(value, string, context))

func string_ends_with(value, string: String, context: String = "") -> void:
	output(StringX.ends_with(value, string, context))

func string_does_not_end_with(value, string: String, context: String = "") -> void:
	output(StringX.does_not_end_with(value, string, context))

func was_called(double, method: String, context: String = "") -> void:
	output(Double.was_called(double, method, context))

func was_not_called(double, method: String, context: String = "") -> void:
	output(Double.was_not_called(double, method, context))

func was_called_with_arguments(double, method: String, arguments: Array, context: String = "") -> void:
	output(Double.called_with_arguments(double, method, arguments, context))

func signal_was_emitted(emitter, _signal, context: String = "") -> void:
	output(Signal.was_emitted(emitter, _signal, context))
	
func signal_was_emitted_x_times(emitter, _signal, times: int, context: String = "") -> void:
	output(Signal.was_emitted_x_times(emitter, _signal, times, context))

func signal_was_not_emitted(emitter, _signal: String, context: String = "") -> void:
	output(Signal.was_not_emitted(emitter, _signal, context))

func signal_was_emitted_with_arguments(emitter, _signal, arguments: Array, context: String = "") -> void:
	output(Signal.was_emitted_with_args(emitter, _signal, arguments, context))

func file_exists(path: String, context: String = "") -> void:
	output(FileX.exists(path, context))

func file_does_not_exist(path: String, context: String = "") -> void:
	output(FileX.does_not_exist(path, context))
	
func that(obj: Object, method: String, arguments: Array = [], context: String = "", passed: String = "", failed: String = "") -> void:
	output(Utility.that(obj, method, arguments, context, passed, failed))
	
func is_valid_instance(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_valid_instance(obj, context))
	
func is_not_valid_instance(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_not_valid_instance(obj, context))
	 
func object_has_meta(obj: Object, meta: String, context: String = "") -> void:
	output(ObjectX.o_has_meta(obj, meta, context))
	
func object_does_not_have_meta(obj: Object, meta: String, context: String = "") -> void:
	output(ObjectX.does_not_have_meta(obj, meta, context))
	
func object_has_method(obj: Object, method: String, context: String = "") -> void:
	output(ObjectX.o_has_method(obj, method, context))
	
func object_does_not_have_method(obj: Object, method: String, context: String = "") -> void:
	output(ObjectX.does_not_have_method(obj, method, context))
	
func object_is_queued_for_deletion(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_queued_for_deletion(obj, context))
	
func object_is_not_queued_for_deletion(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_not_queued_for_deletion(obj, context))
	
func object_is_connected(sender: Object, _signal: String, receiver: Object, method: String, context: String = "") -> void:
	output(ObjectX.o_is_connected(sender, _signal, receiver, method, context))
	
func object_is_not_connected(sender: Object, _signal: String, receiver: Object, method: String, context: String = "") -> void:
	output(ObjectX.o_is_not_connected(sender, _signal, receiver, method, context))
	
func object_is_blocking_signals(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_blocking_signals(obj, context))
	
func object_is_not_blocking_signals(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_not_blocking_signals(obj, context))
	
func object_has_user_signal(obj: Object, _signal: String, context: String = "") -> void:
	output(ObjectX.o_has_user_signal(obj, _signal, context))
	
func object_does_not_have_user_signal(obj: Object, _signal: String, context: String = "") -> void:
	output(ObjectX.does_not_have_user_signal(obj, _signal, context))
	
func is_freed(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_freed(obj, context))

func is_not_freed(obj: Object, context: String = "") -> void:
	output(ObjectX.o_is_not_freed(obj, context))

func is_empty(value, context: String = "") -> void:
	if value is String:
		output(StringX.is_empty(value, context))
	else:
		output(Collections.is_empty(value, context))

func is_bool(value, context: String = "") -> void:
		output(Is.is_bool(value, context))

func is_not_bool(value, context: String = "") -> void:
		output(IsNot.is_not_bool(value, context))

func is_int(value, context: String = "") -> void:
		output(Is.is_int(value, context))

func is_not_int(value, context: String = "") -> void:
		output(IsNot.is_not_int(value, context))

func is_float(value, context: String = "") -> void:
		output(Is.is_float(value, context))

func is_not_float(value, context: String = "") -> void:
		output(IsNot.is_not_float(value, context))

func is_String(value, context: String = "") -> void:
		output(Is.is_String(value, context))

func is_not_String(value, context: String = "") -> void:
		output(IsNot.is_not_String(value, context))

func is_Vector2(value, context: String = "") -> void:
		output(Is.is_Vector2(value, context))

func is_not_Vector2(value, context: String = "") -> void:
		output(IsNot.is_not_Vector2(value, context))

func is_Rect2(value, context: String = "") -> void:
		output(Is.is_Rect2(value, context))

func is_not_Rect2(value, context: String = "") -> void:
		output(IsNot.is_not_Rect2(value, context))

func is_Vector3(value, context: String = "") -> void:
		output(Is.is_Vector3(value, context))

func is_not_Vector3(value, context: String = "") -> void:
		output(IsNot.is_not_Vector3(value, context))

func is_Transform2D(value, context: String = "") -> void:
		output(Is.is_Transform2D(value, context))

func is_not_Transform2D(value, context: String = "") -> void:
		output(IsNot.is_not_Transform2D(value, context))

func is_Plane(value, context: String = "") -> void:
		output(Is.is_Plane(value, context))

func is_not_Plane(value, context: String = "") -> void:
		output(IsNot.is_not_Plane(value, context))

func is_Quat(value, context: String = "") -> void:
		output(Is.is_Quat(value, context))

func is_not_Quat(value, context: String = "") -> void:
		output(IsNot.is_not_Quat(value, context))

func is_AABB(value, context: String = "") -> void:
		output(Is.is_AABB(value, context))

func is_not_AABB(value, context: String = "") -> void:
		output(IsNot.is_not_AABB(value, context))

func is_Basis(value, context: String = "") -> void:
		output(Is.is_Basis(value, context))

func is_not_Basis(value, context: String = "") -> void:
		output(IsNot.is_not_Basis(value, context))

func is_Transform(value, context: String = "") -> void:
		output(Is.is_Transform(value, context))

func is_not_Transform(value, context: String = "") -> void:
		output(IsNot.is_not_Transform(value, context))

func is_Color(value, context: String = "") -> void:
		output(Is.is_Color(value, context))

func is_not_Color(value, context: String = "") -> void:
		output(IsNot.is_not_Color(value, context))

func is_NodePath(value, context: String = "") -> void:
		output(Is.is_NodePath(value, context))

func is_not_NodePath(value, context: String = "") -> void:
		output(IsNot.is_not_NodePath(value, context))

func is_RID(value, context: String = "") -> void:
		output(Is.is_RID(value, context))

func is_not_RID(value, context: String = "") -> void:
		output(IsNot.is_not_RID(value, context))

func is_Object(value, context: String = "") -> void:
		output(Is.is_Object(value, context))

func is_not_Object(value, context: String = "") -> void:
		output(IsNot.is_not_Object(value, context))

func is_Dictionary(value, context: String = "") -> void:
		output(Is.is_Dictionary(value, context))

func is_not_Dictionary(value, context: String = "") -> void:
		output(IsNot.is_not_Dictionary(value, context))

func is_Array(value, context: String = "") -> void:
		output(Is.is_Array(value, context))

func is_not_Array(value, context: String = "") -> void:
		output(IsNot.is_not_Array(value, context))

func is_PoolByteArray(value, context: String = "") -> void:
		output(Is.is_PoolByteArray(value, context))

func is_not_PoolByteArray(value, context: String = "") -> void:
		output(IsNot.is_not_PoolByteArray(value, context))

func is_PoolIntArray(value, context: String = "") -> void:
		output(Is.is_PoolIntArray(value, context))

func is_not_PoolIntArray(value, context: String = "") -> void:
		output(IsNot.is_not_PoolIntArray(value, context))

func is_PoolRealArray(value, context: String = "") -> void:
		output(Is.is_PoolRealArray(value, context))

func is_not_PoolRealArray(value, context: String = "") -> void:
		output(IsNot.is_not_PoolRealArray(value, context))

func is_PoolStringArray(value, context: String = "") -> void:
		output(Is.is_PoolStringArray(value, context))

func is_not_PoolStringArray(value, context: String = "") -> void:
		output(IsNot.is_not_PoolStringArray(value, context))

func is_PoolVector2Array(value, context: String = "") -> void:
		output(Is.is_PoolVector2Array(value, context))

func is_not_PoolVector2Array(value, context: String = "") -> void:
		output(IsNot.is_not_PoolVector2Array(value, context))

func is_PoolVector3Array(value, context: String = "") -> void:
		output(Is.is_PoolVector3Array(value, context))

func is_not_PoolVector3Array(value, context: String = "") -> void:
		output(IsNot.is_not_PoolVector3Array(value, context))

func is_PoolColorArray(value, context: String = "") -> void:
		output(Is.is_PoolColorArray(value, context))

func is_not_PoolColorArray(value, context: String = "") -> void:
		output(IsNot.is_not_PoolColorArray(value, context))
		
func fail(context: String = "Unimplemented Test") -> void:
		output(Utility.fail(context))

func auto_pass(context: String = "") -> void:
		output(Utility.auto_pass(context))
