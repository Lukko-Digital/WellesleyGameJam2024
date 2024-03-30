extends Sprite2D


func _process(delta):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	var dir = Vector2.from_angle(rotation)
	if dir.x < 0:
		flip_v = true
	else:
		flip_v = false
	
	if dir.y < 0: # above
		z_index = -1
	else: z_index = 0
