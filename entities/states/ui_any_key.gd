extends State
class_name StateUiAnyKey

var _dev = Dev.new()

@export var ui: PackedScene
@export_file("*.tres") var on_any_key: String = ""
@export_placeholder("dismiss|ui_hide") var ui_dismiss_method: String

func _enter(me: StateMachine):
    # add UI component
    if not me.add_ui(ui):
        return me.switch()

func _exit(me: StateMachine):
    # remove UI component
    me.remove_ui(ui, ui_dismiss_method)

func _unhandled_input(me: StateMachine, event: InputEvent) -> void:
    # move to next state when any key pressed
    if event.is_action_type() and event.is_pressed():
        _dev.dump("any key pressed")
        var next_state: State = load(on_any_key)
        me.switch(next_state)
