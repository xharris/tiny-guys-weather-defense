extends State
class_name StateOrbitToward

var _dev = Dev.new(true)

const META_AUDIO_PLAYER = &"orbit_toward_audio_player"

static var VELOCITY = preload("res://resources/curves/orbit_toward_velocity.tres")

@export_range(0, 1, 0.1) var velocity: float = 0.0
@export var audio: AudioStream
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
    
    if audio and me.get_tree().get_node_count_in_group("only_one_orbit_audio") == 0:
        # play audio
        var player = AudioStreamPlayer2D.new()
        player.add_to_group("only_one_orbit_audio")
        me.set_meta(META_AUDIO_PLAYER, player)
        player.volume_db = volume_db
        player.autoplay = true
        player.stream = audio
        player.attenuation = 0.5
        me.add_child(player)
    
    if base and me.character:
        data.orbit_toward_angle += delta * 0.2
        var current_dist = me.global_position.distance_to(base.global_position)
        current_dist = current_dist - delta * 10
        
        var target_position = base.global_position + (Vector2.from_angle(data.orbit_toward_angle) * current_dist)
        me.character.global_position = target_position
        me.character.move_and_slide()
