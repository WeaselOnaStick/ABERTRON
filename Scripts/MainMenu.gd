extends CanvasLayer

@onready var main := %MainMenuButtons
@onready var settings := %SettingsButtons


func _ready():
	main.visible = true
	settings.visible = false

func _on_start_game_pressed():
	GameManager.load_scene("res://Scenes/Levels/level_1.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	main.visible = false
	settings.visible = true
	
func _on_back_to_main_menu_pressed():
	main.visible = true
	settings.visible = false
