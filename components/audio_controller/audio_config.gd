extends Resource
class_name AudioConfig

enum AudioType {SFX, MUSIC}

@export var name: String
@export var stream: AudioStream
@export var type: AudioType
@export_range(0, 1, 0.1) var volume: float = 1.0
## Limit how many instances of this audio can play
@export var limit: int

func get_bus_index() -> int:
    return type

func get_bus_name() -> StringName:
    AudioServer.set_bus_name(get_bus_index(), AudioType.find_key(type))
    return AudioServer.get_bus_name(get_bus_index())

func is_equal(other: AudioConfig) -> bool:
    return name == other.name
