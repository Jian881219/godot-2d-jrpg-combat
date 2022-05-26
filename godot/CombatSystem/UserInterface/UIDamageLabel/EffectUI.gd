extends Control


onready var ui_turn: TextureRect = $TextureRect/TextureRect
onready var ui_turn_label : Label = $TextureRect/TextureRect/Label

export(String) var id = ""
export var turn_left := 0 setget set_turn_left

func _ready():
	set_turn_left(0)

func set_turn_left(value):
	turn_left = value
	if value >= 2:
		ui_turn_label.text = str(turn_left)
		ui_turn.show()
	else :
		ui_turn.hide()
