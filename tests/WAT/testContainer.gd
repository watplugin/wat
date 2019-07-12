extends WATTest



func test_Container_class_resolves_when_registered():
	describe("When we register a class in the container, we can create an instance by calling resolve(class)")
	var A = load("res://Examples/Scripts/ABC.gd")
	var B = A.B
	var C = A.C
	container.register(A, [B, C])
	container.register(B, [C])
	var instance = container.resolve(A)
	expect.is_class_instance(instance, A, "instance is instance of A")
	container.unregister(A)
	container.unregister(B)

func test_Container_can_resolve_value_dependecies():
	describe("When we register a class that includes base values, we can create an instance by calling resolve(class)")

	var A = load("res://Examples/Scripts/ABC.gd")
	var C = A.C
	container.register(C, [10, "Whatever"])
	var instance = container.resolve(C)
	expect.is_class_instance(instance, C, "instance is instance of C")

func test_Container_can_unregister_class():
	describe("When we register a class, we can unregister it as well (if we can resolve, it should return null)")

	var A = load("res://Examples/Scripts/ABC.gd")
	var B = A.B
	var C = A.C
	container.register(A, [B, C])
	container.unregister(A)
	# This returns null if not found, handle error somewhere else?
	var instance = container.resolve(A)
	expect.is_null(instance, "We didn't receive an instance back")

func test_we_can_double_classes_with_dependecies():
	describe("When we register with the container, we can double classes with dependecies")

	var library = load("res://Examples/Scripts/library.gd")
	var Book = library.Book
	var Author = library.Author
	container.register(library, [])
	container.register(Book, [Author, "Horror", 7])
	container.register(Author, ["Stephen King", 50, "America"])
	var double = double(library.resource_path, "Book", [], true)
	var object = double.object()
	var author_object = double(library.resource_path, "Author", [], true).object()
	var book = container.resolve(Book)
	var author = container.resolve(Author)
	expect.is_class_instance(book, Book, "book is Book")
	expect.is_class_instance(author, Author, "author is Author")
	expect.is_class_instance(object, Book, "object is instance of Book")
	expect.is_class_instance(author_object, Author, "author double is instance of Author")
	container.unregister(Book)
	container.unregister(Author)





