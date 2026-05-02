extends Resource
class_name AudioConfig

enum AudioType {SFX, MUSIC}

@export var name: String
@export var audio: AudioStream
@export var type: AudioType
@export var volume: float = 1.0
