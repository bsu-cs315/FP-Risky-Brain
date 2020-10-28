extends Node


const SERVER_PORT = 90


func _on_StartButton_pressed():
	Server.rpc_id(1, "start_game")


func _on_JoinButton_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client("localhost", SERVER_PORT)
	get_tree().network_peer = peer
	$JoinGameField.hide()
	$JoinButton.hide()
	$StartButton.show()


func get_join_ip_address() -> String:
	return $JoinGameField.text
