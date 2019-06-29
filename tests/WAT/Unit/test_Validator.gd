extends WATTest

const VALIDATOR = preload("res://addons/WAT/Runner/validator.gd")

func test_func_methods_returns_an_array_of_only_method_names_beginning_with_test_when_test_method_prefix_is_test():
	describe("function VALIDATE.methods() returns an array of only method names beginning with test when test method prefix is 'test'")
	# Arrange
	var prefix: String = "test"
	var methods: Array = [{"name": "test_add"}, {"name": "add_child"}, {"name": "queue_free"}, {"name": "test_subtract"}, {"name": "test_multiply"}, {"name": "print"}]

	# Act
	var expected: Array = ["test_add", "test_subtract", "test_multiply"]
	var actual: Array = VALIDATOR.methods(methods, prefix)

	# Assert
	expect.is_equal(expected, actual, "Returns an array of only method names beginning with 'test' when test method prefix is 'test'")

func test_func_tests_returns_an_array_of_only_test_filepaths_beginning_with_test_when_test_prefixes_only_includes_test():
	describe("function VALIDATE.tests() returns an array of only test filepaths beginning with 'test' when test prefixes only includes test (ie ['test'])'")
	# Arrange
	var prefixes: Array = ["test"]
	var tests: Array = [{name = "A", path = "tests/A.gd"}, {name = "test_B", path = "tests/test_B.gd"}, {name = "test_c", path = "tests/test_c.gd"}]

	# Act
	var expected: Array = ["tests/test_B.gd", "tests/test_c.gd"]
	var actual: Array = VALIDATOR.tests(tests, prefixes)

	# Assert
	expect.is_equal(expected, actual, "Returns an array of only test filepaths beginning with 'test' when test prefixes are: ['test']")