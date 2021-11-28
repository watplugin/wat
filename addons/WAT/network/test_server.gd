tool
extends "res://addons/WAT/network/test_network.gd"

signal network_peer_connected
signal results_received

enum STATE { SENDING, RECEIVING, DISCONNECTED }

var _peer_id: int
# Store incoming cases from client in case of abrupt termination.
var caselist: Array = []
var results_view: TabContainer
var status: int = STATE.DISCONNECTED

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
	
func _on_network_peer_connected(id: int) -> void:
	_peer_id = id
	_peer.set_peer_timeout(id, 1000, 2000, 3000)
	emit_signal("network_peer_connected")

func _on_network_peer_disconnected(_id: int) -> void:
	if status == STATE.SENDING:
		emit_signal("results_received", caselist)
	caselist.clear()
	status = STATE.DISCONNECTED

func send_tests(testdir: Array, repeat: int, thread_count: int) -> void:
	status = STATE.SENDING
	rpc_id(_peer_id, "_on_tests_received_from_server", testdir, repeat, thread_count)

master func _on_results_received_from_client(results: Array = []) -> void:
	status = STATE.RECEIVING
	emit_signal("results_received", results)
	_peer.disconnect_peer(_peer_id, true)

master func _on_test_script_started(data: Dictionary) -> void:
	results_view.on_test_script_started(data)
	
master func _on_test_script_finished(data: Dictionary) -> void:
	results_view.on_test_script_finished(data)
	caselist.append(data)

master func _on_test_method_started(data: Dictionary) -> void:
	results_view.on_test_method_started(data)
	
master func _on_test_method_finished(data: Dictionary) -> void:
	results_view.on_test_method_finished(data)

master func _on_asserted(data: Dictionary) -> void:
	results_view.on_asserted(data)
	
master func _on_test_method_described(data: Dictionary) -> void:
	results_view.on_test_method_described(data)
