extends Camera2D
class_name GameCamera

var shake_amount

@onready var timer: Timer = $ShakeTimer
var default_offset: Vector2 = offset

func _ready():
	Global.camera = self


func _process(_delta):
	offset = mouse_offset() + shake_offset()


func mouse_offset():
	var mouse_pos = get_local_mouse_position()
	return mouse_pos * 0.2


func shake_offset():
	if not timer.is_stopped():
		return Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)
	return Vector2.ZERO


func shake(duration: float, amount: float):
	timer.start(duration)
	shake_amount = amount
