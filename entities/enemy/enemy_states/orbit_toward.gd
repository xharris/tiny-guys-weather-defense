extends State
class_name StateOrbitToward

var _dev = Dev.new(true)

const META_AUDIO_PLAYER = &"orbit_toward_audio_player"

static var VELOCITY = preload("res://resources/curves/orbit_toward_velocity.tres")

@export_range(0, 1, 0.1) var velocity: float = 0.0
@export var audio: AudioConfig
@export var volume_db: float = -10
#@export var orbit_speed: float = 0.0 # TODO
#@export var close_distance_speed: float = 0.0 # TODO

func _exit(me: StateMachine):
    var player: AudioStreamPlayer2D = me.get_meta(META_AUDIO_PLAYER)
    if player:
        var parent = player.get_parent()
        parent.remove_child(player)
    elif audio:
        _dev.warn("no audio node found in {0}", [me.get_path()])

func _process(me: StateMachine, delta: float):
    var data = Metadata.get_data(me)
    var base = Base.get_closest(me)
    if me.audio:
        me.audio.play(audio)
    if base and me.character:
        data.orbit_toward_angle += delta * 0.2
        var current_dist = me.global_position.distance_to(base.global_position)
        current_dist = current_dist - delta * 10
        
        var target_position = base.global_position + (Vector2.from_angle(data.orbit_toward_angle) * current_dist)
        me.character.global_position = target_position
        me.character.move_and_slide()
