extends Resource
class_name Wave

var _dev = Dev.new()

@export var name: String

@export_group("Enemies", "enemy_")
@export var enemy_pool: Array[EnemyConfig]
@export_range(0, 1, 0.05) var enemy_every: float = 1.0
@export_range(0, 1, 0.05) var enemy_spawn_limit: float = 0.0
@export var weight: float = 1.0
## Override difficulty
@export_range(0, 1, 0.05) var difficulty: float = -1.0

func get_difficulty() -> float:
    var ret = difficulty
    if difficulty < 0.0:
        ret = ((1 - enemy_every) + clampf(enemy_pool.size() / 5.0, 0, 1)) / 2
    _dev.dump("{0}, difficulty={1}", [name, ret])
    return ret
