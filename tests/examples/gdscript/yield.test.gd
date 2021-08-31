extends WAT.Test

# Developers may also use the code below in any of the start/pre/post/end..
# ..methods if necessary.

func test_yield_until_timeout() -> void:
	# Developers can yield for a time limit by calling yield with the..
	# ..until_timeout function that takes the time limit and waits for the..
	# ..returned yielder object to emit the built-in YIELD signal.
	yield(until_timeout(0.2), YIELD)
	asserts.auto_pass("Yielding On Timeout")
	
signal my_signal
func test_yield_until_signal() -> void:
	call_deferred("emit_signal", "my_signal")
	
	# Developers can yield on a custom signal by passing in the..
	# ..emitter object, the string signal of the emitter object and..
	# ..a float time limit and waits for the returned yielder object to..
	# ..emit the built-in YIELD Signal (which will be emitted either when..
	# ..the emitter emits the signal or the time limit has run out).
	yield(until_signal(self, "my_signal", 0.2), YIELD)
	asserts.auto_pass("Yielding on Signal")
