extends Node


func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


var player_info = { }


func _connected_ok():
	print("Connected to server")
	rpc_id(1, "register_player", {position = Vector2.ZERO})


func _connected_fail():
	print("Could not connect to server")
	

func _server_disconnected():
	print("Server kicked us")


remotesync func configure_multiplayer_game(info: Dictionary):
	if get_node("/root/World") != null:
		return
	player_info = info
	var self_peer_id = get_tree().get_network_unique_id()

	get_node("/root/LobbyMenu").queue_free()
	# Load world
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)

	# Load players
	for p in player_info:
		var player = preload("res://src/player/Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p)
		get_node("/root/World/Players").add_child(player)
	PlayerInfo.get_player_nodes()


func configure_singleplayer_game():
	get_node("/root/Title").queue_free()
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)
	var player = preload("res://src/player/Player.tscn").instance()
	player.set_name(str("SinglePlayer"))
	get_node("/root/World/Players").add_child(player)
	PlayerInfo.get_player_nodes()