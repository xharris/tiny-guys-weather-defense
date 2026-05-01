extends State
class_name StateReloadScene

func _enter(me: StateMachine):
    me.get_tree().reload_current_scene()
