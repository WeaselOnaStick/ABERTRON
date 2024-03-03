extends Control

@export var dialogue_data : JSON
const SPEECH_BUBBLE_LEFT = preload("res://Scenes/speech_bubble_left.tscn")
const SPEECH_BUBBLE_RIGHT = preload("res://Scenes/speech_bubble_right.tscn")

@onready var bubble_container = $Panel/MarginContainer/VBoxContainer


var cur_line_idx = 0
var cur_line : Dictionary

func clear_bubble_container():
	if bubble_container.get_child_count() == 0:
		return
		
	for x in bubble_container.get_children():
		x.queue_free()

func _ready():
	clear_bubble_container()
	print(dialogue_data.data)
	print(len(dialogue_data.data["lines"]))
	#bubble_container.remove_a

func dialog_step():
		if cur_line_idx >= len(dialogue_data.data["lines"]):
			return
			
		cur_line = dialogue_data.data["lines"][cur_line_idx]
		add_bubble(cur_line["side"],cur_line["text"])
		if cur_line_idx < len(dialogue_data.data["lines"]):
			cur_line_idx += 1
	

func _input(event):
	if event.is_action_pressed("deubg"):
		dialog_step()

func add_bubble(side := "left", text := "ERROR"):
	var new_bubble : NinePatchRect
	if side == "left":
		new_bubble = SPEECH_BUBBLE_LEFT.instantiate()
	elif side == "right":
		new_bubble = SPEECH_BUBBLE_RIGHT.instantiate()
	
	bubble_container.add_child(new_bubble)
	(new_bubble.get_node("%TextField") as RichTextLabel).text = text
