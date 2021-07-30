extends Node

signal results_received
func run(metadata: Dictionary) -> void:
	var directory = metadata["directory"]
	var path = metadata["path"]
	var methods = metadata["method_names"]
	var test: Node = load(path).new().setup(directory, path, methods)

	# We need to wait for the object itself to emit the signal (since we..
	# ..cannot yield for C# so we defer the call to run so we have time to..
	# ..to setup our yielding rather than deal with a race condition)
	call_deferred("add_child", test)
	var results = yield(self, "results_received")
	test.queue_free()
	return results

func get_results(results) -> void:
	# Called by Tests as our children
	emit_signal("results_received", results)
	
