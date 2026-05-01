extends Node2D
class_name AbilityController

static var COOLDOWN = preload("res://resources/curves/ability_cooldown.tres")

var _dev = Dev.new(true)

@export var abilities: Array[Ability] = []
@export var crit_chance: float = 0.0:
    set(v):
        crit_chance = clampf(v, 0, 1)
        if _initial_crit_chance < 0:
            _initial_crit_chance = crit_chance
@export_range(0, 1, 0.1) var cooldown_reduction: float = 0.0:
    set(v):
        cooldown_reduction = clampf(v, 0, 1)
        if _initial_cooldown_reduction < 0:
            _initial_cooldown_reduction = cooldown_reduction
        
var _initial_cooldown_reduction: float = -1
var _initial_crit_chance: float = -1
var aim_position: Vector2
var aim_dir: Vector2
var spawn_position: Vector2
var _cooldown: Dictionary[String, float]

func get_context() -> AbilityContext:
    var ctx = AbilityContext.new()
    ctx.ctrl = self
    return ctx

func use():
    var entities = get_tree().get_first_node_in_group(Groups.entities)
    
    var actives: Array[Ability] = abilities.filter(func(a: Ability): return a.step == Ability.Step.ACTIVE)
    var calc_stats: Array[Ability] = abilities.filter(func(a: Ability): return a.step == Ability.Step.CALC_STATS)
    
    # reset stats
    crit_chance = _initial_crit_chance
    cooldown_reduction = _initial_cooldown_reduction
    
    # modify stats
    for a in calc_stats:
        _dev.dump("calc stats {0}", [a.name])
        a.use(get_context())
    var is_critical = randf() <= crit_chance
        
    _dev.dump("stats: crit_chance={0}, is_critical={1}", [crit_chance, is_critical])
    
    # use actives
    for a in actives:
        var cd = _cooldown.get(a.name, 0.0)
        # is off cooldown?
        if cd > 0:
            _dev.dump("{0} on cooldown", [a.name])
            continue
        # can crit?
        if is_critical and not a.can_crit and not a.only_crit:
            _dev.dump("{0} cannot crit", [a.name])
            continue
        # can only crit?
        if not is_critical and a.only_crit:
            _dev.dump("{0} can only crit", [a.name])
            continue
        _cooldown.set(a.name, COOLDOWN.sample(a.cooldown * (1 - cooldown_reduction)))
        _dev.dump("active {0}", [a.name])
        for i in max(1, a.repeat):
            var ctx = get_context()
            ctx.is_critical = is_critical
            var add_nodes = a.use(ctx)
            if entities:
                for add_node in add_nodes:
                    _dev.dump("add {0} to {1}", [add_node.name, entities.name])
                    add_node.global_position = ctx.ctrl.spawn_position
                    entities.add_child(add_node)
            else:
                _dev.warn("no Entities")

func _process(delta: float) -> void:
    for ability_name in _cooldown:
        var t = _cooldown.get(ability_name, 0.0)
        if t > 0:
            t -= delta
        _cooldown.set(ability_name, t)
        
