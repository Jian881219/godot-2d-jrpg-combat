# Individual button representing one combat action.
extends TextureButton

onready var icon_node: TextureRect = $HBoxContainer/Icon
onready var label_node: Label = $HBoxContainer/Label


func setup(action: ActionData, can_be_used: bool) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	if action.icon:
		icon_node.texture = action.icon
	label_node.text = action.label
	disabled = not can_be_used


func _on_pressed() -> void:
	release_focus()
