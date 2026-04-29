extends Node2D
class_name EnemyFactory

static var SPAWN_EVERY = preload("res://resources/curves/enemy_spawn_every.tres")

signal spawned(enemy: Enemy)

var _dev = Dev.new(true)

@onready var spawn_timer: Timer = %Spawn

@export var every: float = 0.0
@export var enemies: Array[EnemyConfig]

var _rand = RandomNumberGenerator.new()

func _ready() -> void:
    spawn_timer.timeout.connect(_on_spawn_timer_timeout)
    spawn_timer.wait_time = SPAWN_EVERY.sample(every)

func _on_spawn_timer_timeout():
    spawn_timer.wait_time = SPAWN_EVERY.sample(every)
    if enemies.size() > 0:
        var weights = enemies.map(func(e: EnemyConfig): return e.spawn_weight)
        var enemy_config = enemies[_rand.rand_weighted(weights)]
        var enemy: Enemy = Enemy.SCENE.instantiate()
        enemy.config = enemy_config
        _dev.dump("spawn {0}", [enemy_config.name])
        spawned.emit(enemy)
