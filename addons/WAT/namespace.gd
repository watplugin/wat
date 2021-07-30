extends Reference
class_name WAT

enum { RUN, DEBUG, NONE }
const COMPLETED: String = "completed"
const Test: Script = preload("res://addons/WAT/test/test.gd")
const TestRunnerScene: PackedScene = preload("res://addons/WAT/runner/TestRunner.tscn")
#const Settings: Script = preload("res://addons/WAT/settings.gd")

	
static func test_runner() -> _watTestRunner:
	return TestRunnerScene.instance() as _watTestRunner
