extends "base.gd"

func _init(path: String, expected: String) -> void:
	self.expected = expected
	self.success = File.new().file_exists(path)
	self.result = "%s exists" % path if self.success else "%s does not exist" % path