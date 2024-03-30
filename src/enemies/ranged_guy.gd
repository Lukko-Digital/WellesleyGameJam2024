extends Enemy

const ATTACK = {
	SPEED = 200,
	FIELD_TIME = 20
}

@onready var attack_scene = preload("res://src/enemies/staff_attack.tscn")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var staff: AnimatedSprite2D = $staff

func _physics_process(delta):
	super(delta)
	if attacking:
		sprite.play("idle")
	else:
		sprite.play("walk")
		if direction_to_player.x < 0:
			sprite.flip_h = true
			staff.scale = Vector2(-1, 1)
		else:
			sprite.flip_h = false
			staff.scale = Vector2(1, 1)


func attack():
	staff.play("attack")
	await staff.animation_finished
	spawn_bullet()
	staff.play("endlag")
	await staff.animation_finished
	attacking = false


func spawn_bullet():
	var instance: Attack = attack_scene.instantiate()
	var dir = (player.global_position - staff.global_position).normalized()
	instance.start(
		position + dir * staff.offset.x + staff.position,
		dir
	)
	instance.field_time = ATTACK.FIELD_TIME
	instance.speed = ATTACK.SPEED
	get_parent().add_child(instance)
