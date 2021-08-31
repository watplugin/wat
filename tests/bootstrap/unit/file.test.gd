extends WAT.Test

func title() -> String:
	return "Given A File Assertion"
	
func test_when_calling_file_exists_when_file_is_self() -> void:
	describe("When calling asserts.file_exists when the file is this suite")
	
	asserts.file_exists("res://tests/OldTests/unit/file.test.gd", "Then it passes")
	
func test_when_calling_file_does_not_exist_when_there_is_no_file() -> void:
	describe("When calling asserts.file_does_not_exist when there is no file")
	
	asserts.file_does_not_exist("res://somefile.gd", "Then it passes")
	
func test_when_calling_file_does_not_exist_when_path_is_empty() -> void:
	describe("When calling asserts file does not exist when path is empty")
	
	asserts.file_does_not_exist("", "Then it passes")
