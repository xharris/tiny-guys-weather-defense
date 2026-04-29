extends Node2D
class_name Play

var _dev = Dev.new(true)

static var WAVES = preload("res://resources/curves/waves.tres")

@onready var camera: Camera2D = %Camera2D
@onready var base: Base = %Base
@onready var player: Player = %Player
@onready var enemy_factory: EnemyFactory = %EnemyFactory
@onready var entities: Node2D = %Entities

@export var waves: Array[Wave]

var _difficulty: float = 0.0
var _ready_for_wave: bool = true

func increase_difficulty():
    _difficulty += 0.1

func pick_wave() -> bool:
    if waves.is_empty():
        _dev.dump("no waves left")
        return false
    var weights = waves.map(func (w: Wave):
        return w.weight if w.get_difficulty() <= _difficulty else 0.0)
    enemy_factory.wave = waves.pick_random()
    _dev.dump("pick wave {0}", [enemy_factory.wave.resource_path.get_file()])
    return true

func _ready() -> void:
    entities.add_to_group(Groups.entities)
    enemy_factory.spawned.connect(_on_enemy_factory_spawned)
    enemy_factory.wave_finished.connect(_check_ready_wave, CONNECT_DEFERRED)
    base.hp.died.connect(_on_base_died)
    
func _check_ready_wave():
    var enemy_count = get_tree().get_node_count_in_group(Groups.enemy)
    _dev.dump("check, enemy count: {0}", [enemy_count])
    if enemy_count <= 0:
        _ready_for_wave = true

func _on_enemy_factory_spawned(enemy: Enemy):
    entities.add_child(enemy)
    # get random position outside of viewport
    var world_size = get_viewport_rect().size / camera.zoom
    var half_size = world_size / 2
    var world_rect = Rect2(camera.global_position - half_size, world_size)
    var margin = 64.0
    var random_position: Vector2
    match randi() % 4:
        0: random_position = Vector2(randf_range(world_rect.position.x, world_rect.end.x), world_rect.position.y - margin)
        1: random_position = Vector2(randf_range(world_rect.position.x, world_rect.end.x), world_rect.end.y + margin)
        2: random_position = Vector2(world_rect.position.x - margin, randf_range(world_rect.position.y, world_rect.end.y))
        _: random_position = Vector2(world_rect.end.x + margin, randf_range(world_rect.position.y, world_rect.end.y))
    enemy.global_position = random_position
    enemy.hp.died.connect(_check_ready_wave, CONNECT_DEFERRED)
    _dev.dump("enemy position {0}", [enemy.global_position])

func _on_base_died():
    pass # show game over UI

func _process(delta: float) -> void:
    camera.global_position = base.global_position.move_toward(player.global_position, 40)
    if _ready_for_wave:
        if pick_wave():
            increase_difficulty()
        _ready_for_wave = false
