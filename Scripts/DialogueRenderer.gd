class_name DialogueRenderer extends Control

@export var dialogue_file : JSON
var _dialogue_data

const SPEECH_BUBBLE_LEFT = preload("res://Scenes/speech_bubble_left.tscn")
const SPEECH_BUBBLE_RIGHT = preload("res://Scenes/speech_bubble_right.tscn")
const TYPING_INDICATOR = preload("res://Scenes/typing_indicator.tscn")
var typing_bubble : Panel

const END_OF_DIALOGUE = preload("res://Scenes/end_of_dialogue.tscn")

@onready var scroll_container := $Panel/ScrollContainer
@onready var bubble_container := %BubbleContainer

signal dialogue_ended

var cur_line_idx = 0
var cur_line : Dictionary
enum states {NULL, WAITING_MANUAL, WAITING_SIGNAL, WAITING_DELAY, FINISHED}
var state = states.NULL

func clear_bubble_container():
	if bubble_container.get_child_count() == 0:
		return
		
	for x in bubble_container.get_children():
		x.queue_free()

# only for manual interactions
func interact_manual():
	if state == states.WAITING_MANUAL:
		_dialog_step()

# only for interactions through code/signals
func interact_signal():
	if state == states.WAITING_SIGNAL:
		_dialog_step()

func _ready():
	if dialogue_file != null:
		_dialogue_data = dialogue_file.data
	clear_bubble_container()

func init(input_dialogue_file : JSON):
	#var json = JSON.new()
	#DebugUI.DebugLog(str(input_dialogue_file))
	#if json.parse(str(input_dialogue_file)) == OK:
	_dialogue_data = input_dialogue_file.data
	
	if _dialogue_data["init_mode"] == "manual":
		state = states.WAITING_MANUAL
	if _dialogue_data["init_mode"] == "signal":
		state = states.WAITING_SIGNAL
	if _dialogue_data["init_mode"] == "auto":
		_dialog_step()

func _dialog_step():
	hide_typing_indicator()
	DebugUI.DebugLog("cur_line_idx %s (out of %s)" % [cur_line_idx,len(_dialogue_data["lines"])])
	
	if cur_line_idx > len(_dialogue_data["lines"])-1:
		return
	
	cur_line = _dialogue_data["lines"][cur_line_idx]
	add_bubble(cur_line["side"],cur_line["text"])
	
	if cur_line_idx == len(_dialogue_data["lines"])-1:
		DebugUI.DebugLog("reached end of dialogue")
		bubble_container.add_child(END_OF_DIALOGUE.instantiate())
		dialogue_ended.emit()
	
	
	cur_line_idx += 1
	
	if cur_line.get("step_trigger") == "manual":
		state = states.WAITING_MANUAL
		
	if cur_line.get("step_trigger") == "signal":
		state = states.WAITING_SIGNAL
		
	if cur_line.get("step_trigger") == "delay":
		state = states.WAITING_DELAY
		add_typing_indicator()
		await get_tree().create_timer(cur_line["delay_after"]).timeout
		_dialog_step()

func add_typing_indicator():
	hide_typing_indicator()
	typing_bubble = TYPING_INDICATOR.instantiate()
	bubble_container.add_child(typing_bubble)
	var tw := create_tween()
	tw.tween_property(typing_bubble,"modulate",Color("ffffff"), 0.15).from(Color("ffffff00"))
	
func hide_typing_indicator():
	if is_instance_valid(typing_bubble) and typing_bubble != null:
		typing_bubble.queue_free() 

func add_bubble(side := "left", text := "ERROR"):
	var new_bubble : SpeechBubble
	if side == "left":
		new_bubble = SPEECH_BUBBLE_LEFT.instantiate()
	elif side == "right":
		new_bubble = SPEECH_BUBBLE_RIGHT.instantiate()
	
	bubble_container.add_child(new_bubble)
	new_bubble.init()
	new_bubble.rtl.text = text
	await new_bubble.bubble_added
	call_deferred("scroll_to_end")

func scroll_to_end():
	var vbar = scroll_container.get_v_scroll_bar() as VScrollBar
	create_tween().tween_property(vbar, "value", vbar.max_value, 0.5)
