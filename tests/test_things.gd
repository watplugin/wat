extends WATTest

func test_true_stuff():
	expect.is_true(true, "true is true")
	expect.is_true(false, "false is true")