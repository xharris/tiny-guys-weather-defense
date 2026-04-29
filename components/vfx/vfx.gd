extends Node2D
class_name Vfx

var _dev = Dev.new()

@export var playing: bool = true

func stop():
    for child in find_children("*"):
        if child is Trail:
            child.config = null
    playing = false

func is_playing():
    return playing

func _ready() -> void:
    if not playing:
        stop()

func has_active_trail() -> bool:
    for child in find_children("*"):
        if child is Trail:
            if child.is_active():
                _dev.dump("trail is still active: {0}", [child.line.get_point_count()])
                return true
    return false

func _process(delta: float) -> void:
    for child in find_children("*"):
        if child is Sprite2D:
            if child.visible and not playing and not has_active_trail():
                child.hide()
