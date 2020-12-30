tool
extends Resource

export(Array) var _temp = []
export(Array) var _list = []

func save(results: Array) -> void:
	_temp = results
#	_list = results
	ResourceSaver.save(ProjectSettings.get_setting("WAT/Results_Directory") + "/results.tres", self)
	
func failed() -> Array:
	var _failed: Array = []
	for case in _list:
		if not case.success:
			_failed.append(case.source) 
	return _failed

func retrieve() -> Array:
	if _temp.empty():
		push_warning("Fresh Results Not Found")
		return []
	_list = _temp
	_temp = []
	return _list
#	return ResourceLoader.load(ProjectSettings.get_setting("WAT/Results_Directory") + "/results.tres", "", true)._list
