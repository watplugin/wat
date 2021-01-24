extends Node
tool

var _server: NetworkedMultiplayerENet
var _client: NetworkedMultiplayerENet
var runner
var tests: Array = []

func host() -> void:
	_server = NetworkedMultiplayerENet.new()
	var err = _server.create_server(5000)
	_server.connect("peer_connected", self, "on_peer_connected")
	multiplayer.connect("network_peer_connected", self, "on_peer_connected")
	if(err != OK):
		print(err as String)
	multiplayer.network_peer = _server
	
func on_peer_connected(id):
	print("peer connected")
	send_tests()
	
func join() -> void:
	_client = NetworkedMultiplayerENet.new()
	var err = _client.create_client("127.0.0.1", 5000)
	if(err != OK):
		print(err as String)
	multiplayer.connect("connected_to_server", self, "on_conn_success")
	multiplayer.connect("connection_failed", self, "on_conn_failed")
	multiplayer.set_network_peer(_client) # = _client
	
master func send_tests():
	print("sending tests")
	rpc("run_tests", tests)
	
remote func run_tests(test):
	print("got tests")
	runner.run(test)
	
master func confirm():
	print("Server confirmed connection")
#	for test in test:
#	send_tests()
	
func _ready() -> void:
	print("Conn Loaded In Engine? " + Engine.is_editor_hint() as String)
	if Engine.is_editor_hint():
		host()
	else:
		join()
		
func on_conn_failed():
	print("Client could not connect")
	
func on_conn_success():
	print("Client connected")
	rpc_id(1, "confirm")
	
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		if is_instance_valid(_server):
			_server.close()
			
