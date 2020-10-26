extends Weapon


var pellet_count:= 10
var pellet_inaccuracy:= deg2rad(30.0)


func _init(player: Node) -> void:
	weapon_id = "Shotgun"
	damage = 5.0
	bullet = load("res://src/Bullet.tscn")
	player_body_sprite = load("res://assets/visual/player/player_body_shotgun.png")
	max_ammo = 100
	current_ammo = max_ammo
	shot_cooldown = 0.5
	bullet_speed = 500
	shooter = player
	max_lifetime = 1.0
	shoot_point_node = player.get_node("Body/ShotgunShootPoint")
	print("shot")


func shoot() -> void:
	if !shot_cooldown_timer.is_inside_tree():
		shooter.add_child(shot_cooldown_timer)
		shot_cooldown_timer.one_shot = true
	if shot_cooldown_timer.time_left == 0.0:
		for i in range(floor(-pellet_count / 2.0), floor(pellet_count / 2.0)): #evenly spreads pellets
			var pellet_angle: float = shooter.shoot_dir.angle() + (i * pellet_inaccuracy) / pellet_count
			var proj: Area2D = bullet.instance()
			proj.initialize(self)
			proj.direction = Vector2(cos(pellet_angle), sin(pellet_angle))
			shooter.get_tree().get_root().get_node("Main").add_child(proj)
		shot_cooldown_timer.start(shot_cooldown)



