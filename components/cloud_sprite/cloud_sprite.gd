extends Node2D
class_name CloudSprite

@onready var sprite: Sprite2D = %Sprite2D

@export var config: CloudSpriteConfig

var _dismissed = false

func dismiss():
    _dismissed = true

func _process(delta: float) -> void:
    if config:
        sprite.scale = Vector2.ONE * config.size

    if _dismissed:
        sprite.modulate.a -= delta * 0.2
        
        if sprite.modulate.a <= 0:
            var parent = get_parent()
            if parent:
                parent.remove_child(self)
