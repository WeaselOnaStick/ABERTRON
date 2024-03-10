class_name CommsPanel extends Node3D

@onready var dialogue_renderer: DialogueRenderer = $CSGBox3D/Sprite3D/SubViewport/DialogueRenderer
var dialogue_sprite: Sprite3D

func interact():
	dialogue_renderer.interact_manual()

func _ready():
	dialogue_sprite = get_node("CSGBox3D/Sprite3D")
	DebugUI.DebugLog(dialogue_sprite.get_child(0).get_path())
	print(dialogue_sprite.get_child(0).get_path())
	(dialogue_sprite.texture as ViewportTexture).viewport_path = dialogue_sprite.get_child(0).get_path()
