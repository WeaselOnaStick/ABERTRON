@tool
class_name SpeechBubble extends NinePatchRect

@onready var rtl := %TextField

signal bubble_added

func _ready():
	visible = false
	#this is so fucking stupid 
	#god bless issue tracking https://github.com/godotengine/godot/issues/36381
	#get_tree().process_frame.connect(fix_h,CONNECT_ONE_SHOT)
	call_deferred("init")

func init():
	#get_tree().process_frame.connect(fix_h,CONNECT_ONE_SHOT)
	call_deferred("fix_h")
	visible = true
	var _tw := create_tween().tween_property(self, "modulate",Color("ffffff"), 0.15).from(Color("ffffff00")) as PropertyTweener
	await _tw.finished
	bubble_added.emit()
	

func fix_h():
	custom_minimum_size.y = 128 + 66 * (rtl.get_content_height()/68)
	

func _process(_delta):
	if Engine.is_editor_hint():
		call_deferred("fix_h")
		#custom_minimum_size.y = 128 + 64 * (rtl.get_content_height()/67-1)
