extends Node

func get_closest(nodes: Array, to: Node2D) -> Node2D:
    return nodes\
        .filter(func(v): return v is Node2D)\
        .reduce(func(a, b): 
        return a\
            if a.global_position.distance_squared_to(to.global_position) < b.global_position.distance_squared_to(to.global_position)\
            else b)
