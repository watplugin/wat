tool
extends Resource

export(Array) var _list = []

func save(results: Array) -> void:
	_list = results
	ResourceSaver.save(resource_path, self)
	
func failed() -> Array:
	var _failed: Array = []
	
	return _failed

func retrieve() -> Array:
	return _list
