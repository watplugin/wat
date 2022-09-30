tool
extends "res://addons/WAT/network/test_network.gd"


const IPAddress: String = "127.0.0.1"
const PORT: int = 6019
const MAXCLIENTS: int = 1
const MASTER: int = 1
var _peer: NetworkedMultiplayerENet
var _id: int


signal network_peer_connected
signal results_received

enum STATE { SENDING, RECEIVING, DISCONNECTED }

var _peer_id: int
# Store incoming cases from client in case of abrupt termination.
var caselist: Array = []
var results_view: TabContainer
var status: int = STATE.DISCONNECTED

func _init() -> void:
	_close()
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.root_node = self
	custom_multiplayer.allow_object_decoding = true
	_peer = NetworkedMultiplayerENet.new()

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
		
func _process(delta):
	if custom_multiplayer.has_network_peer():
		custom_multiplayer.poll()
	
func _close() -> void:
	if is_instance_valid(_peer):
		if _is_connected():
			_peer.close_connection()
		_peer = null
		
func _error(err: int) -> int:
	if err != OK:
		match err:
			ERR_ALREADY_IN_USE:
				push_warning("Network Peer is already in use")
			ERR_CANT_CREATE:
				push_warning("Network Peer cannot be created")
			_:
				push_warning(err as String)
	return err
	
func _is_connected() -> bool:
	return _peer.get_connection_status() == NetworkedMultiplayerENet.CONNECTION_CONNECTED

func _exit_tree() -> void:
	_close()

	
func _on_network_peer_connected(id: int) -> void:
	_peer_id = id
	# Timeout is 10 minutes.
	_peer.set_peer_timeout(id, 600000, 601000, 602000)
	emit_signal("network_peer_connected")

func _on_network_peer_disconnected(_id: int) -> void:
	if status == STATE.SENDING:
		emit_signal("results_received", caselist)
	caselist.clear()
	status = STATE.DISCONNECTED

func kick_current_peer():
	var kicked = false
	if _peer_id in custom_multiplayer.get_network_connected_peers():
		_on_results_received_from_client([])
		kicked = true
	return kicked

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
