extends Node
class_name WATT

var expect: Expectations
var testcase: WATCase
var title: String

func _init():
	self.expect = Expectations.new()
	self.testcase = WATCase.new(self._title())
	self.expect.connect("OUTPUT", self.testcase, "_add_expectation")

func run() -> void:
	_start()
	for test in self._test_methods():
		self.testcase.add_method(test)
		self._pre()
		self.call(test)
		self._post()
	self._end()
	self._delete_doubles()

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
	
func _title() -> String:
	return self.get_script().get_path()

func _delete_doubles():
	var BLANK: String = ""
	var WATemp: String = "user://WATemp/"
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open(WATemp)
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var file = dir.get_next()
	while file != BLANK:
		if file.begins_with("Doubled") and file.ends_with(".gd"):
			print(file)
			dir.remove("%s%s" % [WATemp, file])
		file = dir.get_next()
	dir.remove(WATemp)
