extends WAT.Test

### BEGIN NOTE - UNWATCHING ###
# To avoid argument-based conflicts when you emit the same signal with different argument counts
# you should use unwatch(emitter, signal) in your post methods (or after asserts in your test method)
# you may even want to use it inbetween asserts if necessary when testing a signal multiple times
### END NOTE ###

### BEGIN NOTE - BOUNDED VARIABLES ###
# We currently cannot track bound arguments. It is suggested to double the target script instead and
# use spies instead to track those arguments
### END NOTE ###

func title():
	return "Given a Signal Watcher"
	
func start():
	# There is no remove_user_signal method apparently
	add_user_signal("example")
	
func pre():
	watch_all(self)
	
func post():
	unwatch_all(self)

func test_When_we_watch_a_signal_from_an_object_with_no_bound_variables():
	describe("When we watch a signal from an object with no bound variables")

	emit_signal("example", 1, 20, 5)
	asserts.signal_was_emitted_with_arguments(self, "example", [1, 20, 5], \
	"Then it captures any arguments that where passed when the signal was emitted")
	
func test_When_we_watch_and_emit_a_signal():
	describe("When we watch and emit a signal")
	
	emit_signal("example")
	asserts.signal_was_emitted(self, "example", "Then it captures the emitted signal")

func test_When_we_watch_and_do_not_emit_a_signal():
	describe("When we watch and do not emit a signal")
	
	asserts.signal_was_not_emitted(self, "example", "Then it does not capture the non-emitted signal")
	
func test_When_we_watch_a_signal_and_emit_it_multiple_times() -> void:
	describe("When we watch and signal and emit it multiple times")
	
	add_user_signal("multiple")
	watch_all(self)
	emit_signal("multiple")
	emit_signal("multiple")
	
	var emit_count: int = 2
	asserts.signal_was_emitted_x_times(self, "multiple", emit_count, "Then we can track how many times we emitted it")
	
### These tests aren't possible in their current form ###
### We have to update the watcher to allow them properly (if even possible) ###
# When we watch a signal from an object with bound arguments
	# Then we recorded the bound arguments
# When we watch a signal from an object with both bound and unbound arguments
	# Then we recorded all of those arguments
