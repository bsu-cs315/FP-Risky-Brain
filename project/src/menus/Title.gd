extends Node2D


func _on_PlayButton_pressed() -> void:
	Server.configure_singleplayer_game()


func _on_MultiplayerButton_pressed() -> void:
	var _change_scene_err = get_tree().change_scene("res://src/menus/LobbyMenu.tscn")