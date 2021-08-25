extends "res://addons/WAT/network/test_network.gd"

func _ready() -> void:
	custom_multiplayer.connect("connection_failed", self, "_on_connection_failed")
	if _error(_peer.create_client(IPAddress, PORT)) == OK:
		custom_multiplayer.network_peer = _peer
	
func _on_connection_failed() -> void:
	push_warning("TestClient could not connect to TestServer")
	
puppet func _on_tests_received_from_server(tests: Array, repeat: int, thread_count: int) -> void:
	var results: Array = yield(get_parent().run(tests, repeat, thread_count, self), "completed")
	rpc_id(MASTER, "_on_results_received_from_client", results)

# LiveWire Functions
func on_test_script_started(data: Dictionary) -> void:
	rpc_id(MASTER, "_on_test_script_started", data)
	
func on_test_script_finished(data: Dictionary) -> void:
	rpc_id(MASTER, "_on_test_script_finished", data)

func on_test_method_started(data: Dictionary) -> void:
	rpc_id(MASTER, "_on_test_method_started", data)
	
func on_test_method_finished(data: Dictionary) -> void:
	rpc_id(MASTER, "_on_test_method_finished", data)

func on_asserted(data: Dictionary) -> void:
	rpc_id(MASTER, "_on_asserted", data)
	
func on_test_method_described(data: Dictionary) -> void:
	rpc_id(MASTER, "_on_test_method_described", data)
