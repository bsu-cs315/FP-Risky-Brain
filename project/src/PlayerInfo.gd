extends Node


var playerNode: Node2D


func _ready() -> void:
	get_nodes()


func get_nodes() -> void:
	playerNode = get_node("/root/Main/Player")
