extends Resource
class_name OnHitEffect

@export var name: String
@export var target_self: bool
@export var hit_self: bool
@export var hit_ally: bool
@export var hit_enemy: bool = true

func apply():
    pass

func apply_hp(hp: Hp):
    pass
