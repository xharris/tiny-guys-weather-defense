extends Node2D
class_name EnemySprite

static var COLORS: Array[Color] = [
    Color.html("#26A69A"),
    Color.html("#A1887F"),
]

@onready var face_dir: Node2D = %FaceDirection
@onready var sprite: Sprite2D = %Sprite2D
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

var _last_pos: Vector2

func use_sprite_frames(frames: SpriteFrames):
    sprite.hide()
    animated_sprite.show()
    animated_sprite.sprite_frames = frames
    
func use_sprite(tex: Texture2D):
    animated_sprite.hide()
    sprite.show()
    sprite.texture = tex

func _ready() -> void:
    modulate = COLORS.pick_random()
    _last_pos = global_position

func _process(delta: float) -> void:
    var _vel = Vector2.ZERO
    if _last_pos != global_position:
        _vel = global_position - _last_pos
        # face direction
        face_dir.scale.x = sign(_vel.x) * abs(face_dir.scale.x)
    _last_pos = global_position
    
    # walking animation
    var is_walking = _vel.length() > 0.2
    if is_walking:
        animated_sprite.play("walk")
    else:
        animated_sprite.play("idle")
