tool
extends "res://addons/WAT/network/test_network.gd"

enum STATE { SENDING, RECEIVING }
signal network_peer_connected
signal results_received
var _peer_id: int

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
	
func _on_network_peer_connected(id: int) -> void:
	_peer_id = id
	_peer.set_peer_timeout(id, 59000, 60000, 61000)
	emit_signal("network_peer_connected")
	
func send_tests(testdir: Array, repeat: int, thread_count: int) -> void:
	rpc_id(_peer_id, "_on_tests_received_from_server", testdir, repeat, thread_count)

master func _on_results_received_from_client(results: Array = []) -> void:
	emit_signal("results_received", results)
	_peer.disconnect_peer(_peer_id, true)
	
var results_view: TabContainer
master func _on_test_script_started(data: Dictionary) -> void:
	results_view.on_test_script_started(data)
	
master func _on_test_script_finished(data: Dictionary) -> void:
	results_view.on_test_script_finished(data)

master func _on_test_method_started(data: Dictionary) -> void:
	results_view.on_test_method_started(data)
	
master func _on_test_method_finished(data: Dictionary) -> void:
	results_view.on_test_method_finished(data)

master func _on_asserted(data: Dictionary) -> void:
	results_view.on_asserted(data)
	
master func _on_test_method_described(data: Dictionary) -> void:
	results_view.on_test_method_described(data)
