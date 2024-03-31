extends Attack


func _on_body_entered(body):
	super(body)
	if body.get_collision_layer() != 1:
		body.knockback(
			direction,
			500,
			0.05
		)
	queue_free()
