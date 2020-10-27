extends Node


const SERVER_PORT = 90
const MAX_PLAYERS = 2


func _on_StartButton_pressed():
	get_tree().change_scene("res://src/Main.tscn")


func _on_HostButton_pressed():
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	$JoinButton.hide()
	$JoinGameField.hide()
	$HostButton.hide()
	$StartButton.show()


func _on_JoinButton_pressed():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client("localhost", SERVER_PORT)
	get_tree().network_peer = peer
	$JoinGameField.hide()
	$JoinButton.hide()
	$HostButton.hide()


func get_join_ip_address() -> String:
	return $JoinGameField.text
