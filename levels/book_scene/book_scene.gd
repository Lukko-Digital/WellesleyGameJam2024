extends Node2D

@onready var book: AnimatedSprite2D = $book
@onready var flip_cd: Timer = $FlipCooldown

var current_anim = 0
var anim_order = ["cover", "page1", "page2", "gun"]


func _ready():
	book.play("cover")


func flip_page():
	if !flip_cd.is_stopped() or book.is_playing() or current_anim >= 3:
		return
	flip_cd.start()
	current_anim += 1
	book.play(anim_order[current_anim])


func slam():
	Global.camera.shake(0.1, 9)
	book.play("slam")


func _unhandled_input(event):
	if event.is_action_pressed("right") or event.is_action_pressed("attack"):
		flip_page()


func _on_book_animation_finished():
	if book.animation == "gun":
		slam()

