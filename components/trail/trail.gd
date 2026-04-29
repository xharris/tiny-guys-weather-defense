extends Node2D
class_name Trail

@onready var line: Line2D = %Line2D

@export var config: TrailConfig

func _ready() -> void:
    line.clear_points()

func _process(delta: float) -> void:
    line.add_point(global_position)
    var length = 0
    if config:
        line.width = config.width
        length = config.length
    if line.get_point_count() > length:
        line.remove_point(0)
