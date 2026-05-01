extends Control
class_name UiGameEnd

static var SCENE = preload("res://ui/game_end/game_end.tscn")

signal any_key

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_type():
        any_key.emit()
