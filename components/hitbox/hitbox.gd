extends Area2D
class_name Hitbox

signal on_hit(hurtbox: Area2D)
signal on_hurt(hitbox: Area2D)

@export var is_hitbox: bool = true
@export var is_hurtbox: bool = true
@export var disabled: bool = false

var _entered: Dictionary[Area2D, bool]

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    
func _on_area_entered(area: Area2D):
    if disabled:
        return
    if _entered.get(area, false):
        return
    _entered.set(area, true)
    if area is Hitbox:
        if area.disabled:
            return
        if is_hitbox and area.is_hurtbox:
            on_hit.emit(area)
        if is_hurtbox and area.is_hitbox:
            on_hurt.emit(area)

func _process(delta: float) -> void:
    for node in find_children("*"):
        if node is CollisionShape2D:
            if disabled:
                node.debug_color = Color.html("#F44336")
            else:
                node.debug_color = Color.html("#4CAF50")
