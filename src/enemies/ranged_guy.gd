extends Enemy

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	super(delta)
	if attacking:
		sprite.play("idle")
	else:
		sprite.play("walk")
		if velocity.x < 0:
			sprite.flip_h = true
		else: sprite.flip_h = false
