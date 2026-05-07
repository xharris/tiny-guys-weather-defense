extends Node2D
class_name AudioController

var _dev = Dev.new()

class AudioInstance extends RefCounted:
    var config: AudioConfig
    var source: AudioController
    var use_source_position: bool
    var stream: AudioStreamPlayer2D

static var VOLUME_DB = preload("res://resources/curves/volume_db.tres")
static var _instances: Array[AudioInstance]
static var _waitlist: Dictionary = {}

@export var autoplay: AudioConfig
@export var remove_with_node: bool = false

func get_players(config: AudioConfig = null):
    var players: Array[AudioStreamPlayer2D]
    for i in _instances:
        if config and not i.config.is_equal(config):
            continue
        if i.source == self:
            players.append(i.stream)
    return players

func stop(config: AudioConfig = null):
    # remove self from waitlist
    if config:
        (_waitlist.get(config, []) as Array).erase(self)
    else:
        for queue in _waitlist.values():
            (queue as Array).erase(self)
    # stop and clean up active instances, then promote next in queue
    var to_remove: Array[AudioInstance] = []
    for i in _instances:
        if i.source != self:
            continue
        if config and not i.config.is_equal(config):
            continue
        to_remove.append(i)
    for i in to_remove:
        i.stream.queue_free()
        _instances.erase(i)
        _promote(i.config)

static func _promote(config: AudioConfig) -> void:
    var queue: Array = _waitlist.get(config, [])
    while queue.size() > 0:
        var next: AudioController = queue.pop_front()
        if is_instance_valid(next):
            next.play(config)
            return
    _waitlist.erase(config)

static func _on_finished(instance: AudioInstance) -> void:
    instance.stream.queue_free()
    _instances.erase(instance)
    _promote(instance.config)

func play(config: AudioConfig):
    if not config:
        _dev.warn("no config given to {0}", [get_path()])
        return
    
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
        if config.type == AudioConfig.AudioType.SFX:
            var queue: Array = _waitlist.get(config, [])
            if not queue.has(self):
                queue.append(self)
            _waitlist[config] = queue
        _dev.dump("reached instance count limit of {0}", [limit])
        return
    
    _dev.dump("play {0}", [config.name])
    # create audio instance
    var instance = AudioInstance.new()
    instance.config = config
    instance.source = self
    instance.use_source_position = config.type == AudioConfig.AudioType.SFX and config.limit <= 0
    instance.stream = AudioStreamPlayer2D.new()
    get_tree().root.add_child(instance.stream)
    instance.stream.stream = config.stream
    # set bus and volume
    instance.stream.bus = config.get_bus_name()
    instance.stream.volume_db = VOLUME_DB.sample(config.volume)
    # play
    instance.stream.finished.connect(func(): _on_finished(instance))
    instance.stream.play()
    _instances.append(instance)

func _exit_tree() -> void:
    if remove_with_node:
        stop()

func _ready() -> void:
    add_to_group(Groups.audio_controller)
    if autoplay:
        play.call_deferred(autoplay)
