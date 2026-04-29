extends Node2D
class_name Player

var _dev = Dev.new(true)

@onready var sprite: PlayerSprite = %PlayerSprite
@onready var orbit_aim: OrbitAim = %OrbitAim
@onready var ability_ctrl: AbilityController = %AbilityController

## Player will orbit around the base when aiming
@export var base: Node2D
@export var abilities: Array[Ability]

func _ready() -> void:
    ability_ctrl.abilities = abilities

func _process(delta: float) -> void:
    var anchor = self
    if base:
        anchor = base
    var aim_dir = orbit_aim.get_aim_dir(anchor.global_position)

    ability_ctrl.aim_position = orbit_aim.aim_position
    ability_ctrl.aim_dir = aim_dir
    ability_ctrl.spawn_position = sprite.wand_tip.global_position
    sprite.aim_dir = aim_dir
    if anchor != self:
        global_position = orbit_aim.get_orbit_position(anchor)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("primary"):
        ability_ctrl.use()
