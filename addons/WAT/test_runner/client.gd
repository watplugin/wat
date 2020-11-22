extends Node

var is_connected_to_client: bool = false
const DEFAULT_PORT = 6000
const IP_ADDRESS: String = "127.0.0.1"
var client: StreamPeerTCP

func join() -> void:
	client = StreamPeerTCP.new()
	var p: int = get_port()
	print("client got port: " + p as String)
	client.connect_to_host(IP_ADDRESS, p)
	
func _process(delta: float) -> void:
	if client.is_connected_to_host():
		client.put_utf8_string("Hello!")
		
	
func get_port() -> int:
	if ProjectSettings.has_setting("WAT/Port"):
		return ProjectSettings.get_setting("WAT/Port")
	return DEFAULT_PORT
	
func quit() -> void:
	client.disconnect_from_host()
