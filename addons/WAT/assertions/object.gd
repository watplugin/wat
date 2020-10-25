extends "assertion.gd"

static func does_not_have_meta(object: Object, meta: String, context: String) -> AssertionResult:
	var passed: String = "%s does not have meta: %s" % [object, meta]
	var failed: String = "%s has meta: %s" % [object, meta]
	var success = not object.has_meta(meta)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func does_not_have_method(obj: Object, method: String, context: String) -> AssertionResult:
	var passed: String = "%s does not have method: %s" % [obj, method]
	var failed: String = "%s has method: %s" % [obj, method]
	var success = not obj.has_method(method)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func does_not_have_user_signal(obj: Object, _signal: String, context: String) -> AssertionResult:
	var passed: String = "%s does not have user signal: %s" % [obj, _signal]
	var failed: String = "%s has user signal: %s" % [obj, _signal]
	var success = not obj.has_user_signal(_signal)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func o_has_meta(object: Object, meta: String, context: String) -> AssertionResult:
	var passed: String = "%s has meta: %s" % [object, meta]
	var failed: String = "%s does not have meta: %s" % [object, meta]
	var success = object.has_meta(meta)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func o_has_method(obj: Object, method: String, context: String) -> AssertionResult:
	var passed: String = "%s has method: %s" % [obj, method]
	var failed: String = "%s does not have method: %s" % [obj, method]
	var success = obj.has_method(method)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func o_has_user_signal(obj: Object, _signal: String, context: String) -> AssertionResult:
	var passed: String = "%s has user signal: %s" % [obj, _signal]
	var failed: String = "%s does not have user signal: %s" % [obj, _signal]
	var success = obj.has_user_signal(_signal)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func o_is_blocking_signals(obj, context: String) -> AssertionResult:
	var passed: String = "%s is blocking signals" % obj
	var failed: String = "%s is not blocking signals" % obj
	var success = obj.is_blocking_signals()
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func o_is_connected(sender: Object, _signal: String, receiver: Object, method: String, context: String) -> AssertionResult:
	var passed: String = "%s.%s is connected to %s.%s" % [sender, _signal, receiver, method]
	var failed: String = "%s.%s is not connected to %s.%s" % [sender, _signal, receiver, method]
	var success = sender.is_connected(_signal, receiver, method)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func o_is_freed(object: Object, context: String) -> AssertionResult:
	var passed: String = "%s is freed from memory" % object
	var failed: String = "%s is not freed from memory" % object
	var success = not is_instance_valid(object)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func o_is_not_blocking_signals(obj, context: String) -> AssertionResult:
	var passed: String = "%s is not blocking signals" % obj
	var failed: String = "%s is blocking signals" % obj
	var success = not obj.is_blocking_signals()
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func o_is_not_connected(sender: Object, _signal: String, receiver: Object, method: String, context: String) -> AssertionResult:
	var passed: String = "%s.%s is not connected to %s.%s" % [sender, _signal, receiver, method]
	var failed: String = "%s.%s is connected to %s.%s" % [sender, _signal, receiver, method]
	var success = not sender.is_connected(_signal, receiver, method)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func o_is_not_freed(obj: Object, context: String) -> AssertionResult:
	var success = is_instance_valid(obj)
	var passed = "%s is not freed" % obj
	var expected = passed
	var failed = "%s is freed" % obj
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func o_is_not_queued_for_deletion(obj: Object, context: String) -> AssertionResult:
	var passed: String = "%s is not queued for deletion" % obj
	var failed: String = "%s is queued for deletion" % obj
	var expected = passed
	var success = not obj.is_queued_for_deletion()
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func o_is_queued_for_deletion(obj: Object, context: String) -> AssertionResult:
	var passed: String = "%s is queued for deletion" % obj
	var failed: String = "%s is not queued for deletion" % obj
	var expected = passed
	var success = obj.is_queued_for_deletion()
	var result = passed if success else failed
	return _result(success, expected, result, context)

