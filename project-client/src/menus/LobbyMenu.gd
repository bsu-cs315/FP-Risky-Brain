extends Node


const SERVER_PORT = 1407
const SERVER_IP = "35.239.181.55"
#const SERVER_IP = "localhost"

func _on_StartButton_pressed():
	Server.rpc_id(1, "start_game")


func _on_JoinButton_pressed():
	var peer = NetworkedMultiplayerENet.new()
	var create_client_error = peer.create_client(SERVER_IP, SERVER_PORT)
	print("Attempted to create client")
	if create_client_error != OK:
		print(create_client_error)
		return
	get_tree().network_peer = peer
	$JoinGameField.hide()
	$JoinButton.hide()
	$StartButton.show()
