extends State
class_name StatePickAbility

var _dev = Dev.new(true)

@export var ability_count: int = 3

func _enter(me: StateMachine):
    if not me.ui:
        return _dev.warn("no [code]ui[/code] set")
    var instance: UiPickAbility = me.add_ui(UiPickAbility.SCENE)
    if not instance:
        return
    instance.on_ability_picked.connect(_on_ability_picked.bind(me), CONNECT_ONE_SHOT)
    # add abilities
    if not me.ability_ctrl:
        return _dev.warn("no [code]ability_ctrl[/code] set")
    var all_next = Abilities.get_next_abilities(me.ability_ctrl.abilities)
    if all_next.is_empty():
        _dev.dump("no abilities to pick")
        return me.go_to_previous()
    var next: Array[Ability] = []
    for i in 3:
        var a: Ability = all_next.pick_random()
        next.append(a)
        all_next.erase(a)
        if all_next.is_empty():
            break
    instance.set_abilities(next)

func _exit(me: StateMachine):
    # clear ui
    me.remove_ui(UiPickAbility.SCENE)
    # reset how many waves until pick next ability
    var data = Metadata.get_data(me)
    data.waves_until_pick_ability = 3
    
func _on_ability_picked(a: Ability, me: StateMachine):
    if not me.ability_ctrl:
        return _dev.warn("no [code]ability_ctrl[/code]")
    _dev.dump("add ability {0}", [a.name])
    me.ability_ctrl.abilities.append(a)
    me.go_to_previous()
