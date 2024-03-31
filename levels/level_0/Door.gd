extends Area2D

@onready var door_sprite: AnimatedSprite2D = $DoorSprite

var active = false
var player_nearby = false

func _ready():
	door_sprite.play("default")


func activate():
	active = true
	door_sprite.play("blue")


func _on_body_entered(body):
	if active:
		player_nearby = true
		door_sprite.play("blue_close")


func _on_body_exited(body):
	if active:
		player_nearby = false
		door_sprite.play("blue")
