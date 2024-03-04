extends Node

enum {BOOTING,MAIN_MENU,LEVEL,LEVEL_PAUSED}

var game_state := BOOTING
var main_menu_scene_path = "res://Scenes/MainMenu.tscn"
var boot_scene_path = "res://Scenes/Boot.tscn"

func _ready():
	call_deferred("game_start")
	#MusicManager.banks_updated
	
	
func game_start():
	#TutorialGUI.display_hint.bind(TutorialGUI.HINT_BASIC_MOVEMENT).call_deferred()
	TutorialGUI.display_hint(TutorialGUI.HINT_BASIC_MOVEMENT)
	MusicManager.updated.connect(MusicManager.play.bind("Global","MainMenu"))
	
	await TutorialGUI.hint_ended
	await get_tree().create_timer(5).timeout
	TutorialGUI.display_hint(TutorialGUI.HINT_INTERACTIONS)
	await TutorialGUI.hint_ended
	await get_tree().create_timer(5).timeout
	TutorialGUI.display_hint(TutorialGUI.HINT_PAUSE)
	

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
