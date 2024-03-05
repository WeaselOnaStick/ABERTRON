class_name SpeechBubble extends NinePatchRect

@onready var rtl := %TextField

func _ready():
	visible = false
	#this is so fucking stupid 
	#god bless issue tracking https://github.com/godotengine/godot/issues/36381
	get_tree().process_frame.connect(fix_h,CONNECT_ONE_SHOT)

func fix_h():
	#print((%TextField as RichTextLabel).get_line_count())
	
	custom_minimum_size.y = 128 + 64 * (rtl.get_content_height()/67-1)
	visible = true
	var _tw := create_tween().tween_property(self, "modulate",Color("ffffff"), 0.15).from(Color("ffffff00"))


func _process(delta):
	if Engine.is_editor_hint():
		custom_minimum_size.y = 128 + 64 * (rtl.get_content_height()/67-1)
