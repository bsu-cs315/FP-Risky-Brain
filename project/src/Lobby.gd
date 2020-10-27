extends Node


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	

var my_info = { position = Vector2.ZERO }
var players_done = []


func _player_connected(id):
	print("Player connected")
	rpc_id(id, "register_player", my_info)
	rpc_id(id, "pre_configure_game")


func _player_disconnected(id):
	GameState.player_info.erase(id)


func _connected_ok():
	print("successfully connected")


func _server_disconnected():
	print("Server kicked us")


func _connected_fail():
	print("Couldn't connect to server")


remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	GameState.player_info[id] = info
	# Call function to update lobby UI here


remote func pre_configure_game():
	var selfPeerID = get_tree().get_network_unique_id()

	# Load world
	get_node("/root/LobbyMenu").queue_free()
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)

	# Load my player
	var my_player = preload("res://src/player/Player.tscn").instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	get_node("/root/World/Players").add_child(my_player)

	# Load other players
	for p in GameState.player_info:
		var player = preload("res://src/player/Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p)
		get_node("/root/World/Players").add_child(player)


#remote func set_player_info(id: int, info: Dictionary):
#	if get_tree().is_network_server():
#		for player_id in GameState.player_info.keys():
#			rpc_id(id, "set_player_info", player_id, GameState.player_info[player_id])
#	GameState.player_info[id] = info
