extends Node2D
@onready var player_dialogue = $PlayerDialogue
@onready var character_dialogue = $CharacterDialogue
@onready var earth_door = $EarthDoor
@onready var afterlife_door = $AfterlifeDoor
@onready var anubis = $Anubis


# Called when the node enters the scene tree for the first time.
func _ready():
	player_dialogue.show()
	character_dialogue.show()
	character_dialogue.display_character_dialogue('NotInterested', 0)
	await character_dialogue.TALKING
	player_dialogue.display_choices_dialogue('Uhhh', 0)
	await player_dialogue.SELECTED
	character_dialogue.display_character_dialogue('Anyways', 0)
	await character_dialogue.TALKING
	await get_tree().create_timer(0.5).timeout
	character_dialogue.display_character_dialogue('Anyways', 1)
	await character_dialogue.TALKING
	await get_tree().create_timer(0.5).timeout
	character_dialogue.display_character_dialogue('Anyways', 2)
	await character_dialogue.TALKING
	player_dialogue.display_choices_dialogue('FieldOf', 0)
	await player_dialogue.SELECTED
	character_dialogue.display_character_dialogue('Busy', 0)
	await character_dialogue.TALKING
	await get_tree().create_timer(0.5).timeout
	character_dialogue.display_character_dialogue('Busy', 1)
	await character_dialogue.TALKING
	player_dialogue.display_choices_dialogue('OffWeGo', 0)
	await player_dialogue.SELECTED
	$ColorRect/AnimationPlayer.play("fade_to_black")
	await $ColorRect/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://levels/level_0/level_0.tscn")
