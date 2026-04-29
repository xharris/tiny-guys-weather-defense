extends Node2D
class_name OrbitAim

@onready var target_sprite: Sprite2D = %Target
@onready var transform_sprite: Node2D = %Transform

@export var aim_position_lerp: float = 5.0
@export var rotation_speed: float = 80.0
@export var size: float = 3

var aim_position: Vector2
var orbit_distance: float = 80

func _ready() -> void:
    aim_position = get_global_mouse_position()

func _process(delta: float) -> void:
    aim_position = aim_position.lerp(get_global_mouse_position(), delta * aim_position_lerp)
    transform_sprite.rotate(deg_to_rad(1) * delta * rotation_speed)
    transform_sprite.global_position = aim_position
    transform_sprite.scale = Vector2.ONE * size

func get_aim_dir(origin: Vector2):
    return (aim_position - origin).normalized()

func get_orbit_position(anchor: Node2D):
    return anchor.global_position + (get_aim_dir(anchor.global_position) * 80)
