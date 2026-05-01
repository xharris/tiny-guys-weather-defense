extends State
class_name StateOrbitToward

static var VELOCITY = preload("res://resources/curves/orbit_toward_velocity.tres")

@export_range(0, 1, 0.1) var velocity: float = 0.0
@export var close_distance_speed: float = 0.0 # TODO

func _process(me: StateMachine, delta: float):
    var data = Metadata.get_data(me)
    var base = Base.get_closest(me)
    
    if base and me.character:
        var current_dist = me.global_position.distance_to(base.global_position)
        current_dist = current_dist - delta
        var target_position = base.global_position + (Vector2.from_angle(data.orbit_toward_angle) * current_dist)
        me.character.velocity = (target_position - me.character.global_position).normalized() * VELOCITY.sample(velocity)
        me.character.move_and_slide()
