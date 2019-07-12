extends WATTest

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
	container.register(B, [C])
	var instance = container.resolve(A)
	expect.is_class_instance(instance, A, "instance is instance of A")
	container.unregister(A)
	container.unregister(B)

func test_Container_can_resolve_value_dependecies():
	describe("When we register a class that includes base values, we can create an instance by calling resolve(class)")

	container.register(C, [10, "Whatever"])
	var instance = container.resolve(C)
	expect.is_class_instance(instance, C, "instance is instance of C")

#func test_Container_can_unregister_class():
#	describe("When we register a class, we can unregister it as well (if we can resolve, it should return null)")
#
#	container.register(A, [B, C])
#	container.unregister(A)
#	var instance = container.resolve(A) # This will throw an error?
#	expect.is_null(instance, "We didn't receive an instance back")

func test_we_can_double_classes_with_dependecies():
	describe("When we register with the container, we can double classes with dependecies")

	print(get_script())
	container.register(get_script(), [])
	container.register(Book, [Author, "Horror", 7])
	container.register(Author, ["Stephen King", 50, "America"])
	var double = double(get_script().resource_path, "Book")
	var object = double.object()
	var book = container.resolve(Book)
	var author = container.resolve(Author)
	expect.is_class_instance(book, Book, "book is Book")
	expect.is_class_instance(author, Author, "author is Author")
	expect.is_class_instance(object, Book, "object is instance of Book")

class Book:
	const CLASS = "BOOK"

	func _init(author: Author, genre: String, rating: int):
		pass

class Author:
	const CLASS = "Author"

	func _init(name: String, age: int, location: String):
		pass

const _FACTORY = preload("res://factory.gd")
var FACTORY = _FACTORY.new()

func double(path, inner: String = ""):
	return FACTORY.double(path, inner, container)






