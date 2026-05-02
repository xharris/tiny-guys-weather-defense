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
@onready var particles: GPUParticles2D = %GPUParticles2D
@onready var audio_on_hit: AudioStreamPlayer2D = %AudioOnHit
@onready var audio_land: AudioStreamPlayer2D = %AudioLand

var config: AbilityDrop
var ctx: AbilityContext

var slant: float = 0
var start_position: Vector2
var target_position: Vector2
var _t: float = 0
var _landed: bool

func _ready() -> void:
    hitbox.on_hit.connect(_on_hitbox_hit)
    remove_timer.timeout.connect(_on_remove_timer)
    sprite.texture = config.sprite
    hitbox.on_hit_effects = config.on_hit_effects
    audio_land.stream = config.land_audio
    audio_on_hit.stream = config.on_hit_audio

    if not sprite.texture:
        _dev.warn("no sprite texture provided in {0}", [config.resource_path.get_file()])
    hitbox.disabled = true
    # place above top of view
    var screen_top_world = get_canvas_transform().affine_inverse() * Vector2.ZERO
    var screen_height = get_viewport_rect().size.y
    start_position = Vector2(ctx.ctrl.aim_position.x + slant + config.slant, ctx.ctrl.aim_position.y - screen_height)
    target_position = ctx.ctrl.aim_position
    global_position = start_position
    _dev.dump("mouse {2}, start {0}, target {1}", [start_position, target_position, get_global_mouse_position()])
        
func _on_hitbox_hit(target: Hitbox):
    audio_on_hit.play()

func _on_remove_timer():
    _dev.dump("remove")
    var parent = get_parent()
    if not parent:
        return
    # reparent nodes so they dont get cut off
    for player: AudioStreamPlayer2D in [audio_land, audio_on_hit]:
        if player.playing:
            NodeUtil.move_up_in_tree(player)
            player.finished.connect(player.queue_free)
    NodeUtil.move_up_in_tree(particles)
    parent.remove_child(self)

func _process(delta: float) -> void:
    trail.config = config.trail
    sprite.modulate = config.sprite_color
    hitbox.config = config.hitbox
    #particles.emitting = false
    
    var duration = 2.0
    if ctx.is_critical:
        duration = 0.8
    var progress = clampf(_t / duration, 0, 1)
    if progress >= 1.0 and not _landed:
        _landed = true

        # play landing effects
        particles.process_material = config.particles_material
        particles.amount = config.particles_amount
        for i in config.particles_amount:
            particles.emit_particle(Transform2D.IDENTITY, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
        audio_land.play()
        
        # enable hitbox when ground reached
        _dev.dump("arrived at target")
        vfx.stop()
        hitbox.enable()
        remove_timer.wait_time = config.remove_wait_time
        remove_timer.start()
        
    elif progress < 1.0:
        # fall to ground
        _t += delta * 0.06 * FALL_SPEED_CURVE.sample(config.fall_speed)
        _dev.dump("t {0}, progress {1}", [_t, progress])
        
    global_position = lerp(start_position, target_position, progress)
