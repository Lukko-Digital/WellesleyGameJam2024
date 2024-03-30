extends Attack


func _on_body_entered(body):
	super(body)
	body.knockback(
		direction,
		1000,
		0.05
	)
