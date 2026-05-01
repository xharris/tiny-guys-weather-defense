extends AbilityCanPick
class_name CanPickCmpAbilityCount

@export var cmp: Enums.Compare
@export var value: int = 0
@export var step: Ability.Step

func can_pick(ctrl: AbilityController) -> bool:
    var filtered: Array[Ability] = ctrl.abilities.filter(func(a: Ability):
        return a.step == step)
    return Enums.compare(cmp, filtered.size(), value)
