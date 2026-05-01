extends Control
class_name UiTitle

static var SCENE = preload("res://ui/title/title.tscn")

signal any_key

var _hiding: bool

func ui_show():
    _hiding = false

func ui_hide():
    _hiding = true
    
func _process(delta: float) -> void:
    if _hiding:
        if modulate.a > 0:
            modulate.a -= delta * 0.2
        else:
            modulate.a = 0
            hide()
    else:
        show()
        if modulate.a < 1.0:
            modulate.a += min(1.0, delta * 0.2)
        else:
            
            modulate.a = 1.0
            show()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_type():
        any_key.emit()
