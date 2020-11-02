extends Node2D


var dirt_particles = preload("res://src/effects/DirtParticles.tscn").instance()

onready var floors: TileMap = $Floor
	
func _ready():
	add_child(dirt_particles)

func _process(delta):
	for player in $Players.get_children():
		player = player as Node
		var tile_coord = $Floor.world_to_map(player.position)
		var tile_index = $Floor.get_cellv(tile_coord)
		var tile_name = $Floor.tile_set.tile_get_name(tile_index)
		if tile_name == "grass":
			if player.velocity.abs() > Vector2.ZERO:
				dirt_particles.emitting = true
				# leave trail of particles
				dirt_particles.process_material.direction.x = - player.velocity.x
				dirt_particles.process_material.direction.y = - player.velocity.y
				dirt_particles.position = player.position
			else:
				dirt_particles.emitting = false
		else:
			dirt_particles.emitting = false
