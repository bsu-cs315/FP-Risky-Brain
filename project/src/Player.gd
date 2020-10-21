extends KinematicBody2D


export var movement_speed: float = 250.0

var alive: bool = true
var movement_dir: Vector2 = Vector2(0.0, 0.0)
var mouse_pos: Vector2
var shoot_dir: Vector2

onready var bullet: Resource = load("res://src/Bullet.tscn")


func _physics_process(delta: float) -> void:
	if alive:
		get_input()
		move()
		rotate_towards_cursor()
		

func get_input() -> void:
	movement_dir = Vector2(0.0, 0.0)
	mouse_pos = get_global_mouse_position()
	shoot_dir = position.direction_to(mouse_pos)
	if Input.is_action_pressed("game_left"):
		movement_dir.x -= 1.0
	if Input.is_action_pressed("game_right"):
		movement_dir.x += 1.0
	if Input.is_action_pressed("game_up"):
		movement_dir.y -= 1.0
	if Input.is_action_pressed("game_down"):
		movement_dir.y += 1.0
	if Input.is_action_pressed("game_fire"):
		shoot()
	movement_dir = movement_dir.normalized()
	

func move() -> void:
	move_and_slide(movement_dir * movement_speed)


func rotate_towards_cursor() -> void:
	rotation = shoot_dir.angle() - (PI / 2)
	
	
func shoot() -> void:
	var proj: Area2D = bullet.instance()
	get_tree().get_root().get_node("Main").add_child(proj)
	proj.direction = shoot_dir
	proj.position = $Body/PistolShootPoint.global_position
	proj.rotation = rotation
