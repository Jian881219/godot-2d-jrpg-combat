# Represents a damage-dealing hit to be applied to a target [Battler].
# Encapsulates calculations for how hits are applied based on their properties.
class_name Hit
extends Reference

var damage := 0
var hit_chance: float
var effect: StatusEffect
var is_add := false


func _init(_damage: int, _hit_chance := 100.0, _is_add := false, _effect: StatusEffect = null) -> void:
	damage = _damage
	hit_chance = _hit_chance
	effect = _effect
	is_add = _is_add


func does_hit() -> bool:
	if is_add :
		return true
	else:
		return randf() * 100.0 < hit_chance
