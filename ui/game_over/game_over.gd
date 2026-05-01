extends Control
class_name UiGameOver

signal try_again

@onready var try_again_timer: Timer = %TryAgain
@onready var try_again_label: Label = %LabelTryAgain

var _try_again_ready = false

func _ready() -> void:
    visibility_changed.connect(_on_visibility_changed)
    try_again_timer.timeout.connect(_on_try_again_timeout)
    hide()
    try_again_label.hide()
    
func _on_visibility_changed():
    if visible:
        try_again_timer.start()
    
func _on_try_again_timeout():
    _try_again_ready = true
    try_again_label.show()

func _unhandled_input(event: InputEvent) -> void:
    if _try_again_ready and event.is_action_type():
        try_again.emit()
