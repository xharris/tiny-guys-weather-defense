extends Node2D
class_name Hp

var _dev = Dev.new(true)

signal died
signal damaged(amount: int)

@export var current: int = 0

func take_damage(amount: int):
    _dev.dump("{0} take {1} damage", [get_path(), amount])
    var prev_current = current
    current = max(0, current - amount)
    damaged.emit(amount)
    if prev_current > 0 and current <= 0:
        _dev.dump("{0} died", [get_path()])
        died.emit()

func is_alive() -> bool:
    return current > 0
