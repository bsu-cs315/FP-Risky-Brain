class_name Weapon
extends Node


var weapon_id: String
var shooter: Node
var damage: int
var bullet: Resource
var player_body_sprite: Texture
var bullet_speed: float
var shot_cooldown: float #cooldown between shots in seconds
var shot_cooldown_timer:= Timer.new()
var max_ammo: int
var current_ammo: int
var max_mag_size: int
var current_mag_ammo: int
var max_lifetime: float

var shoot_point_node: Node


func _init() -> void:
	print("wep")
	
	
func shoot() -> void:
	if !shot_cooldown_timer.is_inside_tree():
		shooter.add_child(shot_cooldown_timer)
		shot_cooldown_timer.one_shot = true
	if shot_cooldown_timer.time_left == 0.0 and current_ammo > 0:
		var proj: Area2D = bullet.instance()
		proj.initialize(self)
		shooter.get_tree().get_root().get_node("Main").add_child(proj)
		shot_cooldown_timer.start(shot_cooldown)
		current_ammo -= 1


