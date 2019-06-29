extends "base.gd"

func _init(emitter, _signal, arguments: Array, context: String) -> void:
	self.success = false
	self.context = "[Expect.SignalWasEmittedWithArguments] %s" % context
	var data = emitter.get_meta("watcher").watching[_signal]
	if data.emit_count <= 0:
		self.success = false
		self.result = "Signal: %s was not emitted at all from %s" % [_signal, emitter]
		return

	elif _found_matching_call(arguments, data.calls):
		self.success = true
		self.result = "Signal: %s was emitted from %s with arguments: %s" % [_signal, emitter, arguments]

	else:
		self.result = "Signal: %s was not emitted from %s with arguments: %s" % [_signal, emitter, arguments]
		self.success = false

func _found_matching_call(args, calls) -> bool:
	for call in calls:
		if _match(args, call.args):
			return true
	return false

func _match(args, call_args) -> bool:
	for i in args.size():
		if args[i] != call_args[i]:
			return false
	return true