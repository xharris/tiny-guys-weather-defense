extends Resource
class_name PauseItemConfig

@export var label: String
@export var group: String

@export var setting_key: String

@export_group("Slider", "slider")
@export var slider_enabled: bool
@export var slider_default_value: float
@export var slider_steps: int = 5
