tool
extends Control

export(String) var title = "Title" setget set_title

onready var label = $Label
func _ready():
	set_title(title)

func set_title(string):
	title = string
	if not label:
		return
	label.text = string
