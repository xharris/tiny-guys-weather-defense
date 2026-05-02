extends Control
class_name HudAbility

static var SCENE = preload("res://ui/hud/hud_ability.tscn")

@onready var color_rect: ColorRect = %ColorRect
@onready var bg_fill: TextureRect = %BgFill
@onready var icon: TextureRect = %Icon

var ability: Ability
var fill: float = 0.0

func _ready() -> void:
    if custom_minimum_size.is_zero_approx():
        custom_minimum_size = bg_fill.texture.get_size()

func _process(delta: float) -> void:
    color_rect.position.y = lerpf(0, bg_fill.size.y, ease(fill, Tween.EaseType.EASE_IN_OUT))
    if ability:
        icon.texture = ability.icon
        color_rect.color = ability.color
