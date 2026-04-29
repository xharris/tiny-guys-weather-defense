extends CharacterBody2D
class_name Enemy

static var SCENE = preload("res://entities/enemy/enemy.tscn")

@onready var sprite: EnemySprite = %EnemySprite
@onready var state: StateMachine = %StateMachine

@export var config: EnemyConfig

func _ready() -> void:
    state.character = self
    if config:
        state.switch(config.initial_state)

func _process(delta: float) -> void:
    state.character = self
    if config:
        sprite.sprite.texture = config.sprite
