extends Resource
class_name BaseConfig

@export var sprite: Texture2D
@export var radius: float = 50.0
@export var hitbox_shape: Shape2D
@export_range(0, 360, 90, "radians_as_degrees") var shape_rotation: float = deg_to_rad(90.0)
@export_range(0.0, 1.0, 0.2) var hp: float = 0.0
