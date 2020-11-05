extends Node


var player_nodes: Array
	
	
func get_player_nodes() -> void:
	player_nodes = get_node("/root/World/Players").get_children()
