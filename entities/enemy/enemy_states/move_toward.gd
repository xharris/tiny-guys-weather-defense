extends State
class_name StateMoveToward

var _dev = Dev.new(true)

const META_AUDIO_PLAYER = &"move_toward_audio_player"
static var VELOCITY = preload("res://resources/curves/move_toward_velocity.tres")

@export_range(0, 1, 0.1) var velocity: float = 0.0
@export var audio: AudioStream
@export var volume_db: float = -10

func _enter(me: StateMachine):
    if audio:
        # play audio
        var player = AudioStreamPlayer2D.new()
        me.set_meta(META_AUDIO_PLAYER, player)
        player.volume_db = volume_db
        player.autoplay = true
        player.stream = audio
        player.attenuation = 0.5
        me.add_child(player)

func _exit(me: StateMachine):
    var player: AudioStreamPlayer2D = me.get_meta(META_AUDIO_PLAYER)
    if player:
        var parent = player.get_parent()
        parent.remove_child(player)
    elif audio:
        _dev.warn("no audio node found in {0}", [me.get_path()])

func _process(me: StateMachine, delta: float):
    var base = Base.get_closest(me)
    if base and me.character:
        me.character.velocity = (base.global_position - me.character.global_position).normalized() * VELOCITY.sample(velocity)
        me.character.move_and_slide()
