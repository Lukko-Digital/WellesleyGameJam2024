extends CharacterBody2D


const MAX_HEALTH = 3
const SPEED = 200.0
const BULLET = {
	SPEED = 600,
	FIELD_TIME = 8
}
const INVLN_TIME = 0.2

@onready var bullet_scene = preload("res://src/player/bullet.tscn")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var screen_color: ColorRect = $ui/ScreenColor
@onready var gun: AnimatedSprite2D = $gun
@onready var invuln_timer = $InvulnTimer

@onready var health = MAX_HEALTH: set = _set_health
var idle_dir: Vector2 = Vector2.DOWN
var rolling = false
var dead = false

## --- SETTERS ---


func _set_health(new_health):
	health = clamp(new_health, 0, MAX_HEALTH)
	var hbox = $ui/TextureRect/HBoxContainer
	for i in hbox.get_child_count():
		if health <= i:
			hbox.get_child(i).empty()


## --- CORE FUNCTIONS ---


func _physics_process(delta):
	if dead: return
	handle_movement()
	handle_animation()
	handle_attack()
	move_and_slide()


func handle_movement():
	if rolling:
		if sprite.frame != 4:
			return
		velocity *= 0.9
		return
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	velocity = direction * SPEED


func handle_animation():
	if rolling:
		return
	var direction = velocity.normalized().round()
	match direction:
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


func _unhandled_input(event):
	if event.is_action_pressed("roll"):
		roll()


## --- ACTION FUNCTIONS ---


func attack():
	if gun.is_playing():
		return
	gun.play("shoot")
	Global.camera.shake(0.1, 4)
	spawn_bullet()


func spawn_bullet():
	var instance: Attack = bullet_scene.instantiate()
	var dir = (get_global_mouse_position() - gun.global_position).normalized()
	instance.start(
		position + dir * gun.offset.x + gun.position,
		dir
	)
	instance.field_time = BULLET.FIELD_TIME
	instance.speed = BULLET.SPEED
	get_parent().add_child(instance)


func roll():
	if velocity == Vector2.ZERO:
		return
	rolling = true
	
	match velocity.normalized().round():
		# down diag and horizontal
		Vector2.RIGHT, Vector2(1, 1), Vector2.LEFT, Vector2(-1, 1):
			sprite.play("dodge_down_right")
		# up diag
		Vector2(1, -1), Vector2(-1, -1):
			sprite.play("dodge_up_right")
		Vector2.DOWN:
			sprite.play("dodge_down")
		Vector2.UP:
			sprite.play("dodge_up")
	
	await sprite.animation_finished
	rolling = false


## --- TAKING DAMAGE ---


func take_damage(damage: int):
	if (
		!invuln_timer.is_stopped() or
		rolling or
		dead
	): return
	invuln_timer.start(INVLN_TIME)
	health -= damage
	if health <= 0: die()
	
	Global.camera.shake(0.18, 9)
	var tween = create_tween()
	screen_color.color = Color(Color.RED, 0.3)
	tween.tween_property(screen_color, "color", Color.TRANSPARENT, 0.3)


func die():
	dead = true
	gun.hide()
	sprite.play("die")
	await sprite.animation_finished
	
	var tween = create_tween()
	screen_color.color = Color(Color.BLACK, 0)
	tween.tween_property(screen_color, "color", Color.BLACK, 1)
	await tween.finished
	get_tree().reload_current_scene()
