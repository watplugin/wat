tool
extends "res://addons/WAT/network/test_network.gd"

# -> Create Test Suite
# -> Return Suite Created
# -> Run Test Method
# <- Return Test Result

# TCP stuff
var server: TCP_Server = TCP_Server.new()
var client: StreamPeerTCP
var port = 8080

var buffer = ["Request"]

func _ready() -> void:
	server.listen(port, "127.0.0.1")

func _process(delta: float) -> void:
	if server.is_connection_available():
		client = server.take_connection()
	if client and client.get_available_bytes() > 0:
		print(client.get_utf8_string())
	if client and not buffer.empty():
		client.put_utf8_string(buffer.pop_back())
		
func _exit_tree() -> void:
	client.disconnect_from_host()
	server.stop()
