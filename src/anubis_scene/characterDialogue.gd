extends PanelContainer

const DIALOGUE_PATH: String = "res://assets/dialogue/dialogue.json"
@onready var char_text = $MarginContainer/CharacterText
@onready var text_timer = $TextTimer
const TEXT_SPEED = 0.06

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(FileAccess.file_exists(DIALOGUE_PATH), "Dialog file at %s does not exist" % DIALOGUE_PATH)
	var json_str = FileAccess.open(DIALOGUE_PATH, FileAccess.READ).get_as_text()
	var dialogue = JSON.parse_string(json_str)
	
	char_text.text = dialogue["Anubis"][0]
	animate_display()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func animate_display():
	char_text.visible_characters = 0
	var display_in_progress = true
	while char_text.visible_characters < len(char_text.text):
		char_text.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
	display_in_progress = false
