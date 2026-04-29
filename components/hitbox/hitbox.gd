extends Area2D
class_name Hitbox

var _dev = Dev.new(true)

static var C_HITBOX = Color.html("#F44336")
static var C_HURTBOX = Color.html("#4CAF50")

static func apply_on_hits(src: Hitbox, target: Hitbox, on_hits: Array[OnHitEffect]):
    for on_hit in on_hits:
        var real_target = target
        if on_hit.target_self:
            real_target = src
        src._dev.dump("apply {0} to {1}", [real_target.get_path()])
        real_target.apply_on_hit.emit(src, on_hit)
        on_hit.apply()

signal apply_on_hit(source: Hitbox, effect: OnHitEffect)

@export var is_hitbox: bool = true
@export var is_hurtbox: bool = true
@export var disabled: bool = false
@export var on_hit_effects: Array[OnHitEffect]

var _entered: Dictionary[Area2D, bool]

func disable():
    disabled = true

func enable():
    disabled = false
    for area in get_overlapping_areas():
        _on_area_entered(area)

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    
func _on_area_entered(area: Area2D):
    if disabled:
        return
    if _entered.get(area, false):
        return
    _entered.set(area, true)
    if area is Hitbox:
        if area.disabled:
            return
        if is_hitbox and area.is_hurtbox:
            Hitbox.apply_on_hits(self, area, on_hit_effects)

func _process(delta: float) -> void:
    set_collision_layer_value(1, is_hitbox)
    set_collision_layer_value(2, is_hurtbox)
    set_collision_mask_value(1, not is_hitbox)
    set_collision_mask_value(2, not is_hurtbox)
    for node in find_children("*"):
        if node is CollisionShape2D:
            # color
            if is_hitbox and is_hurtbox:
                node.debug_color = C_HITBOX.blend(C_HURTBOX)
            elif is_hitbox:
                node.debug_color = C_HITBOX
            elif is_hurtbox:
                node.debug_color = C_HURTBOX
            # transparency
            if disabled:
                node.debug_color.a = 0.25
            else:
                node.debug_color.a = 0.75
