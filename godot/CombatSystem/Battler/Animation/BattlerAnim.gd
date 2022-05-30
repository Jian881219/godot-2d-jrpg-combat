# Hold and plays the base animation for battlers.
tool
class_name BattlerAnim
extends Position2D

signal animation_finished(name)
# Emitted by animations when a combat action should apply its next effect, like dealing damage or healing an ally.
# warning-ignore:unused_signal
signal triggered

enum Direction { LEFT, RIGHT }

# Controls the direction in which the battler looks and moves.
export (Direction) var direction := Direction.RIGHT setget set_direction

var _position_start := Vector2.ZERO

onready var anim_player: AnimationPlayer = $Pivot/AnimationPlayer
onready var anim_player_damage: AnimationPlayer = $Pivot/AnimationPlayerDamage
onready var tween: Tween = $Tween
#onready var anchor_front: Position2D = $FrontAnchor
#onready var anchor_top: Position2D = $TopAnchor
onready var battler_ui := $Pivot/BattlerUI

export var id: String = ""

onready var _ui_life_bar: TextureProgress = $Pivot/BattlerUI/RedBar
onready var _ui_life_bar_label: Label = $Pivot/BattlerUI/RedBar/Label
onready var _ui_skill:AnimationPlayer = $Pivot/BattlerUI/RedBar/Node2D/AnimationPlayer
onready var _ui_skill_sprite:Sprite = $Pivot/BattlerUI/RedBar/Node2D/Sprite

export var max_health := 1 setget set_max_health
export var health := 0 setget set_health
export(bool) var is_party: bool = false setget set_party


func _ready() -> void:
	# print("初始化位置")
	_position_start = position

func act_skill():
	var rand : int = rand_range(1,8)
	_ui_skill_sprite.show()
	_ui_skill.play("run" + str(rand))
	yield(_ui_skill, "animation_finished")
	_ui_skill_sprite.hide()
	

func set_party(value:bool) -> void:
	is_party = value
	if is_party :
		_ui_life_bar_label.rect_scale = Vector2(-1, 1)
		_ui_life_bar_label.rect_position = Vector2(-500, 0)

func set_max_health(value) -> void:
	max_health = value
	if _ui_life_bar != null:
		_ui_life_bar.value = float(100)


func set_health(value) -> void:
	health = value
	assert(_ui_life_bar)
	_ui_life_bar.value = float(health) * 100 / float(max_health)


func update_health(value):
	yield(get_tree().create_timer(0.1), "timeout")
	tween.interpolate_property(self, "health", health, value, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func set_life_text(value) -> void :
	_ui_life_bar_label.text = str(value) + "/" + str(max_health)


func play(anim_name: String) -> void:
	if anim_name == "take_damage":
		anim_player_damage.play(anim_name)
		anim_player_damage.seek(0.0)
	else:
		anim_player.play(anim_name)


func is_playing() -> bool:
	return anim_player.is_playing()


func queue_animation(anim_name: String) -> void:
	anim_player.queue(anim_name)
	if not anim_player.is_playing():
		anim_player.play()


func get_front_anchor_global_position() -> Vector2:
	return _ui_life_bar.rect_global_position +  _ui_life_bar.rect_size


func get_top_anchor_global_position() -> Vector2:
	return _ui_life_bar.rect_global_position +  _ui_life_bar.rect_size


func move_forward() -> void:
	tween.interpolate_property(
		self,
		"position",
		position,
		position + Vector2.LEFT * scale.x * 40.0,
		0.3,
		Tween.TRANS_QUART,
		Tween.EASE_IN_OUT
	)
	tween.start()


func move_back() -> void:
	tween.interpolate_property(
		self, "position", position, _position_start, 0.3, Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)
	tween.start()


func set_direction(value: int) -> void:
	direction = value
	scale.x = -1.0 if direction == Direction.RIGHT else 1.0


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished", anim_name)
