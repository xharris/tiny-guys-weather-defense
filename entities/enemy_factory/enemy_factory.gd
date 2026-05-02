extends Node2D
class_name EnemyFactory

var _dev = Dev.new()

static var SPAWN_EVERY = preload("res://resources/curves/enemy_spawn_every.tres")
static var SPAWN_LIMIT = preload("res://resources/curves/enemy_spawn_limit.tres")

signal spawned(enemy: Enemy)
signal wave_finished

@onready var spawn_timer: Timer = %Spawn

@export var wave: Wave
@export var disabled: bool

var wave_count: int = 0

var _rand = RandomNumberGenerator.new()
var _spawn_count = 0

func spawn_enemy():
    if disabled:
        return
    if not wave:
        spawn_timer.wait_time = 1.0
        return

    var enemy_count = get_tree().get_node_count_in_group(Groups.enemy)
    var enemies = wave.enemy_pool
    if enemies.size() > 0:
        var weights = enemies.map(func(e: EnemyConfig): return e.spawn_weight)
        var enemy_config = enemies[_rand.rand_weighted(weights)]
        var enemy: Enemy = Enemy.SCENE.instantiate()
        _spawn_count += 1
        enemy.config = enemy_config
        var enemy_limit = SPAWN_LIMIT.sample(wave.enemy_spawn_limit)
        _dev.dump("spawn {0} ({1}/{2})", [enemy_config.name, _spawn_count, enemy_limit])
        spawned.emit(enemy)
        if _spawn_count >= enemy_limit:
            _dev.dump("reached enemy limit of {0} ({1})", [enemy_limit, wave.enemy_spawn_limit])
            wave_count += 1
            _spawn_count = 0
            wave = null
            wave_finished.emit()
        else:
            spawn_timer.wait_time = SPAWN_EVERY.sample(wave.enemy_every)

func _ready() -> void:
    add_to_group(Groups.enemy_factory)
    spawn_timer.timeout.connect(spawn_enemy)
