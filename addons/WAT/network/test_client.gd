extends "res://addons/WAT/network/test_network.gd"

# BEGIN WEBSOCKET CLIENT

var socket: WebSocketClient

func _new_client_ready():
	print("NEW CLIENT READY")
	socket = WebSocketClient.new()
	socket.connect("connection_established", self, "_on_connection_established")
	socket.connect("data_received", self, "_on_data_received")
	socket.connect_to_url("http://127.0.0.1:80", ["JSON-RPC"])
	
func _on_connection_established(protocol):
	print("PROTOCOL: ", protocol)
	
# END WEBSOCKET CLIENT


const IPAddress: String = "127.0.0.1"
const PORT: int = 6019
const MAXCLIENTS: int = 1
const MASTER: int = 1
var _peer: NetworkedMultiplayerENet
var _id: int

func _init():
	_old_client_init()
	
func _ready():
	_new_client_ready()
	_old_client_ready()
	
func _process(delta):
	_old_client_process(delta)
	if socket:
		socket.poll()
	
func _exit_tree():
	_old_client_exit_tree()

func _old_client_init() -> void:
	_close()
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.root_node = self
	custom_multiplayer.allow_object_decoding = true
	_peer = NetworkedMultiplayerENet.new()

func _old_client_ready() -> void:
	custom_multiplayer.connect("connection_failed", self, "_on_connection_failed")
	if _error(_peer.create_client(IPAddress, PORT)) == OK:
		custom_multiplayer.network_peer = _peer
		
func _old_client_process(delta: float) -> void:
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

func _old_client_exit_tree() -> void:
	_close()

	
func _on_connection_failed() -> void:
	push_warning("TestClient could not connect to TestServer")
	
puppet func _on_tests_received_from_server(tests: Array, repeat: int, thread_count: int) -> void:
	var results: Array = yield(get_parent().run(tests, repeat, thread_count, self), "completed")
	send_web("_on_results_received_from_client", results)

# LiveWire Functions
func send_web(method, data):
	var json = {"method": method, "data": data}
	var string_json = to_json(json)
	socket.get_peer(1).put_packet(string_json.to_utf8())


func on_test_script_started(data: Dictionary) -> void:
	send_web("_on_test_script_started", data)
	
func on_test_script_finished(data: Dictionary) -> void:
	send_web("_on_test_script_finished", data)

func on_test_method_started(data: Dictionary) -> void:
	send_web("_on_test_method_started", data)

func on_test_method_finished(data: Dictionary) -> void:
	send_web("_on_test_method_finished", data)

func on_asserted(data: Dictionary) -> void:
	send_web("_on_asserted", data)	
	
func on_test_method_described(data: Dictionary) -> void:
	send_web("_on_test_method_described", data)
