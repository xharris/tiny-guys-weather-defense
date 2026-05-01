extends Node2D
class_name Line

var _dev = Dev.new(true)

static var SCENE = preload("res://entities/abilities/line/line.tscn")

@export var config: AbilityLine

@onready var hitbox: Hitbox = %Hitbox
@onready var line: Line2D = %Line2D
@onready var hitbox_timer: Timer = %HitboxTimer
@onready var audio_on_hit: AudioStreamPlayer2D = %AudioOnHit
@onready var particles: GPUParticles2D = %GPUParticles2D
@onready var cloud_sprite: CloudSprite = %CloudSprite

var ctx: AbilityContext
var _fade: float = 1.0

func _ready() -> void:
    hitbox_timer.timeout.connect(_on_hitbox_timeout)

    # line2d
    line.texture = config.line_texture
    line.default_color = config.line_color
    var screen_height = get_viewport_rect().size.y
    var start_position = Vector2(ctx.ctrl.aim_position.x, ctx.ctrl.aim_position.y - screen_height)
    var target_position = ctx.ctrl.aim_position
    line.points = PackedVector2Array([start_position, target_position].map(func(p: Vector2):
        return to_local(p)))
    
    # hitbox
    hitbox.config = config.hitbox
    hitbox.on_hit_effects = config.hitbox_on_hit_effects
    hitbox.global_position = target_position
    
    # audio
    NodeUtil.move_up_in_tree(audio_on_hit)
    audio_on_hit.finished.connect(audio_on_hit.queue_free)
    audio_on_hit.stream = config.audio_on_hit
    audio_on_hit.global_position = target_position
    audio_on_hit.play()
    
    # particles
    particles.emitting = false
    match config.particles_position:
        AbilityLine.ParticlesPosition.START:
            remove_child(cloud_sprite)
            particles.global_position = start_position
        AbilityLine.ParticlesPosition.END:
            cloud_sprite.global_position = target_position
            particles.global_position = target_position
            
    particles.texture = config.particles_texture
    particles.process_material = config.particles_process_material
    particles.amount = config.particles_amount
    for i in config.particles_amount:
        particles.emit_particle(
            Transform2D.IDENTITY.translated(particles.global_position), 
            Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
    
    cloud_sprite.config = config.cloud
    cloud_sprite.dismiss()
        
func _on_hitbox_timeout():
    _dev.dump("disable hitbox")
    hitbox.disabled = true
    NodeUtil.move_up_in_tree(cloud_sprite)

func _process(delta: float) -> void:
    if _fade > 0:
        _fade -= delta
    else:
        # done, remove self
        NodeUtil.move_up_in_tree(cloud_sprite)
        var parent = get_parent()
        if parent:
            parent.remove_child(self)
    _fade = clampf(_fade, 0, 1)

    # line2d
    line.modulate.a = _fade
