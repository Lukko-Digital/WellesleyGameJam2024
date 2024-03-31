extends Node2D
@onready var player_dialogue = $PlayerDialogue
@onready var character_dialogue = $CharacterDialogue
@onready var earth_door = $EarthDoor
@onready var afterlife_door = $AfterlifeDoor
@onready var anubis = $Anubis

var last_choice = -1

signal CONTINUE
# Called when the node enters the scene tree for the first time.
func _ready():
	player_dialogue.hide()
	character_dialogue.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if earth_door.EARTHDOOR:
		character_dialogue.display_character_dialogue('EarthDoor', 0)

func anubis_line1():
	character_dialogue.display_character_dialogue('Anubis', 0)
	await character_dialogue.TALKING
	player_dialogue.display_choices_dialogue('AnubisResponse', 0)
	await player_dialogue.SELECTED
	if last_choice == 2:
		character_dialogue.display_character_dialogue('Anubis', 1)
		await character_dialogue.TALKING
		await CONTINUE
		anubis_line1()


func _on_player_dialogue_selected(choice):
	last_choice = choice

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		CONTINUE.emit()
