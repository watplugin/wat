extends Reference
class_name WAT

const TestDoubleFactory = preload("res://addons/WAT/core/double/factory.gd")
const BaseTest = preload("res://addons/WAT/core/test/base_test.gd")
const Test: Script = preload("res://addons/WAT/core/test/test.gd")
#const TestLoader = preload("res://addons/WAT/test_runner/test_loader.gd")
const Results: Resource = preload("res://addons/WAT/resources/results.tres")
const TestSuiteOfSuites = preload("res://addons/WAT/core/test/suite.gd")
const SignalWatcher = preload("res://addons/WAT/core/test/watcher.gd")
const Parameters = preload("res://addons/WAT/core/test/parameters.gd")
const Yielder = preload("res://addons/WAT/core/test/yielder.gd")
const Asserts = preload("res://addons/WAT/assertions/assertions.gd")
const TestCase = preload("res://addons/WAT/core/test/case.gd")
const Settings = preload("res://addons/WAT/system/settings.gd")

class Icon:
	const SUCCESS = preload("res://addons/WAT/assets/success.png")
	const FAILED = preload("res://addons/WAT/assets/failed.png")
	const SUPPORT = preload("res://addons/WAT/assets/kofi.png")
