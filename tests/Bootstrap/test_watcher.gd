extends WATTest

const METHOD = preload("res://addons/WAT/constants/expectation_list.gd")

signal A
signal B

func start():
	watch(self, "A")
	watch(self, "B")
	emit_signal("A", 1, 2, 3)

func test_watcher_passes_when_correct_behaviour_is_evaluated():
	expect.is_true(METHOD.SIGNAL_WAS_NOT_EMITTED.new(self, "B", "").success, "signal_was_not_emitted passes when passed: self, signal B")
	expect.is_true(METHOD.SIGNAL_WAS_EMITTED.new(self, "A", "").success, "signal_was_emitted passes when passed: self, signal A")
	expect.is_true(METHOD.SIGNAL_WAS_EMITTED_WITH_ARGUMENTS.new(self, "A", [1, 2, 3], "").success, "signal_was_emitted_with_arguments passes when passed: self, signal A, args [1, 2, 3]")

func test_watcher_fails_when_incorrect_behaviour_is_evaluated():
	expect.is_false(METHOD.SIGNAL_WAS_EMITTED.new(self, 'B', '').success, "signal_was_emitted fails when passed: self, signal B")
	expect.is_false(METHOD.SIGNAL_WAS_NOT_EMITTED.new(self, "A", '').success, "signal_was_not_emitted fails when passed: self, signal A")
	expect.is_false(METHOD.SIGNAL_WAS_EMITTED_WITH_ARGUMENTS.new(self, "A", [9, 8, 10], '').success, "signal_was_emitted_with_arguments_fails when passed: self, signal A, args [9, 8, 10]")
