extends Reference
class_name WAT

const Test = preload("test.gd")
const TestSuiteOfSuites = preload("suite.gd")
const Yielder = preload("yielder.gd")
const Asserts = preload("res://addons/WAT/expectations/0_index.gd")
const TestCase = preload("case.gd")
const DefaultConfig: Resource = preload("res://addons/WAT/config/default.tres")

class Icon:
	const SUCCESS = preload("res://addons/WAT/icons/success.png")
	const FAILED = preload("res://addons/WAT/icons/failed.png")

static func clear():
	if ProjectSettings.has_setting("WAT/TestDouble"):
		ProjectSettings.get_setting("WAT/TestDouble").queue_free()
