extends State
class_name StateIdle



func _enter(me: StateMachine):
    if me.character:
        me.character.velocity = Vector2.ZERO
