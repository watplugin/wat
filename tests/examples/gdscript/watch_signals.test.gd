extends WAT.Test

# Developers can call watch(emitter, signal) to check if a signal was..
# ..emitted, not emitter, emitted so many times or was emitted with a..
# ..a particular set of arguments.

signal my_signal
func test_signal_was_emitted() -> void:
	watch(self, "my_signal")
	emit_signal("my_signal")
	asserts.signal_was_emitted(self, "my_signal")
	unwatch(self, "my_signal")
	
func test_signal_was_not_emitted() -> void:
	watch(self, "my_signal")
	asserts.signal_was_not_emitted(self, "my_signal")
	unwatch(self, "my_signal")
	
func test_signal_was_emitted_x_times() -> void:
	watch(self, "my_signal")
	emit_signal("my_signal")
	emit_signal("my_signal")
	asserts.signal_was_emitted_x_times(self, "my_signal", 2)
	unwatch(self, "my_signal")
	
func test_signal_was_emitted_with_arguments() -> void:
	watch(self, "my_signal")
	emit_signal("my_signal", "Hello", "World")
	asserts.signal_was_emitted_with_arguments(self, "my_signal", 
		["Hello", "World"])
	unwatch(self, "my_signal")
