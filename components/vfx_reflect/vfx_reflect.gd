extends CanvasGroup
class_name VfxReflect

static var REFLECT: ShaderMaterial = preload("res://resources/materials/reflect.tres")

@onready var plane: ColorRect = %ColorRect

#@export var plane_width: float = 64.0
#@export var reflection_zone: float = 48.0

var altitude: float = 0.0

func _ready() -> void:
    plane.material = REFLECT.duplicate()

func _process(_delta: float) -> void:
    var view_rect = get_viewport_rect()
    var view_position = get_viewport().get_camera_2d().get_screen_center_position()
    plane.global_position.x = view_position.x - (view_rect.size.x/2)
    plane.global_position.y = view_position.y - (view_rect.size.y/2) # global_position.y
    plane.size = view_rect.size
    plane.color = Color.WHITE
    #var screen_pos = get_viewport_transform() * plane.global_position
    #_plane.material.set_shader_parameter("waterline_screen_y", screen_pos.y / view_rect.y)
