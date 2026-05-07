extends CharacterBody2D
class_name Enemy

static var SCENE = preload("res://entities/enemy/enemy.tscn")
static var HP = preload("res://resources/curves/enemy_hp.tres")

@onready var sprite: EnemySprite = %EnemySprite
@onready var state: StateMachine = %StateMachine
@onready var hp: Hp = %Hp
@onready var hitbox: Hitbox = %Hitbox
@onready var vfx: Vfx = %Vfx
@onready var shadow: Shadow = %Shadow
@onready var audio: AudioController = %AudioController

@export var config: EnemyConfig

func _ready() -> void:
    add_to_group(Groups.enemy)
    hp.damaged.connect(_on_hp_damaged)
    hp.died.connect(_on_died)
    hitbox.apply_on_hit.connect(_on_apply_on_hit)

    state.character = self
    hp.current = HP.sample(0)
    if config:
        hp.current = HP.sample(config.hp)
        state.switch(config.initial_state)
        name = config.name

func _on_hp_damaged(_amount: int):
    audio.play(config.audio_on_take_damage)
    vfx.hurt = 1.0
    vfx.bounce()

func _on_apply_on_hit(_source: Hitbox, on_hit: OnHitEffect):
    on_hit.apply_hp(hp)
    
func _on_died():
    var parent = get_parent()
    if parent:
        parent.remove_child.call_deferred(self)

func _process(delta: float) -> void:
    shadow.position = config.shadow_offset
    state.character = self
    if config:
        if config.sprite:
            sprite.use_sprite(config.sprite)
        elif config.sprite_frames:
            sprite.use_sprite_frames(config.sprite_frames)
        vfx.scale = Vector2.ONE * lerp(1.5, 2.5, config.size)
        hitbox.on_hit_effects = config.hitbox_on_hit_effects
        hitbox.config = config.hitbox
