extends Area2D
class_name Attack

@export var DAMAGE: int
var direction: Vector2
var speed: int = 0
var field_time: int = 0

signal hit(body)

func _ready():
	body_entered.connect(_on_body_entered)
	if field_time:
		await get_tree().create_timer(field_time).timeout
		queue_free()


func _physics_process(delta):
	if speed:
		position += direction * speed * delta


func start(pos: Vector2, dir: Vector2):
	position = pos
	direction = dir.normalized()
	look_at(direction)


func enable():
	set_deferred("monitoring", true)


func disable():
	set_deferred("monitoring", false)


func _on_body_entered(body):
	if body.get_collision_layer() == 1:
		return
	hit.emit(body)
	body.take_damage(DAMAGE)
