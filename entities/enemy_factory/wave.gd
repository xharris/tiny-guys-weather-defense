extends Resource
class_name Wave

@export_group("Enemies", "enemy_")
@export var enemy_pool: Array[EnemyConfig]
@export_range(0, 1, 0.2) var enemy_every: float = 1.0
@export_range(0, 1, 0.2) var enemy_spawn_limit: float = 0.0
@export var weight: float = 1.0
## Override difficulty
@export var difficulty: float = -1.0

func get_difficulty() -> float:
    if difficulty >= 0.0:
        return difficulty
    return ((1 - enemy_every) + clampf(enemy_pool.size() / 5.0, 0, 1)) / 2
