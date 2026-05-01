extends Node

var all: Array[Ability] = [
    preload("res://resources/abilities/raindrop/raindrop.tres"),
    preload("res://resources/abilities/lightning_strike/lightning_strike.tres"),
    preload("res://resources/abilities/crit_chance/add_low_crit.tres"),
    preload("res://resources/abilities/crit_chance/add_mid_crit.tres"),
    preload("res://resources/abilities/crit_chance/add_high_crit.tres"),
]

func get_next_abilities(ctrl: AbilityController, current: Array[Ability]) -> Array[Ability]:
    var out: Array[Ability] = []
    for a in all:
        # chance
        if randf() > a.weight:
            continue
        # cannot pick it
        if a.can_pick.any(func(c: AbilityCanPick): return not c.can_pick(ctrl)):
            continue
        # already has this ability
        if current.any(func(a2: Ability): return a2.name == a.name):
            continue
        # need at least one non crit
        if a.only_crit and not current.any(func(a2: Ability): return not a2.only_crit):
            continue
        # requires previous ability
        if not a.requires.is_empty() and not current.any(func (a2: Ability): return a.requires.has(a2.name)):
            continue
        out.append(a)
    return out
