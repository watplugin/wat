extends "res://addons/WAT/network/test_network.gd"

var peer: StreamPeerTCP = StreamPeerTCP.new()

func _ready() -> void:
	peer.connect_to_host("127.0.0.1", 8080)
	
func _process(delta: float) -> void:
	if peer.is_connected_to_host() and peer.get_available_bytes() > 0:
		print(peer.get_utf8_string())
		peer.put_utf8_string("Response")
