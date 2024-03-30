extends CharacterBody2D


const MAX_HEALTH = 5
const SPEED = 200.0
const BULLET = {
	SPEED = 600,
	FIELD_TIME = 8
}

@onready var bullet_scene = preload("res://src/player/bullet.tscn")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun: AnimatedSprite2D = $gun

@onready var health = MAX_HEALTH: set = _set_health
var idle_dir: Vector2 = Vector2.DOWN

## --- SETTERS ---


func _set_health(new_health):
	health = clamp(new_health, 0, MAX_HEALTH)
	var hbox = $ui/ColorRect/HBoxContainer
	for i in hbox.get_child_count():
		hbox.get_child(i).visible = health > i


## --- CORE FUNCTIONS ---


func _physics_process(delta):
	var direction = handle_movement()
	handle_animation(direction)
	handle_attack()

func handle_movement():
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	velocity = direction * SPEED
	move_and_slide()
	return direction


func handle_animation(direction: Vector2):
	match direction.round():
		Vector2.ZERO:
			if idle_dir == Vector2.DOWN:
				sprite.play("idle_front")
			else:
				sprite.play("idle_back")
		# down diag and horizontal
		Vector2.RIGHT, Vector2(1, 1), Vector2.LEFT, Vector2(-1, 1):
			sprite.play("run_down_right")
		# up diag
		Vector2(1, -1), Vector2(-1, -1):
			sprite.play("run_up_right")
		Vector2.DOWN:
			sprite.play("run_down")
		Vector2.UP:
			sprite.play("run_up")
	
	if direction.x < 0:
		sprite.flip_h = true
	else: sprite.flip_h = false
	
	if direction.y < 0:
		idle_dir = Vector2.UP
	elif direction.y > 0:
		idle_dir = Vector2.DOWN


func handle_attack():
	if Input.is_action_pressed("attack"):
		attack()


## --- ACTION FUNCTIONS ---


func attack():
	if gun.is_playing():
		return
	gun.play("shoot")
	Global.camera.shake(0.1, 4)
	spawn_bullet()


func spawn_bullet():
	var instance: Attack = bullet_scene.instantiate()
	var dir = (get_global_mouse_position() - global_position).normalized()
	instance.start(
		position + dir * gun.offset.x + gun.position,
		dir
	)
	instance.field_time = BULLET.FIELD_TIME
	instance.speed = BULLET.SPEED
	get_parent().add_child(instance)

## --- TAKING DAMAGE ---


func take_damage(damage: int):
#	if !dash_timer.is_stopped(): return
	health -= damage
	if health <= 0: die()
	
	Global.camera.shake(0.2, 5)
	var tween = create_tween()
	$ui/ScreenColor.color = Color(Color.RED, 0.3)
	tween.tween_property($ui/ScreenColor, "color", Color.TRANSPARENT, 0.3)


func die():
	get_tree().reload_current_scene()
