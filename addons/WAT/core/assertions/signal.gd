extends "assertion.gd"

static func was_emitted(emitter, event: String, context: String) -> AssertionResult:
	var passed: String = "signal: %s was emitted from %s" % [event, emitter]
	var failed: String = "signal: %s was not emitted from %s" % [event, emitter]
	var success = emitter.get_meta("watcher").watching[event].emit_count > 0
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func was_not_emitted(emitter, _signal: String, context: String) -> AssertionResult:
	var success = emitter.get_meta("watcher").watching[_signal].emit_count <= 0
	var passed = "Signal: %s was not emitted from %s" % [_signal, emitter]
	var failed = "Signal: %s was emitted from %s" % [_signal, emitter]
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func was_emitted_x_times(emitter, event: String, times: int, context: String) -> AssertionResult:
	var passed: String = "signal: %s was emitted from %s %s" % [event, emitter, times as String]
	var failed: String = "signal: %s was not emitted from %s %s" % [event, emitter, times as String]
	var success = emitter.get_meta("watcher").watching[event].emit_count == times
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func was_emitted_with_args(emitter: Object, event: String, arguments: Array, context: String) -> AssertionResult:
	var passed: String = "Signal: %s was emitted from %s with arguments: %s" % [event, emitter, arguments]
	var failed: String = "Signal: %s was not emitted from %s with arguments: %s" % [event, emitter, arguments]
	var alt_failure: String = "Signal: %s was not emitted from %s" % [event, emitter]
	var expected = passed

	var success: bool
	var result: String
	var data = emitter.get_meta("watcher").watching[event]
	if data.emit_count <= 0:
		success = false
		result = alt_failure

	elif _found_matching_call(arguments, data.calls):
		success = true
		result = passed

	else:
		success = false
		result = failed
		
	return _result(success, expected, result, context)

static func _found_matching_call(args, calls) -> bool:
	for call in calls:
		if _match(args, call.args):
			return true
	return false

static func _match(args, call_args) -> bool:
	for i in args.size():
		if args[i] != call_args[i]:
			return false
	return true
