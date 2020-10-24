class_name Weapon
extends Node


var shooter: Node
var damage: int
var bullet: Resource
var bullet_speed: float
var max_ammo: int
var current_ammo: int
var max_lifetime: float

var shoot_point_node: Node


func _ready() -> void:
	assert(shooter, "Bullet speed must be initialized!")
	assert(damage, "Damage must be initialized!")
	assert(bullet, "Bullet resource must be initialized!")
	assert(bullet_speed, "Bullet speed must be initialized!")
	assert(max_ammo, "Max ammo must be initialized!")
	assert(current_ammo, "Current ammo must be initialized!")
	assert(max_lifetime, "Max lifetime must be initialized!")
	assert(shoot_point_node, "Shoot point must be initialized!")
	

func shoot() -> void:
	var proj: Area2D = bullet.instance()
	proj.initialize(self)
	shooter.get_tree().get_root().get_node("Main").add_child(proj)

