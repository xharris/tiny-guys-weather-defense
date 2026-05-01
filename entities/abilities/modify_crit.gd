extends Ability
class_name AbilityModifyCrit

static var ADD_CRIT = preload("res://resources/curves/add_crit.tres")

@export var operation: Enums.Operation
@export_range(0, 1, 0.1) var value: float

func use(ctx: AbilityContext) -> Array[Node2D]:
    ctx.ctrl.crit_chance = Enums.operate(operation, ctx.ctrl.crit_chance, ADD_CRIT.sample(value))
    return []
