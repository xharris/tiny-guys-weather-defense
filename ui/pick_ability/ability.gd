extends Button
class_name UiAbility

static var SCENE = preload("res://ui/pick_ability/ability.tscn")

@onready var ability_name: Label = %AbilityName
@onready var ability_description: Label = %AbilityDescription

var ability: Ability

func _process(delta: float) -> void:
    if ability:
        ability_name.text = ability.name
        ability_description.text = ability.description
