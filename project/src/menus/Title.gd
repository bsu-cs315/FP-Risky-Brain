extends Node2D


func _on_PlayButton_pressed():
	Server.pre_configure_game()
	get_tree().change_scene("res://src/Main.tscn")


func _on_MultiplayerButton_pressed():
	get_tree().change_scene("res://src/menus/LobbyMenu.tscn")
