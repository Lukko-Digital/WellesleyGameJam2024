extends CharacterBody2D


const SPEED = 300.0
const BULLET = {
	SPEED = 600,
	FIELD_TIME = 8
}

@onready var bullet_scene = preload("res://player/bullet.tscn")

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	velocity = direction * SPEED
	move_and_slide()


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		attack()


func attack():
	var instance: Attack = bullet_scene.instantiate()
	instance.start(
		position,
		(get_global_mouse_position() - global_position).normalized()
	)
	instance.field_time = BULLET.FIELD_TIME
	instance.speed = BULLET.SPEED
	get_parent().add_child(instance)
