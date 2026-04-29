extends Ability
class_name AbilityDrop

@export var sprite: Texture2D
@export_range(0, 1, 0.2) var fall_speed: float = 0.0
@export var trail: TrailConfig

func use(ctx: AbilityContext) -> Array[Node2D]:
    var drop: Drop = Drop.SCENE.instantiate()
    drop.config = self
    drop.ctx = ctx
    return [drop]
