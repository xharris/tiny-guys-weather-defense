extends Control
class_name Hud

var _dev = Dev.new(true)

@onready var abilities: HBoxContainer = %Abilities

func _get_hud_ability(ability: Ability):
    # get existing
    for c: HudAbility in abilities.get_children():
        if c.ability.name == ability.name:
            return c
    # doesn't exist, add one
    var hud: HudAbility = HudAbility.SCENE.instantiate()
    abilities.add_child(hud)
    hud.ability = ability
    _dev.dump("add hud ability {0}", [ability.name])
    return hud

## [code]fill[/code] is how much to fill cooldown meter (1.0 means off cooldown)
func set_ability_cooldown(ability: Ability, fill: float = 1.0):
    var hud = _get_hud_ability(ability)
    hud.fill = fill
