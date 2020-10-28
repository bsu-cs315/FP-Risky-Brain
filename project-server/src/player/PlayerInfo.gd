extends Node


var playerNode: Node2D


func get_nodes() -> void:
	playerNode = get_node("/root/World/Players/" + str(get_tree().get_network_unique_id()))
