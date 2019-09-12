extends WATTest

# Keynote: injector exists to satisfy constructor dependecies. We don't actually intend on
# using the constructor dependecies. However sometimes they may call new but that's probably
# a bad idea and goes against DI (instancing objects outside of other objs that require them
# and then passing them in). We don't have the ability to rewrite constructors entirely though
# so this needs to be part of the style guide/documentation

# Following on from this, we have two type of dependecies, object and primitive. Object dependecies are
# other objects we register for auto-instantiation whereas primitive is anything from int to Script which are
# put in directly. This way if we want just purely a non-instanced object (ie a script) we simply add "Script" to
# the dependecies and voila

func title():
	return "injector"

func test_when_we_register_a_class_in_the_injector_we_can_then_create_an_instance_of_that_class_by_calling_resolve():
	describe("Registers class A with inner classes B & C")

	var A = load("res://Examples/Scripts/ABC.gd")
	var B = A.B
	var C = A.C

	injector.register(A, [B, C])
	injector.register(B, [C])
	var instance = injector.resolve(A)

	asserts.is_class_instance(instance, A, "can Resolve instance of A")

	injector.unregister(A)
	injector.unregister(B)

func test_when_we_have_a_class_that_we_want_to_register_has_primitive_dependecies_we_can_pass_those_dependecies_in_at_register_time():
	describe("Register class A.C with int and string dependecy")

	var A = load("res://Examples/Scripts/ABC.gd")
	var C = A.C

	injector.register(C, [10, "Whatever"])
	var instance = injector.resolve(C)

	asserts.is_class_instance(instance, C, "can Resolve instance of A.C")

func test_we_cannot_resolve_a_class_that_we_have_unregistered_from_the_injector():
	describe("Registers then Unregisters a class")

	var A = load("res://Examples/Scripts/ABC.gd")
	var B = A.B
	var C = A.C

	injector.register(A, [B, C])
	var a = injector.resolve(A)
	injector.unregister(A)

	var instance = injector.resolve(A)
	asserts.is_null(instance, "Cannot resolve instance")


func test_we_can_double_classes_with_nested_dependecies():
	describe("Resolve classes (via Director.double()) with nested dependecies")

	var library = load("res://Examples/Scripts/library.gd")
	var Book = library.Book
	var Author = library.Author

	injector.register(library, [])
	injector.register(Book, [Author, "Horror", 7, Script])
	injector.register(Author, ["Stephen King", 50, "America"])
	var director = direct.script(library.resource_path, "Book", [], injector)
	var object = director.double()

	asserts.is_class_instance(object, Book, "Resolves doubled instance of Book")

	injector.unregister(Book)
	injector.unregister(Author)

func test_we_can_register_scripts():
	describe("Registers a class with a non-instanced script dependecy")
	
	var item = load("res://addons/WAT/filesystem.gd")
	var X = load("res://Examples/Scripts/new_script.gd")
	injector.register(X, [item])
	var resolve = injector.resolve(X)
	asserts.is_equal(resolve.filesystem.resource_path, "res://addons/WAT/filesystem.gd", "does not call .new() on script dependecy")


