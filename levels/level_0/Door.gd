extends Area2D

@onready var door_sprite: AnimatedSprite2D = $DoorSprite

var active = false

func _ready():
	door_sprite.play("default")


func activate():
	active = true
	door_sprite.play("blue")


func _process(delta):
	if Input.is_action_just_pressed("attack") and active and (!get_overlapping_bodies().is_empty()):
		get_tree().change_scene_to_file("res://src/anubis_scene/two_doors_end.tscn")


func _on_body_entered(body):
	if active:
		door_sprite.play("blue_close")


func _on_body_exited(body):
	if active:
		door_sprite.play("blue")
