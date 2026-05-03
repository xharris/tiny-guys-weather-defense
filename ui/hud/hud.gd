extends Control
class_name Hud

var _dev = Dev.new(true)

static var TEX_CRIT = preload("res://ui/hud/crit.png")
static var TEX_CDR = preload("res://ui/hud/cdr.png")

@onready var _stats: BoxContainer = %Stats
@onready var _abilities: BoxContainer = %Abilities

@export var colors: ThemeColors
var ability_ctrl: AbilityController

func _get_hud_icon(ability: Ability):
    # get existing
    for c: HudIcon in _abilities.get_children():
        if c.ability.name == ability.name:
            return c
    # doesn't exist, add one
    var hud: HudIcon = HudIcon.SCENE.instantiate()
    _abilities.add_child(hud)
    hud.ability = ability
    _dev.dump("add hud ability {0}", [ability.name])
    return hud

## [code]fill[/code] is how much to fill cooldown meter (1.0 means off cooldown)
func set_ability_cooldown(ability: Ability, fill: float = 1.0):
    var hud = _get_hud_icon(ability)
    hud.fill = fill

func _process(delta: float) -> void:
    if ability_ctrl:
        # _stats
        if ability_ctrl.crit_chance > 0.01:
            var hud = HudIcon.get_by_id(_stats, "stats.crit_chance")
            hud.subtext = "{0}%".format([int(ability_ctrl.crit_chance * 100)])
            hud.icon = TEX_CRIT
            hud.color_fg = colors.accent
            hud.color_bg = colors.accent_content
            hud.fill = ability_ctrl.crit_chance
            
        if ability_ctrl.cooldown_reduction > 0:
            var hud = HudIcon.get_by_id(_stats, "stats.cooldown_reduction")
            hud.subtext = "{0}%".format([int(ability_ctrl.cooldown_reduction * 100)])
            hud.icon = TEX_CDR
            hud.color_fg = colors.accent
            hud.color_bg = colors.accent_content
            hud.fill = ability_ctrl.cooldown_reduction
    
        # abilities
        for a: Ability in ability_ctrl.abilities:
            match a.step:
                Ability.Step.ACTIVE:
                    var hud = HudIcon.get_by_id(_abilities, a.name)
                    hud.fill = 1 - ability_ctrl.get_cooldown_progress(a)
                    hud.ease_fill = true
                    hud.color_fg = colors.primary
                    hud.color_bg = colors.primary_content
                    hud.icon = a.icon
