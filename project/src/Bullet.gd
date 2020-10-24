extends Area2D


var shooter: Node
var speed: float
var direction: Vector2
var damage: float
var max_lifetime: float

var lifetime: float = 0.0


func initialize(weapon: Weapon):
	shooter = weapon.shooter
	speed = weapon.bullet_speed
	direction = shooter.shoot_dir
	damage = weapon.damage
	max_lifetime = weapon.max_lifetime
	position = weapon.shoot_point_node.global_position
	

func _ready():
	assert(max_lifetime, "Max lifetime must be initialized!")
	assert(speed, "Max lifetime must be initialized!")
	assert(damage, "Max lifetime must be initialized!")
	assert(shooter, "Max lifetime must be initialized!")
	assert(direction, "Max lifetime must be initialized!")
	

func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	lifetime += delta
	if lifetime >= max_lifetime:
		queue_free()


func _on_Bullet_area_entered(area):
	var owner: Node = area.owner
	if owner == null:
		return
	if owner.has_method("take_damage"):
		owner.take_damage(damage, area, shooter)
		queue_free()
	

func _on_Bullet_body_entered(body):
	if body.name == "Walls":
		queue_free()
