extends Node


var player_nodes: Array
var hud: Node


func init_player_nodes() -> void:
	player_nodes = get_node("/root/World/Players").get_children()
	hud = get_node("/root/World/HUD")


func get_owned_player() -> KinematicBody2D:
	var my_player : KinematicBody2D
	if get_tree().network_peer != null:
		var my_player_id = get_tree().get_network_unique_id()
		for player in player_nodes:
			if player.name == str(my_player_id):
				my_player = player
	elif player_nodes.size() > 0:
		my_player = player_nodes[0]
	return my_player
