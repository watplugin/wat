tool
extends Resource

export(Array) var _list = []

func save(results: Array) -> void:
	_list = results
	ResourceSaver.save(ProjectSettings.get_setting("WAT/Results_Directory") + "/results.tres", self)
	
func failed() -> Array:
	var _failed: Array = []
	for case in _list:
		if not case.success:
			_failed.append(case.source) 
	return _failed

func retrieve() -> Array:
	return ResourceLoader.load(ProjectSettings.get_setting("WAT/Results_Directory") + "/results.tres", "", true)._list
