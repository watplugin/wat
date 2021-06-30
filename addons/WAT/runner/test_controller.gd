extends Node

func run(metadata: Dictionary) -> void:
	var directory = metadata["directory"]
	var path = metadata["path"]
	var methods = metadata["method_names"]
	print(methods)
	var test: Node = load(path).new().setup(directory, path, methods)
	add_child(test)
	# We need to wait for the object itself to emit the signal (since we..
	# ..cannot yield for C# so we defer the call to run so we have time to..
	# ..to setup our yielding rather than deal with a race condition)
	test.call_deferred("run")
	yield(test, test.Executed)
	test.queue_free()
	return test.get_results()
