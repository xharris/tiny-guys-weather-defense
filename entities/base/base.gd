extends Node2D
class_name Base

static func get_closest(to: Node2D) -> Base:
    return NodeUtil.get_closest(to.get_tree().get_nodes_in_group(Groups.base), to)

@onready var sprite: BaseSprite = %BaseSprite
@onready var hp: Hp = %Hp

@export var config: BaseConfig

func get_radius() -> float:
    return (config.radius if config else 32) * min(sprite.sprite.global_scale.y, sprite.sprite.global_scale.x)
    
func _ready() -> void:
    add_to_group(Groups.base)

func _process(delta: float) -> void:
    if config:
        sprite.sprite.texture = config.sprite
