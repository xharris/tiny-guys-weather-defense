extends Node2D
class_name StateMachine

var _dev = Dev.new()

@export var character: CharacterBody2D
var current: State
var duration: float = 0.0

func switch(state: State):
    if current:
        _dev.dump("exit {0}", [current.resource_path.get_file()])
        current._exit(self)
    current = state
    if current:
        _dev.dump("enter {0}", [current.resource_path.get_file()])
        duration = 0.0
        current._enter(self)

func _ready() -> void:
    switch(current)
    
func _process(delta: float) -> void:
    if current:
        duration += delta
    if current and current.max_duration > 0 and duration >= current.max_duration:
        var next = current.max_duration_state
        if next == null and current.max_duration_state_path != "":
            next = load(current.max_duration_state_path)
        switch(next)
    if current:
        current._process(self, delta)
