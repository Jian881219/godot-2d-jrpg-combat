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
onready var anchor_front: Position2D = $FrontAnchor
onready var anchor_top: Position2D = $TopAnchor

export var id: String = ""

onready var _ui_life_bar: TextureProgress = $Pivot/BattlerUI/RedBar
onready var _ui_life_bar_label: Label = $Pivot/BattlerUI/RedBar/Label

export var max_health := 1 setget set_max_health
export var health := 0 setget set_health


func set_max_health(value) -> void:
	max_health = value
	_ui_life_bar.value = 100


func set_health(value) -> void:
	health = value
	_ui_life_bar.value = health * 100 / max_health


func update_health(value):
	yield(get_tree().create_timer(0.1), "timeout")
	tween.interpolate_property(self, "health", health, value, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func set_life_text(value) -> void :
	_ui_life_bar_label.text = str(value) + "/" + str(max_health)


func _ready() -> void:
	# print("初始化位置")
	_position_start = position


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
	return anchor_front.global_position


func get_top_anchor_global_position() -> Vector2:
	return anchor_top.global_position


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
