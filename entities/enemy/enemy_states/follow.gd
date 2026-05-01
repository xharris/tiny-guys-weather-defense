extends State
class_name StateFollow

@export var on_no_leader: State
@export var leader_name: String
@export var follows_leader_by_name: String

func _process(me: StateMachine, delta: float):
    pass
    # find leader
    
    # move toward them
