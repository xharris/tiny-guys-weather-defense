extends Node2D
class_name VfxWeather

var _dev = Dev.new(true)

static var CYCLE_SPEED = preload("res://resources/curves/weather_cycle_speed.tres")
static var CLOUD_SPEED = preload("res://resources/curves/cloud_speed.tres")

@onready var states: StateMachine = %StateMachine
@onready var cloud_timer: Timer = %CloudTimer
@onready var cloud_shadows: Node2D = %CloudShadows

@export var texture_rects: Array[Control]
@export var configs: Array[Weather]
@export var playing: bool
@export var clouds_container: Node2D

var _config: Weather
var _tod_progress: float = 0.0
var _tod: Weather.TimeOfDay = Weather.TimeOfDay.DAY
var _rng = RandomNumberGenerator.new()
var hour: int:
    get:
        var h = 0
        match _tod:
            Weather.TimeOfDay.SUNRISE:
                h = lerp(5, 12, _tod_progress)
            Weather.TimeOfDay.DAY:
                h = lerp(12, 20, _tod_progress)
            Weather.TimeOfDay.SUNSET:
                h = lerp(20, 22, _tod_progress)
            Weather.TimeOfDay.NIGHT:
                h = lerp(22, 24+5, _tod_progress)
        return wrapi(round(h), 0, 23)

func set_time_of_day(tod: Weather.TimeOfDay):
    # set time of day
    _tod = wrapi(tod, 0, Weather.TimeOfDay.size()-1)
    _tod_progress = 0.0
    # get weather config
    var possible_configs = configs.filter(func(c: Weather): return c.time_of_day == _tod)
    if not possible_configs.is_empty():
        var weights = possible_configs.map(func(c: Weather): return c.weight)
        _config = possible_configs[_rng.rand_weighted(weights)]
    _dev.dump("change to {0}, hour={1}, color={2}", [Weather.TimeOfDay.find_key(_tod), hour, get_weather_color(hour)])
    if not _config:
        _dev.warn("no config set")

func add_cloud_shadow(pos: Vector2, tex: Texture2D = null) -> Shadow:
    _dev.dump("add cloud shadow at {0}", [pos])
    # pick a texture
    if not tex and _config and _config.cloud_texture.size():
        tex = _config.cloud_texture.pick_random()
    # add shadow
    var shadow: Shadow = Shadow.SCENE.instantiate()
    shadow.texture = tex
    shadow.global_position = pos
    cloud_shadows.add_child(shadow)
    return shadow

func _ready() -> void:
    add_to_group(Groups.weather)
    cloud_timer.timeout.connect(_on_cloud_timeout)
    set_time_of_day(_tod)

func _on_cloud_timeout():
    var chance = 0.2
    if _config:
        chance = _config.cloud_chance
    if randf() <= chance:
        # place at right side of screen
        var cam_rect = CameraFocus.get_camera_rect(self)
        var cloud_position = Vector2(
            cam_rect.position.x + cam_rect.size.x,
            randf_range(cam_rect.position.y, cam_rect.position.y + cam_rect.size.y)
        )
        add_cloud_shadow(cloud_position)

func _process(delta: float) -> void:
    if _config and playing:
        _tod_progress += delta * CYCLE_SPEED.sample(_config.cycle_speed)
        
    if _tod_progress > 1.0:
        # move to next time of day
        set_time_of_day(_tod + 1)
        
    # set color
    modulate = modulate.lerp(get_weather_color(hour), delta * 0.15)
    for tex in texture_rects:
        tex.modulate = modulate

    var cam_rect = CameraFocus.get_camera_rect(self)
    for shadow: Shadow in cloud_shadows.get_children():
        # move shadow
        shadow.global_position.x -= delta * CLOUD_SPEED.sample(_config.wind if _config else 0.0)
        
        # off screen, remove it
        if shadow.is_inside_tree() and shadow.global_position.x < cam_rect.position.x:
            _dev.dump("remove cloud")
            shadow.queue_free()

func get_weather_color(time: int):
    var ra = [0.661133,-0.450579,-0.102644,0.003019,-0.017206,-0.010087]
    var rb = [-0.228901,-0.139233,0.029436,0.047411,0.007989]
    var ga = [0.626849,-0.437814,-0.050352,-0.009737,-0.028222,0.002317]
    var gb = [-0.279056,-0.106992,0.066646,0.032230,-0.001321]
    var ba = [0.725802,-0.268970,-0.035903,-0.006988,-0.021679,-0.002546]
    var bb = [-0.175541,-0.079950,0.034039,0.021785,-0.000069]
    var w = [0.258071, 0.264981, 0.258893]
    
    var r = 0
    var g = 0
    var b = 0
    
    for i in range(6):
        r += ra[i]*cos(i*time*w[0])
        g += ga[i]*cos(i*time*w[1])
        b += ba[i]*cos(i*time*w[2])
    for i in range(1,6):
        r += rb[i-1]*sin(i*time*w[0])
        g += gb[i-1]*sin(i*time*w[1])
        b += bb[i-1]*sin(i*time*w[2])
    r = min(r,1)
    g = min(g,1)
    b = min(b,1)
    return Color(r,g,b,1)
