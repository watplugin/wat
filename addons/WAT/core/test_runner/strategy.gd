extends Reference

# Properties
static func directory() -> String:
	return ProjectSettings.get_setting("WAT/TestStrategy")["directory"]
	
static func script() -> String:
	return ProjectSettings.get_setting("WAT/TestStrategy")["script"]
	
static func tag() -> String:
	return ProjectSettings.get_setting("WAT/TestStrategy")["tag"]
	
static func method() -> String:
	var strat = ProjectSettings.get_setting("WAT/TestStrategy")
	if(strat.has("method")):
		return strat["method"]
	return ""
	
static func repeat() -> int:
	return ProjectSettings.get_setting("WAT/TestStrategy")[Repeat]
	
# Keys
enum { Strategy, Repeat, Tag, } 

# Strategies
enum { RUN_ALL, RUN_DIRECTORY, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RERUN_FAILED }

static func get_current_strategy() -> int:
	var strategy: Dictionary = ProjectSettings.get_setting("WAT/TestStrategy")
	return strategy[Strategy]

static func strategy() -> Dictionary:
	ProjectSettings.set("WAT/TestStrategy", {})
	ProjectSettings.save()
	return ProjectSettings.get_setting("WAT/TestStrategy")

static func RunAll(repeat: int = 1) -> void:
	var strat = strategy()
	strat[Strategy] = RUN_ALL
	strat[Repeat] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunDirectory(directory: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat[Strategy] = RUN_DIRECTORY
	strat["directory"] = directory
	strat[Repeat] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunScript(script: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat[Strategy] = RUN_SCRIPT
	strat["script"] = script
	strat[Repeat] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunTag(tag: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat[Strategy] = RUN_TAG
	strat["tag"] = tag
	print(strat["tag"])
	strat[Repeat] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunMethod(script: String, method: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat[Strategy] = RUN_METHOD
	strat["script"] = script
	strat["method"] = method
	strat[Repeat] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunFailures(repeat: int = 1) -> void:
	var strat = strategy()
	strat[Strategy] = RERUN_FAILED
	strat[Repeat] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)



