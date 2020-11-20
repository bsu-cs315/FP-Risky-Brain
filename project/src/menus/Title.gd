extends Node2D


func _on_PlayButton_pressed() -> void:
	GameState.configure_singleplayer_game()


func _on_MultiplayerButton_pressed() -> void:
	GameState.connect_to_server()
	var _change_scene_err = get_tree().change_scene("res://src/menus/LobbyMenu.tscn")


func _on_CreditsButton_pressed():
	var _change_scene_err = get_tree().change_scene("res://src/menus/Credits.tscn")
