extends State
class_name StateMoveToward

var _dev = Dev.new(true)

const META_AUDIO_PLAYER = &"move_toward_audio_player"
static var VELOCITY = preload("res://resources/curves/move_toward_velocity.tres")

@export_range(0, 1, 0.1) var velocity: float = 0.0
@export var audio: AudioConfig
@export var volume_db: float = -10

func _enter(me: StateMachine):
    if me.audio and audio:
        me.audio.play(audio)

func _exit(me: StateMachine):
    if me.audio and audio:
        me.audio.stop(audio)

func _process(me: StateMachine, delta: float):
    var base = Base.get_closest(me)
    if base and me.character:
        me.character.velocity = (base.global_position - me.character.global_position).normalized() * VELOCITY.sample(velocity)
        me.character.move_and_slide()
