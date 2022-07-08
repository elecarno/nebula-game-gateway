extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1910
var max_players = 100

func _ready():
	start_server()
	
func _process(_delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	
func start_server():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("gateway server started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")

func _peer_connected(player_id):
	print("user " + str(player_id) + " connected")
	
func _peer_disconnected(player_id):
	print("user " + str(player_id) + " disconnected")
	
remote func login_request(username, password):
	print("login request recieved")
	var player_id = custom_multiplayer.get_rpc_sender_id()
	authenticate.authenticate_player(username, password, player_id)
	
func return_login_request(result, player_id, token, username):
	rpc_id(player_id, "return_login_request", result, token, username)
	network.disconnect_peer(player_id)
	
remote func create_account_request(username, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	var valid_request = true
	if username == "":
		valid_request = false
	if password == "":
		valid_request = false
	if password.length() <= 4:
		valid_request = false
		
	if valid_request == false:
		return_create_account_request(valid_request, player_id, 1)
	else:
		authenticate.create_account(username, password, player_id)
		
func return_create_account_request(result, player_id, message):
	rpc_id(player_id, "return_create_account_request", result, message)
	# 1 = failed to create, 2 = existing username, 3 = welcome
	network.disconnect_peer(player_id)
