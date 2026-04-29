extends Node2D
class_name PlayerSprite

@onready var body_face_direciton: Node2D = %BodyFaceDirection
@onready var arm: Node2D = %Arm
@onready var wand_tip: Marker2D = %WandTip

var aim_dir: Vector2

func _process(delta: float) -> void:
    arm.rotation = aim_dir.angle() + deg_to_rad(90)
    body_face_direciton.scale.x = -sign(aim_dir.x) * abs(body_face_direciton.scale.x)
