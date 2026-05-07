extends Node2D
class_name AudioManager

var _dev = Dev.new(true)

static var VOLUME_DB = preload("res://resources/curves/volume_db.tres")

@export var master_audio: PauseItemConfig
@export var audio_configs: Dictionary[AudioConfig.AudioType, PauseItemConfig]

func _set_volume(config: PauseItemConfig, bus_name: String = ''):
    if bus_name.is_empty():
        bus_name = config.setting_key
    # ensure audio bus exists
    var bus_idx = AudioServer.get_bus_index(bus_name)
    if bus_idx < 0:
        AudioServer.add_bus()
        bus_idx = AudioServer.bus_count - 1
        AudioServer.set_bus_name(bus_idx, bus_name)
    var volume: float = Settings.get_setting(config.setting_key, 1.0)
    var value = VOLUME_DB.sample(volume)
    # set bus volume
    AudioServer.set_bus_mute(bus_idx, volume <= 0)
    if value != AudioServer.get_bus_volume_db(bus_idx):
        _dev.dump("set volume {0} ({1}) to {2} ({3})", [bus_name, bus_idx, value, volume])
        AudioServer.set_bus_volume_db(bus_idx, value)

func _process(delta: float) -> void:
    if master_audio:
        _set_volume(master_audio, "Master")
    for type in audio_configs:
        var config = audio_configs[type]
        # set bus volume
        _set_volume(config)
