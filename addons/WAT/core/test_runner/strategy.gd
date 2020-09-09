extends Reference

# Creating a Strategy Object so we don't need to use so many dictionarys and strings

# Once we have all our valid objects pointing to this script, we should replace
# the strings with neums
enum Strategy { RUN_ALL, RUN_DIRECTORY, RUN_SCRIPT, RUN_TAG, RUN_METHOD }

static func strategy() -> Dictionary:
	return ProjectSettings.get_setting("WAT/TestStrategy")

static func RunAll(repeat: int = 1) -> void:
	var strat = strategy()
	strat["strategy"] = "RunAll"
	strat["repeat"] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunDirectory(directory: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat["strategy"] = "RunDirectory"
	strat["directory"] = directory
	strat["repeat"] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunScript(script: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat["strategy"] = "RunScript"
	strat["script"] = script
	strat["repeat"] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunTag(tag: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat["strategy"] = "RunTag"
	strat["tag"] = tag
	print(strat["tag"])
	strat["repeat"] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunMethod(script: String, method: String, repeat: int = 1) -> void:
	var strat = strategy()
	strat["strategy"] = "RunMethod"
	strat["script"] = script
	strat["method"] = method
	strat["repeat"] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)
	
static func RunFailures(repeat: int = 1) -> void:
	var strat = strategy()
	strat["strategy"] = "RerunFailures"
	strat["repeat"] = repeat
	ProjectSettings.set("WAT/TestStrategy", strat)



