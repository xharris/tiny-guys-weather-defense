extends Node2D
class_name AudioController

var _dev = Dev.new(true)

class AudioInstance extends RefCounted:
    var config: AudioConfig
    var source: AudioController
    var use_source_position: bool
    var stream: AudioStreamPlayer2D

static var VOLUME_DB = preload("res://resources/curves/volume_db.tres")
static var _instances: Array[AudioInstance]

@export var autoplay: AudioConfig

func play(config: AudioConfig):
    if not config:
        _dev.warn("no config given to {0}", [get_path()])
        return
    _dev.dump("play {0}", [config.name])
    
    # get count of instances already playing this audio
    var count = 0
    for i in _instances:
        if is_instance_valid(i.stream) and i.config.is_equal(config):
            count += 1

    # check instance count limit
    var limit = config.limit
    if config.type == AudioConfig.AudioType.MUSIC:
        limit = max(1, limit)
    if limit > 0 and count >= limit:
        _dev.dump("reached instance count limit of {0}", [limit])
        return
    
    # create audio instance
    var instance = AudioInstance.new()
    instance.config = config
    instance.source = self
    instance.use_source_position = config.type == AudioConfig.AudioType.SFX
    instance.stream = AudioStreamPlayer2D.new()
    get_tree().root.add_child(instance.stream)
    instance.stream.stream = config.stream
    # set bus and volume
    instance.stream.bus = config.get_bus_name()
    instance.stream.volume_db = VOLUME_DB.sample(config.volume)
    # play
    instance.stream.play()
    _instances.append(instance)

func _ready() -> void:
    add_to_group(Groups.audio_controller)
    if autoplay:
        play.call_deferred(autoplay)

func _process(delta: float) -> void:
    _instances = _instances.filter(func(i): return is_instance_valid(i.stream))
    for i in _instances:
        if i.source == self and i.use_source_position:
            i.stream.global_position = global_position
