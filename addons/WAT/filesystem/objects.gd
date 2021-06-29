extends Node

# Do these need to be dictionaries for the network? Or is that 4.0?
class TestDirectory extends Reference:
	var path: String
	var tests: Array = []
	var name: String
	
	func _init(_path: String) -> void:
		path = _path
		name = _path
		
	func get_tests() -> Array:
		var scripts: Array = []
		for test in tests:
			scripts += test.get_tests()
		return scripts
		
class TestScript extends Reference:
	var directory: String
	var path: String
	var method_names: Array = []
	var methods: Array = []
	var yield_time: float = 0.0
	var tags: Array = []
	var name: String
	
	func _init(dir: String, _path: String) -> void:
		path = _path
		directory = dir
		name = _path
		
	func get_tests() -> Array:
		return [{
		methods = method_names,
		path = path,
		name = path,
		yield_time = 0, # Yield Time is set by the runner
		directory = directory
	}]
		
class TestMethod extends Reference:
	var dir: String = ""
	var path: String
	var method_names: PoolStringArray
	var name: String
	
	func _init(_dir: String, _path: String, _name: String) -> void:
		path = _path
		method_names = [_name]
		name = _name
		dir = _dir
		
	func get_tests() -> Array:
		return [{
		methods = method_names,
		path = path,
		name = path,
		yield_time = 0,
		directory = dir
	}]
		
class TestTag extends Reference:
	var tag: String
	var tests: Array = []
	var name
	
	func _init(_tag: String) -> void:
		tag = _tag
		name = tag
		
	func get_tests() -> Array:
		var scripts: Array = []
		for test in tests:
			scripts += test.get_tests()
		return scripts
		
		
class TestFailures extends Reference:
	var tests: Array = []
	
	func get_tests() -> Array:
		return tests
