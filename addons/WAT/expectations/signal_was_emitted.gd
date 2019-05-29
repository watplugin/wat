extends "base.gd"


func _init(watcher, _signal: String, expected: String) -> void:
	self.expected = expected
	self.success = watcher.watching[_signal].emit_count > 0
	self.result = "Signal: %s was %s emitted" % [_signal, ("" if self.success else "not")]