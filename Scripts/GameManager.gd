# Main orchestrator. (Sadly) also loads scenes and Loading screen (for now?)

extends Node

enum {BOOTING,MAIN_MENU,LEVEL,LEVEL_PAUSED}
var game_state := BOOTING


var main_menu_scene_path = "res://Scenes/MainMenu.tscn"

const LOADING_SCREEN = preload("res://Scenes/loading_screen.tscn")
var cur_loading_screen : LoadingScreen

var CURRENTLY_LOADING_SCENE = ""
var cur_scene : Node

var mouse_mode_cache

signal can_player_interact_override(val : bool)

func _ready():
	pass
	#call_deferred("game_start")
	#MusicManager.banks_updated
	
func game_start():
	load_scene(main_menu_scene_path)

func load_scene(scene_path : StringName, free_current := true):
	if free_current and cur_scene != null:
		cur_scene.queue_free()
	CURRENTLY_LOADING_SCENE = scene_path
	if CURRENTLY_LOADING_SCENE == main_menu_scene_path:
		game_state = MAIN_MENU
		MusicManager.updated.connect(MusicManager.play.bind("Global","MainMenu"), CONNECT_ONE_SHOT)
		game_pause_toggle()
		PauseMenu.visible = false
		TutorialGUI.visible = false
		FPS_HUD.visible = false
		TutorialGUI.clear_hints()
	ResourceLoader.load_threaded_request(CURRENTLY_LOADING_SCENE)
	cur_loading_screen = LOADING_SCREEN.instantiate()
	add_child(cur_loading_screen)
	await cur_loading_screen.finished_loading
	cur_scene = ResourceLoader.load_threaded_get(CURRENTLY_LOADING_SCENE).instantiate()
	add_child(cur_scene)
	CURRENTLY_LOADING_SCENE = ""

func level1_start():
	game_state = LEVEL
	FPS_HUD.visible = true
	TutorialGUI.visible = true
	get_tree().paused = false
	can_player_interact_override.emit(false)
	TutorialGUI.clear_hints()
	MusicManager.play("Global","Ambiertron")
	#MusicManager.updated.connect(MusicManager.play.bind("Global","Ambiertron"), CONNECT_ONE_SHOT)
	FPS_HUD.toggle_crosshair_visible(false)
	
	TutorialGUI.display_hint(TutorialGUI.HINT_BASIC_MOVEMENT,1)
	await TutorialGUI.hint_ended
	await get_tree().create_timer(1).timeout
	TutorialGUI.display_hint(TutorialGUI.HINT_INTERACTIONS,1)
	FPS_HUD.toggle_crosshair_visible(true)
	can_player_interact_override.emit(true)
	await TutorialGUI.hint_ended
	await get_tree().create_timer(1).timeout
	TutorialGUI.display_hint(TutorialGUI.HINT_PAUSE,1)



func _input(event):
	if event.is_action_pressed("Debug_Force_Quit"):
		get_tree().quit()
	
	if event.is_action_pressed("pause"):
		game_pause_toggle()



func game_pause_toggle():
	if game_state == LEVEL:
		mouse_mode_cache = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		PauseMenu.visible = true
		game_state = LEVEL_PAUSED
	elif game_state == LEVEL_PAUSED:
		get_tree().paused = false
		PauseMenu.visible = false
		game_state = LEVEL
		Input.mouse_mode = mouse_mode_cache
	
