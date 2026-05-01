extends State
class_name StatePlayGame

var _dev = Dev.new()

@export var on_no_wave_picked: State
@export var on_game_over: State
@export var on_pick_ability: State
@export var waves: Array[Wave]
@export var max_waves: int = 10

func _pick_wave(me: StateMachine):
    var metadata = Metadata.get_data(me)
    
    # time to pick abilities
    if metadata.waves_until_pick_ability <= 0:
        me.switch(on_pick_ability)
        return
    
    # pick next wave
    _dev.dump("pick wave")
    var lowest_difficulty = waves.reduce(func(prev: float, curr: Wave):
        var difficulty = curr.get_difficulty()
        return difficulty if difficulty <= prev else prev, 1.0)
    var difficulty: float = clampf(float(metadata.wave_count) / max_waves, lowest_difficulty, 1)
    metadata.difficulty = difficulty
    
    var owner: Play = me.owner
    if not owner:
        return
    var enemy_count = me.get_tree()\
        .get_nodes_in_group(Groups.enemy)\
        .filter(func (e: Enemy): return e.hp.is_alive())\
        .size()
    if enemy_count > 0:
        return

    var picked = true
    var possible_waves = waves.filter(func(w: Wave): return w.get_difficulty() <= difficulty)

    if possible_waves.is_empty():
        _dev.dump("no waves left")
        me.switch(on_no_wave_picked)
    else:
        # pick next wave
        var weights = possible_waves.map(func (w: Wave):
            return w.weight if w.get_difficulty() <= difficulty else 0.0)
        var next_wave: Wave = possible_waves.pick_random()
        owner.enemy_factory.wave = next_wave
        metadata.wave_count += 1
        metadata.waves_until_pick_ability -= 1
        _dev.dump("pick wave #{0} {1}", [metadata.wave_count, owner.enemy_factory.wave.resource_path.get_file()])

func _exit(me: StateMachine):
    var owner: Play = me.owner
    if not owner:
        return
    owner.enemy_factory.disabled = true
    owner.enemy_factory.wave_finished.disconnect(_pick_wave.bind(me))
    owner.enemy_factory.spawned.disconnect(_on_enemy_spawned.bind(me))

func _enter(me: StateMachine):
    var owner: Play = me.owner
    if not owner:
        return
    owner.enemy_factory.wave_finished.connect(_pick_wave.bind(me), CONNECT_DEFERRED)
    owner.enemy_factory.spawned.connect(_on_enemy_spawned.bind(me), CONNECT_DEFERRED)
    owner.base.hp.died.connect(me.switch.bind(on_game_over), CONNECT_ONE_SHOT)
    owner.enemy_factory.disabled = false
    _pick_wave(me)

func _on_enemy_spawned(enemy: Enemy, me: StateMachine):
    enemy.hp.died.connect(_pick_wave.bind(me), CONNECT_ONE_SHOT)

func _unhandled_input(me: StateMachine, event: InputEvent) -> void:
    # for testing purposes
    var owner: Play = me.owner
    if owner and event.is_action_pressed("debug_primary"):
        owner.base.hp.take_damage(owner.base.hp.current)
