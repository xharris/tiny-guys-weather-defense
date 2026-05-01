extends Node2D
class_name PlayerSprite

@onready var body_face_direciton: Node2D = %BodyFaceDirection
@onready var arm: Node2D = %Arm
@onready var wand_tip: Marker2D = %WandTip
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var aim_dir: Vector2
var aim_position: Vector2

func idle():
    animation_player.play("RESET")

func stun():
    animation_player.play("stun")

func _process(delta: float) -> void:
    arm.rotation = aim_dir.angle() + deg_to_rad(90)
    body_face_direciton.scale.x = sign(global_position.x - aim_position.x) * abs(body_face_direciton.scale.x)
