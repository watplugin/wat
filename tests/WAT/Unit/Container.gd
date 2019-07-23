extends WATTest

func test_when_we_register_a_class_in_the_container_we_can_then_create_an_instance_of_that_class_by_calling_resolve():
	describe("When we register a class in the container, we can then create an instance of that class by calling container.resolve(class_script)")

	var A = load("res://Examples/Scripts/ABC.gd")
	var B = A.B
	var C = A.C

	container.register(A, [B, C])
	container.register(B, [C])
	var instance = container.resolve(A)

	asserts.is_class_instance(instance, A, "instance is instance of A")

	container.unregister(A)
	container.unregister(B)

func test_when_we_have_a_class_that_we_want_to_register_has_primitive_dependecies_we_can_pass_those_dependecies_in_at_register_time():
	describe("When we have a class that we want to register has primitive dependecies, we can pass those dependecies in at register time")

	var A = load("res://Examples/Scripts/ABC.gd")
	var C = A.C

	container.register(C, [10, "Whatever"])
	var instance = container.resolve(C)

	asserts.is_class_instance(instance, C, "instance is instance of C")

func test_we_cannot_resolve_a_class_that_we_have_unregistered_from_the_container():
	describe("We cannot resolve a class that we have unregitered for the container")

	var A = load("res://Examples/Scripts/ABC.gd")
	var B = A.B
	var C = A.C

	container.register(A, [B, C])
	var a = container.resolve(A)
	asserts.is_not_null(a)
	container.unregister(A)

	var instance = container.resolve(A)
	asserts.is_null(instance, "We failed to resolve the class because it was unregistered")


func test_we_can_double_classes_with_nested_dependecies():
	describe("We can double classes with nested dependecies")

	var library = load("res://Examples/Scripts/library.gd")
	var Book = library.Book
	var Author = library.Author

	container.register(library, [])
	container.register(Book, [Author, "Horror", 7])
	container.register(Author, ["Stephen King", 50, "America"])
	var director = double.script(library.resource_path, "Book", [], container)
	var object = director.object()

	asserts.is_class_instance(object, Book, "object is instance of Book")

	container.unregister(Book)
	container.unregister(Author)

func test_we_can_register_scripts():

	var item = load("res://addons/WAT/filesystem.gd")
	var X = load("res://Examples/Scripts/new_script.gd")
	container.register(X, [item])
	var resolve = container.resolve(X)
	asserts.is_equal(resolve.filesystem.resource_path, "res://addons/WAT/filesystem.gd")


