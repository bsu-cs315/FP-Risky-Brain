extends Area2D


export var max_lifetime: float = 1.0
export var speed: float = 100.0
export var damage: float = 0.0

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
		if owner.take_damage(damage, area):
			queue_free()
