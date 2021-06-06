extends "assertion.gd"

static func is_not_AABB(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: AABB" % value
	var failed: String = "%s is builtin: AABB" % value
	var success = not value is AABB
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Array(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Array" % value
	var failed: String = "%s is builtin: Array" % value
	var success = not value is Array
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Basis(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Basis" % value
	var failed: String = "%s is builtin: Basis" % value
	var success = not value is Basis
	var expected = passed
	var result = passed if success else failed

	return _result(success, passed, result, context)

static func is_not_bool(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: bool" % value
	var failed: String = "%s is builtin: bool" % value
	var success = not value is bool
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_class_instance(instance, klass: Script, context: String) -> Dictionary:
	var passed: String = "%s is not instance of class: %s" % [instance, klass]
	var failed: String = "%s is instance of class: %s" % [instance, klass]
	var success = not instance is klass
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Color(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Color" % value
	var failed: String = "%s is builtin: Color" % value
	var success = not value is Color
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Dictionary(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Dictionary" % value
	var failed: String = "%s is builtin: Dictionary" % value
	var success = not value is Dictionary
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_float(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: float" % value
	var failed: String = "%s is builtin: float" % value
	var success = not value is float
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_int(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: int" % value
	var failed: String = "%s is builtin: int" % value
	var success = not value is int
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_NodePath(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: NodePath" % value
	var failed: String = "%s is builtin: NodePath" % value
	var success = not value is NodePath
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Object(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Object" % value
	var failed: String = "%s is builtin: Object" % value
	var success = not value is Object
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Plane(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Plane" % value
	var failed: String = "%s is builtin: Plane" % value
	var success = not value is Plane
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_PoolByteArray(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: PoolByteArray" % value
	var failed: String = "%s is builtin: PoolByteArray" % value
	var success = not value is PoolByteArray
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_PoolColorArray(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: PoolColorArray" % value
	var failed: String = "%s is builtin: PoolColorArray" % value
	var success = not value is PoolColorArray
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_PoolIntArray(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: PoolIntArray" % value
	var failed: String = "%s is builtin: PoolIntArray" % value
	var success = not value is PoolIntArray
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_PoolRealArray(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: PoolRealArray" % value
	var failed: String = "%s is builtin: PoolRealArray" % value
	var success = not value is PoolRealArray
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_PoolStringArray(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: PoolStringArray" % value
	var failed: String = "%s is builtin: PoolStringArray" % value
	var success = not value is PoolStringArray
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_PoolVector2Array(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: PoolVector2Array" % value
	var failed: String = "%s is builtin: PoolVector2Array" % value
	var success = not value is PoolVector2Array
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_PoolVector3Array(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: PoolVector3Array" % value
	var failed: String = "%s is builtin: PoolVector3Array" % value
	var success = not value is PoolVector3Array
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Quat(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Quat" % value
	var failed: String = "%s is builtin: Quat" % value
	var success = not value is Quat
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Rect2(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Rect2" % value
	var failed: String = "%s is builtin: Rect2" % value
	var success = not value is Rect2
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_RID(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: RID" % value
	var failed: String = "%s is builtin: RID" % value
	var success = not value is RID
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_String(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: String" % value
	var failed: String = "%s is builtin: String" % value
	var success = not value is String
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Transform(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Transform" % value
	var failed: String = "%s is builtin: Transform" % value
	var success = not value is Transform
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Transform2D(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Transform2D" % value
	var failed: String = "%s is builtin: Transform2D" % value
	var success = not value is Transform2D
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Vector2(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Vector2" % value
	var failed: String = "%s is builtin: Vector2" % value
	var success = not value is Vector2
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)

static func is_not_Vector3(value, context: String) -> Dictionary:
	var passed: String = "%s is not builtin: Vector3" % value
	var failed: String = "%s is builtin: Vector3" % value
	var success = not value is Vector3
	var expected = passed
	var result = passed if success else failed
	return _result(success, passed, result, context)
