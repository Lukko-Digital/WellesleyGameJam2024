extends CharacterBody2D


const SPEED = 150.0


func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED

	move_and_slide()
