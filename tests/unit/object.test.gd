extends WAT.Test

func title() -> String:
	return "Given an Object Assertion"
	
func test_when_calling_freed_object_is_freed() -> void:
	describe("When calling asserts.is_freed(freed_object")
	
	var node = Node.new()
	node.free()
	asserts.is_freed(node, "Then it passes")
	
func test_when_calling_unfreed_object_is_not_freed() -> void:
	describe("When calling asserts.is_not_freed(unfreed_object)")
	
	var node = Node.new()
	asserts.is_not_freed(node, "Then it passes")
	node.free()
