extends Node2D
class_name GrassBladeSprite

static var SCENE = preload("res://components/grass_blade_sprite/grass_blade_sprite.tscn")
static var COLORS: Array[Color] = [Color.html("#2E7D32"), Color.html("#1B5E20")]

@onready var sprite: Sprite2D = %Sprite2D

func _ready() -> void:
    var frame_count = sprite.hframes * sprite.vframes
    sprite.frame = int(randi() * frame_count)
    sprite.modulate = COLORS.pick_random()
