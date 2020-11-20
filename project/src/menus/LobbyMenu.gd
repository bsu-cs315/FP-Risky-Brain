extends Node


func _process(_delta) -> void:
	if GameState.players_in_lobby.size() == 0:
		$GameStatusLabel.text = "This lobby is empty"
	elif not GameState.is_networked_game_running:
		$GameStatusLabel.text = "%d/4 players in lobby" % GameState.players_in_lobby.size()
	else: 
		$GameStatusLabel.text = "There is currently a game in progress"


func _on_StartButton_pressed() -> void:
	if GameState.is_client_connected_to_server():
		GameState.rpc_id(1, "start_game")


func _on_JoinButton_pressed() -> void:
	GameState.rpc_id(1, 'join_game')
	$JoinButton.hide()
	$StartButton.show()


func _on_BackButton_pressed() -> void:
	GameState.networked_client = null
	get_tree().network_peer = GameState.client
	var _err = get_tree().change_scene("res://src/menus/Title.tscn")
