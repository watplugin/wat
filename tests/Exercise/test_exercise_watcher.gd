extends WATTest

signal A
signal B

func start():
	watch(self, "A")
	watch(self, "B")

func test_watcher_all_should_pass():
	emit_signal("A", 1, 2, 3)
	expect.signal_was_not_emitted(self, "B", "B was not emitted from self")
	expect.signal_was_emitted(self, "A", "A was emitted from self")
	expect.signal_was_emitted_with_arguments(self, "A", [1, 2, 3], "A was emitted from self with args 1, 2, 3")
	
func test_watcher_all_should_fail():
	expect.signal_was_emitted(self, "B", "B was emitted from self")
	expect.signal_was_not_emitted(self, "A", "A was not emitted from self")
	expect.signal_was_emitted_with_arguments(self, "A", [5, 7, 10], "Signal was emitted from self with args 5, 7, 10")