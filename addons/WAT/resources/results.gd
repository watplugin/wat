tool
extends Resource

export(Dictionary) var results = {0: []}
export(int) var current_key: int = 0

func add_unique_run_key(key: int) -> void:
	# We set a unique run key so we don't end up loading old results by mistake
	if results.has(key) or current_key == key:
		push_warning("Results already has key. Key needs to be unique")
		return
	results[key] = []
	current_key = key
	WAT.ResManager.save_results(self)
	
func save(_results: Array) -> void:
	results[current_key] = _results
	WAT.ResManager.save_results(self)

func failed() -> Array:
	var _failed: Array = []
	for case in results[current_key]:
		if not case.success:
			_failed.append(case.source) 
	return _failed

func retrieve(runkey: int) -> Array:
	if current_key != runkey:
		push_warning("Run Key is invalid")
		return []
	return results[runkey]
