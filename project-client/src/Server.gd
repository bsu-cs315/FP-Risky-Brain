extends Node

const SERVER_URL = "wss://kadedentel.com:403"
#const SERVER_URL = "ws://localhost:403"

var client : WebSocketClient
var is_network_connected := false


func _ready() -> void:
	var _err_func_conn_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _err_func_conn_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _err_func_disconn_from_server = get_tree().connect("server_disconnected", self, "_server_disconnected")


func _physics_process(_delta: float) -> void:
	if Server.client != null && Server.client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		Server.client.poll()


var player_info = { }


func _connected_ok() -> void:
	is_network_connected = true
	rpc_id(1, "register_player", {position = Vector2.ZERO})


func _connected_fail() -> void:
	print("Could not connect to server")
	

func _server_disconnected() -> void:
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
	PlayerInfo.get_player_nodes()


func configure_singleplayer_game() -> void:
	get_node("/root/Title").queue_free()
	var world = load("res://src/Main.tscn").instance()
	get_node("/root").add_child(world)
	var player = preload("res://src/player/Player.tscn").instance()
	player.set_name(str("SinglePlayer"))
	get_node("/root/World/Players").add_child(player)
	player.position = get_node("/root/World/PlayerSpawnPoint").position
	PlayerInfo.get_player_nodes()
