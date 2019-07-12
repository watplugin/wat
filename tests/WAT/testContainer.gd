extends WATTest

var container = preload("res://container.gd").new()


class A:

	func _init(b: B, c: C):
		pass

class B:

	func _init(c: C):
		pass

class C:

	func _init(a: int, b: String):
		pass

func test_Container_class_resolves_when_registered():
	describe("When we register a class in the container, we can create an instance by calling resolve(class)")

	container.register(A, [B, C])
	var instance = container.resolve(A)
	expect.is_class_instance(instance, A, "instance is instance of A")
	container.unregister(A)

func test_Container_can_resolve_value_dependecies():
	describe("When we register a class that includes base values, we can create an instance by calling resolve(class)")

	container.register(C, [10, "Whatever"])
	var instance = container.resolve(C)
	expect.is_class_instance(instance, C, "instance is instance of C")

func test_Container_can_unregister_class():
	describe("When we register a class, we can unregister it as well (if we can resolve, it should return null)")

	container.register(A, [B, C])
	container.unregister(A)
	var instance = container.resolve(A)
	expect.is_null(instance, "We didn't receive an instance back")
