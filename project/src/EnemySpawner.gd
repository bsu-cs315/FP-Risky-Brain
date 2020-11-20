extends Node


var rng = RandomNumberGenerator.new()
var spawn_timer:= Timer.new()

onready var spawn_points: Array = get_tree().get_nodes_in_group("EnemySpawnPoints")
onready var zombie: Resource = load("res://src/enemies/Zombie.tscn")


func _ready() -> void:
	if get_tree().is_network_server():
		rng.randomize()
		add_child(spawn_timer)
		var _err_func_timer_timeout = spawn_timer.connect("timeout", self, "spawn_enemy")
		spawn_timer.one_shot = true
		spawn_timer.start(1)


func spawn_enemy() -> void:
	var random_spawn_timer_cooldown: float = rng.randf_range(1, 3)
	var available_spawn_points:= []
	for i in range(spawn_points.size()):
		var spawn_point = spawn_points[i]
		if spawn_point.can_spawn():
			available_spawn_points.append(spawn_point)
	var random_spawn_point_index: int = rng.randi_range(0, available_spawn_points.size() - 1)
	var random_spawn_point: Node2D = available_spawn_points[random_spawn_point_index]
	
	spawn_timer.start(random_spawn_timer_cooldown)
	if GameState.is_server:
		print("Added multiplayer enemy")
		rpc("add_enemy", random_spawn_point.position)
	else:
		print("Added local enemy")
		add_enemy(random_spawn_point.position)


remotesync func add_enemy(position: Vector2):
	var enemy: Node2D = zombie.instance()
	enemy.position = position
	get_parent().add_child(enemy)
