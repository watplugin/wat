extends WAT.Test

var a; var b; var c; var d; var e; var f;
# warning-ignore:unused_signal 
signal abc # (its used by call_defferred)

func title() -> String:
	return "Given a Yield"

func start():
	yield(until_timeout(0.1), YIELD)
	a = true
	yield(until_timeout(0.1), YIELD)
	b = true

func pre():
	yield(until_timeout(0.1), YIELD)
	c = true
	yield(until_timeout(0.1), YIELD)
	d = true
	yield(until_timeout(0.1), YIELD)

func test_When_we_yield_in_start():
	describe("When we yield in start twice")
	asserts.is_true(a, "Then we set var a to true")
	asserts.is_true(b, "Then we set var b to true")

func test_When_we_yield_in_pre():
	describe("When we yield in pre thrice")
	asserts.is_true(c, "Then we set var c to true")
	asserts.is_true(d, "Then we set var d to true")

func test_When_we_yield_in_execute():
	describe("When we yield twice in execute")
	yield(until_timeout(0.1), YIELD)
	e = true
	yield(until_timeout(0.1), YIELD)
	f = true
	asserts.is_true(e, "Then we set var e to true")
	asserts.is_true(f, "Then we set var f to true")
	

func test_When_we_yield_we_get_the_return_value() -> void:
	describe("When yield(self.yield_value()) returns")
	var args = yield(until_signal(yield_value(), "completed", 2.0), YIELD)
	
	asserts.is_Array(args, "Then we get an array")
	asserts.is_equal(args.size(), 6, "Of size 6")
	asserts.is_equal(args[0], 100, "Where element 0 is 100")

func yield_value() -> int:
	yield(get_tree().create_timer(1), "timeout")
	return 100

func test_Yielder_is_not_active_when_asserting():
	describe("When asserting against a test")
	yield(until_timeout(0.1), YIELD)
	asserts.is_true(not _yielder.is_active(), "Then yielder is not active")

func test_When_a_signal_being_yielded_on_is_emitted_the_yielder_is_stopped():
	describe("When a signal being yielded on is emitted")
	call_deferred("emit_signal", "abc")
	yield(until_signal(self, "abc", 0.3), YIELD)
	asserts.is_true(_yielder.paused, "Then the yielder is paused")

func test_When_yielder_is_finished_signals_are_disconnected():
	describe("When it is finished")

	yield(until_signal(self, "abc", 0.1), YIELD)
	asserts.is_true(not _yielder.is_connected("timeout", _yielder, "_on_resume"), "Then the timeout signal is disconnected")
	asserts.is_true(not is_connected("abc", _yielder, "_on_resume"), "Then the signal-signal is disconnected")

func test_When_we_call_until_timeout() -> void:
	describe("When we call until_timeout (with 1.0)")
	var yielder = WAT.Yielder.new()
	add_child(yielder)
	yielder.until_timeout(1.0)
	asserts.is_true(not yielder.paused, "Then yielder is unpaused")
	asserts.is_true(yielder.is_connected("timeout", yielder, "_on_resume"), "The timeout signal of the yielder is connected")
	remove_child(yielder)
	yielder.free()

func test_When_we_call_until_signal() -> void:
	describe("When we call until signal")
	var yielder = WAT.Yielder.new()
	add_child(yielder)
	yielder.until_signal(1.0, self, "abc")
	asserts.is_true(not yielder.paused, "Then the yielder is unpaused")
	asserts.is_true(yielder.is_connected("timeout", yielder, "_on_resume"), "Then the timeout signal of the yielder is connected")
	asserts.is_true(is_connected("abc", yielder, "_on_resume"), "Then our signal is connected to the yielder")
	remove_child(yielder)
	yielder.free()

func test_When_the_yielder_times_out() -> void:
	describe("When the yielder times out on until_timeout(0.1)")
	yield(until_timeout(0.1), YIELD)
	asserts.is_true(_yielder.paused, "Then the yielder is paused")
	asserts.is_true(not _yielder.is_connected("timeout", _yielder, "_on_resume"), "The timeout signal of the yielder is not connected")

func test_When_the_yielder_hears_our_signal() -> void:
	describe("When the yielder heres our signal")

	call_deferred("emit_signal", "abc")
	yield(until_signal(self, "abc", 0.1), YIELD)
	asserts.is_true(_yielder.paused, "Then the yielder is paused")
	asserts.is_true(not _yielder.is_connected("timeout", _yielder, "_on_resume"), "Then the timeout signal of the yielder is disconnected")
	asserts.is_true(not is_connected("abc", _yielder, "_on_resume"), "Then our signal to the yielder is disconnected")
