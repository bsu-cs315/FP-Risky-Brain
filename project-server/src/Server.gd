extends Node

const SERVER_PORT = 1407
const MAX_PLAYERS = 20


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	peer.set_bind_ip("34.68.78.182")
	if err != OK:
		print_debug("Error: " + str(err) + " create server err for port " + str(SERVER_PORT))
	get_tree().set_network_peer(peer)


var players_in_game : Dictionary # Player Nodes
var player_info = { }


func _player_connected(id):
	print("Player connected")


func _player_disconnected(id):
	print("player %d disconnected" % id)
	player_info.erase(id)
	if id in players_in_game:
		get_node("/root/World/Players").remove_child(players_in_game[id])
	if players_in_game.size() == 0:
		end_game()
	

remote func register_player(info: Dictionary):
	player_info[get_tree().get_rpc_sender_id()] = info


remote func start_game():
	if not get_node("/root/World"): # if not game already started
		rpc("configure_multiplayer_game", player_info)
	
	
func end_game():
	get_node("/root/World").queue_free()
	player_info.clear()
	players_in_game.clear()


remotesync func configure_multiplayer_game(info: Dictionary):
	player_info = info
	var self_peer_id = get_tree().get_network_unique_id()

	# Load world
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)

	# Load players
	for p_id in player_info:
		var player = preload("res://src/player/Player.tscn").instance()
		player.set_name(str(p_id))
		player.set_network_master(p_id)
		if not player in get_node("/root/World/Players").get_children():
			get_node("/root/World/Players").add_child(player)
			players_in_game[p_id] = player

