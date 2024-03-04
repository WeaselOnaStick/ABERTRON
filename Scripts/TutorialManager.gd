extends Control

const TUTORIAL_LINE = preload("res://Scenes/TutorialLine.tscn")


const ICON_SPACE_KEY_LIGHT = "res://Assets/Xelu Icons/KeyboardMouse/Light/Space_Key_Light.png"
const ICON_WASD_LIGHT = "res://Assets/Xelu Icons/WASD_Light.png"
const ICON_MOUSE = "res://Assets/Xelu Icons/KeyboardMouse/Light/Mouse_Simple_Key_Light.png"
const ICON_MOUSE_KEY_LEFT = "res://Assets/Xelu Icons/KeyboardMouse/Light/Mouse_Left_Key_Light.png"
const ICON_MOUSE_KEY_MIDDLE = "res://Assets/Xelu Icons/KeyboardMouse/Light/Mouse_Middle_Key_Light.png"
const ICON_MOUSE_KEY_RIGHT = "res://Assets/Xelu Icons/KeyboardMouse/Light/Mouse_Right_Key_Light.png"

const X_KEY_LIGHT = "res://Assets/Xelu Icons/KeyboardMouse/Light/X_Key_Light.png"
const ESC_KEY_LIGHT = "res://Assets/Xelu Icons/KeyboardMouse/Light/Esc_Key_Light.png"

var HINT_BASIC_MOVEMENT := "MOVE AROUND WITH [img]%s[/img] AND [img]%s[/img]\n PRESS [img]%s[/img] TO ENABLE [i]PRECISION MODE[/i]" % [ICON_WASD_LIGHT, ICON_MOUSE, ICON_SPACE_KEY_LIGHT]
var HINT_INTERACTIONS := "INTERACT WITH OBJECTS BY LOOKING AT THEM\n AND PRESSING [img]%s[/img]" % X_KEY_LIGHT
var HINT_PAUSE := "PRESS [img]%s[/img] TO PAUSE THE GAME" % ESC_KEY_LIGHT

signal hint_ended

func _ready():
	clear_hints()
	#_display_hint("MOVE AROUND WITH [img]%s[/img] & [img]%s[/img]" % [ICON_WASD_LIGHT, ICON_MOUSE])
	
func clear_hints():
	if get_child_count() == 0 :
		return
	for x in get_children():
		x.queue_free()

func display_hint(text : String, center := true, autofade := 10.0):
	var new_line := TUTORIAL_LINE.instantiate()
	add_child(new_line)
	var rtl := new_line.get_node("RichTextLabel") as RichTextLabel
	rtl.text = "[center]" if center else ""
	rtl.text += text
	rtl.text = rtl.text.replace("[img]", "[img=0x48]")
	print(rtl.text)
	var tw_clr := create_tween().tween_property(new_line, "modulate", Color("#ffffff"), 1.0).from(Color("#ffffff00"))
	var tw_txt := create_tween().tween_property(rtl, "visible_ratio", 1.0, 2).from(0.0)
	var tw_fade := create_tween().tween_property(new_line, "modulate", Color("#ffffff00"), 1.0).set_delay(autofade)
	
	await tw_fade.finished
	hint_ended.emit()
