extends Node

var _dev = Dev.new()

var all: Array[Ability] = [
    # actives
    preload("res://resources/abilities/raindrop/raindrop.tres"),
    preload("res://resources/abilities/lightning_strike/lightning_strike.tres"),
    # crit
    preload("res://resources/abilities/crit_chance/add_low_crit.tres"),
    preload("res://resources/abilities/crit_chance/add_mid_crit.tres"),
    preload("res://resources/abilities/crit_chance/add_high_crit.tres"),
    # cdr
    preload("res://resources/abilities/cdr/low_cdr.tres"),
    preload("res://resources/abilities/cdr/high_cdr.tres"),
]

func get_next_abilities(ctrl: AbilityController, current: Array[Ability]) -> Array[Ability]:
    var out: Array[Ability] = []
    for a in all:
        _dev.dump("pick {0}?", [a.name])
        # chance
        var chance = randf()
        if randf() > a.weight:
            _dev.dump("not a chance ({0} > {1})", [chance, a.weight])
            continue
        # cannot pick it
        if a.can_pick.any(func(c: AbilityCanPick): return not c.can_pick(ctrl)):
            _dev.dump("can_pick not satisfied")
            continue
        # already has this ability
        if a.step == Ability.Step.ACTIVE and current.any(func(a2: Ability): return a2.name == a.name):
            _dev.dump("already has active ability")
            continue
        # need at least one non crit
        if ctrl.crit_chance <= 0 and a.only_crit and not current.any(func(a2: Ability): return not a2.only_crit):
            _dev.dump("need at least one non-crit ability first")
            continue
        # requires previous ability
        if not a.requires.is_empty() and not current.any(func (a2: Ability): return a.requires.has(a2.name)):
            _dev.dump("requires abilities: {0}", [a.requires.map(func (a2: Ability): return a2.name)])
            continue
        _dev.dump("added {0}", [a.name])
        out.append(a)
    return out
