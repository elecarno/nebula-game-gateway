extends Node2D

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 5030

func _ready():
	connect_to_server()
	
func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connnection_failed():
	print("failed to connect to authentication server")
	
func _on_connnection_succeeded():
	print("successfully connected to authentication server")
	