# Deals damage periodically
class_name StatusEffectAdd
extends StatusEffect

var amount := 3


# data: StatusEffectData
func _init(target, data).(target, data) -> void:
	id = "add"
	amount = data.ticking_damage
	_can_stack = true


func _apply() -> void:
	_target.take_hit(Hit.new(amount, 1, true, null))
