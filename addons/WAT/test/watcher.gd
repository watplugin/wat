extends Reference

var watching: Dictionary = {}

func watch(emitter, event: String) -> void:
	emitter.connect(event, self, "_add_emit", [emitter, event])
	watching[event] = {emit_count = 0, calls = []}

func _add_emit(a = null, b = null, c = null, d = null, e = null, f = null, g = null, h = null, i = null, j = null, k = null):
	var arguments: Array = [a, b, c, d, e, f, g, h, i, j, k]
	var event: String
	while not event:
		event = arguments.pop_back()
	var obj: String = arguments.pop_back()
	watching[event].emit_count += 1
	watching[event].calls.append({emitter = obj, args = arguments})