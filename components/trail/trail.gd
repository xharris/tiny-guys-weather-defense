extends Node2D
class_name Trail

@onready var line: Line2D = %Line2D

@export var config: TrailConfig

func is_active() -> bool:
    return line.get_point_count() > 0

func _ready() -> void:
    line.clear_points()

func _process(delta: float) -> void:
    var length = 0
    if config:
        line.add_point(global_position)
        line.width = config.width
        length = config.length
        line.default_color = config.color
    if line.get_point_count() > length:
        line.remove_point(0)
