extends Node2D
class_name Vfx

@export var playing: bool = true

func stop():
    for child in find_children("*"):
        if child is Trail:
            child.config = null
        if child is Sprite2D:
            child.hide()
    playing = false

func is_playing():
    return playing

func _ready() -> void:
    if not playing:
        stop()
