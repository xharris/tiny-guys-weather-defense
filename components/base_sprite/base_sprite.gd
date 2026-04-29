extends Node2D
class_name BaseSprite

@onready var base_health: Node2D = %BaseHealth

## [0,1]
var health: float = 1.0

func _process(delta: float) -> void:
    base_health.scale = Vector2.ONE * lerpf(2, 8, health)
