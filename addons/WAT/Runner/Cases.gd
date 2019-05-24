extends Reference
tool

var list: Array = []
var current: Case

func create(test) -> void:
	var case = Case.new(test)
	self.current = case
	list.append(case)
	# No Need to return since case is handled here
	
func method_details_to_string() -> Array:
	var list = []
	var method = current.methods.back()
	for expect in method.expectations:
		list.append("%s:  %s" % ["PASSED" if expect.success else "FAILED", expect.expected.lstrip("Expect:").dedent()])
	list.append("%s:  %s" % ["PASSED" if method.success() else "FAILED", method.title])
	return list
	
func script_details_to_string() -> String:
	return "%s:  %s" % ["PASSED" if current.success() else "FAILED", current.title]

class Case extends Reference:
	var title: String
	var methods: Array = []
	var _totals: int = 0

	func _init(test) -> void:
		self.title = test.title()
		test.expect.connect("OUTPUT", self, "_add_expectation")

	func add_method(method: String) -> void:
		methods.append(Method.new(method))
		_totals += 1

	func _add_expectation(success: bool, expected: String, result: String, notes: String) -> void:
		methods.back().expectations.append(Expectation.new(success, expected, result, notes))
		methods.back()._totals += 1 if success else 0

	func total() -> int:
		return _totals

	func successes() -> int:
		var success: int = 0
		for method in methods:
			if method.success():
				success += 1
		return success

	func success() -> bool:
		return true if _totals > 0 and _totals == successes() else false

class Method extends Reference:
	var title: String
	var expectations: Array = []
	var _totals: int = 0
	var _successes: int = 0

	func _init(title) -> void:
		self.title = title.substr(title.find("_"), title.length()).replace("_", " ").dedent()

	func total() -> int:
		return _totals

	func successes() -> int:
		return _successes

	func success() -> bool:
		return true if _totals > 0 and _totals == _successes else false

class Expectation extends Reference:
	var success: bool
	var expected: String
	var result: String
	var notes: String

	func _init(success, expected, result, notes):
		self.success = success
		self.expected = expected
		self.result = result
		self.notes = notes