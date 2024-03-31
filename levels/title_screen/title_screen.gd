extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	anim.play("fade_title")
	await anim.animation_finished
	anim.play("fade_tutorial")
	await anim.animation_finished
	# !!!! TRANSITION HERE !!!!
