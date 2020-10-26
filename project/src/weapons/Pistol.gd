extends Weapon


func _init(player: Node) -> void:
	damage = 1.0
	bullet = load("res://src/weapons/Bullet.tscn")
	max_ammo = 100
	current_ammo = max_ammo
	max_mag_size = 12
	current_mag_ammo = max_mag_size
	bullet_speed = 1000
	shot_cooldown = 0.15
	shooter = player
	max_lifetime = 1.0
	shoot_point_node = player.get_node("Body/PistolShootPoint")
	player_body_sprite = load("res://assets/visual/player/player_body_pistol.png")

