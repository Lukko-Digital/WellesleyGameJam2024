extends Area2D

@onready var door_sprite: Sprite2D = $Sprite2D

func _ready():
	door_sprite.frame = 2


func _process(delta):
	if Input.is_action_just_pressed("attack") and (!get_overlapping_bodies().is_empty()):
		get_tree().change_scene_to_file("res://levels/credits.tscn")


func _on_body_entered(body):
	door_sprite.frame = 3


func _on_body_exited(body):
	door_sprite.frame = 2
