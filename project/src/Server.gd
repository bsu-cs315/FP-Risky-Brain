extends Node

#const SERVER_URL = "wss://kadedentel.com:403"
const SERVER_URL = "ws://localhost:403"
const SERVER_PORT = 403

var client : WebSocketClient
var server : WebSocketServer
var is_network_connected := false

var is_multiplayer := false

var multiplayer_game_started := false

var players_in_game : Dictionary # Player Nodes
var player_info = { }

func _ready() -> void:
	var args = Array(OS.get_cmdline_args())
	if args != null && args.has("-s"):
		print("Starting Server")
		configure_server()
	else:
		print("Starting Client")
		var _change_scene_err = get_tree().change_scene("res://src/menus/Title.tscn")
		configure_client()


func configure_server() -> void:
	get_tree().connect("network_peer_connected", self, "client_connected_to_server")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected_from_server")
	server = WebSocketServer.new()
	enable_ssl()
	server.listen(SERVER_PORT, PoolStringArray(), true)
	get_tree().set_network_peer(server)


func enable_ssl() -> void:
	var cert : X509Certificate = X509Certificate.new()
	var load_cert_err = cert.load("res://assets/certs/fullchain.pem")
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
	print("Player connected")


func client_disconnected_from_server(id) -> void:
	print("player %d disconnected" % id)
	player_info.erase(id)
	if id in players_in_game.keys():
		get_node("/root/World/Players").remove_child(players_in_game[id])
	if players_in_game.size() == 0:
		end_game()


remote func register_player(info: Dictionary) -> void:
	print("registered")
	player_info[get_tree().get_rpc_sender_id()] = info


remote func start_game() -> void:
	print("Starting game")
	 # if not game already started
	if not multiplayer_game_started:
		rpc("configure_multiplayer_game", player_info)


func end_game() -> void:
	get_node("/root/World").queue_free()
	player_info.clear()
	players_in_game.clear()
	multiplayer_game_started = false


func configure_client() -> void:
	var _err_func_conn_to_server = get_tree().connect("connected_to_server", self, "client_connected_ok")
	var _err_func_conn_failed = get_tree().connect("connection_failed", self, "client_connected_fail")
	var _err_func_disconn_from_server = get_tree().connect("server_disconnected", self, "client_disconnected")


func _physics_process(_delta: float) -> void:
	if server != null && server.is_listening():
		server.poll()
	if client != null && client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		client.poll()


func client_connected_ok() -> void:
	is_network_connected = true
	rpc_id(1, "register_player", {position = Vector2.ZERO})


func client_connected_fail() -> void:
	print("Could not connect to server")
	

func client_disconnected() -> void:
	is_network_connected = false
	print("Server kicked us")


func connect_to_server() -> void:
	client = WebSocketClient.new()
	var create_client_error = client.connect_to_url(SERVER_URL, PoolStringArray(), true)
	if create_client_error != OK:
		print("Create client error: " + str(create_client_error))
		return 
	get_tree().network_peer = client


remotesync func configure_multiplayer_game(info: Dictionary) -> void:
	player_info = info
	
	if not get_tree().is_network_server():
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
