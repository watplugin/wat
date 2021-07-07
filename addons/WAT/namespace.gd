extends Reference
class_name WAT

enum { RUN, DEBUG, NONE }
const COMPLETED: String = "completed"
const Test: Script = preload("res://addons/WAT/test/test.gd")
const Settings: Script = preload("res://addons/WAT/settings.gd")
const TestParcel: Script = preload("res://addons/WAT/filesystem/test_parcel.gd")
const TestRunner: Script = preload("res://addons/WAT/runner/TestRunner.gd")
const TestRunnerScene: PackedScene = preload("res://addons/WAT/runner/TestRunner.tscn")
const FileSystem: GDScript = preload("res://addons/WAT/filesystem/filesystem.gd")
# Can't always type due to cyclic references but this should work

	
static func test_runner() -> TestRunner:
	return TestRunnerScene.instance() as TestRunner
