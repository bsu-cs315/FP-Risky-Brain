extends KinematicBody2D

signal died


export var max_movement_speed: float = 250.0

# misc.
var regen_cooldown:= 3.0
var slowdown_duration:= 0.5

# movement
var current_movement_speed: float = 250.0
var velocity : Vector2
var shoot_dir: Vector2

# player info
var current_weapon: Weapon
var currency:= 10000
var health: int = 100
var inventory:= Inventory.new()


# player inputs / pos
var owner_inputs : Dictionary
var past_player_inputs:= {}
var past_player_positions := {}

# puppet inputs / pos
var puppet_inputs : Dictionary
var puppet_position:= Vector2.ZERO
var puppet_rotation:= 0.0
var is_alive:= true
var movement_dir: Vector2 = Vector2(0.0, 0.0)
var mouse_pos: Vector2

# server input processing
var inputs_to_be_processed : Array
var last_processed_input_id := 0

onready var bullet: Resource = load("res://src/weapons/Bullet.tscn")


func _ready() -> void:
	inventory.primary = load("res://src/weapons/Pistol.gd").new(self)
	change_current_weapon(inventory.primary)
	if GameState.networked_client == null || is_network_master():
		$Camera2D.current = true


func _physics_process(_delta: float) -> void:
	if GameState.is_server:
		_server_tick()
	elif health > 0:
		_client_tick()

# <---Server-Exclusive Functions--->

func _server_tick() -> void:
	if not get_tree().is_network_server():
		return
	if not inputs_to_be_processed.empty():
		move(inputs_to_be_processed[0])
		rpc("send_puppet_data", inputs_to_be_processed[0], position, rotation)
		rpc("validate_movements", position, inputs_to_be_processed[0].id)
		inputs_to_be_processed.pop_front()


remote func send_player_inputs(data: Dictionary) -> void:
	inputs_to_be_processed.append(data)

# END <---Server-Exclusive Functions--->


func _client_tick() -> void:
	if not GameState.is_client_connected_to_server(): # Single Player
		owner_inputs = get_inputs(0)
		show_interactable_information()
		move(owner_inputs)
	elif is_network_master():
		show_interactable_information()
		move_owned_network_player()
	else:
		#I'm not controlling player, move based on server pos, rot
		position = puppet_position
		rotation = puppet_rotation


# <---Player Controls--->

func get_inputs(timestamp: int) -> Dictionary:
	var inputs : Dictionary = {
		id = timestamp,
		left = Input.is_action_pressed("game_left"),
		right = Input.is_action_pressed("game_right"),
		up = Input.is_action_pressed("game_up"),
		down = Input.is_action_pressed("game_down"),
		primary = Input.is_action_just_pressed("game_primary"),
		secondary = Input.is_action_just_pressed("game_secondary"),
		fire = Input.is_action_pressed("game_fire"),
		reload = Input.is_action_pressed("game_reload"),
		interact = Input.is_action_just_pressed("game_interact"),
		mouse_pos = get_global_mouse_position()
	}
	return inputs


func move_owned_network_player() -> void:
	#I am controlling this player, move based on my inputs
	var timestamp = OS.get_ticks_msec()
	owner_inputs = get_inputs(timestamp)
	past_player_inputs[timestamp] = owner_inputs
	move(owner_inputs)
	past_player_positions[timestamp] = position
	rpc_id(1, "send_player_inputs", owner_inputs)


func move(inputs: Dictionary) -> void:
	if inputs.empty():
		return
	if inputs.primary: # player always has a primary
		change_current_weapon(inventory.primary)
	if inputs.secondary && inventory.secondary != null:
		change_current_weapon(inventory.secondary)
	if inputs.fire && weapon_can_fire():
		current_weapon.shoot()
	if inputs.reload:
		current_weapon.reload()
	if inputs.interact:
		interact()
	rotation = get_rot(inputs, position)
	shoot_dir = get_shoot_dir(inputs, position) # need shoot dir for weapon
	velocity = get_movement_dir(inputs) * current_movement_speed # need velocity of player for walking particles
	var _linear_velocity = move_and_slide(velocity)


func get_interactable_areas() -> Array:
	var overlapping_areas : Array = $Body/PlayerInteractArea.get_overlapping_areas()
	var interactable_areas := []
	for area in overlapping_areas:
		if area is Interactable:
			interactable_areas.append(area)
	return interactable_areas


func get_targeted_interactable() -> Interactable:
	var interactable_areas:= get_interactable_areas()
	var targeted_interactable: Interactable
	if interactable_areas.size() > 0:
		var possible_interactables: Array = []
		for area in interactable_areas:
			if player_can_interact(area.global_position) and area.is_interactable:
				possible_interactables.append(area)
		if possible_interactables.size() > 0:
			var closest_area: Area2D = possible_interactables[0]
			for area in possible_interactables:
				if position.distance_to(area.global_position) < position.distance_to(closest_area.global_position):
					closest_area = area
			targeted_interactable = closest_area
	return targeted_interactable


func show_interactable_information() -> void:
	var targeted_interactable := get_targeted_interactable()
	if get_targeted_interactable():
		targeted_interactable.show_information(self)
	else:
		PlayerInfo.hud.set_interactable_label_text("")


func interact() -> void:
	var targeted_interactable := get_targeted_interactable()
	if targeted_interactable:
		targeted_interactable.interact(self)


func get_movement_dir(inputs: Dictionary) -> Vector2:
	movement_dir = Vector2.ZERO
	if inputs.left:
		movement_dir.x -= 1.0
	if inputs.right:
		movement_dir.x += 1.0
	if inputs.up:
		movement_dir.y -= 1.0
	if inputs.down:
		movement_dir.y += 1.0
	return movement_dir.normalized()


func get_shoot_dir(inputs: Dictionary, pos: Vector2) -> Vector2:
	return pos.direction_to(inputs.mouse_pos)


func get_rot(inputs: Dictionary, pos: Vector2) -> float:
	return get_shoot_dir(inputs, pos).angle() - (PI/2)


func change_current_weapon(weapon: Weapon) -> void:
	current_weapon = weapon
	change_weapon_sprite()
	change_weapon_sound()


func change_weapon_sprite() -> void:
	$Body.animation = current_weapon.player_animation_name
	$Body.stop()
	$Body.frame = 0
	
	
func change_weapon_sound() -> void:
	$WeaponAudioPlayer.stream = current_weapon.audio_stream


func weapon_can_fire() -> bool:
	$WeaponShootPointRayCast.cast_to = Vector2(current_weapon.shoot_point_node.position.x, current_weapon.shoot_point_node.position.y)
	return not $WeaponShootPointRayCast.is_colliding()
	
	
func player_can_interact(interactable_pos: Vector2) -> bool:
	$InteractableRayCast.cast_to = (interactable_pos - position).rotated(-rotation)
	$InteractableRayCast.force_raycast_update()
	if $InteractableRayCast.is_colliding():
		if $InteractableRayCast.get_collider().owner is Interactable:
			return true
		else:
			return false
	return true

# END <---Player Controls--->


# <---Client Netcode--->

remote func send_puppet_data(inputs: Dictionary, pos: Vector2, rot: float) -> void:
	puppet_inputs = inputs
	puppet_position = pos
	puppet_rotation = rot


# client validates client position based on server
remote func validate_movements(server_pos: Vector2, last_accepted_input_id: int) -> void:
	if past_player_inputs.size() != 0:
		var player_pos_for_id : Vector2 = past_player_positions[last_accepted_input_id]
		if abs(server_pos.x - player_pos_for_id.x) > 1 || abs(server_pos.y - player_pos_for_id.y) > 1:
			reconciliate(server_pos, last_accepted_input_id)
		# clear player inputs and positions older than last accepted
		for id in past_player_inputs.keys():
			if id < last_accepted_input_id:
				var _erased_input = past_player_inputs.erase(id)
				var _erased_pos = past_player_positions.erase(id)


func reconciliate(server_pos: Vector2, _last_accepted_input_id: int) -> void:
		position = server_pos

# END <---Client Netcode--->


func add_currency(amount: int) -> void:
	assert(amount >= 0)
	currency += amount


func take_damage(damage: int, area: Area2D, _attacker: Node) -> bool:
	var took_damage: bool = false
	if area.name == "PlayerArea":
		health -= damage
		took_damage = true
		if health > 0:
			PlayerInfo.hud.flash_damage_indicator()
	if health <= 0:
		die()
	else:
		$SlowdownTimer.start(slowdown_duration)
		$RegenTimer.start(regen_cooldown)
	return took_damage


func die() -> void:
	PlayerInfo.hud.show_reset_button()
	emit_signal("died")


func _on_RegenTimer_timeout():
	if health > 0:
		health = 100


func _on_SlowdownTimer_timeout():
	if health > 0:
		current_movement_speed = max_movement_speed
