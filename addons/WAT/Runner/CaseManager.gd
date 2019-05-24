extends Node
tool

var list: Array = []
var current: Case

func create(test) -> void:
	var case = Case.new(test)
	self.current = case
	list.append(case)
	# No Need to return since case is handled here

class Case extends Reference:
	var title: String
	var methods: Array = []
	
	func _init(test) -> void:
		self.title = test.title()
		test.expect.connect("OUTPUT", self, "_add_expectation")
		
	
	func add_method(method: String) -> void:
		methods.append(Method.new(method))
	
	func _add_expectation(success: bool, expected: String, result: String, notes: String) -> void:
		methods.back().expectations.append(Expectation.new(success, expected, result, notes))
		
	func total() -> int:
		return methods.size()
		
	func successes() -> int:
		var success: int = 0
		for method in methods:
			if method.success():
				success += 1
		return success
		
	func success() -> bool:
		if total() <= 0:
			return false
		return successes() == total()
			

class Method extends Reference:
	var title: String
	var expectations: Array = []
	
	func _init(title) -> void:
		self.title = title.substr(title.find("_"), title.length()).replace("_", " ").dedent()
	
	func total() -> int:
		return expectations.size()
		
	func successes() -> int:
		var success: int = 0
		for expectation in expectations:
			if expectation.success:
				success += 1
		return success
		
	func success() -> bool:
		if total() <= 0:
			return false
		return successes() == total()
	
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