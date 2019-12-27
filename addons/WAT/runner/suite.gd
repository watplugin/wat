extends Reference

const IS_WAT_SUITE: bool = true

func subtests() -> Array:
	var tests: Array = []
	var source = get_script().source_code
	for l in source.split("\n"):
		if l.begins_with("class"):
			var classname = l.split(" ")[1]
			var expr = Expression.new()
			expr.parse(classname)
			var t = expr.execute([], self)
			tests.append(t)
	return tests