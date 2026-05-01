extends Node

var all: Array[Ability] = [
    preload("res://resources/abilities/raindrop/raindrop.tres"),
]

func get_next_abilities(current: Array[Ability]) -> Array[Ability]:
    var out: Array[Ability] = []
    for a in all:
        # already has
        if current.any(func(a2: Ability): return a2.name == a.name):
            continue
        # requires previous ability
        if not a.requires.is_empty() and not current.any(func (a2: Ability): return a.requires.has(a2.name)):
            continue
        out.append(a)
    return out
