extends Reference
class_name WAT

const TestDoubleFactory = preload("res://addons/WAT/core/double/factory.gd")
const BaseTest = preload("res://addons/WAT/test/base_test.gd")
const Test: Script = preload("res://addons/WAT/test/test.gd")
#const TestLoader = preload("res://addons/WAT/test_runner/test_loader.gd")
const Results: Resource = preload("res://addons/WAT/resources/results.tres")
const TestSuiteOfSuites = preload("res://addons/WAT/test/suite.gd")
const SignalWatcher = preload("res://addons/WAT/test/watcher.gd")
const Parameters = preload("res://addons/WAT/test/parameters.gd")
const Yielder = preload("res://addons/WAT/test/yielder.gd")
const Asserts = preload("res://addons/WAT/assertions/assertions.gd")
const TestCase = preload("res://addons/WAT/test/case.gd")
const Settings = preload("res://addons/WAT/system/settings.gd")

class Icon:
	const SUCCESS = preload("res://addons/WAT/icons/success.png")
	const FAILED = preload("res://addons/WAT/icons/failed.png")
	const SUPPORT = preload("res://addons/WAT/icons/kofi.png")
