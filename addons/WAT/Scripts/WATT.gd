extends Node
class_name WATT

var expect: Expectations
var testcase: WATCase

func _init(title: String):
	# We pass the title in from the Runner
	self.expect = Expectations.new()
	self.testcase = WATCase.new(title)
	self.expect.connect("OUTPUT", self.testcase, "_add_expectation")

func run() -> void:
	_start()
	for test in self._test_methods():
		self.testcase.add_method(test)
		self._pre()
		self.call(test)
		self._post()
	self._end()
	

func _start():
	pass

func _pre():
	pass
	
func _post():
	pass
	
func _end():
	pass
	
func _test_methods() -> Array:
	var results: Array = []
	for method in self.get_method_list():
		if method.name.begins_with("test_"):
			results.append(method.name)
	return results