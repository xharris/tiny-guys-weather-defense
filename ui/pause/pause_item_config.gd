extends Resource
class_name PauseItemConfig

@export var label: String
@export var group: String

@export var setting_key: String
@export var setting_default_value: Variant

@export_group("Slider", "slider")
@export var slider_enabled: bool
@export var slider_curve: Curve
@export var slider_steps: int = 4
