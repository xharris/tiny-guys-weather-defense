extends Resource
class_name Ability

@export var name: String
@export_multiline var description: String
@export var scenes: Array[PackedScene]
@export var repeat: int = 0
@export_range(0.0, 1.0, 0.1) var cooldown: float = 1.0
@export var can_crit: bool = true
@export var only_crit: bool
## Random weight when picking a new ability
@export var weight: float = 1.0
## Requires having any of these other ability names
@export var requires: Array[String]

## Can return Node2D that will be added to the Entities node
func use(ctx: AbilityContext) -> Array[Node2D]:
    var instances: Array[Node2D]
    for scene in scenes:
        var instance = scene.instantiate()
        instances.append(instance)
    return instances
