extends Node2D


func _on_PlayButton_pressed():
	Server.configure_single_player_game()


func _on_MultiplayerButton_pressed():
	get_tree().change_scene("res://src/menus/LobbyMenu.tscn")
