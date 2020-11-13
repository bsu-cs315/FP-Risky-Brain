extends Node2D


export var linked_door_path: NodePath

var linked_door: Interactable


func _ready():
	if linked_door_path:
		linked_door = get_node(linked_door_path)
	
	
func can_spawn() -> bool:
	if !linked_door or linked_door.opened:
		return true
	return false
