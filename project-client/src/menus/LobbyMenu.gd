extends Node


func _on_StartButton_pressed():
	Server.rpc_id(1, "start_game")


func _on_JoinButton_pressed():
	Server.connect_to_server()
	$JoinGameField.hide()
	$JoinButton.hide()
	$StartButton.show()
