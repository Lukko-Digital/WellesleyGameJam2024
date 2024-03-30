extends Enemy

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var staff: AnimatedSprite2D = $staff

func _physics_process(delta):
	super(delta)
	if attacking:
		sprite.play("idle")
	else:
		sprite.play("walk")
		if velocity.x < 0:
			sprite.flip_h = true
			staff.scale = Vector2(-1, 1)
		else:
			sprite.flip_h = false
			staff.scale = Vector2(1, 1)
