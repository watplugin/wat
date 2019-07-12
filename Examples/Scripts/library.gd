extends Reference

class Book extends Reference:
	const CLASS = "BOOK"

	func _init(author: Author, genre: String, rating: int):
		pass

class Author extends Reference:
	const CLASS = "Author"

	func _init(name: String, age: int, location: String):
		pass
