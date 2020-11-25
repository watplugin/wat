extends Reference

enum { Strategy, Repeat, Tag, } 
enum { RUN_ALL, RUN_DIRECTORY, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RERUN_FAILED }

func RunAll(repeat: int = 1) -> Dictionary:
	var strat = {}
	strat[Strategy] = RUN_ALL
	strat[Repeat] = repeat
	return strat
	
func RunDirectory(directory: String, repeat: int = 1) -> Dictionary:
	var strat = {}
	strat[Strategy] = RUN_DIRECTORY
	strat["directory"] = directory
	strat[Repeat] = repeat
	return strat
	
func RunScript(script: String, repeat: int = 1) -> Dictionary:
	var strat = {}
	strat[Strategy] = RUN_SCRIPT
	strat["script"] = script
	strat[Repeat] = repeat
	return strat
	
func RunTag(tag: String, repeat: int = 1) -> Dictionary:
	var strat = {}
	strat[Strategy] = RUN_TAG
	strat["tag"] = tag
	strat[Repeat] = repeat
	return strat
	
func RunMethod(script: String, method: String, repeat: int = 1) -> Dictionary:
	var strat = {}
	strat[Strategy] = RUN_METHOD
	strat["script"] = script
	strat["method"] = method
	strat[Repeat] = repeat
	return strat
	
func RunFailures(repeat: int = 1) -> Dictionary:
	var strat = {}
	strat[Strategy] = RERUN_FAILED
	strat[Repeat] = repeat
	return strat
