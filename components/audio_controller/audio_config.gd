extends Resource
class_name AudioConfig

enum AudioType {SFX, MUSIC}

@export var name: String
@export var stream: AudioStream
@export var type: AudioType
@export_range(0, 1, 0.1) var volume: float = 1.0
## Limit how many instances of this audio can play
@export var limit: int

func get_bus_name() -> StringName:
    var bus_name: StringName = AudioType.find_key(type)
    if AudioServer.get_bus_index(bus_name) != -1:
        return bus_name
    return &"Master"

func is_equal(other: AudioConfig) -> bool:
    return name == other.name
