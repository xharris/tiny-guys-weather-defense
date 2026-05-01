extends Node

var _dev = Dev.new()

func get_closest(nodes: Array, to: Node2D) -> Node2D:
    return nodes\
        .filter(func(v): return v is Node2D)\
        .reduce(func(a, b): 
        return a\
            if a.global_position.distance_squared_to(to.global_position) < b.global_position.distance_squared_to(to.global_position)\
            else b)

func move_up_in_tree(node: Node):
    var parent = node.owner
    if not parent:
        node.get_parent()
    if parent:
        var grandparent = parent.get_parent()
        if grandparent:
            _dev.dump("move {0} up to {1}", [node.get_path(), grandparent.get_path()])
            node.reparent(grandparent)

func detach_audio(node_owner: Node, node: AudioStreamPlayer2D):
    node.reparent(node_owner.get_parent())
    node.finished.connect(node.queue_free)
