extends Node2D
class_name BaseSprite

static var HEALTH_SCALE = preload("res://resources/curves/base_sprite_health_scale.tres")

@onready var base_health: Node2D = %BaseHealth
@onready var sprite: Sprite2D = %Sprite2D

## [0,1]
var health: float = 1.0

func get_hp_scale() -> Vector2:
    return Vector2.ONE * HEALTH_SCALE.sample(health)

func _process(delta: float) -> void:
    base_health.scale = get_hp_scale()
