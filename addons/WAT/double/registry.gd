extends Node

var test_directors: Dictionary = {}

func register(director) -> void:
	var id: int = director.get_instance_id()
	if id in test_directors:
		push_warning("Director Object is already registered")
		return
	test_directors[id] = director
	director.instance_id = id
	
func method(instance_id: int, method: String) -> Object:
	return test_directors[instance_id].methods[method]
	
func clear():
	for id in test_directors:
		test_directors[id].clear()
	queue_free()
