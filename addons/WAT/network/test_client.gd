extends "res://addons/WAT/network/test_network.gd"

# BEGIN WEBSOCKET CLIENT

var socket: WebSocketClient

func _ready():
	print("NEW CLIENT READY")
	socket = WebSocketClient.new()
	socket.connect("connection_established", self, "_on_connection_established")
	socket.connect("data_received", self, "_on_data_received")
	socket.connect_to_url("http://127.0.0.1:80", ["JSON-RPC"])
	
func _on_connection_established(protocol):
	print("PROTOCOL: ", protocol)
	

func _on_data_received():
	var json_string = socket.get_peer(1).get_packet().get_string_from_ascii()
	var res: JSONParseResult = JSON.parse(json_string)
	match res.result["method"]:
		"_on_tests_received_from_server":
			var tests = res.result["data"]["testdir"]
			var repeat = res.result["data"]["repeat"]
			var count = res.result["data"]["thread_count"]
			_on_tests_received_from_server(tests, repeat, count)
# END WEBSOCKET CLIENT
	
func _process(delta):
	if socket:
		socket.poll()
	
func _on_tests_received_from_server(tests: Array, repeat: int, thread_count: int) -> void:
	var results: Array = yield(get_parent().run(tests, repeat, thread_count, self), "completed")
	print("TESTS FINISHED")
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
