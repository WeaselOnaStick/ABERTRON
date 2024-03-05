extends Control

@export var dialogue_file : JSON
var dialogue_data
const SPEECH_BUBBLE_LEFT = preload("res://Scenes/speech_bubble_left.tscn")
const SPEECH_BUBBLE_RIGHT = preload("res://Scenes/speech_bubble_right.tscn")
const TYPING_INDICATOR = preload("res://Scenes/typing_indicator.tscn")
var typing_bubble : Panel

@onready var bubble_container = $Panel/MarginContainer/VBoxContainer


var cur_line_idx = -1
var cur_line : Dictionary
var dialog_busy := false

func clear_bubble_container():
	if bubble_container.get_child_count() == 0:
		return
		
	for x in bubble_container.get_children():
		x.queue_free()

func interact():
	if not dialog_busy:
		dialog_step()

func _ready():
	dialogue_data = dialogue_file.data
	clear_bubble_container()

func dialog_step():
	hide_typing_indicator()
	cur_line_idx += 1
	if cur_line_idx >= len(dialogue_data["lines"]):
		return
	cur_line = dialogue_data["lines"][cur_line_idx]
	add_bubble(cur_line["side"],cur_line["text"])
	if cur_line.get("step_trigger") == "manual":
		dialog_busy = false
		
	if cur_line.get("step_trigger") == "delay":
		dialog_busy = true
		add_typing_indicator()
		await get_tree().create_timer(cur_line["delay_after"]).timeout
		dialog_step()

func add_typing_indicator():
	if typing_bubble != null:
		typing_bubble.queue_free() 
	typing_bubble = TYPING_INDICATOR.instantiate()
	bubble_container.add_child(typing_bubble)
	var tw := create_tween()
	tw.tween_property(typing_bubble,"modulate",Color("ffffff"), 0.15).from(Color("ffffff00"))
	
func hide_typing_indicator():
	if typing_bubble != null:
		typing_bubble.free()

func add_bubble(side := "left", text := "ERROR"):
	var new_bubble : SpeechBubble
	if side == "left":
		new_bubble = SPEECH_BUBBLE_LEFT.instantiate()
	elif side == "right":
		new_bubble = SPEECH_BUBBLE_RIGHT.instantiate()
	
	var rtl := new_bubble.get_node("%TextField") as RichTextLabel
	bubble_container.add_child(new_bubble)
	rtl.text = text
	
