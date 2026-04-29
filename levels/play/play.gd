extends Node2D
class_name Play

@onready var camera: Camera2D = %Camera2D
@onready var base: Node2D = %Base
@onready var player: Player = %Player
@onready var entities: Node2D = %Entities

func _ready() -> void:
    entities.add_to_group(Groups.entities)

func _process(delta: float) -> void:
    camera.global_position = base.global_position.move_toward(player.global_position, 40)
