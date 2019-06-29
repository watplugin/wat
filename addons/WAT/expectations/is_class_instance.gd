extends "base.gd"

func _init(instance, klass: Script, context: String) -> void:
	var passed: String = "%s is instance of class: %s" % [instance, klass]
	var failed: String = "%s is not instance of class: %s" % [instance, klass]
	self.context = "[Expect.IsClassInstance] %s" % context
	self.success = instance is klass
	self.expected = passed
	self.result = passed if self.success else failed