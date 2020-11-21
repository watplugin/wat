tool
extends Node

const DEFAULT_PORT = 6000
const IP_ADDRESS: String = "127.0.0.1"
var port: int
var server: TCP_Server
var peer: StreamPeerTCP
var is_listening: bool = false
var has_active_connection: bool = false

func host() -> void:
	server = TCP_Server.new()
	server.listen(port, IP_ADDRESS)
	is_listening = true
	
func _process(delta: float) -> void:
	if is_listening and server.is_connection_available():
			peer = server.take_connection()
			is_listening = false
			has_active_connection = true
			print("Server has found client")
	elif has_active_connection:
		peer.put_utf8_string("Hello TestRunner") # Why 0?
	
func get_port() -> int:
	if ProjectSettings.has_setting("WAT/Port"):
		return ProjectSettings.get_setting("WAT/Port")
	return DEFAULT_PORT
	
	