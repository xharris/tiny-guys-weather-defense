extends Control
class_name UiPause

@onready var _items: VBoxContainer = %Items

@export var items: Array[PauseItemConfig]

var _is_paused: bool

func pause():
    _is_paused = true
    get_tree().paused = true
    set_items(items)
    show()

func resume():
    _is_paused = false
    hide()
    get_tree().paused = false

func set_items(items: Array[PauseItemConfig]):
    # remove items
    for c in _items.get_children():
        _items.remove_child(c)
    # add items
    for item in items:
        var new_item: PauseItem = PauseItem.SCENE.instantiate()
        new_item.config = item
        _items.add_child(new_item)

func _ready() -> void:
    hide()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("exit") and _is_paused:
        # exit game
        # TODO confirm
        get_tree().quit()

    elif event.is_action_pressed("pause") or event.is_action_pressed("exit"):
        # toggle pause
        if _is_paused:
            resume()
        else:
            pause()
