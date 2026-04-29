extends OnHitEffect
class_name OnHitDealDamage

static var DEAL_DAMAGE = preload("res://resources/curves/deal_damage.tres")

@export var amount: float = 0.0
@export var kills: bool

func apply_hp(hp: Hp):
    if kills:
        hp.take_damage(hp.current)
    else:
        hp.take_damage(DEAL_DAMAGE.sample(amount))
