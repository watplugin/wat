tool
extends Reference

static func directory(path: String):
	pass
	
static func script(path: String):
	pass

class TestDirectory:
	var path: String
	var relative_subdirs: Array
	var nested_subdirs: Array
	
	func _init() -> void:
		pass
		
class TestScript:
	var path: String
	var methods: Array # TestMethods
	
	func _init() -> void:
		pass
		
class TestMethod:
	var path: String
	var method: String
		
class TestTag:
	var tag: String
	var tagged: Array
	
	func _init() -> void:
		pass
