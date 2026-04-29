extends Resource
class_name Ability

@export var name: String
@export var scenes: Array[PackedScene]
@export var repeat: int = 0

## Can return Node2D that will be added to the Entities node
func use(ctx: AbilityContext) -> Array[Node2D]:
    var instances: Array[Node2D]
    for scene in scenes:
        var instance = scene.instantiate()
        instances.append(instance)
    return instances
