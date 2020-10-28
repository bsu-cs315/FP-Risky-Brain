extends KinematicBody2D

signal died

export var movement_speed: float = 250.0
export var health: int = 100
export var player_id:= 1

var inputs : Dictionary
var inventory:= Inventory.new()
var currency:= 0
var alive: bool = true
var movement_dir: Vector2 = Vector2(0.0, 0.0)
var velocity : Vector2
var mouse_pos: Vector2
var shoot_dir: Vector2

onready var current_weapon: Weapon
onready var bullet: Resource = load("res://src/weapons/Bullet.tscn")
var camera : Camera2D = Camera2D.new()


func _ready():
	inventory.primary = load("res://src/weapons/Shotgun.gd").new(self)
	inventory.secondary = load("res://src/weapons/Pistol.gd").new(self)
	current_weapon = inventory.primary
	change_weapon_sprite()
	if is_network_master():
		camera.current = true
		camera.zoom = Vector2(1, 1)
		add_child(camera)


func _physics_process(delta: float) -> void:
	if str(get_tree().get_network_unique_id()) == name:
		inputs = get_inputs()
		move()
		rpc_id(1, "send_player_inputs", inputs)
	else:
		pass


remote func check_position(pos: Vector2):
	if pos != position:
		position = pos


func get_inputs() -> Dictionary:
	var inputs : Dictionary = {
		left = Input.is_action_pressed("game_left"),
		right = Input.is_action_pressed("game_right"),
		up = Input.is_action_pressed("game_up"),
		down = Input.is_action_pressed("game_down"),
		primary = Input.is_action_just_pressed("game_primary"),
		secondary = Input.is_action_just_pressed("game_secondary"),
		fire = Input.is_action_pressed("game_fire"),
		mouse_pos = get_global_mouse_position()
	}
	
	return inputs
	

func change_weapon_sprite():
	var frames:= SpriteFrames.new()
	frames.add_animation("normal")
	frames.add_frame("normal", current_weapon.player_body_sprite, 0)
	$Body.frames = frames
	$Body.animation = "normal"
	$Body.frame = 0
	

func move() -> void:
	movement_dir = Vector2.ZERO
	mouse_pos = inputs.mouse_pos
	shoot_dir = position.direction_to(mouse_pos)
	if inputs.left:
		movement_dir.x -= 1.0
	if inputs.right:
		movement_dir.x += 1.0
	if inputs.up:
		movement_dir.y -= 1.0
	if inputs.down:
		movement_dir.y += 1.0
	if inputs.primary:
		current_weapon = inventory.primary
		change_weapon_sprite()
	if inputs.secondary:
		current_weapon = inventory.secondary
		change_weapon_sprite()
	if inputs.fire:
		current_weapon.shoot()
	if Input.is_action_pressed("game_reload"):
		current_weapon.reload()
	rotation = shoot_dir.angle() - (PI / 2)
	movement_dir = movement_dir.normalized()
	velocity = movement_dir * movement_speed
	move_and_slide(velocity)

	
	
func add_currency(amount: int) -> void:
	currency += amount
	

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
	


