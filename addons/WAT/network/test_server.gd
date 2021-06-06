tool
extends "res://addons/WAT/network/test_network.gd"

signal network_peer_connected
signal results_received
var _peer_id: int

func _ready() -> void:
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
	
func _on_network_peer_connected(id: int) -> void:
	_peer_id = id
	emit_signal("network_peer_connected")
	
func send_tests(testdir: Array, thread_count: int) -> void:
	rpc_id(_peer_id, "_on_tests_received_from_server", testdir, thread_count)

master func _on_results_received_from_client(results: Array = []) -> void:
	rpc_id(_peer_id, "quit")
	emit_signal("results_received", results)
