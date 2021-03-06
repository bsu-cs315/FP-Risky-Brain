class_name Weapon
extends Node


var weapon_id: String
var shooter: Node
var damage: int
var bullet: Resource
var player_animation_name: String
var bullet_speed: float
var shot_cooldown: float #cooldown between shots in seconds
var shot_cooldown_timer:= Timer.new()
var player_sprite: AnimatedSprite
var audio_player: AudioStreamPlayer2D
var audio_stream: AudioStream
var ammo_total_max: int
var ammo_total_current: int
var ammo_mag_max: int
var ammo_mag_current: int
var max_lifetime: float

var shoot_point_node: Node
	
	
func shoot() -> void:
	if !shot_cooldown_timer.is_inside_tree():
		shooter.add_child(shot_cooldown_timer)
		shot_cooldown_timer.one_shot = true
	if shot_cooldown_timer.time_left == 0.0 and ammo_mag_current > 0:
		var proj: Area2D = bullet.instance()
		proj.initialize(self)
		shooter.get_node("/root/World").add_child(proj)
		shot_cooldown_timer.start(shot_cooldown)
		play_fire_sound()
		player_sprite.frame = 1 # play shooting from the second frame
		player_sprite.play() # animation set in player.gd change_weapon_sprite
		decrement_ammo(1)
		
		
func stop_animation() -> void:
	player_sprite.stop()
	
	
func play_fire_sound() -> void:
	var new_audio_player = AudioStreamPlayer2D.new()
	new_audio_player.volume_db = -10
	shooter.add_child(new_audio_player)
	new_audio_player.stream = audio_stream
	new_audio_player.play()
	yield(new_audio_player, "finished")
	
	
func reload() -> void:
	ammo_mag_current = int(min(ammo_mag_max, ammo_total_current))


func decrement_ammo(amount: int) -> void:
	ammo_mag_current -= amount
	ammo_total_current -= amount
	
	
func refill_ammo() -> void:
	ammo_total_current = ammo_total_max
