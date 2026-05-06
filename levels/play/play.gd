extends Node2D
class_name Play

var _dev = Dev.new(true)

static var WAVES = preload("res://resources/curves/waves.tres")
static var CAMERA_OFFSET = preload("res://resources/curves/camera_offset.tres")

@onready var camera: Camera2D = %Camera2D
@onready var base: Base = %Base
@onready var player: Player = %Player
@onready var enemy_factory: EnemyFactory = %EnemyFactory
@onready var entities: Node2D = %Entities
@onready var ui: CanvasLayer = %SpatialUI
@onready var states: StateMachine = %StateMachine
@onready var weather: VfxWeather = %VfxWeather
@onready var hud: Hud = %Hud
@onready var ui_non_dia: CanvasLayer = %NonDiageticUI

@export_range(0, 1, 0.1) var camera_offset: float = 0.0

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        _dev.dump("quit game")

func _ready() -> void:
    entities.add_to_group(Groups.entities)
    enemy_factory.spawned.connect(_on_enemy_factory_spawned)
    
    var view_rect = get_viewport_rect()
    ui.offset = -view_rect.size / 2
    states.ability_ctrl = player.ability_ctrl
    
    # random blades of grass
    for i in randi_range(15, 30):
        var instance: GrassBladeSprite = GrassBladeSprite.SCENE.instantiate()
        entities.add_child(instance)
        instance.scale = Vector2.ONE * randf_range(6, 8)
        instance.global_position = Vector2(
            randi_range(view_rect.position.x, view_rect.position.x + view_rect.size.x),
            randi_range(view_rect.position.y, view_rect.position.y + view_rect.size.y)
        ) - (view_rect.size/2)

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
    _dev.dump("enemy position {0}", [enemy.global_position])

func _process(delta: float) -> void:
    camera.global_position = base.global_position.move_toward(player.global_position, CAMERA_OFFSET.sample(camera_offset))
    hud.ability_ctrl = player.ability_ctrl
