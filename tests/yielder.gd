extends WATTest

signal a
signal b

func test_waiting():
	# We don't really care about the results of the inbetween tests here
	# Our only goal is to make sure they're reached past the yields
	watch(self, "b")
	expect.is_true(true, "true is true")
	print("Beginning Signal Yield for A")
	yield(until_signal(self, "a", 1), YIELD)
	print("Resuming Signal Yield from A")
	expect.is_false(false, "false is false")
	expect.signal_was_not_emitted(self, "a", "signal a was not emitted")
	print("Beginning Timout of 1 Second Yield")
	yield(until_timeout(1), YIELD)
	print("Resuming from Timeout of 1 Second Yield")
	expect.is_equal(1, 1, "1 == 1")
	expect.signal_was_not_emitted(self, "b", "b was not emitted")
