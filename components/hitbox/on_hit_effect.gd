extends Resource
class_name OnHitEffect

@export var name: String
@export var hit_self: bool
@export_enum(Groups.base, Groups.enemy) var hit_groups: Array[String]

func apply():
    pass

func apply_hp(hp: Hp):
    pass
