extends Weapon


func _init(player: Node) -> void:
	damage = 1.0
	bullet = load("res://src/Bullet.tscn")
	max_ammo = 100
	current_ammo = max_ammo
	bullet_speed = 100
	shooter = player
	max_lifetime = 1.0
	shoot_point_node = player.get_node("Body/PistolShootPoint")

