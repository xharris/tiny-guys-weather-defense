extends Node2D
class_name EnemySprite

static var COLORS: Array[Color] = [
    Color.html("#26A69A"),
    Color.html("#A1887F"),
]

@onready var sprite: Sprite2D = %Sprite2D

func _ready() -> void:
    modulate = COLORS.pick_random()
