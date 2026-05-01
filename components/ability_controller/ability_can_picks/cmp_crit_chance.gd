extends AbilityCanPick
class_name CanPickCmpCritChance

@export var cmp: Enums.Compare
@export_range(0, 1, 0.1) var value: float = 0.0

func can_pick(ctrl: AbilityController) -> bool:
    return Enums.compare(cmp, ctrl.crit_chance, value)
