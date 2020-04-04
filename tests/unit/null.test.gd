extends WAT.Test

func title() -> String:
	return "Given a Null Assertion"
	
func test_when_calling_null_is_null() -> void:
	describe("When calling asserts.is_null(null)")
	
	asserts.is_null(null, "Then it passes")
	
func test_when_calling_node_is_not_null() -> void:
	describe("When calling Node is not null")
	
	var node = Node.new()
	asserts.is_not_null(node, "Then it passes")
	node.free()
	
func test_when_calling_freed_object_is_not_null() -> void:
	describe("When calling freed object is not null")
	
	var node = Node.new()
	node.free()
	asserts.is_not_null(node, "Then it passes")
