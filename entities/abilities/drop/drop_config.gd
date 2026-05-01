extends Ability
class_name AbilityDrop

@export var sprite: Texture2D
@export var sprite_color: Color = Color.WHITE
@export_range(0, 1, 0.2) var fall_speed: float = 0.0
@export var slant: float = 0.0
@export var trail: TrailConfig
@export var on_hit_effects: Array[OnHitEffect]
@export var remove_wait_time: float = 0.1
@export var hitbox: HitboxConfig
@export var cloud: CloudSpriteConfig

@export var land_audio: AudioStream
@export var on_hit_audio: AudioStream

@export_group("Particles", "particles_")
@export var particles_amount: int = 8
@export var particles_material: ParticleProcessMaterial

func use(ctx: AbilityContext) -> Array[Node2D]:
    var drop: Drop = Drop.SCENE.instantiate()
    drop.config = self
    drop.ctx = ctx
    return [drop]
