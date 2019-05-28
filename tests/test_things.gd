extends WATTest


func test_all_should_pass():
	expect.is_true(true, "true is true")
	expect.is_false(false, "false is false")
	expect.is_equal(1, 1, "1 == 1")
	expect.is_equal("Hello World", "Hello World", "'Hello World' == 'Hello World'")
	expect.is_equal(1.0, 1, "1 == 1.0")
	expect.is_not_equal(1, 2, "1 != 2")
	expect.is_not_equal(1.0, 2, "1.0 != 2")
	expect.is_not_equal('Hello', 'World', "'Hello' != 'World'")

func test_all_should_fail():
	expect.is_true(false, "false is true")
	expect.is_false(true, "true is false")
	expect.is_equal(1, 2, "1 == 2")
	expect.is_equal(1.0, 2, "1.0 == 2")
	expect.is_equal("Hello", "World", "'Hello' == 'World'")
	expect.is_not_equal(1.0, 1, "1.0 != 1")
	expect.is_not_equal('Hello World', 'Hello World', "'Hello World' != 'Hello World'")