extends RefCounted
class_name ContextController

var _name:StringName

func _init(name:StringName) -> void:
    self._name = name + &"_Context"

func get_context(obj:Object, default:Variant):
    var ctx = obj.get_meta(_name, default)
    obj.set_meta(_name, ctx)
    return ctx
