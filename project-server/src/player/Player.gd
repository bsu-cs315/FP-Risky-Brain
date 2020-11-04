extends KinematicBody2D

signal died


export var movement_speed: float = 250.0
export var health: int = 100
export var player_id:= 1

var inputs_to_be_processed : Array
var last_processed_input_id := 0
var inventory:= Inventory.new()
var currency:= 0
var alive: bool = true
var movement_dir: Vector2 = Vector2(0.0, 0.0)
var velocity : Vector2
var shoot_dir: Vector2

onready var current_weapon: Weapon
onready var bullet: Resource = load("res://src/weapons/Bullet.tscn")


remote func send_player_inputs(data: Dictionary):
	inputs_to_be_processed.append(data)


func _ready():
	inventory.primary = load("res://src/weapons/Shotgun.gd").new(self)
	inventory.secondary = load("res://src/weapons/Pistol.gd").new(self)
	current_weapon = inventory.primary


func _physics_process(delta):
	if inputs_to_be_processed.empty():
		return
	move()
	# move this player on all clients
	rpc("send_puppet_data", inputs_to_be_processed[0], position, rotation)
	if not inputs_to_be_processed.empty():
		rpc("validate_movements", position, inputs_to_be_processed[0].id)
	# remove what we just used
	inputs_to_be_processed.pop_front()


func move() -> void:
	var inputs : Dictionary = inputs_to_be_processed[0]
	if inputs.empty():
		return
	movement_dir = get_movement_dir(inputs)
	shoot_dir = get_shoot_dir(inputs, position)
	if inputs.primary:
		current_weapon = inventory.primary
	if inputs.secondary:
		current_weapon = inventory.secondary
	if inputs.fire:
		if weapon_can_fire():
			current_weapon.shoot()
	if inputs.reload:
		current_weapon.reload()
	rotation = get_rot(inputs, position)
	move_and_slide(movement_dir * movement_speed)


func get_movement_dir(inputs: Dictionary) -> Vector2:
	movement_dir = Vector2.ZERO
	if inputs.left:
		movement_dir.x -= 1.0
	if inputs.right:
		movement_dir.x += 1.0
	if inputs.up:
		movement_dir.y -= 1.0
	if inputs.down:
		movement_dir.y += 1.0
	return movement_dir.normalized()


func get_shoot_dir(inputs: Dictionary, pos: Vector2) -> Vector2:
	return pos.direction_to(inputs.mouse_pos)


func get_rot(inputs: Dictionary, pos: Vector2) -> float:
	return get_shoot_dir(inputs, pos).angle() - (PI/2)


func weapon_can_fire() -> bool:
	$RayCast2D.cast_to = Vector2(current_weapon.shoot_point_node.position.x, current_weapon.shoot_point_node.position.y)
	return not $RayCast2D.is_colliding()
