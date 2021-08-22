extends Node

signal asserted
signal results_received
var _current_method: String = ""
var _dir: String = ""
var _path: String

func run(metadata: Dictionary) -> void:
	_dir = metadata["dir"]
	_path = metadata["path"]
	var methods = metadata["methods"]
	var test: Node = load(_path).new().setup(_dir, _path, methods)

	# We need to wait for the object itself to emit the signal (since we..
	# ..cannot yield for C# so we defer the call to run so we have time to..
	# ..to setup our yielding rather than deal with a race condition)
	get_parent().emit_signal("test_started", metadata)
	call_deferred("add_child", test)
	var results = yield(self, "results_received")
	test.queue_free()
	return results

func get_results(results) -> void:
	# Called by Tests as our children
	emit_signal("results_received", results)
	
func on_test_method(method) -> void:
	var x = {"dir" : _dir, "path": _path, "method": method}
	get_parent().emit_signal("method_started", x) # What about "described" methods?
	_current_method = method
	
#signal asserted
#signal test_started
#signal method_started
#
func _on_assertion(assertion) -> void:
	var x = {"dir" : _dir, "path": _path, "method": _current_method, "assertion": assertion}
	get_parent().emit_signal("asserted", x)
