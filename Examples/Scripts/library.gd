extends Reference

class Book extends Reference:
	const CLASS = "BOOK"
	var _author
	var _aut

	func _init(author: Author, genre: String, rating: int, aut: Script):
		self._author = author
		self._aut = aut
		print_debug("aut is script: ", aut is Script)
		print_debug("Author is Author: ", typeof(author))

class Author extends Reference:
	const CLASS = "Author"
	var _title

	func _init(name: String, age: int, location: String):
		self._title = name
