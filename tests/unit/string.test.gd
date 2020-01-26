extends WAT.Test

func title():
	return "Given a String Assertion"
	
func test_when_calling_string_begins_with():
	describe("When calling asserts.string_begins_with('lorem', 'lorem impsum')")

	var prefix: String = "lorem"
	var string: String = "lorem impsum"
	
	asserts.string_begins_with(prefix, string, "Then it passes")

func test_when_calling_string_does_not_begin_with():
	describe("When calling asserts.string_does_not_begin_with('lorem', 'impsum')")
	
	var prefix: String = "lorem"
	var string: String = "impsum"
	
	asserts.string_does_not_begin_with(prefix, string, "Then it passes")

func test_when_calling_string_contains():
	describe("When calling asserts.string_contains('em im', 'lorem impsum')")
	
	var contents: String = "em im"
	var string: String = "lorem impsum"
	
	asserts.string_contains(contents, string, "Then it passes")
	
func test_when_calling_string_does_not_contain():
	describe("When calling asserts.string_does_not_contain('em im', 'impsum')")
	
	var contents: String = "em im"
	var string: String = "impsum"
	
	asserts.string_does_not_contain(contents, string, "Then it passes")
	
func test_when_calling_string_ends_with():
	describe("When calling asserts.string_ends_with('impsum', 'lorem impsum')")
	
	var postfix: String = "impsum"
	var string: String = "lorem impsum"
	
	asserts.string_ends_with(postfix, string, "Then it passes")

func test_when_calling_string_does_not_end_with():
	describe("When calling asserts.string_does_not_end_with('lorem', 'impsum')")

	var postfix: String = "lorem"
	var string: String = "impsum"
	
	asserts.string_does_not_end_with(postfix, string, "Then it passes")
