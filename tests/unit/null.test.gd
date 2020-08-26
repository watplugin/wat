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
	describe("When calling freed object is null")
	
	# Before Godot 3.2.2, deleted objects could point to a different object
	# which means they wouldn't be null but they can be null now
	var node = Node.new()
	node.free()
	
	if Engine.get_version_info().major == 3 and Engine.get_version_info().patch < 2:
		asserts.is_not_null(node, "A Freed Node has a dangling variant in Engine 3.2.1 or less")
	else:
		asserts.is_null(node, "A Freed Node is null in Engine 3.2.2 or greater")
