extends KinematicBody2D


export var movement_speed:= 100.0
export var health:= 100
export var damage:= 35
export var attack_time:= 0.5
export var bounty:= 50

var alive:= true
var movement_dir:= Vector2(0.0, 0.0)
var target: Node2D
var areas_to_damage: Array
var attack_timer:= Timer.new()


func _physics_process(_delta: float) -> void:
	find_player()
	move_toward_player()
	if health <= 0:
		die()


func find_player() -> void:
	if PlayerInfo.player_nodes[0] != null:
		target = PlayerInfo.player_nodes[0]


func move_toward_player() -> void:
	movement_dir = position.direction_to(target.position)
	var _linear_velocity = move_and_slide(movement_dir * movement_speed)
	rotation = movement_dir.angle() - (PI / 2)


func take_damage(damage_incoming: int, area: Area2D, attacker: Node) -> void:
	if !alive:
		return
	var damage_to_take:= damage_incoming
	var reward:= 0
	if area.name == "HeadArea":
		damage_to_take = damage_incoming * 2
	if attacker.has_method("add_currency"):
		if health < damage_to_take:
			reward += health
		else:
			reward += damage_to_take
	health -= damage_to_take
	if health <= 0:
		if attacker.has_method("add_currency"):
			reward += bounty
		die()
	attacker.add_currency(reward)


func die() -> void:
	alive = false
	queue_free()


func _on_AttackArea_area_entered(area) -> void:
	var owner: Node = area.owner
	if owner == null:
		return
	if owner.has_method("take_damage"):
		if areas_to_damage.size() == 0:
			$Body/AttackArea/AttackTimer.start(attack_time)
		areas_to_damage.append(area)


func _on_AttackArea_area_exited(area) -> void:
	var owner: Node = area.owner
	if owner == null:
		return
	if owner.has_method("take_damage"):
		if areas_to_damage.size() == 0:
			$Body/AttackArea/AttackTimer.stop()
		areas_to_damage.remove(areas_to_damage.find(area))


func _on_AttackTimer_timeout() -> void:
	for area in areas_to_damage:
		area.owner.take_damage(damage, area, self)
