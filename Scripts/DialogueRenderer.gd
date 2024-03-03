extends Control

@export var dialogue_file : JSON
var dialogue_data
const SPEECH_BUBBLE_LEFT = preload("res://Scenes/speech_bubble_left.tscn")
const SPEECH_BUBBLE_RIGHT = preload("res://Scenes/speech_bubble_right.tscn")

@onready var bubble_container = $Panel/MarginContainer/VBoxContainer


var cur_line_idx = -1
var cur_line : Dictionary
var dialog_busy := false

func clear_bubble_container():
	if bubble_container.get_child_count() == 0:
		return
		
	for x in bubble_container.get_children():
		x.queue_free()

func _process(delta):
	if Input.is_action_just_pressed("debug") and not dialog_busy:
		dialog_step()

func _ready():
	dialogue_data = dialogue_file.data
	clear_bubble_container()
	print(dialogue_data)

func dialog_step():
	cur_line_idx += 1
	if cur_line_idx >= len(dialogue_data["lines"]):
		return
	cur_line = dialogue_data["lines"][cur_line_idx]
	add_bubble(cur_line["side"],cur_line["text"])
	if cur_line.get("step_trigger") == "manual":
		dialog_busy = false
		
	if cur_line.get("step_trigger") == "delay":
		dialog_busy = true
		await get_tree().create_timer(cur_line["delay_after"]).timeout
		dialog_step()

func add_bubble(side := "left", text := "ERROR"):
	var new_bubble : SpeechBubble
	if side == "left":
		new_bubble = SPEECH_BUBBLE_LEFT.instantiate()
	elif side == "right":
		new_bubble = SPEECH_BUBBLE_RIGHT.instantiate()
	
	var rtl := new_bubble.get_node("%TextField") as RichTextLabel
	bubble_container.add_child(new_bubble)
	rtl.text = text
	
	#this is so fucking stupid 
	#god bless issue tracking https://github.com/godotengine/godot/issues/36381
	get_tree().process_frame.connect(new_bubble.fix_h,CONNECT_ONE_SHOT)
	
