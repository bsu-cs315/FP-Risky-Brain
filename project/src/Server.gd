extends Node

const SERVER_PORT = 90
const MAX_PLAYERS = 2

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")


var player_info = { }


func _connected_ok():
	rpc_id(1, "register_player", {position = Vector2.ZERO})


remotesync func configure_game(info: Dictionary):
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

