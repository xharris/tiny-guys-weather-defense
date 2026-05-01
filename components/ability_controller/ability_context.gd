extends RefCounted
class_name AbilityContext

var is_critical: bool
var ctrl: AbilityController
var instance: Node2D

func add_entity(node: Node2D):
    var entities = ctrl.get_tree().get_first_node_in_group(Groups.entities)
    if entities:
        entities.add_child(node)
