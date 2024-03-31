extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	anim.play("fade_title")
	await anim.animation_finished
	anim.play("fade_tutorial")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://src/anubis_scene/anubis_scene.tscn")
