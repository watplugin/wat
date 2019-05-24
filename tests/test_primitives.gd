extends WATTest

func test_successes():
	expect.is_true(true, "true is true")
	expect.is_false(false, "false is false")
	expect.is_false(bool(0), "0 is falsey")
	expect.is_false(bool(0.0), "0.0 is falsey")
	expect.is_false(bool(""), "An empty string is falsey")
	
	expect.is_null(null, "null is null")
	expect.is_not_null(10, "10 is not null")
	expect.is_not_null([], "[] is not null")
	
	expect.is_greater_than(10, 5, "10 > 5")
	expect.is_greater_than([1, 2, 3], [1], "[1, 2, 3] > [1]")
	expect.is_greater_than({1: 0, 2: 0, 3: 0}, {1: 0}, "{1:0, 2:0, 3:0} > {1:0}")
	expect.is_greater_than([1, 2, 3], {0: 1}, "[1, 2, 3] > {0: 1}")
	expect.is_greater_than({1: 0, 2: 0, 3: 0}, [1], "{1: 0, 2:0, 3:0} > [1]")

	expect.is_less_than(5, 10, "5 < 10")
	expect.is_less_than([1], [1, 2, 3], "[1] < [1, 2, 3]")
	expect.is_less_than({1:0}, {1: 0, 2: 0, 3: 0}, "{1:0} < {1:0, 2:0, 3:0}")
	expect.is_less_than({0: 1}, [1, 2, 3], "{0: 1} < [1, 2, 3]")
	expect.is_less_than([1], {1: 0, 2: 0, 3: 0}, "[1] < {1: 0, 2: 0, 3: 0}")
	
	expect.is_equal(5, 5, "5 == 5")
	expect.is_equal([], [], "[] == []")
	expect.is_equal([1, 2, 3], [1, 2, 3], "[1, 2, 3] == [1, 2, 3]")
	expect.is_equal(1, 1, "1 == 1")
	expect.is_equal(1.0, 1, "1.0 == 1")
	expect.is_equal("Hello World", "Hello World", '"Hello World" == "Hello World"')
	
	expect.is_not_equal(5, 10, "5 != to 10")
	expect.is_not_equal([], [1, 2, 3], "[] != [1, 2, 3]")
	expect.is_not_equal({}, {}, "{} == {}")
	expect.is_not_equal(1, 2, "1 != 2")
	expect.is_not_equal(1.0, 2, "1.0 != 2")
	expect.is_not_equal("Hello", "Hello World", '"Hello" != "Hello World"')
	
	expect.is_equal_or_greater_than(5, 5, "5 >= 5")
	expect.is_equal_or_greater_than(10, 5, "10 >= 5")
	expect.is_equal_or_greater_than(5.5, 5, "5.5 >= 5")
	expect.is_equal_or_greater_than(5.5, 5.5, "5.5 >= 5.5")
	expect.is_equal_or_greater_than([1, 2, 3], [], "[1, 2, 3] >= []")
	expect.is_equal_or_greater_than([1, 2], [1, 2], "[1, 2] >= [1, 2]")
	expect.is_equal_or_greater_than({0: 0, 1: 0, 2: 0}, {0: 0, 1: 0, 2: 0}, "{0:0, 1:0,2:0} >= {0:0,1:0,2:0}")
	expect.is_equal_or_greater_than({0: 1, 1: 0, 2: 0}, {}, "{0:0,1:0,2:0} >= {}")
	expect.is_equal_or_greater_than([1, 2, 3], {0: 1, 2: 0, 3: 0}, "[1, 2, 3] >= {0:1, 2:0, 3:0}")
	expect.is_equal_or_greater_than([1, 2, 3], {}, "[1, 2, 3] >= {}")
	expect.is_equal_or_greater_than({0:1, 1:0, 2:0}, [1, 2, 3], "{0:1,1:0,2:0} >= [1,2,3]")
	expect.is_equal_or_greater_than({0: 1, 1:0, 2:0}, [], "{0: 1, 1:0, 2:0} >= []")
	expect.is_equal_or_greater_than("Hello World", "Hello", '"Hello World" >= "Hello"')
	expect.is_equal_or_greater_than("Hello World", "Hello World", '"Hello World" >= "Hello World"')
	
	expect.is_equal_or_less_than(5, 5, "5 <= 5")
	expect.is_equal_or_less_than(5, 10, "5 <= 10")
	
	expect.is_in_range(5, 0, 10, "5 is in range 0-10")
	expect.is_not_in_range(0, 5, 10, "0 is not in range 5 - 10")
	
func test_failures():
	pass
	
