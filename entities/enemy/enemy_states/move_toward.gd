extends State
class_name StateMoveToward

static var VELOCITY = preload("res://resources/curves/move_toward_velocity.tres")

@export_range(0, 1, 0.2) var velocity: float = 0.0

func _process(me: StateMachine, delta: float):
    var base = Base.get_closest(me)
    if base and me.character:
        me.character.velocity = (base.global_position - me.character.global_position).normalized() * VELOCITY.sample(velocity)
        me.character.move_and_slide()
