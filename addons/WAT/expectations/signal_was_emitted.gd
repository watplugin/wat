extends "base.gd"


func _init(emitter, _signal: String, expected: String) -> void:
	self.expected = expected
	self.success = emitter.get_meta("watcher").watching[_signal].emit_count > 0
	self.result = "Signal: %s was %s emitted from %s" % [_signal, ("" if self.success else "not"), emitter]