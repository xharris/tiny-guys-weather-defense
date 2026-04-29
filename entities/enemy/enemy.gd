extends CharacterBody2D
class_name Enemy

static var SCENE = preload("res://entities/enemy/enemy.tscn")
static var HP = preload("res://resources/curves/enemy_hp.tres")

@onready var sprite: EnemySprite = %EnemySprite
@onready var state: StateMachine = %StateMachine
@onready var hp: Hp = %Hp
@onready var hitbox: Hitbox = %Hitbox
@onready var hitbox_shape: CollisionShape2D = %CollisionShape2D

@export var config: EnemyConfig

func _ready() -> void:
    add_to_group(Groups.enemy)
    hp.died.connect(_on_died)
    hitbox.apply_on_hit.connect(_on_apply_on_hit)

    state.character = self
    hp.current = HP.sample(0)
    if config:
        hp.current = HP.sample(config.hp)
        state.switch(config.initial_state)

func _on_apply_on_hit(_source: Hitbox, on_hit: OnHitEffect):
    on_hit.apply_hp(hp)
    
func _on_died():
    var parent = get_parent()
    if parent:
        parent.remove_child.call_deferred(self)

func _process(delta: float) -> void:
    state.character = self
    if config:
        sprite.sprite.texture = config.sprite
        hitbox.on_hit_effects = config.hitbox_on_hit_effects
        var shape = hitbox_shape.shape
        if shape is CircleShape2D:
            shape.radius = config.hitbox_radius
