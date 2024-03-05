extends CanvasLayer

signal start_game
signal settings
signal exit
signal credits



func _on_start_game_pressed():
	GameManager.load_scene("res://Scenes/tinkering.tscn")


func _on_settings_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
