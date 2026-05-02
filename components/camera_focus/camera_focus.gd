extends Node2D
class_name CameraFocus

static func get_camera_rect(node: CanvasItem):
    var camera = node.get_viewport().get_camera_2d()
    var world_size = node.get_viewport_rect().size / camera.zoom
    var center = camera.get_screen_center_position()
    return Rect2(center - (world_size/2), world_size)
