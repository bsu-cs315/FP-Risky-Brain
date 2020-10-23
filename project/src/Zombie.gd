extends KinematicBody2D


export var movement_speed:= 100.0
export var health:= 100
export var damage:= 35
export var attack_time:= 0.75

var movement_dir:= Vector2(0.0, 0.0)
var target: Node2D
var areas_to_damage: Array
var attack_timer:= Timer.new()


func _ready() -> void:
	find_player()


func _physics_process(delta: float) -> void:
	move_toward_player()
	if health <= 0:
		die()
		
		
func find_player() -> void:
	target = PlayerInfo.playerNode


func move_toward_player() -> void:
	movement_dir = position.direction_to(target.position)
	move_and_slide(movement_dir * movement_speed)
	rotation = movement_dir.angle() - (PI / 2)
	

func take_damage(damage: int, area: Area2D) -> bool:
	var took_damage: bool = false
	if area.name == "BodyArea":
		health -= damage
		took_damage = true
		print("HIT")
	if area.name == "HeadArea":
		health -= damage * 2
		took_damage = true
		print("HEADSHOT")
	if health <= 0:
		die()
	return took_damage
	
	
func die() -> void:
	get_parent().remove_child(self)


func _on_AttackArea_area_entered(area):
	var owner: Node = area.owner
	if owner == null:
		return
	if owner.has_method("take_damage"):
		if areas_to_damage.size() == 0:
			$Body/AttackArea/AttackTimer.start(attack_time)
		areas_to_damage.append(area)


func _on_AttackArea_area_exited(area):
	var owner: Node = area.owner
	if owner == null:
		return
	if owner.has_method("take_damage"):
		if areas_to_damage.size() == 0:
			$Body/AttackArea/AttackTimer.stop()
		areas_to_damage.remove(areas_to_damage.find(area))


func _on_Timer_timeout():
	for area in areas_to_damage:
		area.owner.take_damage(damage, area)
