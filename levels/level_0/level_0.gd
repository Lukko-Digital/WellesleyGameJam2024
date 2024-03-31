extends Node2D

@onready var ranged_guy_scene = preload("res://src/enemies/ranged_guy.tscn")
@onready var enemies = $enemies

var WAVES_TO_KILL = 3

var SPAWN_POINTS = [
#	Vector2(-222, -73),
	Vector2(-222, 100),
	Vector2(222, -73)
#	Vector2(222, 100)
]

var waves_spawned = 0


func _ready():
	spawn_wave()
	await get_tree().create_timer(15).timeout
	spawn_wave()
	await get_tree().create_timer(15).timeout
	$map/Door.activate()


func spawn_wave():
	waves_spawned += 1
	for pos in SPAWN_POINTS:
		var instance = ranged_guy_scene.instantiate()
		instance.position = pos
		enemies.add_child(instance)
