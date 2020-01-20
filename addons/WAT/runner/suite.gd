extends Reference

const IS_WAT_SUITE: bool = true

func subtests() -> Array:
	var tests: Array = []
	for constant in get_script().get_script_constant_map():
		var expression: Expression = Expression.new()
		expression.parse(constant)
		var test = expression.execute([], self)
		tests.append(test)
	return tests
