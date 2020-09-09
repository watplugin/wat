extends Reference

# Creating a Strategy Object so we don't need to use so many dictionarys and strings

# Once we have all our valid objects pointing to this script, we should replace
# the strings with neums

# Keys
enum { Strategy, Repeat } 

# Strategys
enum { RUN_ALL, RUN_DIRECTORY, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RERUN_FAILED }

#func get_tests() -> Array:
#	match _strategy["strategy"]:
#		"RunAll":
#			return test_loader.all()
#		"RunDirectory":
#			return test_loader.directory(_strategy["directory"])
#		"RunScript":
#			return test_loader.script(_strategy["script"])
#		"RunTag":
#			return test_loader.tag(_strategy["tag"])
#		"RunMethod":
#			return test_loader.script(_strategy["script"])
#		"RerunFailures":
#			return test_loader.last_failed()
#		_:
#			return _tests

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



