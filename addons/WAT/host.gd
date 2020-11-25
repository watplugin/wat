tool
extends Node

enum {
	COMMAND
	CONNECTED
	STRATEGY
	RESULTS
}

signal ClientConnected
signal ResultsReceived
const DO_NOT_ALLOW_FULL_OBJECTS: bool = false
const DEFAULT_PORT = 6000
const IP_ADDRESS: String = "127.0.0.1"
var port: int
var server: TCP_Server
var peer: StreamPeerTCP
var is_listening: bool = false
var has_active_connection: bool = false

func host() -> void:
	close()
	server = TCP_Server.new()
	var p: int = get_port()
	print("host got port: " + p as String)
	server.listen(p, IP_ADDRESS)
	is_listening = true
	
func close():
	if peer != null and peer.is_connected_to_host():
		peer.disconnect_from_host()
		peer = null
	if server != null and server.is_listening():
		server = null
		server.stop()
	
func _process(delta: float) -> void:
	if server != null and server.is_connection_available():
			peer = server.take_connection()
			is_listening = false
			has_active_connection = true
	if peer != null and peer.get_available_bytes() > 0:
		_process_command(peer.get_var(DO_NOT_ALLOW_FULL_OBJECTS))
		
func _process_command(cmd: Dictionary) -> void:
	match cmd[COMMAND]:
		STRATEGY:
			pass
		RESULTS:
			_on_results_received(cmd["results"])
		_:
			pass # NoValidCommandFound (Error?)
		
func _on_results_received(results: Array) -> void:
	emit_signal("ResultsReceived", results)
		
func send_strategy(strategy: Dictionary = {0: 0}) -> void:
	peer.put_var(strategy)
			
func get_port() -> int:
	if ProjectSettings.has_setting("WAT/Port"):
		return ProjectSettings.get_setting("WAT/Port")
	return DEFAULT_PORT
	
	
