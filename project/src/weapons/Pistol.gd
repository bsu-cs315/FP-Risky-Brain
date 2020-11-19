extends Weapon


func _init(player: Node) -> void:
	damage = 20
	bullet = load("res://src/weapons/Bullet.tscn")
	ammo_total_max = 48
	ammo_total_current = ammo_total_max
	ammo_mag_max = 12
	ammo_mag_current = ammo_mag_max
	bullet_speed = 1000
	shot_cooldown = 0.15
	shooter = player
	max_lifetime = 1.0
	shoot_point_node = player.get_node("Body/PistolShootPoint")
	player_sprite = player.get_node("Body")
	player_animation_name = "pistol"
	audio_player = player.get_node("WeaponAudioPlayer")
	audio_stream = load("res://assets/audio/pistol_fire.wav")

