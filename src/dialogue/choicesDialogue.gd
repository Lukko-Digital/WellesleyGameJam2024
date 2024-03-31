extends PanelContainer

signal SELECTED(choice)

@onready var choices_list = $MarginContainer/Choices
@onready var choice_prefab = $MarginContainer/Choices/ChoiceButton
@onready var json_str = FileAccess.open(DIALOGUE_PATH, FileAccess.READ).get_as_text()
@onready var dialogue = JSON.parse_string(json_str)

const DIALOGUE_PATH: String = "res://assets/dialogue/dialogue.json"

var choices:
	set(value):
		choices = value
		initButtons()

# Called when the node enters the scene tree for the first time.
func _ready():
	choices_list.get_child(0).pressed.connect(onChoice.bind(0))
	
	assert(FileAccess.file_exists(DIALOGUE_PATH), "Dialog file at %s does not exist" % DIALOGUE_PATH)


func display_choices_dialogue(scene, line):	
	choices = dialogue[scene][line]
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initButtons():
	var button
	choices_list.show()
	
	while choices_list.get_child_count() > 1:
		button = choices_list.get_child(choices_list.get_child_count() - 1)
		choices_list.remove_child(button)
		button.queue_free()
		
	for choice_index in range(choices.size()):
		if(choice_index) == 0:
			choices_list.get_child(0).text = choices[choice_index]
		else:
			choices_list.add_child(choice_prefab.duplicate())
			choices_list.get_child(choice_index).text = choices[choice_index]
			choices_list.get_child(choice_index).pressed.connect(onChoice.bind(choice_index))
	
	choices_list.get_child(0).grab_focus()

func onChoice(choice_index):
	choices_list.hide()
	emit_signal("SELECTED", choice_index)
