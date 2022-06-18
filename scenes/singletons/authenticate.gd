extends Node2D

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1911

func _ready():
	connect_to_server()
	
func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
func _on_connnection_failed():
	print("failed to connect to authentication server")
	
func _on_connection_succeeded():
	print("successfully connected to authentication server")
	
func authenticate_player(username, password, player_id):
	print("sending out authentication request for " + username + " (" + str(player_id) + ")")
	rpc_id(1, "authenticate_player", username, password, player_id)
	
remote func authentication_results(result, player_id, token):
	print("authentication results recieved for " + str(player_id))
	gateway.return_login_request(result, player_id, token)
	
func create_account(username, password, player_id):
	print("sending out create account request")
	rpc_id(1, "create_account", username, password, player_id)

remote func create_account_results(result, player_id, message):
	print("results recieved and replying to player create account request")
	gateway.return_create_account_request(result, player_id, message)
