extends Node2D
class_name StateMachine

var _dev = Dev.new()

static var UI_DISMISS_METHODS = ["dismiss", "ui_hide"]

@export var character: CharacterBody2D
@export var vfx: Vfx
@export var current: State
@export var ui: Node
@export var ability_ctrl: AbilityController

var duration: float = 0.0
var prev_state: State

func add_ui(scene: PackedScene) -> Control:
    if not ui:
        _dev.warn("[code]ui[/code] not set")
        return null
    var instance: Control = scene.instantiate()
    ui.add_child(instance)
    instance.owner = ui # NOTE required for find_children call
    return instance
    
func remove_ui(scene: PackedScene, dismiss_method: String = ""):
    var dismiss_methods = UI_DISMISS_METHODS.duplicate()
    if not dismiss_method.is_empty():
        dismiss_methods.append(dismiss_method)
    if not ui:
        _dev.warn("[code]ui[/code] not set")
    var found = false
    for c in ui.find_children("*"):
        if c.scene_file_path == scene.resource_path:
            found = true
            # try to gracefully dismiss UI
            var dismissed = false
            for method in dismiss_methods:
                if c.has_method(method):
                    _dev.dump("dismissed {0} with {1}", [c.scene_file_path.get_file(), method])
                    dismissed = true
                    c.call(method)
            if not dismissed:
                # not dismissed, remove it
                _dev.dump("not dismissed, just remove it ({0})", [c.get_path()])
                var parent = c.get_parent()
                if parent:
                    parent.remove_child(c)
    if not found:
        _dev.warn("cannot remove ui, {0} not found in state {1}", [scene.resource_path, current.resource_path.get_file()])

func go_to_previous():
    if not prev_state:
        _dev.warn("no previous state")
        return
    switch(prev_state)

func switch(state: State = null):
    if current:
        _dev.dump("exit {0}", [current.resource_path.get_file()])
        current._exit(self)
        prev_state = current
    current = state
    if current:
        _dev.dump("enter {0}", [current.resource_path.get_file()])
        duration = 0.0
        current._enter(self)
    else:
        _dev.warn("switch to nothing")

func _ready() -> void:
    if current:
        var temp_current = current
        current = null
        switch.call_deferred(temp_current)

func _process(delta: float) -> void:
    if current:
        duration += delta
    if current and current.max_duration > 0 and duration >= current.max_duration:
        _dev.dump("reached max duration")
        var next = current.max_duration_state
        if next == null and current.max_duration_state_path != "":
            next = load(current.max_duration_state_path)
        switch(next)
    if current:
        current._process(self, delta)

func _unhandled_input(event: InputEvent) -> void:
    if current:
        current._unhandled_input(self, event)
