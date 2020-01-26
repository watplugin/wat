extends Reference
class_name WAT

const TestDoubleFactory = preload("res://addons/WAT/double/factory.gd")
const BaseTest = preload("base_test.gd")
const Test: Script = preload("test.gd")
const TestLoader = preload("res://addons/WAT/test_runner/test_loader.gd")
const Results: Resource = preload("res://addons/WAT/resources/results.tres")
const TestSuiteOfSuites = preload("suite.gd")
const SignalWatcher = preload("res://addons/WAT/test/watcher.gd")
const Parameters = preload("res://addons/WAT/test/parameters.gd")
const Yielder = preload("yielder.gd")
const Asserts = preload("res://addons/WAT/expectations/0_index.gd")
const TestCase = preload("case.gd")
const Settings = preload("res://addons/WAT/settings.gd")

class Icon:
	const SUCCESS = preload("res://addons/WAT/icons/success.png")
	const FAILED = preload("res://addons/WAT/icons/failed.png")
