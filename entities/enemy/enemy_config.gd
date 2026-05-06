extends Resource
class_name EnemyConfig

@export var name: String
@export var spawn_weight: float = 1.0
@export var sprite: Texture2D
@export var sprite_frames: SpriteFrames
@export var size: float = 0.0
@export var initial_state: State
@export var count: int = 1
@export var count_range: int = 0
@export var count_time_between: float = 0.5
@export var hp: float = 0.0
@export var hitbox: HitboxConfig
@export var hitbox_on_hit_effects: Array[OnHitEffect]
@export var shadow_offset: Vector2

@export_group("Audio", "audio")
@export var audio_on_take_damage: AudioConfig
