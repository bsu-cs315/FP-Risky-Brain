extends Node

const SERVER_URL = "wss://kadedentel.com:403"
#const SERVER_URL = "ws://localhost:403"
const SERVER_PORT = 403

var networked_client : WebSocketClient
var server : WebSocketServer

var is_client := false
var is_server := false

var is_networked_game_running := false

var player_nodes : Dictionary
var players_in_lobby:= [] #ids of players


func _ready() -> void:
	var args = Array(OS.get_cmdline_args())
	if args != null and args.has("-s"):
		get_node("/root/Title").queue_free()
		print("Starting Server")
		is_server = true
		configure_server()
	else:
		print("Starting Client")
		is_client = true
		var _change_scene_err = get_tree().change_scene("res://src/menus/Title.tscn")
		configure_client()


func configure_server() -> void:
	var _err_network_peer_connected = get_tree().connect("network_peer_connected", self, "client_connected_to_server")
	var _err_network_peer_disconnected = get_tree().connect("network_peer_disconnected", self, "client_disconnected_from_server")
	server = WebSocketServer.new()
	enable_ssl()
	var _err_server_listen = server.listen(SERVER_PORT, PoolStringArray(), true)
	get_tree().set_network_peer(server)


func enable_ssl() -> void:
	var cert : X509Certificate = X509Certificate.new()
	var load_cert_err = cert.load("/home/kadedentel/fullchain.pem")
	if load_cert_err != OK:
		print("Loading cert error: " + str(load_cert_err))
	else:
		print("Server set certificate")
		server.ssl_certificate = cert
	var key : CryptoKey = CryptoKey.new()
	var load_key_err = key.load("/home/kadedentel/privkey.pem")
	if load_key_err != OK:
		print("Loading key error: " + str(load_key_err))
	else:
		server.private_key = key
		print("Server set private key")


func client_connected_to_server(id) -> void:
	print("Player %d connected" % id)
	rpc("get_game_info", players_in_lobby, is_networked_game_running)
	

remote func get_game_info(players: Array, game_running: bool) -> void:
	players_in_lobby = players
	is_networked_game_running = game_running
	print("Got game info")


func client_disconnected_from_server(id) -> void:
	print("player %d disconnected" % id)
	players_in_lobby.erase(id)
	if id in player_nodes.keys():
		player_nodes[id].free()
	if players_in_lobby.size() == 0:
		end_server_game()
	else:
		print("Still %d players in game" % player_nodes.size())
	
	
remote func join_game() -> void:
	if not is_networked_game_running:
		print("joined game")
		players_in_lobby.append(get_tree().get_rpc_sender_id())
		rpc("get_game_info", players_in_lobby, is_networked_game_running)
	else:
		print("couldnt join")


remote func leave_game() -> void:
	players_in_lobby.erase(get_tree().get_rpc_sender_id())
	if players_in_lobby.size() == 0:
		end_server_game()


func leave_multiplayer_game() -> void:
	networked_client = null
	GameState.rpc_id(1, "leave_game")
	get_tree().call_group("Enemies", "queue_free")
	get_node("/root/World").queue_free()
	var _err_change_scene = get_tree().change_scene("res://src/menus/Title.tscn")


func leave_singleplayer_game() -> void:
	get_tree().call_group("Enemies", "queue_free")
	get_node("/root/World").queue_free()
	var _err_change_scene = get_tree().change_scene("res://src/menus/Title.tscn")


remote func start_server_game() -> void:
	print("Starting game")
	 # if not game already started
	if not is_networked_game_running && get_tree().is_network_server():
		rpc("configure_multiplayer_game")


func end_server_game() -> void:
	print("ending game")
	get_node("/root/World").queue_free()
	players_in_lobby.clear()
	player_nodes.clear()
	is_networked_game_running = false


func end_client_game() -> void:
	leave_multiplayer_game()


func configure_client() -> void:
	var _err_func_conn_to_server = get_tree().connect("connected_to_server", self, "client_connected_ok")
	var _err_func_conn_failed = get_tree().connect("connection_failed", self, "client_connected_fail")
	var _err_func_disconn_from_server = get_tree().connect("server_disconnected", self, "client_disconnected")


func _physics_process(_delta: float) -> void:
	if server != null && server.is_listening():
		server.poll()
	if is_client_connected_to_server():
		networked_client.poll()


func is_client_connected_to_server() -> bool:
	if networked_client != null:
		return networked_client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED
	return false


func client_connected_ok() -> void:
	print("Connected to server")


func client_connected_fail() -> void:
	print("Could not connect to server")
	

func client_disconnected() -> void:
	print("Server kicked us")


func connect_to_server() -> void:
	networked_client = WebSocketClient.new()
	var create_client_error = networked_client.connect_to_url(SERVER_URL, PoolStringArray(), true)
	if create_client_error != OK:
		print("Create client error: " + str(create_client_error))
		return 
	get_tree().network_peer = networked_client


remotesync func configure_multiplayer_game() -> void:
	is_networked_game_running = true
	if not get_tree().is_network_server():
		get_node("/root/LobbyMenu").queue_free()
	# Load world
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)

	# Load players
	for player_id in players_in_lobby:
		var player = preload("res://src/player/Player.tscn").instance()
		player.connect("died", self, "on_networked_player_died", [player_id])
		player.set_name(str(player_id))
		player.set_network_master(player_id)
		get_node("/root/World/Players").add_child(player)
		player_nodes[player_id] = player
		player.position = get_node("/root/World/PlayerSpawnPoint").position
	PlayerInfo.init_player_nodes()


func configure_singleplayer_game() -> void:
	get_node("/root/Title").queue_free()
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)
	var player = preload("res://src/player/Player.tscn").instance()
	player.set_name(str("SinglePlayer"))
	get_node("/root/World/Players").add_child(player)
	player.position = get_node("/root/World/PlayerSpawnPoint").position
	PlayerInfo.init_player_nodes()


func on_networked_player_died(id: int) -> void:
	if get_tree().is_network_server():
		if player_nodes.size() == 1:
			end_server_game()
		else:
			player_nodes[id].queue_free()
	else:
		end_client_game()
	
