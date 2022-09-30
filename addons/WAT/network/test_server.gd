tool
extends "res://addons/WAT/network/test_network.gd"

# BEGIN WEBSOCKET SERVER

var socket: WebSocketServer 
var peer_id: int

func _ready():
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


signal web_network_peer_connected
signal results_received
# Store incoming cases from client in case of abrupt termination.
var caselist: Array = []
var results_view: TabContainer

func _process(delta):
	if socket:
		socket.poll()

# Note 1 - Close any possible open connections before creating new ones
# Note 2 - Don't bother if this is not an Engine (or allow all things use it)
# Note 3 - Check Connection Errors
# Note 4 - Close on Exit
# Note 5 - Managing timed out peers (send caselist on abrupt stop)
# Note 6 - Kick Current Peers
	
func send_web(method, data):
	var json = {"method": method, "data": data}
	var string_json = to_json(json)
	print("sending data to ", peer_id)
	socket.get_peer(peer_id).put_packet(string_json.to_utf8())

func send_tests(testdir: Array, repeat: int, thread_count: int) -> void:
	send_web("_on_tests_received_from_server", 
		{
			"testdir": testdir, 
			"repeat": repeat, 
			"thread_count": thread_count
		})

func _on_results_received_from_client(results: Array = []) -> void:
	emit_signal("results_received", results)

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

