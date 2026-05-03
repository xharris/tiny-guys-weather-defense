extends Control
class_name HudIcon

static var SCENE = preload("res://ui/hud/hud_icon.tscn")

static func get_by_id(container: Control, id: String) -> HudIcon:
    for h: HudIcon in container.get_tree().get_nodes_in_group(Groups.hud_icon):
        if h.id == id:
            return h
    # create new
    var me: HudIcon = SCENE.instantiate()
    me.id = id
    container.add_child(me)
    return me

@onready var color_rect: ColorRect = %ColorRect
@onready var bg_fill: TextureRect = %BgFill
@onready var icon_rect: TextureRect = %Icon
@onready var subtext_label: Label = %Subtext

var ability: Ability

var id: String
var icon: Texture2D
var color_fg: Color = Color.BLACK
var color_bg: Color = Color.WHITE
var fill: float = 0.0
var ease_fill: bool
var subtext: String = ""

func _ready() -> void:
    add_to_group(Groups.hud_icon)
    if custom_minimum_size.is_zero_approx():
        custom_minimum_size = bg_fill.texture.get_size()

func _process(delta: float) -> void:
    # fill
    if ease_fill:
        color_rect.position.y = lerpf(bg_fill.size.y, 0, ease(fill, Tween.EaseType.EASE_IN_OUT))
    else:
        color_rect.position.y = lerpf(bg_fill.size.y, 0, fill)
    color_rect.color = color_bg
    
    # icon
    icon_rect.texture = icon
    icon_rect.modulate = color_fg
    
    # subtext label
    subtext_label.text = subtext
    subtext_label["theme_override_colors/font_color"] = color_fg
    subtext_label["theme_override_colors/font_shadow_color"] = color_bg
    subtext_label["theme_override_colors/font_outline_color"] = color_bg
