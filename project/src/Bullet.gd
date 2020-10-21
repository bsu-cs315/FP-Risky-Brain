extends Area2D


export var max_lifetime: float = 1.0

var direction: Vector2
var speed: float = 1000.0
var lifetime: float = 0.0


func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	lifetime += delta
	if lifetime >= max_lifetime:
		queue_free()
