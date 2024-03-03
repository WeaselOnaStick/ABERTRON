@tool
class_name SpeechBubble extends NinePatchRect

@onready var rtl := %TextField

func fix_h():
	#print((%TextField as RichTextLabel).get_content_height())
	custom_minimum_size.y = 128 + 64 * (rtl.get_content_height()/67-1)
	
func _process(delta):
	if Engine.is_editor_hint():
		fix_h()
