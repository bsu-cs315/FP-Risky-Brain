extends Node


var rng = RandomNumberGenerator.new()
var spawn_timer:= Timer.new()

onready var spawn_points: Array = get_tree().get_nodes_in_group("EnemySpawnPoints")
onready var zombie: Resource = load("res://src/enemies/Zombie.tscn")


func _ready():
	rng.randomize()
	add_child(spawn_timer)
	spawn_timer.connect("timeout", self, "spawn_enemy")
	spawn_timer.one_shot = true
	spawn_timer.start(1)


func spawn_enemy():
	var random_spawn_point_index: int = rng.randi_range(0, spawn_points.size() - 1)
	var random_spawn_point: Node2D = spawn_points[random_spawn_point_index]
	var random_spawn_timer_cooldown: float = rng.randf_range(0.1, 3)
	var new_enemy: Node2D = zombie.instance()
	get_parent().add_child(new_enemy)
	new_enemy.position = random_spawn_point.position
	spawn_timer.start(random_spawn_timer_cooldown)
	