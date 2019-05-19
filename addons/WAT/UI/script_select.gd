extends OptionButton
tool

const TEST_DIRECTORY = "res://tests/"

func _init():
	self.connect("pressed", self, "_collect")

func _collect():
	self.clear()
	var tests = tests()
	print(tests.size(), " tests collected")
	for test in tests:
		print(test.resource_path)
		add_item(test.resource_path)
		
func tests() -> Array:
	var tests: Array = []
	var dirs: Array = _get_subdirs()
	dirs.push_front("")
	for d in dirs:
		tests += _testloop(d)
	return tests

func _get_subdirs() -> Array:
	var results: Array = []
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open(TEST_DIRECTORY)
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title: String = dir.get_next()
	while title != "":
		if dir.current_is_dir():
			results.append(title)
		title = dir.get_next()
	return results
	
func _testloop(d):
	var results: Array = []
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open("%s%s" % [TEST_DIRECTORY, d])
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title: String = dir.get_next()
	while title != "":
		if title.ends_with(".gd"):
			results.append(load(TEST_DIRECTORY + d + "/" + title))
		title = dir.get_next()
	return results
	