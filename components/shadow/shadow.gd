@tool
extends Node2D
class_name Shadow

static var SCENE = preload("res://components/shadow/shadow.tscn")
static var DEFAULT_TEX = preload("res://components/shadow/filled_circle_64.png" )

@onready var sprite: Sprite2D = %Sprite2D

@export var width: float = 64.0
@export var texture: Texture2D

var _is_placeholder: bool
var _placeholder: Shadow
var _texture_width: float

func sync(original: Shadow):
    global_transform = original.global_transform
    sprite.scale = original.sprite.scale
    sprite.texture = original.sprite.texture

func _ready() -> void:
    add_to_group(Groups.shadow)

    if not Engine.is_editor_hint():
        visible = _is_placeholder
        sprite.modulate = Color.WHITE
    else:
        sprite.modulate = Color(0, 0, 0, 0.2)

func _exit_tree() -> void:
    if _placeholder:
        _placeholder.queue_free()
        _placeholder = null

func _process(delta: float) -> void:
    if not _is_placeholder:
        # update components
        var tex = DEFAULT_TEX
        if texture:
            tex = texture
        if tex != sprite.texture or _texture_width <= 0:
            sprite.texture = tex
            _texture_width = sprite.texture.get_width()
        sprite.scale = Vector2(1, 0.5) * (width / max(1.0, _texture_width))

    if _placeholder:
        # have placeholder mimic the original
        _placeholder.sync(self)
        visible = false
