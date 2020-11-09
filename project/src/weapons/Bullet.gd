extends Area2D


var shooter: Node
var speed: float
var direction: Vector2
var movement_vector: Vector2
var damage: float
var max_lifetime: float
var lifetime: float = 0.0


func initialize(weapon: Weapon) -> void:
	shooter = weapon.shooter
	speed = weapon.bullet_speed
	direction = shooter.shoot_dir
	rotation = shooter.rotation
	damage = weapon.damage
	max_lifetime = weapon.max_lifetime
	position = weapon.shoot_point_node.global_position
	

func _ready() -> void:
	assert(max_lifetime, "Max lifetime must be initialized!")
	assert(speed, "Max lifetime must be initialized!")
	assert(damage, "Max lifetime must be initialized!")
	assert(shooter, "Max lifetime must be initialized!")
	assert(direction, "Max lifetime must be initialized!")
	movement_vector = direction.normalized() * speed * get_physics_process_delta_time()
	$RayCast2D.cast_to = Vector2(0.0, movement_vector.length())


func _physics_process(delta: float) -> void:
	# checks raycast to see if it will collide with anything before moving
	if $RayCast2D.is_colliding():
		var collision: Object = $RayCast2D.get_collider()
		handle_collision(collision)
	position += movement_vector
	lifetime += delta
	if lifetime >= max_lifetime:
		queue_free()


func handle_collision(collision: Object) -> void:
	var owner: Node = collision.owner
	if collision is Area2D and owner.has_method("take_damage"):
		if owner.has_method("take_damage"):
			owner.take_damage(damage, collision, shooter)
			queue_free()
		return
	if collision.get_collision_layer_bit(2): #collide with walls
		queue_free()
