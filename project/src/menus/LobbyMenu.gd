extends Node


func _on_StartButton_pressed() -> void:
	Server.is_multiplayer = true
	if Server.is_network_connected:
		Server.rpc_id(1, "start_game")


func _on_JoinButton_pressed() -> void:
	Server.connect_to_server()
	$JoinGameField.hide()
	$JoinButton.hide()
	$StartButton.show()
