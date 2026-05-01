@tool
extends Node2D
class_name Shadow

@onready var sprite: Sprite2D = %Sprite2D

@export var size: float = 1.0

func _process(delta: float) -> void:
    sprite.scale = Vector2(1, 0.5) * size
    
