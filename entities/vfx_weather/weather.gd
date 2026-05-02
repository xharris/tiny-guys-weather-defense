extends State
class_name Weather

enum TimeOfDay {SUNRISE, DAY, SUNSET, NIGHT}

@export var time_of_day: TimeOfDay
@export var cycle_speed: float = 0.0
@export var weight: float = 1.0

@export var cloud_texture: Array[Texture2D] = []
@export var cloud_chance: float = 0.2

@export_range(0, 1, 0.05) var wind: float = 0.0

@export_group("Color", "color")
@export var color_override: bool
@export var color_from: Color = Color.WHITE
@export var color_to: Color = Color.WHITE

@export_group("Precipitation", "precip")
@export_range(0, 1, 0.05) var precip_density: float = 0.0
@export var precip_texture: Texture2D
@export var precip_particles: ParticleProcessMaterial

func _enter(me: StateMachine):
    pass
    
func _exit(me: StateMachine):
    pass
