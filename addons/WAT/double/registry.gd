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
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		var directors = test_directors.values()
		while not directors.empty():
			var director = directors.pop_back()
			director.clear()
		queue_free()
