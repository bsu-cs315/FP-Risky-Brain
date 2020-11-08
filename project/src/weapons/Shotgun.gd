extends Weapon


const BULLET_RELOAD_TIME = .4

var pellet_count:= 10
var pellet_inaccuracy:= deg2rad(20.0)
var reloading:= false
var reload_timer := Timer.new()
var shotgun_cock_sound: AudioStream = load("res://assets/audio/shotgun_cock.wav")


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
	reload_timer.one_shot = true
	reload_timer.connect("timeout", self, "load_single_bullet")
	shoot_point_node = player.get_node("Body/ShotgunShootPoint")
	player_sprite = player.get_node("Body")
	player_sprite.connect("animation_finished", self, "stop_animation")
	audio_player = player.get_node("WeaponAudioPlayer")
	audio_stream = load("res://assets/audio/shotgun_fire.wav")
	shot_cooldown_timer.one_shot = true
	shooter.call_deferred("add_child", shot_cooldown_timer)


func shoot() -> void:
	if shot_cooldown_timer.time_left == 0.0 and ammo_mag_current > 0 and not reloading:
		for i in range(floor(-pellet_count / 2.0), floor(pellet_count / 2.0)): #evenly spreads pellets
			var pellet_angle: float = shooter.shoot_dir.angle() + (i * pellet_inaccuracy) / pellet_count
			var proj: Area2D = bullet.instance()
			proj.initialize(self)
			proj.direction = Vector2(cos(pellet_angle), sin(pellet_angle))
			proj.rotation = pellet_angle - (PI / 2)
			shooter.get_node("/root/World").add_child(proj)
		shot_cooldown_timer.start(shot_cooldown)
		play_fire_sound()
		player_sprite.frame = 1 # play shooting from the second frame
		player_sprite.play() # animation set in player.gd change_weapon_sprite
		decrement_ammo(1)


func play_fire_sound() -> void:
	var new_audio_player = AudioStreamPlayer2D.new()
	new_audio_player.volume_db = -10
	shooter.add_child(new_audio_player)
	new_audio_player.stream = audio_stream
	new_audio_player.connect("finished", self, "play_cock_sound")
	new_audio_player.play()
	yield(new_audio_player, "finished")
	
	
func play_cock_sound() -> void:
	if shooter.current_weapon is get_script():
		var new_audio_player = AudioStreamPlayer2D.new()
		new_audio_player.volume_db = -10
		shooter.add_child(new_audio_player)
		new_audio_player.stream = shotgun_cock_sound
		new_audio_player.play()
		yield(new_audio_player, "finished")


func reload() -> void:
	if !reloading and get_empty_mag_slots() != 0:
		reloading = true
		shooter.add_child(reload_timer)
		# start timer so it can add a bullet when it expires
		reload_timer.start(BULLET_RELOAD_TIME)


func load_single_bullet() -> void:
	if get_empty_mag_slots() > 0:
		ammo_mag_current += 1
	if get_empty_mag_slots() > 0:
		# if there are still empty spots in mag, add another bullet when the timer expires again
		reload_timer.start(BULLET_RELOAD_TIME)
	else:
		reloading = false
		shooter.remove_child(reload_timer)


func get_empty_mag_slots() -> int:
	return int(min(ammo_mag_max, ammo_total_current) - ammo_mag_current)
