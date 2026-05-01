extends Resource
class_name State

## How long the current state has been running for[br]
## [code]0[/code] = infinite duration
@export var max_duration: float = 0.0
## State to switch to when [code]max_duration[/code] is reached
@export var max_duration_state: State
## Use this instead of max_duration_state to avoid circular resource references
@export_file("*.tres") var max_duration_state_path: String = ""

func _enter(me: StateMachine):
    pass

func _process(me: StateMachine, delta: float):
    pass
    
func _exit(me: StateMachine):
    pass

func _unhandled_input(me: StateMachine, event: InputEvent) -> void:
    pass
