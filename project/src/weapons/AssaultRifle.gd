extends Weapon


func _init(player: Node) -> void:
	damage = 20
	bullet = load("res://src/weapons/Bullet.tscn")
	ammo_total_max = 120
	ammo_total_current = ammo_total_max
	ammo_mag_max = 30
	ammo_mag_current = ammo_mag_max
	bullet_speed = 1000
	shot_cooldown = 0.10
	shooter = player
	max_lifetime = 1.0
	shoot_point_node = player.get_node("Body/AssaultRifleShootPoint")
	player_sprite = player.get_node("Body")
	var _err_animation_finished = player_sprite.connect("animation_finished", self, "stop_animation")
	audio_player = player.get_node("WeaponAudioPlayer")
	audio_stream = load("res://assets/audio/assault_rifle_fire.wav")
	player_animation_name = "assault_rifle"

