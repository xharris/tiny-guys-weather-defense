extends Node2D
class_name AbilityController

var _dev = Dev.new()

@export var abilities: Array[Ability]
var aim_position: Vector2
var aim_dir: Vector2
var spawn_position: Vector2

func get_context() -> AbilityContext:
    var ctx = AbilityContext.new()
    ctx.ctrl = self
    return ctx

func use():
    var entities = get_tree().get_first_node_in_group(Groups.entities)
    for a in abilities:
        _dev.dump("use {0}", [a.name])
        for i in max(1, a.repeat):
            var ctx = get_context()
            var add_nodes = a.use(ctx)
            if entities:
                for add_node in add_nodes:
                    _dev.dump("add {0} to {1}", [add_node.name, entities.name])
                    add_node.global_position = ctx.ctrl.spawn_position
                    entities.add_child(add_node)
            else:
                _dev.warn("no Entities")
