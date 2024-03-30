extends CharacterBody2D
class_name Enemy

@export var SPEED: int
@export var MAX_HEALTH: int

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var re_nav_timer: Timer = $NavigationAgent2D/Timer
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player")

## Added in every instantiation of an enemy
@onready var color_rect: ColorRect = $ColorRect
@onready var attack_ray: RayCast2D = $AttackRay

@onready var DEFAULT_COLOR: Color = color_rect.color
@onready var health = MAX_HEALTH
var attacking = false
var knockback_vec: Vector2


func _ready():
	re_nav_timer.timeout.connect(find_path)
	find_path()


func _physics_process(_delta):
	if attacking:
		pass
	elif check_attack_ray():
		attacking = true
		attack()
	else:
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * SPEED
		if not knockback_timer.is_stopped():
			velocity += knockback_vec
		move_and_slide()


func check_attack_ray():
	attack_ray.rotation = global_position.angle_to_point(player.global_position)
	var col = attack_ray.get_collider()
	if col == null: return false
	return col.is_in_group("player")


func find_path():
	nav_agent.target_position = player.global_position


func attack():
	pass


func knockback(dir: Vector2, strength: int, duration: float):
	knockback_vec = dir.normalized() * strength
	knockback_timer.start(duration)


func take_damage(damage: int):
	health -= damage
	if health <= 0: die()
	var blink = 0.05
	for i in range(3):
		color_rect.color = Color.WHITE
		await get_tree().create_timer(blink).timeout
		color_rect.color = DEFAULT_COLOR
		await get_tree().create_timer(blink).timeout


func die():
	queue_free()
