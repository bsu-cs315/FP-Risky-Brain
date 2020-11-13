extends Node


var rng = RandomNumberGenerator.new()
var spawn_timer:= Timer.new()

onready var spawn_points: Array = get_tree().get_nodes_in_group("EnemySpawnPoints")
onready var zombie: Resource = load("res://src/enemies/Zombie.tscn")


func _ready() -> void:
	if not Server.is_multiplayer || get_tree().is_network_server():
		rng.randomize()
		add_child(spawn_timer)
		var _err_func_timer_timeout = spawn_timer.connect("timeout", self, "spawn_enemy")
		spawn_timer.one_shot = true
		spawn_timer.start(1)


func spawn_enemy() -> void:
	var random_spawn_point_index: int = rng.randi_range(0, spawn_points.size() - 1)
	var random_spawn_point: Node2D = spawn_points[random_spawn_point_index]
	var random_spawn_timer_cooldown: float = rng.randf_range(1, 3)
	
	spawn_timer.start(random_spawn_timer_cooldown)
	if Server.is_multiplayer:
		print("Added multiplayer enemy")
		rpc("add_enemy", random_spawn_point.position)
	else:
		add_enemy(random_spawn_point.position)


remotesync func add_enemy(position: Vector2):
	var enemy: Node2D = zombie.instance()
	enemy.position = position
	get_parent().add_child(enemy)
