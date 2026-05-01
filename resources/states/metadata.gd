extends RefCounted
class_name Metadata

const META_NAME = &"metadata"

static func get_data(me: StateMachine) -> Metadata:
    var data = me.get_meta(META_NAME, Metadata.new())
    me.set_meta(META_NAME, data)
    return data

var wave_count: int = 0
var waves_until_pick_ability: int = 0
var difficulty: float = 0.0
