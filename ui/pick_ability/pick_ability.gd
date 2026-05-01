extends Control
class_name UiPickAbility

static var SCENE = preload("res://ui/pick_ability/pick_ability.tscn")

signal on_ability_picked(a: Ability)

@onready var abilities_container: BoxContainer = %Abilities

func clear():
    for c in abilities_container.get_children():
        abilities_container.remove_child(c)

func set_abilities(abilities: Array[Ability]):
    clear()
    for a in abilities:
        var scene: UiAbility = UiAbility.SCENE.instantiate()
        scene.ability = a
        scene.pressed.connect(on_ability_picked.emit.bind(a))
        abilities_container.add_child(scene)
