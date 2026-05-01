extends Resource
class_name HitboxConfig

@export var shape: Shape2D
@export_range(0, 360, 90, "radians_as_degrees") var rotation: float = deg_to_rad(90.0)
