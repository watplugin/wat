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

func test_when_calling_has_meta_after_adding_metadata() -> void:
	describe("When calling asserts.object_has_meta() after adding metadata")
	
	set_meta("dummy", 1)
	asserts.object_has_meta(self, "dummy", "Then it passes")
	remove_meta("dummy")
	
func test_when_calling_does_not_have_meta() -> void:
	describe("When calling asserts.object_does_not_have_meta()")
	
	asserts.object_does_not_have_meta(self, "bad_meta", "Then it passes")
	
func test_when_calling_does_not_have_meta_real_key_null_value_pair() -> void:
	describe("When calling asserts.object_has_meta with real key but null val")
	
	set_meta("confusing", null)
	asserts.object_does_not_have_meta(self, "confusing", "Then it passes")
	
func test_when_calling_has_method_title() -> void:
	describe("When calling has_method('title')")
	
	asserts.object_has_method(self, "title", "Then it passes")
	
func when_calling_does_not_have_method() -> void:
	describe("When calling does_not_have_method('false_method')")
	
	asserts.object_does_not_have_method(self, "false_method", "Then it passes")
	
func test_when_calling_has_user_signal_after_adding_a_signal() -> void:
	describe("When calling obj_has_user_signal after adding a signal")
	
	add_user_signal("dummy_signal")
	asserts.object_has_user_signal(self, "dummy_signal", "Then it passes")
	
func test_when_calling_does_not_have_user_signal() -> void:
	describe("When calling obj_does_not_have_user_signal with fake signal")
	
	asserts.object_does_not_have_user_signal(self, "false_signal", 
												"Then it passes")

signal builtin_dummy
func test_when_calling_does_not_have_user_signal_with_class_signal_constant() -> void:
	describe("When calling does not have user signal with class signal")
	
	asserts.object_does_not_have_user_signal(self, "builtin_dummy", 
	                                          "Then it passes")
