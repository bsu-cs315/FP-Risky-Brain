extends Node

const SERVER_PORT = 1407
const MAX_PLAYERS = 20


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	peer.set_bind_ip("35.239.181.55")
	if err != OK:
		print_debug("Error: " + str(err) + " create server err for port " + str(SERVER_PORT))
	get_tree().set_network_peer(peer)



var player_info = { }


func _player_connected(id):
	print("Player connected")


func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.


remote func register_player(info: Dictionary):
	player_info[get_tree().get_rpc_sender_id()] = info


remote func start_game():
	rpc("configure_multiplayer_game", player_info)


remotesync func configure_multiplayer_game(info: Dictionary):
	player_info = info
	var self_peer_id = get_tree().get_network_unique_id()

	# Load world
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)

	# Load players
	for p in player_info:
		var player = preload("res://src/player/Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p)
		if not player in get_node("/root/World/Players").get_children():
			get_node("/root/World/Players").add_child(player)

