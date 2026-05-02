extends Ability
class_name AbilityLine

enum ParticlesPosition {END, START}

@export_group("Line", "line")
@export var line_texture: Texture2D
@export var line_color: Color

@export_group("Hitbox", "hitbox")
@export var hitbox: HitboxConfig
@export var hitbox_on_hit_effects: Array[OnHitEffect]

@export_group("Audio", "audio")
@export var audio_on_hit: AudioStream

@export_group("Particles", "particles")
@export var particles_position: ParticlesPosition
@export var particles_texture: Texture2D
@export var particles_amount: int = 8
@export var particles_process_material: ParticleProcessMaterial

func use(ctx: AbilityContext) -> Array[Node2D]:
    var me: Line = Line.SCENE.instantiate()
    me.config = self
    me.ctx = ctx
    return [me]
