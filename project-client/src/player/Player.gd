extends KinematicBody2D

signal died

export var movement_speed: float = 250.0
export var health: int = 100
export var player_id:= 1

var owner_inputs : Dictionary
var past_player_inputs:= {}
var puppet_inputs : Dictionary
var inventory:= Inventory.new()
var currency:= 0
var alive:= true
var movement_dir: Vector2 = Vector2(0.0, 0.0)
var velocity : Vector2
var mouse_pos: Vector2
var shoot_dir: Vector2


onready var camera:= Camera2D.new()
onready var current_weapon: Weapon
onready var bullet: Resource = load("res://src/weapons/Bullet.tscn")


func _ready():
	inventory.primary = load("res://src/weapons/Shotgun.gd").new(self)
	inventory.secondary = load("res://src/weapons/Pistol.gd").new(self)
	current_weapon = inventory.primary
	change_weapon_sprite()
	if name == "SinglePlayer" || is_network_master():
		camera.current = true
		camera.zoom = Vector2(.5, .5)
		add_child(camera)


func _physics_process(delta: float) -> void:
	if name == "SinglePlayer":
		owner_inputs = get_inputs()
		move(owner_inputs)
		return
	if str(get_tree().get_network_unique_id()) == name:
		#I am controlling this player, move based on my inputs
		owner_inputs = get_inputs()
		past_player_inputs[OS.get_ticks_msec()] = owner_inputs
		move(owner_inputs)
		rpc_id(1, "send_player_inputs", owner_inputs)
	else:
		#I am not in control of this player, move based on server input
		move(puppet_inputs)


remote func send_puppet_inputs(inputs: Dictionary):
	puppet_inputs = inputs


remote func validate_movements(pos: Vector2, rot: float, last_accepted_input_id: int) -> void:
	if past_player_inputs.size() == 0:
		return
	# remove everything BEFORE or same as last accepted
	for id in past_player_inputs.keys():
		if id <= last_accepted_input_id:
			past_player_inputs.erase(id)
		else:
			break
	reapply_inputs(last_accepted_input_id, pos, rot)

	
func reapply_inputs(last_accepted_input_id: int, pos: Vector2, rot: float):
	position = pos
	for id in past_player_inputs.keys():
		move_and_slide(get_movement_dir(past_player_inputs[id]) * movement_speed)
		

func get_inputs() -> Dictionary:
	var inputs : Dictionary = {
		id = OS.get_ticks_msec(),
		left = Input.is_action_pressed("game_left"),
		right = Input.is_action_pressed("game_right"),
		up = Input.is_action_pressed("game_up"),
		down = Input.is_action_pressed("game_down"),
		primary = Input.is_action_just_pressed("game_primary"),
		secondary = Input.is_action_just_pressed("game_secondary"),
		fire = Input.is_action_pressed("game_fire"),
		reload = Input.is_action_pressed("game_reload"),
		mouse_pos = get_global_mouse_position()
	}
	
	return inputs


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


func get_pos(inputs: Dictionary, pos: Vector2) -> Vector2:
	var movement_dir:= get_movement_dir(inputs)
	pos += movement_dir * movement_speed * get_physics_process_delta_time()
	return pos
	

func get_rot(inputs: Dictionary, pos: Vector2) -> float:
	return get_shoot_dir(inputs, pos).angle() - (PI/2)


func get_shoot_dir(inputs: Dictionary, pos: Vector2) -> Vector2:
	return pos.direction_to(inputs.mouse_pos)


# actually moves player
func move(inputs: Dictionary) -> void:
	if inputs.empty():
		return
	movement_dir = get_movement_dir(inputs)
	shoot_dir = get_shoot_dir(inputs, position)
	if inputs.primary:
		current_weapon = inventory.primary
		change_weapon_sprite()
	if inputs.secondary:
		current_weapon = inventory.secondary
		change_weapon_sprite()
	if inputs.fire:
		if weapon_can_fire():
			current_weapon.shoot()
	if inputs.reload:
		current_weapon.reload()
	rotation = get_rot(inputs, position)
	move_and_slide(movement_dir * movement_speed)


func change_weapon_sprite():
	var frames:= SpriteFrames.new()
	frames.add_animation("normal")
	frames.add_frame("normal", current_weapon.player_body_sprite, 0)
	$Body.frames = frames
	$Body.animation = "normal"
	$Body.frame = 0
	cast_weapon_collider()
	
	
func add_currency(amount: int) -> void:
	currency += amount
	

func cast_weapon_collider():
	$RayCast2D.cast_to = Vector2(current_weapon.shoot_point_node.position.x, current_weapon.shoot_point_node.position.y)


func weapon_can_fire() -> bool:
	return not $RayCast2D.is_colliding()


func take_damage(damage: int, area: Area2D, _attacker: Node) -> bool:
	var took_damage: bool = false
	if area.name == "PlayerArea":
		health -= damage
		took_damage = true
	if health <= 0:
		die()
	return took_damage
	

func die() -> void:
	get_parent().remove_child(self)
	emit_signal("died")
	


