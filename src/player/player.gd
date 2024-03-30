extends CharacterBody2D


const MAX_HEALTH = 5
const SPEED = 300.0
const BULLET = {
	SPEED = 1000,
	FIELD_TIME = 8
}

@onready var bullet_scene = preload("res://src/player/bullet.tscn")

@onready var health = MAX_HEALTH: set = _set_health


## --- SETTERS ---


func _set_health(new_health):
	health = clamp(new_health, 0, MAX_HEALTH)
	var hbox = $ui/ColorRect/HBoxContainer
	for i in hbox.get_child_count():
		hbox.get_child(i).visible = health > i


## --- CORE FUNCTIONS ---


func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	velocity = direction * SPEED
	move_and_slide()


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		attack()


## --- ACTION FUNCTIONS ---


func attack():
	var instance: Attack = bullet_scene.instantiate()
	instance.start(
		position,
		(get_global_mouse_position() - global_position).normalized()
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
