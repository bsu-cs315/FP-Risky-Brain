extends Node

const SERVER_PORT = 403
const MAX_PLAYERS = 20

var server : WebSocketServer


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	server = WebSocketServer.new()
	var cert : X509Certificate = load("res://assets/certs/fullchain.pem")
	if cert != null:
		server.ssl_certificate = cert
	server.listen(SERVER_PORT, PoolStringArray(), true)
	get_tree().set_network_peer(server)


func _physics_process(delta):
	if server.is_listening():
		server.poll()

var players_in_game : Dictionary # Player Nodes
var player_info = { }


func _player_connected(id):
	print("Player connected")


func _player_disconnected(id):
	print("player %d disconnected" % id)
	player_info.erase(id)
	if id in players_in_game.keys():
		get_node("/root/World/Players").remove_child(players_in_game[id])
	if players_in_game.size() == 0:
		end_game()
	

remote func register_player(info: Dictionary):
	print("registered")
	player_info[get_tree().get_rpc_sender_id()] = info


remote func start_game():
	print("Starting game")
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

