extends Control

@onready var crosshair := $Crosshair

@export var CROSSHAIR_COLOR_DEFAULT : Color = Color(1,1,1,0.8)
@export var CROSSHAIR_COLOR_INTERACTABLE : Color = Color(0.698039, 0.133333, 0.133333, 0.45)

func _ready():
	visible = true
	crosshair.modulate = CROSSHAIR_COLOR_DEFAULT

func toggle_crosshair_visible(enabled := true):
	visible = enabled
	
func toggle_crosshair_highlight(highlight := true):
	if highlight:
		crosshair.modulate = CROSSHAIR_COLOR_INTERACTABLE
		$how_to_interact_label.visible = TutorialGUI.show_interact_button
	else:
		crosshair.modulate = CROSSHAIR_COLOR_DEFAULT
		$how_to_interact_label.visible = false
