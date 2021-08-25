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
	
func test_when_calling_is_not_valid_instance() -> void:
	describe("When calling asserts.is_not_valid_instance(freed node)")
	
	var n = Node.new()
	n.free()
	asserts.is_not_valid_instance(n, "Then it passes")
	
func test_when_calling_is_valid_instance() -> void:
	describe("When calling is_instance_valid(node)")
	
	var node = Node.new()
	asserts.is_valid_instance(node, "Then it passes")
	node.free()
