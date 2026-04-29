extends Node2D
class_name EnemyFactory

var _dev = Dev.new(true)

static var SPAWN_EVERY = preload("res://resources/curves/enemy_spawn_every.tres")
static var SPAWN_LIMIT = preload("res://resources/curves/enemy_spawn_limit.tres")

signal spawned(enemy: Enemy)
signal wave_finished

@onready var spawn_timer: Timer = %Spawn
@onready var wave_timer: Timer = %Wave

@export var wave: Wave

var wave_count: int = 0
var _rand = RandomNumberGenerator.new()
var _spawn_enemy_count: int = 0

func spawn_enemy():
    if not wave:
        spawn_timer.wait_time = 1.0
        return
    _spawn_enemy_count += 1
    var enemies = wave.enemy_pool
    if enemies.size() > 0:
        var weights = enemies.map(func(e: EnemyConfig): return e.spawn_weight)
        var enemy_config = enemies[_rand.rand_weighted(weights)]
        var enemy: Enemy = Enemy.SCENE.instantiate()
        enemy.config = enemy_config
        _dev.dump("spawn {0}", [enemy_config.name])
        spawned.emit(enemy)
        var enemy_limit = SPAWN_LIMIT.sample(wave.enemy_spawn_limit)
        if _spawn_enemy_count >= enemy_limit:
            _dev.dump("reached enemy limit ({0})", [enemy_limit])
            wave_count += 1
            wave = null
            _spawn_enemy_count = 0
            wave_finished.emit()
        else:
            spawn_timer.wait_time = SPAWN_EVERY.sample(wave.enemy_every)

func _ready() -> void:
    spawn_timer.timeout.connect(spawn_enemy)
