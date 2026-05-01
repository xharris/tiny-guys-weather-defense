extends AbilityCanPick
class_name CanPickCmpAbilityCount

@export var cmp: Enums.Compare
@export var value: int = 0
@export var step: Ability.Step
@export var filter_not_only_crit: bool
@export var filter_only_crit: bool

func can_pick(ctrl: AbilityController) -> bool:
    var filtered: Array[Ability] = ctrl.abilities.filter(func(a: Ability):
        if filter_not_only_crit and not a.only_crit:
            return false
        if filter_only_crit and a.only_crit:
            return false
        # step type
        if a.step != step:
            return false
        return true)
    return Enums.compare(cmp, filtered.size(), value)
