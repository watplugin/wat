extends WATTest

### BEGIN NOTES ###
# All of these tests are standalone expressions so some of what they're doing doesn't look
# immediatly obvious. In this case, when writing a failing test, we write the message as "x equals x"
# whereas the expectation is written as x against y. What we're essentially doing here is pretending
# that Y is a wrong "return value". 
### END NOTES ###

signal hello

func test_hash_comparison():
	var N = Node.new()
	var C = Node.new()
	expect.hashes_are_equal(N, N, "hash of N is equal to hash of the same N (should pass)")
	expect.hashes_are_equal(N, C, "hash of N is equal to hash of C (should fail)")

func test_yielder_works():
	expect.is_true(true, "true is true. Yield not called")
	yield(to(self, "hello", 10.0), YIELD)
	yield(to(self, "hello", 10.0), YIELD)
	expect.is_true(true, "true is true. Yield was called")
#	get_parent().resume() # Resuming the test runner (since we called multiple yields this method)

func test_expect_is_true_all_of_these_should_pass():
	expect.is_true((true), "true is true")
	expect.is_true((true != false), "true is not false")
	expect.is_true((true != null), "true is not null")
	expect.is_true((1 is int), "1 is an Integer")
	expect.is_true((1.0 is float), "1.0 is a float")
	expect.is_true(("String" is String), '"String" is a String')
	expect.is_true(([] is Array), "[] is an Array")
	expect.is_true(({} is Dictionary), "{} is a Dictionary")
	expect.is_true((Vector2(0, 0) is Vector2), "Vector2(0, 0) is Vector2")
	expect.is_true((Vector3(0, 0, 0) is Vector3), "Vector3(0, 0, 0) is Vector3")
#
func test_expect_is_true_all_of_these_should_fail():
	var bad: Dictionary = {"integer": 1.0, "floating": 1, "string": 1, "vec2": [], "vec3": [], "array": {}, "dict": []}
	expect.is_true((false), "true is true")
	expect.is_true((true == false), "true is not false")
	expect.is_true((true == null), "true is not null")
	expect.is_true((bad.integer is int), "1 is int")
	expect.is_true((bad.floating is float), "1.0 is float")
	expect.is_true((bad.string is String), '"1" is String')
	expect.is_true((bad.vec2 is Vector2), "Vector2(0, 0) is Vector2")
	expect.is_true((bad.vec3 is Vector3), "Vector3(0, 0, 0) is Vector3")
	expect.is_true((bad.array is Array), "[] is Array")
	expect.is_true((bad.dict is Dictionary), "{} is Dictionary")
#
func test_expect_is_equal_all_of_these_should_pass():
	# Add Exceptions for this comparisons due to unusual nature
	# expect.is_equal({}, {}, "{} equals {}") # Is inequal // Add a Warning about Dictionary Exceptions
	# expect.is_equal(false, null, "false equals null") # Is inequal
	expect.is_equal(true, true, "true equals true")
	expect.is_equal(false, false, "false equals false")
	expect.is_equal(1, 1, "1 equals 1")
	expect.is_equal(1.0, 1.0, "1.0 equals 1.0")
	expect.is_equal("String", "String", '"String" equals "String"')
	expect.is_equal([], [], "[] equals []")
	expect.is_equal(Vector2(0, 0), Vector2(0, 0), "Vector2(0, 0) equals Vector2(0, 0)")
	expect.is_equal(Vector3(0, 0, 0), Vector3(0, 0, 0), "Vector3(0, 0, 0) equals Vector3(0, 0, 0)")

func test_expect_is_equal_all_of_these_should_fail():
	# Add Notes for these comparisons due to implicit conversion
	# expect.is_equal(1, 1.0, "1 equals 1")
	#	expect.is_equal(1.0, 1, "1.0 equals 1.0")
	expect.is_equal(true, false, "true equals true")
	expect.is_equal(false, true, "false equals false")
	expect.is_equal("String", "Words", '"String" equals "String"')
	expect.is_equal([], [1, 2, 3], "[] equals []")
	expect.is_equal(Vector2(0, 0), Vector2(10, 10), "Vector2(0, 0) equals Vector2(0, 0)")
	expect.is_equal(Vector3(0, 0, 0), Vector3(10, 10, 10), "Vector3(0, 0, 0) equals Vector3(0, 0, 0)")

func test_expect_is_not_equal_all_of_these_should_pass():
	expect.is_not_equal(true, false, "true != false")
	expect.is_not_equal(false, true, "false != true")
	expect.is_not_equal("String", "Words", '"String != "String"')
	expect.is_not_equal([], [1, 2, 3], "[] != [1, 2, 3]")
	expect.is_not_equal(Vector2(0, 0), Vector2(10, 10), "Vector2(0, 0) != Vector2(0, 0)")
	expect.is_not_equal(Vector3(0, 0, 0), Vector3(10, 10, 10), "Vector3(0, 0, 0) != Vector3(0, 0)")

func test_expect_is_not_equal_all_of_these_should_fail():
	expect.is_not_equal(true, true, "true != false")
	expect.is_not_equal(false, false, "false != true")
	expect.is_not_equal("String", "String", '"String != "String"')
	expect.is_not_equal([], [], "[] != [1, 2, 3]")
	expect.is_not_equal(Vector2(0, 0), Vector2(0, 0), "Vector2(0, 0) != Vector2(0, 0)")
	expect.is_not_equal(Vector3(0, 0, 0), Vector3(0, 0, 0), "Vector3(0, 0, 0) != Vector3(0, 0)")

func test_expect_is_greater_than_all_of_these_should_pass():
	expect.is_greater_than(1, 0, "1 > 0")
	expect.is_greater_than("Massive", "Small", '"Massive" > "Small"')
	expect.is_greater_than(Vector2(10, 10), Vector2(0, 0), "Vector2(10, 10) > Vector2(0, 0)")
	expect.is_greater_than(Vector3(10, 10, 10), Vector3(0, 0, 0), "Vector3(10, 10, 10) > Vector3(0, 0, 0)")
	expect.is_greater_than(1.0, 0.5, "1.0 > 0.5")
	expect.is_greater_than([1, 2, 3], [], "[1, 2, 3] > []")
	expect.is_greater_than({0: 10, 1: 20}, {0: 0}, "{0: 10, 1: 20, {0: 0}")
	expect.is_greater_than([1, 2, 3], {0: 0}, "[1, 2, 3] > {0:0}") # Add a note?

func test_expect_is_greater_than_all_of_these_should_fail():
	expect.is_greater_than(0, 1, "0 > -1")
	expect.is_greater_than("Massive", "SuperMassive", '"Massive" > "Small"')
	expect.is_greater_than(Vector2(0, 0), Vector2(10, 10), "Vector2(10, 10) > Vector2(100, 100)")
	expect.is_greater_than(Vector3(0, 0, 0), Vector3(10, 10, 10), "Vector3(10, 10, 10) > Vector3(100, 100, 100)")
	expect.is_greater_than(-1.0, 0.0, "1.0 > 0.0")
	expect.is_greater_than([], [1, 2], "[1, 2, 3] > [1, 2]")
	expect.is_greater_than({}, {0: 0}, "{0: 0} > {}")
	expect.is_greater_than([0], {0: 0, 1:1}, "[0, 1, 2] > {0:0, 1:1}")

func test_expect_is_less_than_all_of_these_should_pass():
	expect.is_less_than(0, 1, "0 < 1")
	expect.is_less_than("Small", "Massive", '"Massive" < "Small"')
	expect.is_less_than(Vector2(0, 0), Vector2(10, 10), "Vector2(0, 0) < Vector2(10, 10)")
	expect.is_less_than(Vector3(0, 0, 0), Vector3(10, 10, 10), "Vector3(0, 0, 0), Vector3(10, 10, 10)")
	expect.is_less_than(0.5, 1.0, "0.5 < 1.0")
	expect.is_less_than([], [1, 2, 3], "[] < [1, 2, 3]")
	expect.is_less_than({0: 0}, {0:0, 1: 1}, "{0: 0} < {0: 0, 1: 1}")
	expect.is_less_than([], {0: 1}, "[] < {0: 1}")

func test_expect_is_less_than_all_of_these_should_fail():
	expect.is_less_than(0, -1, "0 < 1")
	expect.is_less_than("Massive", "Massive", '"Small" < "Massive"')
	expect.is_less_than(Vector2(0, 0), Vector2(-5, -5), "Vector2(0, 0) < Vector2(5, 5)")
	expect.is_less_than(Vector3(0, 0, 0), Vector3(-2, -2, -2), "Vector3(0, 0, 0) < Vector3(2, 2, 2)")
	expect.is_less_than(0.5, -2.0, "0.5 < 2")
	expect.is_less_than([1, 2, 3], [0, 1], "[] < [0, 1]")
	expect.is_less_than({0:0, 1:1}, {}, "{0:0, 0:1} < {0: 0}")
	expect.is_less_than([1, 2], {}, "[1, 2] < {0: 0, 1:1, 2:2}")