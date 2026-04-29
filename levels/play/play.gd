extends Node2D
class_name Play

var _dev = Dev.new(true)

@onready var camera: Camera2D = %Camera2D
@onready var base: Base = %Base
@onready var player: Player = %Player
@onready var enemy_factory: EnemyFactory = %EnemyFactory
@onready var entities: Node2D = %Entities

func _ready() -> void:
    entities.add_to_group(Groups.entities)
    enemy_factory.spawned.connect(_on_enemy_factory_spawned)
    base.hp.died.connect(_on_base_died)

func _on_enemy_factory_spawned(enemy: Enemy):
    var world_size = get_viewport_rect().size / camera.zoom
    entities.add_child(enemy)
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
    _dev.dump("enemy position {0}", [enemy.global_position])

func _on_base_died():
    pass # show game over UI

func _process(delta: float) -> void:
    camera.global_position = base.global_position.move_toward(player.global_position, 40)
