extends Node

func run(metadata: Dictionary) -> void:
	var test = load(metadata["path"]).new().setup(metadata)
	add_child(test)
	# We need to wait for the object itself to emit the signal (since we..
	# ..cannot yield for C# so we defer the call to run so we have time to..
	# ..to setup our yielding rather than deal with a race condition)
	test.call_deferred("run")
	yield(test, "executed")
	test.queue_free()
	return test.get_results()
