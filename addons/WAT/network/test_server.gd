tool
extends "res://addons/WAT/network/test_network.gd"

# BEGIN WEBSOCKET SERVER

var socket: WebSocketServer 
var peer_id: int

func _new_server_ready():
	print("NEW SERVER READY")
	socket = WebSocketServer.new()
	socket.connect("client_connected", self, "_on_web_client_connected")
	socket.connect("client_close_request", self, "_on_client_close_request")
	socket.connect("client_disconnected", self, "_on_client_disconnected")
	socket.connect("data_received", self, "_on_data_received")
	socket.listen(80, ["JSON-RPC"], false)
	
func _on_web_client_connected(id, protocol):
	peer_id = id
	print("%s connected with protocol %s" % [id, protocol])
	emit_signal("web_network_peer_connected")
	
func _on_client_close_request(id, code, reason):
	print("client close request: %s, %s, %s" % [id, code, reason])
	
func _on_client_disconnected(id, clean):
	print("client disconnected: %s, %s" % [id, clean])
	
func _on_data_received(id):
	var json_string = socket.get_peer(id).get_packet().get_string_from_ascii()
	var res: JSONParseResult = JSON.parse(json_string)
	match res.result["method"]:
		"_on_test_script_started":
			_on_test_script_started(res.result["data"])
		"_on_test_script_finished":
			_on_test_script_finished(res.result["data"])
		"_on_test_method_started":
			_on_test_method_started(res.result["data"])
		"_on_test_method_finished":
			_on_test_method_finished(res.result["data"])
		"_on_asserted":
			_on_asserted(res.result["data"])
		"_on_test_method_described":
			_on_test_method_described(res.result["data"])
		"_on_results_received_from_client":
			_on_results_received_from_client(res.result["data"])
		_:
			print("Fallthrough")
		
# END WEBSOCKET SERVER

const IPAddress: String = "127.0.0.1"
const PORT: int = 6019
const MAXCLIENTS: int = 1
const MASTER: int = 1
var _peer: NetworkedMultiplayerENet
var _id: int

signal web_network_peer_connected
signal network_peer_connected
signal results_received

enum STATE { SENDING, RECEIVING, DISCONNECTED }

var _peer_id: int
# Store incoming cases from client in case of abrupt termination.
var caselist: Array = []
var results_view: TabContainer
var status: int = STATE.DISCONNECTED

func _init() -> void:
	_old_server_init()
	
func _ready() -> void:
	_new_server_ready()
	_old_server_ready()

	
func _process(delta):
	_old_server_process()
	if socket:
		socket.poll()
	
func _old_server_init():
	_close()
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.root_node = self
	custom_multiplayer.allow_object_decoding = true
	_peer = NetworkedMultiplayerENet.new()
	
func _old_server_ready():
	if not Engine.is_editor_hint():
		return
	custom_multiplayer.connect("network_peer_connected", self, "_on_network_peer_connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	if _error(_peer.create_server(PORT, MAXCLIENTS)) == OK:
		custom_multiplayer.network_peer = _peer
		
func _old_server_process():
	if custom_multiplayer.has_network_peer():
		custom_multiplayer.poll()
	
func _old_server_exit():
	pass

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
	
func send_web(method, data):
	var json = {"method": method, "data": data}
	var string_json = to_json(json)
	print("sending data to ", peer_id)
	socket.get_peer(peer_id).put_packet(string_json.to_utf8())

func send_tests(testdir: Array, repeat: int, thread_count: int) -> void:
	status = STATE.SENDING
	send_web("_on_tests_received_from_server", 
		{
			"testdir": testdir, 
			"repeat": repeat, 
			"thread_count": thread_count
		})

func _on_results_received_from_client(results: Array = []) -> void:
	status = STATE.RECEIVING
	emit_signal("results_received", results)
	_peer.disconnect_peer(_peer_id, true)

func _on_test_script_started(data: Dictionary) -> void:
	results_view.on_test_script_started(data)
	
func _on_test_script_finished(data: Dictionary) -> void:
	results_view.on_test_script_finished(data)
	caselist.append(data)

func _on_test_method_started(data: Dictionary) -> void:
	results_view.on_test_method_started(data)
	
func _on_test_method_finished(data: Dictionary) -> void:
	results_view.on_test_method_finished(data)

func _on_asserted(data: Dictionary) -> void:
	results_view.on_asserted(data)
	
func _on_test_method_described(data: Dictionary) -> void:
	results_view.on_test_method_described(data)

