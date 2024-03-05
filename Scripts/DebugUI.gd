extends CanvasLayer

@onready var debug_text := %DebugText

func _ready():
	debug_text.text = ""
	debug_text.placeholder_text = ""

func _process(_delta):
	%"FPS-TEXT".text = str(Engine.get_frames_per_second())
	%"PAUSED-TEXT".text = str(get_tree().paused)
	%"CUR_LOAD_SCENE-TEXT".text = GameManager.CURRENTLY_LOADING_SCENE if GameManager.CURRENTLY_LOADING_SCENE != "" else "<None>"
	%"MUSIC-TEXT".text = "%s|%s" % [MusicManager._get_current_player().bank_label,MusicManager._get_current_player().track_name]
	
	
func DebugLog(text):
	debug_text.text += str(text)+"\n"
	call_deferred("fix_debug_text_height")
	get_tree().create_timer(5).timeout.connect(remove_last_debug)

func fix_debug_text_height():
	debug_text.custom_minimum_size.y = 28*debug_text.get_line_count()

func remove_last_debug():
	var idx = debug_text.text.find("\n")

	if idx != -1:
		debug_text.text = debug_text.text.substr(idx + 1)

func _input(event):
	if event.is_action_pressed("debug_panel_toggle"):
		if visible:
			visible = false
		else:
			visible = true
