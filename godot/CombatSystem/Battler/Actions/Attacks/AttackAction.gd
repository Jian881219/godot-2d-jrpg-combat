# Concrete class for basic damaging attacks. Inflicts direct damage to one or more targets.
class_name AttackAction
extends Action

var _hits := []


func _init(data: ActionData, actor, targets: Array).(data, actor, targets) -> void:
	pass


# Plays the acting battler's attack animation once for each target. Damages each target when the actor's animation emits the `triggered` signal.
func _apply_async() -> bool:
	var anim = _actor.battler_anim
	if not anim.is_connected("triggered", self, "_on_BattlerAnim_triggered"):
		anim.connect("triggered", self, "_on_BattlerAnim_triggered")
	for target in _targets:
		_hits.append(Hit.new(target, _actor.get_damage()))
		anim.play("attack")
		yield(_actor, "animation_finished")
	return true


func _on_BattlerAnim_triggered() -> void:
	var hit: Hit = _hits.pop_front()
	hit.apply()
