extends WATTest

func start():
	print("running")

func example_method():
	expect.is_true(true, "true is true")