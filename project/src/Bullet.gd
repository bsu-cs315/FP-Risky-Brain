extends Area2D


export var max_lifetime: float = 1.0
export var speed: float = 100.0
export var damage: float = 0.0

var shooter: Node
var direction: Vector2
var lifetime: float = 0.0


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
