extends WAT.Test

func title() -> String:
	return "Given A Folder Assertion"
	
func test_when_calling_folder_exists_when_folder_is_self() -> void:
	describe("When calling asserts.folder_exists when the folder is this suite")
	
	asserts.folder_exists(get_script().resource_path.get_base_dir(), "Then it passes")
	
func test_when_calling_folder_does_not_exist_when_there_is_no_folder() -> void:
	describe("When calling asserts.folder_does_not_exist when there is no folder")
	
	asserts.folder_does_not_exist("res://somefolder", "Then it passes")
	
func test_when_calling_folder_does_not_exist_when_path_is_empty() -> void:
	describe("When calling asserts folder does not exist when path is empty")
	
	asserts.folder_does_not_exist("", "Then it passes")
