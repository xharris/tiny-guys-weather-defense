extends CharacterBody2D
class_name Drop

var _dev = Dev.new()

static var SCENE = preload("res://entities/abilities/drop/drop.tscn")
static var FALL_SPEED_CURVE = preload("res://resources/curves/fall_from_top_speed.tres")

@onready var hitbox: Hitbox = %Hitbox
@onready var remove_timer: Timer = %RemoveTimer
@onready var vfx: Vfx = %Vfx
@onready var sprite: Sprite2D = %Sprite2D
@onready var trail: Trail = %Trail

var config: AbilityDrop
var ctx: AbilityContext

var slant: float = 0
var start_position: Vector2
var target_position: Vector2
var _t: float = 0

func _ready() -> void:
    remove_timer.timeout.connect(_on_remove_timer)
    
    sprite.texture = config.sprite
    if not sprite.texture:
        _dev.warn("no sprite texture provided in {0}", [config.resource_path.get_file()])
    hitbox.disabled = true
    # place above top of view
    var screen_top_world = get_canvas_transform().affine_inverse() * Vector2.ZERO
    start_position = Vector2(ctx.ctrl.aim_position.x + slant + config.slant, screen_top_world.y)
    target_position = ctx.ctrl.aim_position
    global_position = start_position
    _dev.dump("mouse {2}, start {0}, target {1}", [start_position, target_position, get_global_mouse_position()])

func _on_remove_timer():
    _dev.dump("remove")
    var parent = get_parent()
    if parent:
        parent.remove_child(self)

func _process(delta: float) -> void:
    trail.config = config.trail
    sprite.modulate = config.sprite_color
    
    var progress = clampf(_t / 2.0, 0, 1)
    if progress >= 1.0 and vfx.visible:
        # enable hitbox when ground reached
        vfx.stop()
        hitbox.disabled = false
        remove_timer.start()
        
    elif progress < 1.0:
        # fall to ground
        _t += delta * 0.2 * FALL_SPEED_CURVE.sample(config.fall_speed)
        _dev.dump("t {0}, progress {1}", [_t, progress])
        global_position = lerp(start_position, target_position, progress)
