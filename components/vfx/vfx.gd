extends Node2D
class_name Vfx

var _dev = Dev.new(true)

@export var playing: bool = true
@export_range(0, 1, 1.0) var hurt: float = 0.0:
    set(v):
        hurt = clampf(v, 0, 1)
        if hurt > 0:
            modulate = hurt_color
@export var hurt_color: Color = Color.html("#F44336")

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
    var final_color = Color.WHITE
    if hurt > 0.0:
        hurt -= delta * 2
        _dev.dump("hurt {0}", [hurt])
        final_color = Color.WHITE.lerp(hurt_color, hurt)
    rotation = deg_to_rad(lerpf(0, randf_range(-20, 20), hurt))
    modulate = modulate.lerp(final_color, delta)
    for child in find_children("*"):
        if child is Sprite2D:
            if child.visible and not playing and not has_active_trail():
                child.hide()
