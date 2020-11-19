extends Node


func _process(_delta) -> void:
	if Server.players_in_lobby.size() == 0:
		$GameStatusLabel.text = "This lobby is empty"
	elif not Server.multiplayer_game_started:
		$GameStatusLabel.text = "%d/4 players in lobby" % Server.players_in_lobby.size()
	else: 
		$GameStatusLabel.text = "There is currently a game in progress"


func _on_StartButton_pressed() -> void:
	Server.is_multiplayer = true
	if Server.is_network_connected:
		Server.rpc_id(1, "start_game")


func _on_JoinButton_pressed() -> void:
	Server.connect_to_server()
	$JoinButton.hide()
	$StartButton.show()


func _on_BackButton_pressed() -> void:
	var _err = get_tree().change_scene("res://src/menus/Title.tscn")
