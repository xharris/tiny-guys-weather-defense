extends Resource
class_name Dev

var dump_enabled:bool = false

func _init(dump_enabled:bool = false) -> void:
    self.dump_enabled = dump_enabled
    
func _fmt(msg:String, args:Variant = []):
    var last:Dictionary = get_stack()[2]
    var filename = last.get("source", "").get_file()
    var line = last.get("line", 0)
    
    return "("+Time.get_datetime_string_from_system()+" "+filename+":"+str(line)+") "+msg.format(args)
    
func dump(msg:String, args:Variant = []):
    if dump_enabled:
        print(_fmt(msg, args))

func warn(msg:String, args:Variant = []):
    var fmt_msg = _fmt(msg, args)
    push_warning(fmt_msg)
    print_rich("[color=#FDD835]", fmt_msg, "[/color]")
