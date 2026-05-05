extends Control
class_name PauseItem

var _dev = Dev.new(true)

static var SCENE = preload("res://ui/pause/pause_item.tscn")

@onready var label: Label = %Label
@onready var slider: HSlider = %HSlider

@export var config: PauseItemConfig

func _on_slider_changed(value: float):
    if config and config.slider_enabled:
        Settings.set_setting(config.setting_key, value / 100.0)

func _process(delta: float) -> void:
    label.text = config.label
    slider.visible = config.slider_enabled

func _ready() -> void:
    if config and config.slider_enabled:
        slider.min_value = 0
        slider.max_value = 100
        slider.step = 100.0 / config.slider_steps
        slider.tick_count = config.slider_steps
        # set initial value
        var value = Settings.get_setting(config.setting_key, config.slider_default_value)
        slider.value = value * 100.0
        _dev.dump("set initial slider value: {0}={1} ({2})", [config.setting_key, slider.value, value])
    slider.value_changed.connect(_on_slider_changed)
