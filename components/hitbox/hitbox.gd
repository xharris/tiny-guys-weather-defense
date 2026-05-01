extends Area2D
class_name Hitbox

var _dev = Dev.new()

static var C_HITBOX = Color.html("#F44336")
static var C_HURTBOX = Color.html("#4CAF50")

static func apply_on_hits(src: Hitbox, target: Hitbox, on_hits: Array[OnHitEffect]):
    for on_hit in on_hits:
        var real_target = target
        # can hit self
        if on_hit.hit_self:
            real_target = src
        if not real_target.is_inside_tree():
            return
        # can only hit certain groups
        var skip = false
        for group in on_hit.hit_groups:
            if not real_target.owner or not real_target.owner.is_in_group(group):
                skip = true
                break
        if skip:
            continue
        src._dev.dump("apply '{0}' to {1}", [on_hit.name, real_target.get_path()])
        src.on_hit.emit(real_target)
        real_target.apply_on_hit.emit(src, on_hit)
        on_hit.apply()

signal on_hit(target: Hitbox)
signal apply_on_hit(source: Hitbox, effect: OnHitEffect)

@onready var default_shape: CollisionShape2D = %CollisionShape2D

@export var is_hitbox: bool = true
@export var is_hurtbox: bool = true
@export var disabled: bool = false
@export var on_hit_effects: Array[OnHitEffect]
@export var config: HitboxConfig:
    set(v):
        config = v
        update()

var shape_scale: Vector2 = Vector2.ONE
var _entered: Dictionary[Area2D, bool]

func disable():
    disabled = true

func enable():
    disabled = false
    for area in get_overlapping_areas():
        _on_area_entered(area)

func update():
    if not is_inside_tree():
        return
    if config:
        if config.shape:
            default_shape.rotation = config.rotation
            default_shape.shape = config.shape
            default_shape.scale = shape_scale
        else:
            default_shape.shape = null

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    update()
    
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
    set_collision_mask_value(1, false)
    set_collision_mask_value(2, is_hitbox)
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
