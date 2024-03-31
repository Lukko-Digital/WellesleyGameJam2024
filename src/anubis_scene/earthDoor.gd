extends Area2D

var area_active = false
signal EARTHDOOR

func _input(event):
	if area_active and event.is_action_pressed("ui_accept"):
		EARTHDOOR.emit()
# Called when the node enters the scene tree for the first time.

func _on_area_entered(area):
	area_active = true

func _on_area_exited(area):
	area_active = false
