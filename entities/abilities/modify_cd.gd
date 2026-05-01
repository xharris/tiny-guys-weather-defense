extends Ability
class_name AbilityModifyCooldown

@export var operation: Enums.Operation
@export_range(0, 1, 0.05) var value: float

func use(ctx: AbilityContext) -> Array[Node2D]:
    ctx.ctrl.cooldown_reduction = Enums.operate(operation, ctx.ctrl.cooldown_reduction, value)
    return []
