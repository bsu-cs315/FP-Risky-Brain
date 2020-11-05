extends KinematicBody2D


var opened := false
var start_rot := rotation


func _process(delta) -> void:
	if rotation != start_rot + PI:
		unlock(PI, delta)


func unlock(amount_to_rotate: float, delta) -> void:
	rotation = lerp_angle(rotation, + amount_to_rotate, delta)
