extends Node
class_name WAT
tool

const TestDoubleFactory = preload("res://addons/WAT/core/double/factory.gd")
const Test: Script = preload("res://addons/WAT/core/test/test.gd")
const TestSuiteOfSuites = preload("res://addons/WAT/core/test/suite.gd")
const SignalWatcher = preload("res://addons/WAT/core/test/watcher.gd")
const Parameters = preload("res://addons/WAT/core/test/parameters.gd")
const Yielder = preload("res://addons/WAT/core/test/yielder.gd")
const Asserts = preload("res://addons/WAT/core/assertions/assertions.gd")
const TestCase = preload("res://addons/WAT/core/test/case.gd")
const Recorder = preload("res://addons/WAT/core/test/recorder.gd")
const Settings = preload("res://addons/WAT/globals/settings.gd")
const ResManager = preload("res://addons/WAT/globals/resourcemanager.gd")

class Icon:
	const SUCCESS = preload("res://addons/WAT/assets/passed.svg")
	const FAILED = preload("res://addons/WAT/assets/failed.svg")
	const SUPPORT = preload("res://addons/WAT/assets/kofi.png")
	const FOLDER = preload("res://addons/WAT/assets/folder.svg")
	const SCRIPT = preload("res://addons/WAT/assets/script.svg")
	const FUNCTION = preload("res://addons/WAT/assets/function.svg")
	const RERUN_FAILED = preload("res://addons/WAT/assets/rerun_failures.svg")
	const RUN = preload("res://addons/WAT/assets/play.svg")
	const TAG = preload("res://addons/WAT/assets/label.svg")
	
static func results() -> Resource:
	# Lazy Initialization
	# Add toggle for compiled/exported vs non-compiled/exported
	# Make seperate ResourceManager scripts?
	var path = Settings.test_directory() + "/.test/results.tres"
	if not ResourceLoader.exists(path):
		Directory.new().make_dir(Settings.test_directory() + "/.test")
		var instance = load("res://addons/WAT/resources/results.gd").new()
		ResourceSaver.save(path, instance)
	return ResourceLoader.load(path, "", true)

