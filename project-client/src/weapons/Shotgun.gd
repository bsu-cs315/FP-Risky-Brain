extends Weapon


var pellet_count:= 10
var pellet_inaccuracy:= deg2rad(20.0)


func _init(player: Node) -> void:
	weapon_id = "Shotgun"
	damage = 10
	bullet = load("res://src/weapons/Bullet.tscn")
	player_animation_name = "shotgun"
	ammo_total_max = 20
	ammo_total_current = ammo_total_max
	ammo_mag_max = 5
	ammo_mag_current = ammo_mag_max
	shot_cooldown = 1.0
	bullet_speed = 1000
	shooter = player
	max_lifetime = 1.0
	shoot_point_node = player.get_node("Body/ShotgunShootPoint")
	player_sprite = player.get_node("Body")
	player_sprite.connect("animation_finished", self, "stop_animation")
	audio_player = player.get_node("WeaponAudioPlayer")
	audio_player.stream = load("res://assets/audio/shotgun_fire.wav")


func shoot() -> void:
	if !shot_cooldown_timer.is_inside_tree():
		shooter.add_child(shot_cooldown_timer)
		shot_cooldown_timer.one_shot = true
	if shot_cooldown_timer.time_left == 0.0 and ammo_mag_current > 0:
		for i in range(floor(-pellet_count / 2.0), floor(pellet_count / 2.0)): #evenly spreads pellets
			var pellet_angle: float = shooter.shoot_dir.angle() + (i * pellet_inaccuracy) / pellet_count
			var proj: Area2D = bullet.instance()
			proj.initialize(self)
			proj.direction = Vector2(cos(pellet_angle), sin(pellet_angle))
			proj.rotation = pellet_angle - (PI / 2)
			shooter.get_node("/root/World").add_child(proj)
		shot_cooldown_timer.start(shot_cooldown)
		audio_player.play()
		player_sprite.frame = 1
		player_sprite.play()
		decrement_ammo(1)
		
		
func stop_animation() -> void:
	player_sprite.stop()


