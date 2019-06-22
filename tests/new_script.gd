extends WATTest

func start():
	print("running")
	expect.is_true(false, "This should crash", CRASH_IF_TEST_FAILS)

func example_method():
	expect.is_true(true, "true is true")