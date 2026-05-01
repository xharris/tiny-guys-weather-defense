extends Node2D
class_name Base

static var HP = preload("res://resources/curves/base_hp.tres")

static func get_closest(to: Node2D) -> Base:
    return NodeUtil.get_closest(to.get_tree().get_nodes_in_group(Groups.base), to)

@onready var sprite: BaseSprite = %BaseSprite
@onready var hp: Hp = %Hp
@onready var hitbox: Hitbox = %Hitbox
@onready var vfx: Vfx = %Vfx
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var shadow: Shadow = %Shadow

@export var config: BaseConfig

func get_hp_scale() -> float:
    return min(sprite.sprite.global_scale.y, sprite.sprite.global_scale.x)

func get_radius() -> float:
    return (config.orbit_radius if config else 32.0) * get_hp_scale()
    
func _ready() -> void:
    add_to_group(Groups.base)
    hp.damaged.connect(_on_hp_damaged)
    hitbox.apply_on_hit.connect(_on_apply_on_hit)
    if config:
        hp.current = HP.sample(config.hp)

func _on_hp_damaged(_amount: int):
    audio_player.play()
    vfx.hurt = 1.0
    vfx.bounce()
    
func _on_apply_on_hit(_source: Hitbox, on_hit: OnHitEffect):
    on_hit.apply_hp(hp)

func _process(delta: float) -> void:
    shadow.size = sprite.get_hp_scale().length() * 20
    sprite.health = hp.current / HP.sample(1.0)
    if config:
        sprite.sprite.texture = config.sprite
        hitbox.config = config.hitbox
        hitbox.shape_scale = Vector2.ONE * get_hp_scale()
