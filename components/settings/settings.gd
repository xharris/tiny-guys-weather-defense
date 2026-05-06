extends Node

var _dev = Dev.new(true)

const SAVE_PATH: String = "user://settings.json"

signal saved

var _data: Dictionary
var _changed: bool

func get_setting(key: String, default: Variant = null) -> Variant:
    return _data.get(key, default)

func set_setting(key: String, value: Variant):
    _dev.dump("set {0}={1}", [key, value])
    _data.set(key, value)
    _changed = true
    
func _save():
    var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    f.store_line(JSON.stringify(_data))
    _changed = false
    _dev.dump("save to {0}", [ProjectSettings.globalize_path(SAVE_PATH)])
    saved.emit()

func _load():
    if not FileAccess.file_exists(SAVE_PATH):
        return
    var f = FileAccess.open(SAVE_PATH, FileAccess.READ)
    _data.merge(JSON.parse_string(f.get_as_text()), true)
    _dev.dump("load from {0}", [ProjectSettings.globalize_path(SAVE_PATH)])

func _process(delta: float) -> void:
    if _changed:
        _save()

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    _load()
