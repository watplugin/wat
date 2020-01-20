tool
extends Resource

export(Array, Dictionary) var _list: Array = []

func deposit(results: Array) -> void:
	_list = results
	ResourceSaver.save(resource_path, self)
	
func withdraw() -> Array:
	var deep_copy: bool = true
	var results: Array = _list.duplicate(deep_copy)
	_list.clear()
	ResourceSaver.save(resource_path, self)
	return results
	
func exist() -> bool:
	return not _list.empty()
