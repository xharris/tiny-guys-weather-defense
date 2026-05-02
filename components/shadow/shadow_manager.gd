extends Node2D
class_name ShadowManager

@onready var canvas: CanvasGroup = %CanvasGroup

var alpha: float = 0.2

func _process(delta: float) -> void:
    canvas.self_modulate = Color(0, 0, 0, alpha)
    
    for shadow: Shadow in get_tree().get_nodes_in_group(Groups.shadow):
        if not shadow._placeholder and not shadow._is_placeholder:
            var placeholder: Shadow = Shadow.SCENE.instantiate()
            placeholder._is_placeholder = true
            placeholder.name = "{0}Shadow".format([shadow.owner if shadow.owner else shadow.name])
            shadow._placeholder = placeholder
            canvas.add_child(placeholder)
