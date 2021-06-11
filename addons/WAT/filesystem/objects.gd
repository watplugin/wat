extends Node

# Do these need to be dictionaries for the network? Or is that 4.0?
class TestDirectory extends Reference:
	var path: String
	var tests: Array = []
	
	func _init(_path: String) -> void:
		path = _path
		
	func get_tests() -> Array:
		var scripts: Array = []
		for test in tests:
			scripts += test.get_tests()
		return scripts
		
class TestScript extends Reference:
	var path: String
	var gdscript: GDScript
	var method_names: Array = []
	var methods: Array = []
	var yield_time: float = 0.0
	var tags: Array = []
	
	func _init(_path: String, _gdscript: GDScript) -> void:
		path = _path
		gdscript = _gdscript
		
	func get_tests() -> Array:
		return [{
		gdscript = gdscript,
		methods = method_names,
		path = path,
		name = path,
		yield_time = 0 #yield_time
	}]
		
class TestMethod extends Reference:
	var path: String
	var gdscript: GDScript
	var method_names: PoolStringArray
	
	func _init(_path: String, _gdscript: GDScript, name: String) -> void:
		path = _path
		gdscript = _gdscript
		method_names = [name]
		
	func get_tests() -> Array:
		return [{
		gdscript = gdscript,
		methods = method_names,
		path = path,
		name = path,
		yield_time = 0
	}]
		
class TestTag extends Reference:
	var tag: String
	var tests: Array = []
	
	func _init(_tag: String) -> void:
		tag = _tag
		
	func get_tests() -> Array:
		var scripts: Array = []
		for test in tests:
			scripts += test.get_tests()
		return scripts
		
		
class TestFailures extends Reference:
	var tests: Array = []
	
	func get_tests() -> Array:
		return tests
