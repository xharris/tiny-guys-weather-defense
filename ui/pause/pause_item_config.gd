extends Resource
class_name PauseItemConfig

static func get_setting(config: PauseItemConfig) -> Variant:
    return Settings.get_setting(config.setting_key)

@export var label: String
@export var group: String

@export var setting_key: String

@export_group("Slider", "slider")
@export var slider_enabled: bool
@export var slider_default_value: float
@export var slider_steps: int = 5
