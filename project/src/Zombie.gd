extends KinematicBody2D


export var movement_speed: float = 100.0
export var health: int = 100

var movement_dir: Vector2 = Vector2(0.0, 0.0)
var target: Node2D


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
	if area.name == "HeadArea":
		health -= damage * 2
		took_damage = true
	if health <= 0:
		die()
	return took_damage
	
func die() -> void:
	get_parent().remove_child(self)
	
