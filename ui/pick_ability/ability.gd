extends Button
class_name UiAbility

static var SCENE = preload("res://ui/pick_ability/ability.tscn")

@onready var ability_name: Label = %AbilityName
@onready var ability_description: Label = %AbilityDescription
@onready var audio: AudioStreamPlayer2D = %AudioStreamPlayer2D

var ability: Ability

func _pressed() -> void:
    _on_pressed()

func _on_pressed():
    print("play it")
    audio.play()
    NodeUtil.move_up_in_tree(audio)

func _process(delta: float) -> void:
    if ability:
        ability_name.text = ability.name
        ability_description.text = ability.description
