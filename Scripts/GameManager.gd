extends Node

enum {BOOTING,MAIN_MENU,LEVEL,LEVEL_PAUSED}

var game_state := BOOTING
var main_menu_scene_path = "res://Scenes/MainMenu.tscn"
var boot_scene_path = "res://Scenes/Boot.tscn"

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
