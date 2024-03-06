extends CanvasLayer

@onready var main := %MainMenuButtons
@onready var settings := %SettingsButtons
@onready var volume_slider := %VolumeSlider


func _ready():
	volume_slider.value = MusicManager._volume
	main.visible = true
	settings.visible = false

func _on_start_game_pressed():
	GameManager.load_scene("res://Scenes/tinkering.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	main.visible = false
	settings.visible = true
	
func _on_back_to_main_menu_pressed():
	main.visible = true
	settings.visible = false


func _on_fullscreen_checkbox_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_slider_value_changed(value):
	MusicManager.set_volume(value)
