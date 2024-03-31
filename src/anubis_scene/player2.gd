extends CharacterBody2D


const SPEED = 100.0


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED
	if velocity.x == 0:
		sprite.play("default")
	elif velocity.x < 0:
		sprite.play("walk")
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.play("walk")
		sprite.flip_h = false
	move_and_slide()
