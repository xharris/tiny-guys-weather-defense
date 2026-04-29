extends Node2D
class_name Hp

signal died
signal damaged(amount: int)

@export var max: int = 0
var current: int = 0

func take_damage(amount: int):
    current = max(0, current - amount)
    damaged.emit(amount)
    if current <= 0:
        died.emit()

func is_alive() -> bool:
    return current > 0
