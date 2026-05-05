extends Control
class_name PauseItem

static var SCENE = preload("res://ui/pause/pause_item.tscn")

@onready var label: Label = %Label
@onready var slider: HSlider = %HSlider

@export var config: PauseItemConfig

func _on_slider_changed(value: float):
    if config and config.slider_enabled:
        var setting_value = value
        if config.slider_curve:
            setting_value = config.slider_curve.sample(value / 100.0)
        Settings.set_setting(config.setting_key, setting_value)

func _process(delta: float) -> void:
    label.text = config.label
    slider.visible = config.slider_enabled

func _ready() -> void:
    if config and config.slider_enabled:
        slider.min_value = 0
        slider.max_value = 100
        slider.step = 100.0 / config.slider_steps
        slider.tick_count = config.slider_steps + 1
        # set initial value
        var default: float = 0
        if config.setting_default_value != null:
            default = config.setting_default_value
        slider.value = Settings.get_setting(config.setting_key, default)
    slider.value_changed.connect(_on_slider_changed)
