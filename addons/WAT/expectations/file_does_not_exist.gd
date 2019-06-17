extends "base.gd"

func _init(path: String, expected: String) -> void:
	self.expected = expected
	self.success = not File.new().file_exists(path)
	self.result = "%s does not exist" % path if self.success else "%s exists" % path